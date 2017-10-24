%This function detects which circumcircles are intersected by a line segment with
%endpoints [P1 P2].
%CT is a 2XnCt array of circumcenter coordinates.
%R is a nCtX1 array of radii measurements.
%P1 is a 2X1 double.
%P2 is a 2X1 double.
 
function [ index1 ] = piercedT( Ct , R , P1 , P2 )
  
  Za = ( 10^-1 ) * pi / 180;
  Z = R * ( 1 - cos( Za ) );
  index1 = [];
  v = ( P2 - P1 ) / norm( P2 - P1 );
  e = Ct - P1;
  V = ( sum( e .* e , 1 ) - ( v' * e ).^2 ).^.5;
  K = sum( ( v * v' * e + ( P1 - P2 ) / 2 ).^2 , 1 ).^.5;
  index1 = find( ( R' > ( ( 10^-10 ) / cosd( 89 ) * 1.1 ) ) & ( V < ( R - Z)' ) & ( K < ( norm( P2 - P1 ) / 2 ) ) );

endfunction
