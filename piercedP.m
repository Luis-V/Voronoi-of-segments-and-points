%This function determines if triangles with vertices [P1 P2 P3] and circumcenters 
%Ct are intersected by segment n with endpoints [p1 p2]. M is a list of indices of
%segments to which [P1 P2 P3] belong.
%P1 is a 2XnT double.
%P2 is a 2XnT double.
%P3 is a 2Xnt double.
%M is a nTX3 integer.
%n is a 1X1 integer.
%Ct is a 2XnT double.
%[p1 p2] is a 2X2 double.

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-07-02

function [ index1 ] = piercedP ( P1 , P2 , P3 , M , n , Ct , p1 , p2 )
  
  index1 = [];
  l = norm( p1  - p2 );
  v1 = ( p2 - p1 ) / l;
  v2 = [ 0 -1 ; 1 0 ] * v1;
  Pc = p1 + v1 * v1' * ( Ct - p1 );
  %S is the sign of the location of vertices [P1 P2 P3] along a line perpendicular 
  %to segment n, with origin at segment n. Vertices on segment n have sign 0. 
  S = int8( [ sign( ( P1 - p1 )' * v2 ) sign( ( P2 - p1 )' * v2 ) sign( ( P3 - p1 )' * v2 ) ] );
  S( M == n ) = 0;
  S = sort( S , 2 );
  index1 = find( ( ( S( :  , 1 ) == -1 )' & ( S( : , 3 ) == 1 )' ) & ( ( sum( ( Pc - ( p1 + p2 ) / 2 ).^2 , 1 ).^.5 ) < ( l/2 ) ) );

endfunction
