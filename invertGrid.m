function grid = invertgrid(grid)
        % Author: Paul Lathrop, MAE, UCSD
        % Date last edited: 4/6/23
        %% Description:
        % Function inverts grid (1 to 0, 0 to 1)
        %% Dependencies:
        % N/A
        %% Uses:
        % sameConnectedComponent, main.m->GRNFLCC (inline)
        for s = 1:length(grid(:,1))
            for j = 1:length(grid(1,:))
                if(grid(s,j) == 0),grid(s,j) = 1; else, grid(s,j) = 0; end
            end
        end
    end