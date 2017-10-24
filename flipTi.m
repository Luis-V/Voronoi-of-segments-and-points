%This function reorients a triangle that has at least one point on a segment. Triangles 
%are progressively reoriented by repeatedly projecting their circumcenters onto their 
%corresponding line segments. The coordinates of re-oriented triangle vertices are 
%stored in B. Vector m has the indices of the segments to which points in B belong.
%T is a 1X3 list of triangle vertex indices.
%Ct is a 2X1 circumcenter.
%R is a 1X1 radius.
%M is a 1X3 list of segment indices to which vertices in T belong.
%L is a nX2 list of segment endpoint indices.
%P is a 2Xn list of point coordinates. 

## Author: Luis <Luis@DESKTOP-I49GOFE>
## Created: 2017-07-10

function [ B , m ] = flipTi( T , Ct , R , M , L , P )
  
  nST = 10; %Maximum number of iterations.
  ST = 0; %Current number of iterations.
  B = []; m = []; %New vertex data.
  P1 = P( : , T( 1 ) ); %Original triangle vertices. 
  P2 = P( : , T( 2 ) );
  P3 = P( : , T( 3 ) );
  
  n1 = 1; %This variable indicates that the current triangle's circumcenter is crossed by
  %at least one segment.
  p1 = p2 = p3 = []; %Potential new vertex data.
  m1 = m2 = m3 = [];
  
  iP1 = iP2 = iP3 = []; %These variable indicate if the triangle itself is crossed by a segment.
  %If the triangle is crossed by a segment, this function should not proceed.
  if M( 1 ) ~= 0
    v1 = ( P( : , L( M( 1 ) , 2 ) ) - P( : , L( M( 1 ) , 1 ) ) ) / norm( P( : , L( M( 1 ) , 2 ) ) - P( : , L( M( 1 ) , 1 ) ) );
    iP1 = piercedP( P1 , P2 , P3 , M , M( 1 ) , Ct , P( : , L( M( 1 ) , 1 ) ),P( : ,L( M( 1 ), 2 ) ) );
  end
  
  if M( 2 ) ~= 0
    v2 = ( P( : , L( M( 2 ) , 2 ) ) - P( : , L( M( 2 ) , 1 ) ) ) / norm( P( : , L( M( 2 ) , 2 ) ) - P( : ,L( M( 2 ) , 1 ) ) );
    iP2 = piercedP( P1 , P2 , P3 , M , M( 2 ) , Ct , P( : , L( M( 2 ) , 1 ) ) , P( : , L( M( 2 ) , 2 ) ) );
  end
  
  if M( 3 ) ~= 0
    v3 = ( P( : , L( M( 3 ) , 2 ) ) - P( : , L( M( 3 ) , 1 ) ) ) / norm( P( : , L( M( 3 ) , 2 ) ) - P( : , L( M( 3 ) , 1 ) ) );
    iP3 = piercedP( P1 , P2 , P3 , M , M( 3 ) , Ct , P( : , L( M( 3 ) , 1 ) ) , P( : , L( M( 3 ) , 2 ) ) );
  end
  
  if ( size( iP1 , 2 ) == 0 ) && ( size( iP2 , 2 ) == 0 ) && ( size( iP3 , 2 ) == 0 )
    
    while ( n1 == 1 ) && ( ST < nST )
      ST = ST + 1; n1 = 0;
      
      if M( 1 ) ~= 0
        iT1 = piercedT( Ct , R , P( : , L( M( 1 ) , 1 ) ) , P( : , L( M( 1 ) , 2 ) ) );
        
        if size( iT1 , 2 ) == 1
          P1 = P( : , L( M( 1 ) , 1 ) ) + v1 * v1' * ( Ct - P( : , L( M( 1 ) , 1 ) ) );
          p1 = P1;
          m1 = M( 1 );
          n1 = 1;
        end
        
      end
      
      if M( 2 ) ~= 0
        iT2 = piercedT( Ct , R , P( : , L( M( 2 ) , 1 ) ) , P( : , L( M( 2 ) , 2 ) ) );
        
        if size( iT2 , 2 ) == 1
          P2 = P( : , L( M( 2 ) , 1 ) ) + v2 * v2' * ( Ct - P( : , L( M( 2 ) , 1 ) ) );
          p2 = P2;
          m2 = M( 2 );
          n1 = 1;
        end
      
      end
      
      if M( 3 ) ~= 0
        iT3 = piercedT( Ct , R , P( : ,L( M( 3 ) , 1 ) ) , P( : , L( M( 3 ) , 2 ) ) );
        
        if size( iT3 , 3 ) == 1
          P3 = P( : , L( M( 3 ) , 1 ) ) + v3 * v3' * ( Ct - P( : , L( M( 3 ) , 1 ) ) );
          p3 = P3;
          m3 = M( 3 );
          n1 = 1;
        end
      
      end
      
      if n1 == 1
        %Recalculate Ct, and R.
        [ Ct , R ] = getQ( [ 3 2 1 ] , [ P3 P2 P1 ] );
      end
    
    end
    
  end
 
  B=[ p1 p2 p3 ];
  m=[ m1 m2 m3 ]';

endfunction
