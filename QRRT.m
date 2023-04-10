function [node_list,parent_list,oracle_count] = QRRT(grid,x_i,x_goal,goal_radius,r)
% Author: Paul Lathrop, MAE, UCSD
% Date last edited: 4/9/23
%% Description:
% QRRT performs a quantum RRT search, from x_i, in a 2D obstacle space grid
% for a goal location x_goal and returns a tree that includes a node within
% goal_radius of x_goal
% Notes: size of database and number of QAA iterations are up to user
% preference and specific environment
%% Inputs: 
% grid: Boolean array (shape = (L,L)), obstacle environment, represented as 2D array with 1's for
% obstacles and 0's for free space
% x_i: double (shape = (1,2)), initial robot state, forming root of tree
% x_goal: double (shape = (1,2)), goal robot state
% goal_radius: double, radius of region around xgoal where solutions will be counted
% r: double, concentration of envivornment (probability of obstacle)
%% Outputs:
% node_list: double array (shape = (n,2)), list of nodes of output tree
% parent_list: double array (shape = (1,n)), list of parents of each node of the tree
% oracle_count: int, total number of oracle calls
%% Dependencies:
% hadamard.m, ia.m, vf.m, getMaxIter.m, bin2vec.m, dec2vec.m, cf_assert.m, cf_approx.m, measure.m, findanswer.m,
% oracle.m, pointobscheck.m, invertGrid.m, findParent.m, quick1Norm.m
%% Uses:
% main.m

if(length(grid(1,:))~=length(grid(:,1))), return; end %environment not square error
if((length(size(x_i))~=2) || (length(size(x_goal))~=2)), return; end %initial x or goal x not dim 3
if(goal_radius >= length(grid(1,:))), return; end %goal radius too large
if(r>1 || r<0), return; end %r not in range

%% Initializations
bound = length(grid(1,:)); %calculate size of square environment
finished = false; count = 1; oracle_count = 0; %initializations
node_list = x_i; parent_list = 1; %initialize tree
while(~finished)
    %% Construct database
    n = 9; %number of registers
    H = hadamard(n); %hadamard function assignment matrix
    D = ia(n); %invert around average matrix
    database = zeros([2^n 3]); 
    for k = 1:2^n
        x_new = bound*[rand rand];
        x_new_parent = findParent(x_new, node_list); %find nearest parent
        database(k,:) = [x_new x_new_parent];
    end
    V_oracle = vf('oracle', n, database, grid, node_list); %inversion function assignment matrix
    
    %% Search database
    max_iter = getMaxIter(r,bound); %find upper bound for iterations of Grover's alg
    min_iter = getMaxIter(r,bound/sqrt(count)); %estimate a lower bound given already existing nodes
    phi = '0'; %create registers
    for k = 2:n
        phi = strcat(phi,'0'); %add 0's to qubit register
    end
    phi = bin2vec(phi); %to vector
    phi = H*phi; %apply Hadamard operator -> superposition
    
    %% Grover's diffusion operator
    for i=1:((max_iter+min_iter)/2) %iterate average of min and max iteration count estimates
        phi=V_oracle*phi; %oracle-conditional 0 inverter
        phi=D*phi; %invert around mean
        oracle_count = oracle_count + 1; 
    end
    
    phi_classical = measure(phi); %measure a solution from qubit
    answer = findanswer(phi_classical); %select the measured answer
    
    %% Add to tree
    x_pick = database(answer,1:2); 
    x_parent = database(answer,3);
    %final check to account for measurement error
    oracle_count = oracle_count + 1;
    if(oracle(answer - 1,database,grid,node_list)) %answer-1 due to +1 offset in oracle.m
        node_list = [node_list; x_pick];
        parent_list = [parent_list; x_parent];
        if(quick1Norm(x_pick,x_goal,2)<goal_radius), finished = true; end
    end
    count = count + 1;
end
end