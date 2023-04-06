function [phi,obs]=measure(psi)
%[phi]=measure(psi)
% Author: Charles Fox, Robotics Research Group, Oxford University
% Accessed: April 2022
%
%Measure phi wrt standard basis.
%
%phi is the new state of psi after measurement collapse. 
%
%(For other bases, transform them to std, measure, then transform back).
%TODO: measure wrt subspaces
%% Dependencies:
% cf_assert.m, cf_approx.m

p = (abs(psi)).^2;
cf_assert(cf_approx(sum(p)-1, 0), 'Phi not normalised');

[sp,ip]=sort(p);
sp=cumsum(sp);

r = rand;

i=1;
while r>sp(i)
    i=i+1;
end

obs=ip(i);  

phi=zeros(size(psi));
phi(obs)=1;

