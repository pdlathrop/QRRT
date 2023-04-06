function phi = bin2vec(bin)
% Author: Charles Fox, Robotics Research Group, Oxford University
% Accessed: April 2022
%phi = bin2vec(bin)
%Converts a single (non-superposed) binary state description of a register 
%to a vector state representation.
%% Dependencies:
% dec2vec.m, cf_assert.m
dec=bin2dec(bin); %string 01 representation to number
phi=dec2vec(dec,length(bin)); %decimal state to vector representation