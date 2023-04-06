function phi=dec2vec(dec,n)
% Author: Charles Fox, Robotics Research Group, Oxford University
% Accessed: April 2022
%phi = dec2vec(dec,n)
%convert single dec state to vector representation
%n is max bits

cf_assert(dec<=2^n-1, 'dec too big for register size n!');

phi=zeros(2^n,1);
phi(dec+1)=1; %compensate for matlab indexing with +1