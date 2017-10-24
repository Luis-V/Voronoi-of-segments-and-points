%This function extracts triangle data Tq and Mq that correspond to linear arcs in 
%the Voronoi graph of points and line segments. The corresponding data are 
%removed from the regular triangulation data T, Ct, R, and M.

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-08-06

function [ Tq , Mq , T , Ct , R , M ] = find_quads( T , M , Ct , R )
  
  %Extract linear edge data from triagles that have all 3 vertices on only 2 segments.
  Tq = T( ( sum( M > 0 , 2 ) == 3 ) & ( sum( abs( sign( diff( sort( M , 2 )' )' ) ) , 2 ) == 1 ) , : );
  Mq = M( ( sum( M > 0 , 2 ) == 3 ) & ( sum( abs( sign( diff( sort( M , 2 )' )' ) ) , 2 ) == 1 ) , : );
  Tq( Mq( : , 1 ) == Mq( : , 3 ) , [ 2 3 ] ) = Tq( Mq( : , 1 ) == Mq( : , 3 ) , [ 3 2 ] );
  Tq( Mq( : , 2 ) == Mq( : , 3 ) , [ 1 3 ] ) = Tq( Mq( : , 2 ) == Mq( : , 3 ) , [ 3 1 ] );
  Mq( Mq( : , 1 ) == Mq( : , 3 ) , [ 2 3 ] ) = Mq( Mq( : , 1 ) == Mq( : , 3 ) , [ 3 2 ] );
  Mq( Mq( : , 2 ) == Mq( : , 3 ) , [ 1 3 ] ) = Mq( Mq( : , 2 ) == Mq( : , 3 ) , [ 3 1 ] );
  
  T( ( sum( M > 0 , 2 ) == 3 ) & ( sum( abs( sign( diff( sort( M , 2 )' )' ) ) , 2 ) == 1 ) , : ) = [];
  Ct( : , ( sum( M > 0 , 2 ) == 3 ) & ( sum( abs( sign( diff( sort( M , 2 )' )' ) ) , 2 ) == 1 ) ) = [];
  R( ( sum( M > 0 , 2 ) == 3 ) & ( sum( abs( sign( diff( sort( M , 2 )' )' ) ) , 2 ) == 1 ) ) = [];
  M( ( sum( M > 0 , 2 ) == 3 ) & ( sum( abs( sign( diff( sort( M , 2 )' )' ) ) , 2 ) == 1 ) , : ) = [];


endfunction
