function H = hadamard(n)
% Author: Charles Fox, Robotics Research Group, Oxford University
% Accessed: April 2022
%H = hadamard(n)
%
%Create n-bit hadamard matrix.

if n==1
    H = [ 1 1; 1 -1]/sqrt(2);
else
    H1 = hadamard(1);
    H=1;
    for i=1:n
        H=kron(H,H1);    
    end
end

