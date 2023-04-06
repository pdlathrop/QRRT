function b = oracle(i,database,env,node_list)
% Author: Paul Lathrop, MAE, UCSD
% Date last edited: 4/6/23
%% Description:
% Oracle function tests reachability for index i of database from nearest 
% node in node_list in environment env, and returns 1 for reachable and 0 
% else. Reachability is not tested rigorously, the function tests whether
% the point given by index i of database is reachable with an obstacle 
% free path with the given dynamics and feedback controller
%% Inputs:
% i: int, index of database being queried
% database: double array (size (n,3)), database of possible points and parents
% env: Boolean array (shape = (L,L)), environment
% node_list: double array (size (m,2)), list of nodes in current tree 
%% Outputs:
% b: boolean, test for reachability, with 1 corresponding with reachable
%% Dependencies:
% sameConnectedComponent (inline), invertGrid.m, reachable (inline),
% quickRast (inline), pointobscheck.m
%% Uses:
% QRRT.m

i = i+1; %1 is added due to for loop in vf.m 0:N-1
rawdata = database(i,:);
point = rawdata(1:2);
parent = rawdata(3);

conn_comp_test = sameConnectedComponent(env,node_list(parent,:),point); %connected component test
if(conn_comp_test)
    reachability_test = reachable(env,node_list(parent,:),point);
else
    reachability_test = false;
end
b = conn_comp_test & reachability_test;


    function answer = sameConnectedComponent(grid,x1,x2)
        % Author: Paul Lathrop, MAE, UCSD
        % Date last edited: 4/6/23
        %% Description: 
        % Inline function tests whether points x1 and x2 are within the same connected component of grid
        %% Inputs:
        % grid: environmental grid
        % x1: double array (shape = (1,2)), query point 1
        % x2: double array (shape = (1,2)), query point 2
        %% Outputs:
        % answer: Boolean, 1 if within same connected component, 0 otherwise
        %% Dependencies:
        % invertGrid (inline)
        %% Uses:
        % oracle.m
        answer = 0;
        x1 = [ceil(x1(1)) ceil(x1(2))]; x2 = [ceil(x2(1)) ceil(x2(2))]; %define what grid spacing the points are in
        x1index = length(grid(1,:))*(x1(2)-1) + x1(1); x2index = length(grid(1,:))*(x2(2)-1) + x2(1); %define the unwrapped grid indices of each point
        if(grid(ceil(x2(1)),ceil(x2(2))) == 1), answer = 0; return; end %efficiency line: if x2 is not in free space return 0
        inverted_grid = invertGrid(grid); %invert grid, free space is 0
        connected_component_object = bwconncomp(inverted_grid,4); %get connectivity info of grid
        groups = connected_component_object.PixelIdxList; %pull group lists
        for k = 1:length(groups) %check over all groups
            current_group = groups(k); %get current grooup
            current_group = current_group{1}; %open the cell
            if(ismember(x1index,current_group)&&ismember(x2index,current_group)), answer = 1; end %if both x1,x2 are in same group, output connected
        end
    end

    function good = reachable(grid,point1,point2)
        % Author: Paul Lathrop, MAE, UCSD
        % Date last edited: 4/6/23
        %% Description:
        % Inline function determines if point 2 is reachable with an obstacle free path, given dynamics, from
        % point 1 in grid
        %% Inputs:
        % grid: Boolean array (shape = (L,L)), environment
        % point 1: double array (shape = (1,2)), parent point
        % point 2: double array (shape = (1,2)), reachability test point
        %% Outputs:
        % good: Boolean, 1 if reachable, else 0
        %% Dependencies:
        % quickRast (inline), pointobscheck.m, sys (inline)
        %% Uses:
        % oracle.m

        good = true;
        A = [-1.5 -2;1 3]; %define dynamics
        B = [0.5 .25;0 1];
        K = [1.9 -7.5; 1 7]; %place with ploc = [-2.7 -4];
        t_span = [0:.05 5];
        init_e = point1-point2; %error term
        [t,y] = ode45(@sys,t_span,init_e); %numerical integration of controller and dynamics
        y = y + point2; %offset output back from error to state

        for i_path = 1:min(length(t),50) %for first 50 output points
            if(i_path>1 && i_path<=25) %first 25 points quite spread, so rasterize path
                temp_good = quickRast(y(i_path,:),y(i_path-1,:),17,grid); 
            else
                temp_good = pointobscheck(grid,y(i_path,:)); %else just take point
            end
            good = good && temp_good;
            if(~good), break; end %leave loop early if bad
        end

        function  dx = sys(t, x)
            % system
            u = -K*(x);
            dx = A*(x) + B*u;
        end

        function supra_check = quickRast(p1,p2,rastnum,grid)
            % Author: Paul Lathrop, MAE, UCSD
            % Date last edited: 4/6/23
            %% Description:
            % Inline function straight line rasterizes between p1 and p2 with
            % rastnum points in grid, and returns whether the path is
            % obstacle free
            %% Inputs:
            % p1: query point 1
            % p2: query point 2
            % rastnum: number of in between points to check
            % grid: environment
            %% Outputs:
            % supra_check: 1 if obstacle free rasterization, 0 else
            %% Dependencies:
            % pointobscheck.m
            %% Uses:
            for j = 1:rastnum
                supra_check = true;
                temp_point = [p1(1)+(j/rastnum)*(p2(1)-p1(1)) p1(2)+(j/rastnum)*(p2(2)-p1(2))];
                intra_check = pointobscheck(grid,temp_point);
                supra_check = supra_check && intra_check;
                if(~supra_check), break; end %leave loop early if bad
            end
        end
    end
end
