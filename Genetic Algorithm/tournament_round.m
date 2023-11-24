function [roundWinners] = tournament_round(population, constraintMatrix, numDesignVars)
    % Get index array for the population
    populationIndices = 1 : 1 : numel(population);
    
    % Randomly pair all the individuals (round 1)
    count = 0;
    
    while ~isempty(populationIndices)
        % Generate one random number
        randomNumber1 = randi(numel(populationIndices), 1);
        
        % Remove from the list
        collectNumber1 = populationIndices(randomNumber1);
        populationIndices(randomNumber1) = [];
        
        % Generate a seond random
        randomNumber2 = randi(numel(populationIndices), 1);
        
        % Remove from the list
        collectNumber2 = populationIndices(randomNumber2);
        populationIndices(randomNumber2) = [];
        
        % Store the pair
        count = count + 1;
        roundPairing(count, :) = [collectNumber1 collectNumber2];
    end
    
    % Perform the tournament
    for i = 1 : numel(roundPairing(:, 1))
        % Compare to see if each is within the constraints
        count1 = 0;
        count2 = 0;
        
        var1ConstraintViolation = [];
        var2ConstraintViolation = [];
        
        for j = 1 : numDesignVars
            % Convert the variables from binary
            var1 = bi2de(fliplr(population(roundPairing(i, 1)).individual(j).variables));
            var2 = bi2de(fliplr(population(roundPairing(i, 2)).individual(j).variables));
            
            % See if they are outside the constraints
            if (var1 > constraintMatrix(j, 2) || var1 < constraintMatrix(j, 1))
                if (var1 > constraintMatrix(j, 2))
                    var1Delta = var1 - constraintMatrix(j, 2);
                else
                    var1Delta = constraintMatrix(j, 1) - var1;
                end
                
                % Normalize the violation
                normVar1Delta = var1Delta / (constraintMatrix(j, 2) - constraintMatrix(j, 1));
                
                count1 = count1 + 1;
                var1ConstraintViolation(count1, :) = [j normVar1Delta];
            end
            
            if (var2 > constraintMatrix(j, 2) || var2 < constraintMatrix(j, 1))
                if (var1 > constraintMatrix(j, 2))
                    var2Delta = var2 - constraintMatrix(j, 2);
                else
                    var2Delta = constraintMatrix(j, 1) - var2;
                end
                
                % Normalize the violation
                normVar2Delta = var2Delta / (constraintMatrix(j, 2) - constraintMatrix(j, 1));

                count2 = count2 + 1;
                var2ConstraintViolation(count2, :) = [j normVar2Delta];
            end     
        end
        
        % 3 options: both violate, one violates, none violate. Evaluate all
        % Both violate
        if (~isempty(var1ConstraintViolation) && ~isempty(var2ConstraintViolation))
            % Determine total constraint violations
            totalViolation1 = sum(var1ConstraintViolation(:, 2));
            totalViolation2 = sum(var2ConstraintViolation(:, 2));
            
            % Pick the one with smallest violation
            if (totalViolation1 < totalViolation2)
                roundWinners(i) = roundPairing(i, 1);
            else
                roundWinners(i) = roundPairing(i, 2);
            end
        
        % One violates, but not the other
        elseif (~isempty(var1ConstraintViolation))
            roundWinners(i) = roundPairing(i, 2);
        elseif (~isempty(var2ConstraintViolation))
            roundWinners(i) = roundPairing(i, 1);
        
        % If none violate
        else
            if (population(roundPairing(i, 1)).result) < (population(roundPairing(i, 2)).result)
                roundWinners(i) = roundPairing(i, 1);
            else
                roundWinners(i) = roundPairing(i, 2);
            end
        end
    end
end