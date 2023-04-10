function   dist = quick1Norm(x,y,d)
% Author: Paul Lathrop, MAE, UCSD
% Date last edited: 4/6/23
%% Description:
% Inline function calculates the manhattan norm between points x and y of
% dimension d (works for d=2)
%% Inputs:
% x: double array (shape = (1,d)), query point 1
% y: double array (shape = (1,d)), query point 2
% d: int, dimension
%% Outputs:
% dist: double, manhattan norm between x and y
%% Dependencies:
% N/A
%% Uses:
% findParent (inline)
% QRRT.m
if(d==2)
    dist = abs(x(1)-y(1))+abs(x(2)-y(2));
end
end