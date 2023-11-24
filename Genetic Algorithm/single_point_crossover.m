function [newPopulation] = single_point_crossover(population, parentPairIndices, numDesignVars)
    % Set counter
    count = 0;
    
    % Cross-over each of the parents
    for i = 1 : numel(parentPairIndices(:,1))
        % Loop through each of the variables
        for j = 1 : numDesignVars
            % Get number of bits for the variable
            numBits = numel(population(parentPairIndices(i, 1)).individual(j).variables);
            
            % Calculate cross-over point
            crossOverPoint = randi((numBits - 1), 1);
            
            % Cross-over variables
            cross1 = [population(parentPairIndices(i, 1)).individual(j).variables(1 : crossOverPoint) ...
                population(parentPairIndices(i, 2)).individual(j).variables((crossOverPoint + 1) : end)];
            
            cross2 = [population(parentPairIndices(i, 2)).individual(j).variables(1 : crossOverPoint) ...
                population(parentPairIndices(i, 1)).individual(j).variables((crossOverPoint + 1) : end)];
            
            % Store the variables
            newPopulation(count + 1).individual(j).variables = cross1;
            newPopulation(count + 2).individual(j).variables = cross2;
        end
        
        count = count + 2;
    end
end