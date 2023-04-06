function pos = findanswer(phi)
% Author: Charles Fox, Robotics Research Group, Oxford University
% Accessed: April 2022
% finds index of first 1 in phi
for i = 1:length(phi)
    if(phi(i) == 1), pos = i; return; end
end
end