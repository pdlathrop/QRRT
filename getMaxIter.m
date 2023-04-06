function max_iter = getMaxIter(r,L)
% Author: Paul Lathrop, MAE, UCSD
% Date last edited: 4/6/23
%% Description:
% Calculates the number of required amplitude amplifications based on numerical estimations 
%% Inputs: 
% r: double, concentration of environment
% L: int, characteristic length of environment
%% Outputs:
% max_iter: double, estimated number of iterations of QAA for optimal amplification
%% Dependencies:
% N/A
%% Uses:
% QRRT.m
a = -0.156; b = -64.9; c = .3407; d = 1.808; f = 0.931; %parameters
pstar = f/(1+exp(-a*(L-b)*(r-c)))+d*L^(-2); %calc correctness estimation
max_iter = (pi/4)*sqrt(1/pstar); %calc max iterations
end


