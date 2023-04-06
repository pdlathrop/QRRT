function output = pointobscheck(grid,p1)
% Author: Paul Lathrop, MAE, UCSD
% Date last edited: 4/6/23
%% Description:
% Function checks whether point p1 is obstacle free in grid 
%% Inputs:
% grid: environment to check
% p1: query point
%% Outputs:
% answer: true if obstacle free, false otherwise
%% Dependencies:
% N/A
%% Uses:
% oracle.m (inline: reachable, quickrast)

output = true;
if(p1(1) > length(grid(1,:))||p1(1)<0||p1(2) > length(grid(1,:))||p1(2)<0), output = false;
elseif(grid(ceil(p1(1)),ceil(p1(2))) == 1), output = false;
end
end