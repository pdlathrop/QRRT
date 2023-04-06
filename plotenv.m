function r = plotenv(grid,bound)
% Author: Paul Lathrop
% Date last edited: 4/6/23
%% Description:
% Function plots environment grid of square size bound
%% Inputs:
% grid: obstacle information matrix (1 = obstacle)
% bound: side length of grid
%% Outputs:
% r: unused
%% Dependencies:
% N/A
%% Uses:
% plotfinalpath.m
figure
hold on
for i = 1:length(grid(1,:))
    for j = 1:length(grid(:,1))
        if(grid(i,j) == 1)
            rectangle('position',[i-1,j-1,1,1],'FaceColor',[0 0 0])
        end
    end
end
xlim([0 bound]); ylim([0 bound])
end