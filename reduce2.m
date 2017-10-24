%This function merges adjacent parabolas.

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-06-21

function [ hull ] = reduce2( hull , Ms )
  
  n2 = 1;
  
  while n2 == 1
    
    n2 = 0;
    pL = unique( hull( Ms( hull( : ) ) > 0 ) );
    %find the connectivity of each pL
    K = pL;
    
    for n1 = 1 : size( pL , 1 )
      
      hull2 = hull( ( hull( : , 1 ) == pL( n1 ) ) | ( hull( : , 2 ) == pL( n1 ) ) , : );
      hull2 = unique( hull2 )';
      hull2( hull2 == pL( n1 ) ) = [];
      K( n1 , [ 2 3 ] ) = hull2;
      
    end
    
    if size( hull , 1 ) > 0
      
      Mk = [ Ms( K( : , 1 ) ) Ms( K( : , 2 ) ) Ms( K( : , 3 ) ) ];
      k = K( sum( sign( abs( diff( Mk' )' ) ) , 2 ) == 0 , : );
      
      if size( k , 1 ) > 0
        
        n2 = 1;
        k1 = k( 1 , 1 );
        k2 = k( 1 , [ 2 3 ] );
        hull( ( hull( : , 1 ) == k1 ) | ( hull( : , 2 ) == k1 ) , : ) = [];
        hull = [ hull ; k2 ];
      
      end
    
    end
    
  end

endfunction
