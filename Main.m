clear
CreateSites

%Compute a preliminary triangulation.
[ triangles, id_matrix, points, segment_id, segments ] = ConformingTriangulation(points, segments);
%Produce a wavefront file of the preliminary triangulation.
Graph2WF( SimplexToLines( triangles ) , points , 'voronoi0.obj' )

if size( segments , 1 ) == 0 %Simply plot the voronoi graph if there are no segments.
  [ centers , radii ] = getQ( triangles , points ); %Compute the circumradii and circumcenters of the triangles.
  %Produce a wavefront file of the preliminary Voronoi graph.
  Graph2WF( GetVoronoi( triangles , id_matrix ) , centers , 'voronoi1.obj' )
end

if size( segments , 1 ) > 0

  [ centers , radii ] = getQ( triangles , points ); %Circumradii and circumcenters.
  Graph2WF( GetVoronoi( triangles , id_matrix ) , centers , 'voronoi1.obj' ) %Make a wavefront file with the initial voronoi graph.
  
  %Delete triangles that will not be flipped.
  triangles( ( ( sum( id_matrix > 0 , 2 ) >= 2 ) | ( sum( id_matrix < 0 , 2 ) >= 2 ) ) & ( sum( abs( sign( diff( sort( id_matrix , 2 )' )' ) ) , 2 ) == 1 ) , : ) = [];
  centers( : , ( ( sum( id_matrix > 0 , 2 ) >= 2 ) | ( sum( id_matrix < 0 , 2 ) >= 2 ) ) & ( sum( abs( sign( diff( sort( id_matrix , 2 )' )' ) ) , 2 ) == 1 ) ) = [];
  radii( ( ( sum( id_matrix > 0 , 2 ) >= 2 ) | ( sum( id_matrix < 0 , 2 ) >= 2 ) ) & ( sum( abs( sign( diff( sort( id_matrix , 2 )' )' ) ) , 2 ) == 1 ) ) = [];
  
  id_matrix( ( ( sum( id_matrix > 0 , 2 ) >= 2 ) | ( sum( id_matrix < 0 , 2 ) >= 2 ) ) & ( sum( abs( sign( diff( sort( id_matrix , 2 )' )' ) ) , 2 ) == 1 ) , : ) = [];


  disp([88])
  fflush(stdout)

  %Find T0, which are triangles whose circumcircles are crossed by segments 
  %that do not have a corresponding Delaunay vertex.
  for n2 = 1 : size( segments , 1 )
    
    %Endpoints of current segment.
    P1 = points( : , segments( n2 , 1 ) );
    P2 = points( : , segments( n2 , 2 ) ); 
 
    %Find triangles that do not have a point on the current segment,
    %and find which of those have circumcircles that cross the current line.
    iT0 = find( sum( id_matrix == n2 , 2 ) == 0 );
    T0 = triangles( iT0 , : ); %Array of triangles.
    Ct0 = centers( : , iT0 ); %Circumcenters of T0.
    R0 = radii( iT0 ); %Circumradii of T0.
    M0 = id_matrix( iT0 , : ); %Indeces of lines of which the triangle vertices are inside.
    [ i0 ] = piercedT( Ct0 , R0 , P1 , P2 ); %Find which triangles have circumradii crossed by the current segment.
    
    if size( i0 , 2 ) > 0 
      %Connect T0 to the current line by projecting their circumcenter onto the current line.
      v = ( P2 - P1 ) / norm( P2 - P1 ); %Unit vector along current line.
      b = P1 + v * v' * ( Ct0( : , i0 ) - P1 ); %Projection of circumcenters Ct0 onto the current line.
      points = [ points b ]; %The projected circumcenters are added to the points.
      segment_id = [ segment_id ; ones( size( b , 2 ) , 1 ) * n2 ]; %The new points are marked according to which segment they are in.
    end
    
  end

  %Retriangulate. Ideally, this would only require incremental insertion of newly found points,
  %but the built in triangulator is fast enough to do the whole triangulation more than once.
  triangles = sort( delaunay( points( 1 , : ) , points( 2 , : ) , 'Qt' ) , 2 );
  id_matrix = [ segment_id( triangles( : , 1 ) ) segment_id( triangles( : , 2 ) ) segment_id( triangles( : , 3 ) ) ];

  %Delete triangles that will not be flipped.
  triangles( ( ( ( sum( id_matrix > 0 , 2 ) >= 2 ) | ( sum( id_matrix < 0 , 2 ) >= 2 ) ) & ( sum( abs( sign( diff( sort( id_matrix , 2 )' )' ) ) , 2 ) == 1 ) ) | ( sum( id_matrix , 2 ) == 0 ) , : ) = [];
  id_matrix( ( ( ( sum( id_matrix > 0 , 2 ) >= 2 ) | ( sum( id_matrix < 0 , 2 ) >= 2 ) ) & ( sum( abs( sign( diff( sort( id_matrix , 2 )' )' ) ) , 2 ) == 1 ) ) | ( sum( id_matrix , 2 ) == 0 ) , : ) = [];

  %Get the circumradii and circumcenters.
  [ centers , radii ] = getQ( triangles , points );

  %Find which of the remaining triangles are crossed by a segment and "flip" them.
  for n2 = 1 : size( triangles , 1 )
    [ b , ms ] = flipTi( triangles( n2 , : ) , centers( : , n2 ) , radii( n2 ) , id_matrix( n2 , : ) , segments , points );
    segment_id = [ segment_id ; ms ];
    points = [ points b ];         
  end
      
  %Retriangulate.
  triangles = sort( delaunay( points( 1 , : ) , points( 2 , : ) , 'Qt' ) , 2 );
  id_matrix = [ segment_id( triangles( : , 1 ) ) segment_id( triangles( : , 2 ) ) segment_id( triangles( : , 3 ) ) ];
  [ centers , radii ] = getQ( triangles , points );

  disp([88])
  fflush(stdout)
  
  LT = SimplexToLines( [ triangles ] ); %Extract the edges of the resulting triangulation and plot them.
  %Produce a wavefront file of the Delaunay triangulation at this stage.
  Graph2WF( [ LT ] , points , 'voronoi2.obj' )
  %Produce a wavefront file of the Voronoi graph at this stage.
  Graph2WF( GetVoronoi( triangles , id_matrix ) , centers , 'voronoi3.obj' )
  
end


%Extract linear and parabolic arc data.
Tp = [];
Tq = [];
if size( segments , 1 ) > 0
  
  [ Tp , triangles , centers , radii , id_matrix ] = find_parabolas( segment_id , triangles , centers , radii , id_matrix );
  [ Tq , Mq , triangles , centers , radii , id_matrix ] = find_quads( triangles , id_matrix , centers , radii );
  %After this step, only true Delaunay triangles remain in the vector T.
  
end

%Plot the quasi triangulation.
LT = SimplexToLines( [ triangles ] );
%Produce a wavefront file of the quasi-triangulation.
Graph2WF( [ LT ; segments ] , points , 'voronoi4.obj' )

%Create parabolic edges for plotting.
LP = [];
R = [];
for n = 1 : size( Tp , 1 )
  [ lp , r ] = create_parabola( Tp( n , : ) , points , 100 );
  lp = lp + size( R , 2 );
  LP = [ LP ; lp ];
  R = [ R r ];
end

%Create linear edges for plotting.
LG = [];
B = [];
for n1 = 1 : size( Tq , 1 )
  if sum( sign( abs( diff( Tq( n1 , : )' )' ) ) , 2 ) == 2
    [ lg , b ] = create_line( Tq( n1 , : ) , points , segments , Mq( n1 , : ) , 2 );
    lg = lg + size( B , 2 );
    LG = [ LG ; lg ];
    B = [ B b ];
  end
end

%Create the Voronoi graph with the parabolic edges and linear edges.
[ V ] = GetVoronoi( triangles , id_matrix );
V = [ V ; LP + size( centers , 2 ) ; LG + size( centers , 2 ) + size( R , 2 ) ];
centers = [ centers R B ];
%Produce a wavefront file of the Voronoi graph.
Graph2WF( V  ,centers , 'voronoi5.obj' )


%Create the Medial axis graph.
M2 = 1 : size( L2 , 1 );
M2 = [ M2 M2 ];
L2 = L2( : );
LU = unique( L2 );

for n1 = 1 : size( LU , 1 )
  iP = LU( n1 );
  iL = M2( L2 == iP )';
  for n2 = 1 : size( iL ,1 )
    Lt = LT( ( ( LT( : , 1 ) == iP ) & ( segment_id( LT( : , 2 ) ) == iL( n2 ) ) ) | ( ( LT( : , 2 ) == iP ) & ( segment_id( LT( : , 1 ) ) == iL( n2 ) ) ) , : );
    segment_id( Lt( : ) ) = iL( 1 );
  end
end

id_matrix = [ segment_id( triangles( : , 1 ) ) segment_id( triangles( : , 2 ) ) segment_id( triangles( : , 3 ) ) ];
[ V ] = GetVoronoi( triangles , id_matrix );
V = [ V ; LP + size( centers , 2 ) ; LG + size( centers , 2 ) + size( R , 2 ) ];
centers = [ centers R B ];
%Produce a wavefront file of the medial axis graph.
Graph2WF(  V , centers , 'voronoi6.obj' )

%Create the WF file of the input sites.
Graph2WF ( [ segments ; ( 1 : size( points , 2 ) )' ( 1 : size( points , 2 ) )' ] , points , 'voronoi7.obj' )