%Creates the graph of a parabola given two points along the directrix and the focus.
%The domain is between the two points given along the directrix.

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-06-21

function [ L , R ] = create_parabola( T , P , n )
  
    P1 = P( : , T( 1 ) ); %First point along the directrix.
    P2 = P( : , T( 2 ) ); %Second point along the directrix.
    P3 = P( : , T( 3 ) ); %Focus.
    L = norm( P2 - P1 );
    t = linspace( 0 , L , n );
    v = ( P2 - P1 ) / L;
    B = v * t + P1; %Points along the directrix.
    Pe = P1 + ( ( P3 - P1 )' * v ) * v;
    z = P3 - Pe;
    d = ( sum( ( Pe - B ).^2 , 1 ) + z' * z ) / 2 / norm( z );
    R = B + z / norm( z ) * d; %Points along the parabolic arc.
    L = [ 1 : ( n - 1 ) ; 2 : n ]'; %Connectivity of points along the parabolic arc.
    
endfunction
