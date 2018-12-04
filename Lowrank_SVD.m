function A_low = Lowrank_SVD(A,tol,maxrk)
%{
This function uses the SVD to find a low rank approximation of the m x n 
matrix A so that 
                           || A - B ||_2 < tol ||A||_2
By truncating the SVD appropriately. If the number of arguments is 2, it outputs
the low rank approximation as A_low
%}

if nargin < 3
   maxrk = min(size(A));  
end

% SVD
[U,S,V] = svd(A); 
% singular values
ss = diag(S); 

% eps-rank -> # of singular values with relative size > tol
rk = min(sum(ss./max(ss)>tol),maxrk); 

% if nargout == 1
A_low= U(:,1:rk)*S(1:rk,1:rk)*V(:,1:rk)';
% end

display(rk)

end