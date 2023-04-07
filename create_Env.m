function graph = create_Env(gridnum,r,D)
% Author: Paul Lathrop
% Date last edited: 4/7/23
%% Description:
% Function creates a square environment grid of 0s and 1s, where 1 corresponds
% with obstacles and 0 free space, of side length gridnum and concentration
% r
%% Inputs:
% gridnum: int, size of space
% r: double, concentration
% D: int, dimension (future) 
%% Outputs:
% graph: Boolean array (shape = (gridnum,gridnum)), created obstacle environment
%% Dependencies:
% N/A
%% Uses:
% main.m
numobs = r*gridnum^2;
graph = zeros(gridnum);
i = 1;
while(i<=numobs)
    temp1 = 1+floor(gridnum*rand);
    temp2 = 1+floor(gridnum*rand);
    if(temp1 == 1 && temp2 == 1), continue; end %leave bottom left open
    if(temp1 == gridnum && temp2 == gridnum), continue; end %leave top right open
    if(graph(temp1,temp2) == 0)
        graph(temp1,temp2) = 1;
        i = i + 1;
    end
end
end