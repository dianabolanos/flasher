function [parentPairIndices] = roulette_wheel_selection(population)
    % Find the highest and lowest function values
    maxVal = 0;
    minVal = 0;
    
    for i = 1 : numel(population)
        if (population(i).result > maxVal)
            maxVal = population(i).result;
        end
        
        if (population(i).result < minVal)
            minVal = population(i).result;
        end
    end
    
    % Convert objective function to fitness values
    dF = (1.1 * maxVal) - (0.1 * minVal);
    
    for i = 1 : numel(population)
        fitnessValues(i) = (-(population(i).result) + dF) / max([1, (dF - minVal)]);
    end
    
    % Calculate size of table for each individual in the population
    totalFitnessValueSum = sum(fitnessValues);
    
    for i = 1 : numel(fitnessValues)
        S(i) = sum(fitnessValues(1 : i)) / totalFitnessValueSum;
    end
    
    % Randomly select index order
    for i = 1 : numel(S)
        randNumber = rand;
        
        % Find indices where random number lies between
        for j = 1 : numel(S)
            if (randNumber <= S(j))
                pairingIndices(i) = j;
                break;
            end
        end
    end
    
    % Pair indices
    pairNum = 1;
    
    for i = 1 : 2 : (numel(pairingIndices) - 1)
        parentPairIndices(pairNum, :) = [pairingIndices(i) pairingIndices(i + 1)];
        pairNum = pairNum + 1;
    end
    
end