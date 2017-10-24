%This function extracts a vector of indices of the endpoints of faces that
%belong to only one simplex.

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-04-21

function [ hull ] = Extract_Hull ( T )
  
  hull = [];%This will be a list of n-1 dimensional faces of each simplex. 
  
  if size( T , 1 ) > 0
    D = size( T , 2 ) - 1; %This is the dimensionality of the points.
    ID = 1 : ( D + 1 );
    
    for n1 = 1 : ( D + 1 )
      id = ID( ID ~= n1 );
      hull = [ hull ; T( : , id ) ];
    end
    
    hull = sortrows( hull );
    DIFF = [ sum( [ abs( diff( hull ) ) ; ones( 1 , D ) ] , 2 ) hull ];
    index1 = find( DIFF( : , 1 ) == 0 );
    index2 = index1 + 1;
    hull( [ index1 index2 ] , : ) = [];
  
  end
  
endfunction

