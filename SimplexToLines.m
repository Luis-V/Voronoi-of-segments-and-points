%This function transforms an array of simplex indices T into an array of line 
%segment indices LINES.
%T is an nTXd array of integers.
%L is a nT*dX2 array of integers. 

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-04-22

function [ LINES ] = SimplexToLines( T )
  
  T = sort( T , 2 );
  LINES = [];
  d = size( T , 2 ) - 1;

  for n1 = 1 : d
  
    for n2 = ( n1 + 1 ) : ( d + 1 ) 
    
      LINES = [ LINES ; T( : , n1 ) T( : , n2 ) ];
  
    end
  
  end

  LINES = unique( LINES , 'rows' );

endfunction
