function [xOpt, fOpt, exitFlag, iter, opt, count, counter] = flasher_optimization()
    % Run Lang code
    
    % Define number of variables and setup dr mapping
    numVars = 4;
    drCorrect = .2 : 1E-4 : .4;
    
    % Define upper and lower bounds and constraints (M, H, R, dr)
    lx = [3 1 1 1];  % lower bounds   
    ux = [7 2 2 length(drCorrect)];  % upper bounds
    
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    
    % Define options to be used
    options = optimoptions(@ga, ...
                    'Display', 'iter', ...
                    'UseParallel', false, ...
                    'PopulationSize', 40, ...
                    'MaxGenerations', 60, ...
                    'FunctionTolerance', 1e-6, ...
                    'PlotFcn', {@gaplotbestf, @gaplotscorediversity});
                
    % Define "global" variables
    iter = [];
    opt = [];
    count = [];
    counter = 0;
    
    % Output function to collect data
    function stop = outfun(x, ov, state)
        iter = [iter; ov.iteration];
        opt = [opt; ov.firstorderopt];
        count = [count; ov.funccount];
        stop = false;
    end

    % Define objective function
    function [f] = objcon(x)      
        % Map dr appropriately
        try
            x(4) = drCorrect(x(4));
        catch
            pause(1);
        end
        
        % Run simulation
        %[dia] = optimize_flasher_series(x);
        [dia] = flasher_function(x);
        
        % Assign to output
        f = -dia;
        
        % Increase counter
        counter = counter + 1;
    end
    
    %%----------------------- Don't need to change after this point
    xlast = [];
    flast = [];
%    clast = [];
%    ceqlast = [];
    
    % Perform optimization
    [xOpt, fOpt, exitFlag] = ga(@obj, numVars, A, b, Aeq, beq, lx, ux, [], [1 2 3 4], options);
    
    % Define objective function
    function [f] = obj(x)
        if ~isequal(x, xlast)
            [flast] = objcon(x);
            xlast = x;
        end
        
        f = flast;
    end

    % Define constraint function
%     function [c, ceq] = con(x)
%         if ~isequal(x, xlast)
%             [flast, clast, ceqlast] = objcon(x);
%             xlast = x;
%         end
%         
%         c = clast;
%         ceq = ceqlast;
%         
%     end
end
