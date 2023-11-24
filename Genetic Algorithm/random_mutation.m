function [mutatedPopulation] = random_mutation(population, numDesignVars)
    % Threshold value
     p = 0.05;
     
     % Walk through each individual in the population
     for i = 1 : numel(population)
         % Loop through each individuals design variables
         for j = 1 : numDesignVars
             % Loop through each of the bits in the variable
             for k = 1 : numel(population(i).individual(j).variables)
                 % Generate random number
                 randNumber = rand;
                 
                 % Flip the bit if less than the threshold
                 if (randNumber < p)
                     if (population(i).individual(j).variables(k) == 0)
                         population(i).individual(j).variables(k) = 1;
                     else
                         population(i).individual(j).variables(k) = 0;
                     end
                 end
             end
         end
     end
     
     % Pass population out
     mutatedPopulation = population;
end
