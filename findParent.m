function parent_ind = findParent(x,node_list)
% Author: Paul Lathrop, MAE, UCSD
% Date last edited: 4/9/23
%% Description:
% Inline function that finds the nearest parent in node_list (based on Manhattan norm) of x
%% Inputs:
% x: double array (shape = (1,2)), query point
% node_list: double array (shape = (n,2)), list of possible parents
%% Outputs:
% parent_ind: int, index of nearest parent to x
%% Dependencies:
% quickdist.m
%% Uses:
% QRRT.m, RRTclassical.m
min_dist = inf;
for j = 1:length(node_list(:,1)) %iterate over node_list
    temp_dist = quick1Norm(x,node_list(j,:),2);
    if(temp_dist < min_dist), min_dist = temp_dist; parent_ind = j; end
end
end