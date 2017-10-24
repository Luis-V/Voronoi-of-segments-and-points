%This function creates an nX2 vector V of the conncetivity of the circumcenters of the
%Delaunay triangles T with vertices inside segments indicated by M. 

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-08-06

function [V] = GetVoronoi (T,M)
  
  EG = [];%This will be a list of n-1 dimensional faces of each simplex, labeled by simplex. 
  T = sort( T , 2 );
  D = size( T , 2 ) - 1;
  ID = 1 : ( D + 1 );
  
  for  n1 = 1 : ( D + 1 )
    id = ID( ID ~= n1 );
    %This sorting operation is to facilitate the removal of Voronoi edges that cross segments.
    EG = [ EG ; [ T( : , id ) M( : , id ) ( 1 : size( T , 1 ) )' ] ];
  end
  
  EG = sortrows( EG );
  EG = EG( ( EG( : , 3) == 0 ) | ( EG( : , 4 ) == 0 ) | ( EG( : , 3 ) ~= EG( : , 4 ) ), : );
  V = [ EG( find( sum( diff( EG( : , 1 : D ) ) == 0 , 2 ) == D ) , D + D+1 ) EG( find( sum( diff( EG( : , 1 : D ) ) == 0 , 2 ) == D ) + 1 , D + D+1 ) ];

endfunction
