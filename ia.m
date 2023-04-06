function IA = ia(n)
% Author: Charles Fox, Robotics Research Group, Oxford University
% Accessed: April 2022
%IA = ia(n)
%
%Inversion about average.

%TODO: normalise correctly

IA =2*ones(2^n)/(2^n);

IA =IA-eye(2^n);