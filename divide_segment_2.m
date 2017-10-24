%This script computes points with coordinates stored in B along segments to 
%ensure that successive pairs of points along each segment form Delaunay edges 
%when triangulated. Ms is a vector that indicates to which segment each point belongs.

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-07-01

function [ B , Ms ] = divide_segment_2( P , L )
  
  Z = 2 * (10^-6); %Tolerance for the minimum distance between points on the same segment.
  Z3 = 2 * (10^-3); %Separation between segment endpoints and closest interior point.
  B = Ms = [];

  for n1 = 1 : size( L , 1 )%Find the nearest neighbor of each end point.

    disp(n1)
    fflush(stdout) 
    
    P1 = P( : , L( n1 , 1 ) ); %Current segment end points. 
    P2 = P( : , L( n1 , 2 ) );
    
    %Separate the farthest points of the segment slightly from the endpoints.
    U = ( P2 - P1 ) / norm( P2 - P1 );
    P1 = P1 + Z3 * U;
    P2 = P2 - Z3 * U;

    p1 = P( : , L( ( 1 : size( L , 1 ) ) ~= n1 , 1 ) ); %Endpoints of all other segments.
    p2 = P( : , L( ( 1 : size( L , 1 ) ) ~= n1 , 2 ) );
    v = ( p2 - p1 ) ./ ( [ 1 ; 1 ] * sum( ( p2 - p1 ).^2 , 1 ).^.5 ); %Unit vectors along other segments.
    
    p = p1 + [ 1 ; 1 ] * sum( ( P1 - p1 ) .* v , 1 ) .* v; %Projectionof P1 onto all other segment.
    pm = ( p1 + p2 ) / 2; %Midpoint of all other segments.
    p( : ,( sum( ( p - pm ) .^2 , 1 ).^.5 ) > ( sum( ( p1 - pm ) .^2 , 1 ).^.5  ) )=[];
    d1l = min( sum( ( p - P1 ) .^2 , 1 ).^.5 ); %Minimum distance from P1 to all other segments.

    iP1 = 1 : size( P , 2 );
    iP1 = iP1( ( iP1 ~= L( n1 , 1 ) ) & ( iP1 ~= L( n1 , 2 ) ) );
    iP2 = L( ( 1 : size( L , 1 ) ) ~= n1 , : );
    iP2 = unique( iP2( : ) )';
    iP = unique( [ iP1 iP2 ] );
    d1p = min( sum( ( P1 - P( : , iP ) ).^2 , 1 ).^.5 ); %Minimum distance from P1 to all points not on the current segment.
    d1 = min( [ d1l d1p ] ); %Minimum distance from P1 to any other site.
    
    p = p1 + [ 1 ; 1 ] * sum( ( P2 - p1 ) .* v , 1 ) .* v; %Projection of P2 onto all other segments.
    p( : , ( sum( ( p - pm ).^2 , 1 ).^.5 ) > ( sum( ( p1 - pm ).^2 , 1 ).^.5 ) ) = [];
    d2l = min( sum( ( p - P2 ).^2 , 1 ).^.5 ); %Minimum distance from P2 to any other segment.
    d2p = min( sum( ( P2 - P( : , iP ) ).^2 , 1 ).^.5 ); %Minimum distance from P2 to any other point.
    d2 = min( [ d2l d2p ] ); %Minimum distance from P2 to any other site.
    
    Q = [ P1' P2' d1 d2 norm( P2 - P1 ) n1 ];
    
    while size( Q , 1 ) > 0 
      %subdivide the current segment until the length of each sub-segment is smaller than
      %the shortest separation between the endpoints of each sub-segment and any other site. 
     
      q = Q( 1 , : );
      Q( 1 , : ) = [];
      
      if ( ( q( 7 ) > Z ) && ( ( q( 5 ) < q( 7 ) ) || ( q( 6 ) < q( 7 ) ) ) )
           
        P0 = mean( [ q( [ 1 2 ] )' q( [ 3 4 ] )' ] , 2 );
        p = p1 + [ 1 ; 1 ] * sum( ( P0 - p1 ) .* v , 1 ) .* v; 
        p( : , ( sum( ( p - pm ) .^ 2 , 1 ) .^.5 ) > ( sum( ( p1 - pm ).^2 , 1 ).^.5 ) ) = [];
        d0l = min( sum( ( p - P0 ).^2 , 1 ).^.5 ); %Minimum separation between P0 and any other segment not on the current segment.
        d0p = min( sum( ( P0 - P( : , iP ) ).^2 , 1 ).^.5 ); %Minimum separation between P0 and any other point.
        d0 = min( [ d0l d0p ] );
        
        q1 = [ q( [ 1 2 ] ) P0' q( 5 ) d0 norm(P0-q([1 2])') q(8)];
        q2 = [ q( [ 3 4 ] ) P0' q( 6 ) d0 norm( P0 - q( [ 3 4 ] )' ) q( 8 ) ];
        Q = [ Q ; [ q1 ; q2 ] ];
        B = [ B P0 ];
        Ms = [ Ms ; q( 8 ) ];
      end
      
    end
  end
  
endfunction
