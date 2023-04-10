function [node_list,parent_list,oracle_count] = RRTclassical(grid,x_i,x_goal,goal_radius)
% Author: Paul Lathrop, MAE, UCSD
% Date last edited: 4/9/23
%% Description:
% RRTclassical performs a classical RRT search, from x_i, in a 2D obstacle space grid
% for a goal location x_goal and returns a tree that includes a node within
% goal_radius of x_goal
%% Inputs: 
% grid: Boolean array (shape = (L,L)), obstacle environment, represented as 2D array with 1's for
% obstacles and 0's for free space
% x_i: double (shape = (1,2)), initial robot state, forming root of tree
% x_goal: double (shape = (1,2)), goal robot state
% goal_radius: double, radius of region around xgoal where solutions will be counted
%% Outputs:
% node_list: double array (shape = (n,2)), list of nodes of output tree
% parent_list: double array (shape = (1,n)), list of parents of each node of the tree
% oracle_count: int, total number of oracle calls
%% Dependencies:
% oracle.m and dependencies, findParent.m, quick1Norm.m
%% Uses:
% main.m

if(length(grid(1,:))~=length(grid(:,1))), return; end %environment not square error
if((length(size(x_i))~=2) || (length(size(x_goal))~=2)), return; end %initial x or goal x not dim 3
if(goal_radius >= length(grid(1,:))), return; end %goal radius too large
if(r>1 || r<0), return; end %r not in range

%% Initializations
bound = length(grid(1,:)); %calc bound
finished = false;
node_list = x_i; parent_list = 1;
oracle_count = 0;
%% Loop
while(~finished)
    x_new = bound*[rand rand]; %pick random point
    x_new_parent = findParent(x_new,node_list); %x_new_parent is index of node_list
    oracle_count = oracle_count + 1;
    if(oracle(x_new, x_new_parent,grid,node_list))
        node_list = [node_list;x_new];
        parent_list = [parent_list; x_new_parent];
    end
    if(quick1Norm(x_i,x_goal,2)<=goal_radius), finished = true; end %end condition
end
end