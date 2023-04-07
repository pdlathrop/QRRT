function [node_list,parent_list,oracle_count] = QRRT(grid,x_i,x_goal,goal_radius,r)
% Author: Paul Lathrop, MAE, UCSD
% Date last edited: 4/7/23
%% Description:
% QRRT performs a quantum RRT search, from x_i, in a 2D obstacle space grid
% for a goal location x_goal and returns a tree that includes a node within
% goal_radius of x_goal
% Notes: size of database and number of QAA iterations are up to user
% preference and specific environment
%% Inputs: 
% grid: Boolean array (shape = (L,L)), obstacle environment, represented as 2D array with 1's for
% obstacles and 0's for free space
% xi: double (shape = (1,2)), initial robot state, forming root of tree
% xgoal: double (shape = (1,2)), goal robot state
% goalradius: double, radius of region around xgoal where solutions will be counted
% r: double, concentration of envivornment (probability of obstacle)
%% Outputs:
% nodelist: double array (shape = (n,2)), list of nodes of output tree
% parentlist: double array (shape = (1,n)), list of parents of each node of the tree
% oraclecount: int, total number of oracle calls
%% Dependencies:
% hadamard.m, ia.m, vf.m, getMaxIter.m, bin2vec.m, dec2vec.m, cf_assert.m, cf_approx.m, measure.m, findanswer.m,
% oracle.m, pointobscheck.m, invertGrid.m
% in line: findParent, quick1Norm
%% Uses:
% main.m


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
    
    phi_classical=measure(phi); %measure a solution from qubit
    answer = findanswer(phi_classical); %select the measured answer
    
    %% Add to tree
    x_pick = database(answer,1:2); 
    x_parent = database(answer,3);
    %final check to account for measurement error
    oracle_count = oracle_count + 1;
    if(oracle(answer-1,database,grid,node_list)) %answer-1 due to +1 offset in oracle.m
        node_list = [node_list; x_pick];
        parent_list = [parent_list; x_parent];
        if(quick1Norm(x_pick,x_goal,2)<goal_radius), finished = true; end
    end
    count = count + 1;
end

    function parent_ind = findParent(x,node_list)
        % Author: Paul Lathrop, MAE, UCSD
        % Date last edited: 4/6/23
        %% Description:
        % Inline function that finds the nearest parent in node_list (based on Manhattan norm) of x
        %% Inputs:
        % x: double array (shape = (1,2)), query point
        % node_list: double array (shape = (n,2)), list of possible parents
        %% Outputs:
        % parent_ind: int, index of nearest parent to x
        %% Dependencies:
        % quick1Norm (inline)
        %% Uses:
        % QRRT.m
        min_dist = inf;
        for j = 1:length(node_list(:,1)) %iterate over node_list
            temp_dist = quick1Norm(x,node_list(j,:),2);
            if(temp_dist < min_dist), min_dist = temp_dist; parent_ind = j; end
        end
    end
    function   dist = quick1Norm(x,y,d)
        % Author: Paul Lathrop, MAE, UCSD
        % Date last edited: 4/6/23
        %% Description:
        % Inline function calculates the manhattan norm between points x and y of
        % dimension d
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
end