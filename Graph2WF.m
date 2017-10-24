%This function creates a wavefront file of a linear graph plot. The graph segment
%vertex indices are defined by L, the vertices are defined by P, and the name of 
%the wavefront file is defined by name. The name variable is a string that should end in .obj
%L is a nLX2 int array
%P is a 2XnP double
%name is a 1Xn string that ends in .obj  

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-04-29

function [] = Graph2WF( L , P , name )
  
  p1( 1 : size( P , 2 ) , : ) = 'v';
  p2 = P';
  p3( 1 : size( P , 2 ) , : ) = ' ';
  
  if size( P , 1 ) == 2
    
    p2( : , 3 ) = 0;
  
  end
  
  V = [ p1 p3 num2str( p2 ) ];
  l1( 1 : size( L , 1 ) , : ) = 'l';
  l2( 1 : size( L , 1 ) , : ) = ' ';
  l = [ l1 l2 num2str( L ) ];
  STRING = [ V ; l ];
  fid = fopen( name , 'w' );
  
  for n1 = 1 : size( STRING , 1 )
   
    fprintf( fid , [ STRING( n1 , : ) "\r\n" ] );
  
  end
  
  fclose( fid );

endfunction
