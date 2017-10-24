%This function creates a line segment between segments to which the points on 
%triangle Tq belong. The domain for segment points b is the length of the segment 
%between points P1i and P2i.

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-07-05

function [ lg , b ] = create_line( Tq , P , L , M , n )
  
  P1i = P( : , Tq( 1 ) ); %Two points along segment i.
  P2i = P( : , Tq( 2 ) );
  Pj = P( : ,Tq( 3 ) ); %Two points along segment j.
  P1j = P( : , L( M( 3 ) , 1 ) );
  P2j = P( : , L( M( 3 ) , 2 ) );
  w = ( P2j - P1j ) / norm( P2j - P1j ); %Unit vector along segment j.
  S = norm( P2i - P1i );
  t = linspace( 0 , S , n );
  v = ( P2i - P1i ) / S; %Unit vector along segment i.
  Pi = v * t + P1i; %Points along segment i.
  
  V = ( [ 1 0;0 1 ] -v * v' ) * ( Pj - P1i );
  U = V / norm( V ); %Unit vector perpendicular to segment i.

  e = P1j + w * w' * ( Pi - P1j );
  d1 = sum( ( e - Pi ).^2 , 1 ).^.5;
  d = d1 ./ ( ( ( U' * ( e - Pi ) ) ./ d1 ) + 1 );
  b = Pi + U * d; %Points equidistant to lines i and j.
  lg = [ 1 : ( n - 1 ) ; 2 : n ]'; %Connectivity of points b.

endfunction
