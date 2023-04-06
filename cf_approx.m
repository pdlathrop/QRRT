function b = cf_approx(x,y)
% Author: Charles Fox, Robotics Research Group, Oxford University
% Accessed: April 2022
%b = cf_approx(x,y)
%
%true if x and y are approximately equal (to very small machine error tolerance)

b = (abs(x-y)<0.0000000001);
