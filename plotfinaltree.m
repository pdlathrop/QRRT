function plotfinaltree(env,nodes,parents)
% Author: Paul Lathrop
% Date last edited: 4/6/23
%% Description:
% Function plots final path in environment env
%% Inputs:
% env: environment
% nodes: returned tree of nodes
% parents: returned parent relationships
%% Outputs:
% N/A
%% Dependencies:
% plotenv.m
%% Uses:
% main.m

plotenv(env,length(env(1,:)));
hold on
for j = length(parents):-1:1
    plot(nodes(j,1),nodes(j,2),'r.','MarkerSize',32)
    line([nodes(j,1) nodes(parents(j),1)],[nodes(j,2) nodes(parents(j),2)],'Linestyle','-','LineWidth',4,'Color','black')
end
plot(nodes(1,1),nodes(1,2),'g.','MarkerSize',32)
set(gca,'FontSize',20,'TickLabelInterpreter','latex')

end

