%This function computes a Delaunay triangulation T that conforms to a set of 
%input points P and segments with endpoint indices L. M is a vector that identifies
%the segment to which each delaunay vertex belongs.
%P is 2XnP, L is nLX2.

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-08-06

function [ T,M,P,Ms,L ] = ConformingTriangulation (P, L)
  
  Zl = 10^(-3);
  %Mark the  points according to which segment they are in. Assign a 0 to points not on a segment.
  Ms( 1 : size( P , 2 ) , 1 ) = 0;
  
  if size( L , 1 ) > 0

    iL = ( 1 : size( L , 1 ) )';

    %subdivide segments
    [ B , m ] = divide_segment_2( P , L );
    P = [ P B ];
    Ms = [ Ms ; m ];
    
    Pl1 = P( : , L( : , 1 ) ); %These are the exterior endpoints.
    Pl2 = P( : , L( : , 2 ) );

    %Create interior endpoints.
    U = ( Pl2 - Pl1 ) ./ ( [ 1 ; 1 ] * ( sum( ( Pl2 - Pl1 ).^2 , 1 ).^.5 ) );
    Pl1prime = Pl1 + Zl * U;
    Pl2prime = Pl2 - Zl * U;

    L = sort( [ iL iL + size( iL , 1 ) ] + size( P , 2 ) , 2 );%This defines the segments.
    P = [ P Pl1prime Pl2prime ]; %Add the interior endpoints.

    %Mark the points.
    
    Ms( L( : ) ) = [ iL ; iL ];

  end
  
  T = sort( delaunay( P(1,:) , P(2,:) , 'Qt' ) , 2 ); %An array of triangles.
  %Mark the  points according to which segment they are in.
  M = [ Ms( T(:,1) ) Ms( T(:,2) ) Ms( T(:,3) ) ];

endfunction
