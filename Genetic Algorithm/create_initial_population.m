function [population] = create_initial_population(numDesignVars, popSize, constraints)
    % Calculate the number of bits need for each variable
    for i = 1 : numDesignVars
        bits = 0;
        
        while ((2 ^ bits) <= constraints(i, end))
            bits = bits + 1;
        end
         
        % Create bitvariables
        bitVarsBase(i, :).variables = zeros(bits, 1)';
    end
    
    % Create population
    for i = 1 : popSize
        currentIndividual = bitVarsBase;
        
        % Randomly flip bits for design variables
        for j = 1 : numDesignVars
            for k = 1 : numel(currentIndividual(j).variables)
                randomNumber = rand;
                
                if (randomNumber > 0.5)
                    currentIndividual(j).variables(k) = 1;
                end
            end
        end
        
        % Store the individual
        population(i).individual = currentIndividual;
    end
            
end