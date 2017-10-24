%This function extracts triangle data Tp that correspond to parabolic arcs in 
%the Voronoi graph of points and line segments. The corresponding data are 
%removed from the regular triangulation data T, Ct, R, and M.

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-06-20

function [ Tp , T , Ct , R , M ] = find_parabolas( Ms , T , Ct , R , M )
  
  
  %Extract parabolic triangles.
  Tp = T( ( M( : , 2 ) == M( : , 3 ) ) & ( M( : , 2 ) > 0 ) & ( M( : , 1 ) == 0 ) , : );
  Mp = M( ( M( : , 2 ) == M( : , 3 ) ) & ( M( : , 2 ) > 0 ) & ( M( : , 1 ) == 0 ) , : );
   
  %Delete parabolic triangle data from regular triangle data.
  T( ( M( : , 2 ) == M( : , 3 ) ) & ( M( : , 2 ) > 0 ) & ( M( : , 1 ) == 0 ) , : ) = [];
  Ct( : , ( M( : , 2 ) == M( : , 3 ) ) & ( M( : , 2 ) > 0 ) & ( M( : , 1 ) == 0 ) ) = [];
  R( ( M( : , 2 ) == M( : , 3 ) ) & ( M( : , 2 ) > 0 ) & ( M( : , 1 ) == 0 ) ) = [];
  M( ( M( : , 2 ) == M( : , 3 ) ) & ( M( : , 2 ) > 0 ) & ( M( : , 1 ) == 0 ) , : ) = [];
  
  %Determine the foci of the parabolas encoded in the parabolic triangles.
  vertexindex = unique( Tp ( Mp( : ) == 0 ) );
  t = [];
  
  for n1 = 1 : size( vertexindex , 1 ) %Merge adjacent parabolic triangles.
    
    tp = Tp( ( Tp( : , 1 ) == vertexindex( n1 ) ) , : );
    tH = Extract_Hull( tp ); 
    [ tH ] = reduce2( tH , Ms );   
    tH2 = tH( ( tH( : , 1 ) ~= vertexindex( n1 ) ) & ( tH( : , 2 ) ~= vertexindex( n1 ) ) , : );
    t = [ t ; tH2 vertexindex( n1 ) * ones( size( tH2 , 1 ) , 1 ) ];
    
  end
 
  Tp = t;
 
endfunction
