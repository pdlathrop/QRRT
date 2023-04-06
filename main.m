% Author: Paul Lathrop
% Date last edited: 4/6/23
%% Description
% main function to initialize environment, pick an initial and final point
% from the largest connected component, run QRRT, and plot the result
%% Dependencies:
% create_Env.m, GRNFLCC (inline), QRRT.m and dependencies, plotfinaltree.m,
% plotenv.m

D = 2; %dimension
bound = 72;
r = 0.5;
%dynamics matrices defined in oracle.m and oraclem2.m


grid = create_Env(bound,r,D);

x_init = GRNFLCC(grid,bound); %xi is initial point
x_goal = GRNFLCC(grid,bound); %goal point
tic
[nodes,parents,oraclecount1] = QRRT(grid,x_init,x_goal,2,r);
t_elapsed = toc;
plotfinaltree(grid,nodes,parents)

function rand_node = GRNFLCC(grid,bound)
% Author: Paul Lathrop, MAE, UCSD
% Date last edited: 4/6/23
%% Description:
% Inline function {Gets Random Node From Largest Connected Component} of grid
%% Inputs:
% grid: Boolean array (shape = (bound,bound)), environment
% bound: int, side length of grid
%% Outputs:
% rand_node: double array (shape = (1,2)), random node from within largest
% connected component of grid
%% Dependencies:
% invertGrid.m
%% Uses:
% main.m (inline)

temp = bwconncomp(invertgrid(grid),4);
groups = temp.PixelIdxList; %pull group lists
lengths = zeros([length(groups) 1]); %preallocate lengths
for k = 1:length(groups)
    tempgroup = groups(k);
    lengths(k) = length(tempgroup{1});
end
[elem,ind] = max(lengths); %find which group has the most elements
largest_group = groups(ind); %pick largest group
largest_group = largest_group{1}; %open cell
randomnum = largest_group(randsample(elem,1)); %returns wrapped number of random element
if(rem(randomnum,bound) == 0), x2 = bound-1; x1 = floor(randomnum/bound)-1; else
x1 = floor(randomnum/bound);x2 = rem(randomnum,bound)-1; %unwrap to get coordinates
end
rand_node = [x2+.5 x1+.5];
end