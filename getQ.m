% This function computes the circumcenters Ct and circumradii R of triangles with
%vertices in P with indices T
%T is nTX3
%P is 2XnP
%Ct is 2XnCt
%R is nRX1 

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-07-10

function [ Ct , R ] = getQ( T , P )
  
  x1 = P( 1 , T( : , 1 ) )';
  x2 = P( 1 , T( : , 2 ) )';
  x3 = P( 1 , T( : , 3 ) )';
  y1 = P( 2 , T( : , 1 ) )';
  y2 = P( 2 , T( : , 2 ) )';
  y3 = P( 2 , T( : , 3 ) )';
  a = sum( [ x1 x2 x3 ] .* ( [ y2 y3 y1 ] - [ y3 y1 y2 ] ) , 2 );
  bx = -sum( ( [ x1 x2 x3 ].^2 + [ y1 y2 y3 ].^2 ) .* ( [ y2 y3 y1 ] - [ y3 y1 y2 ] ) , 2 );
  by = sum( ( [ x1 x2 x3 ].^2 + [ y1 y2 y3 ].^2 ) .* ( [ x2 x3 x1 ] - [ x3 x1 x2 ] ) , 2 ); 
  c = -sum( ( [ x1 x2 x3 ].^2 + [ y1 y2 y3 ].^2 ) .* ( [ x2.*y3 x3.*y1 x1.*y2 ] - [ x3.*y2 x1.*y3 x2.*y1 ] ) , 2 );
  R = ( ( bx.^2 + by.^2 - 4 * a.*c ).^.5) ./ abs( a ) / 2;
  Ct = [ -bx./a/2 -by./a/2 ]';

endfunction
