clc;
clear all;
close all;

%% Initialize parameters
k = 0;
numDesignVars = 4; % M, H, R, dr
popSize = 400;
numGen = 800;

drMap = 0 : 1E-4 : 0.5;

%% Setup constraints for design variables
constraintStruct(1, :) = [3 7];
constraintStruct(2, :) = [1 2];
constraintStruct(3, :) = [1 2];
constraintStruct(4, :) = [1 2201];

%% Create initial population
[population] = create_initial_population(numDesignVars, popSize, constraintStruct);

%% Run the optimization for as many generations as specified
while (k < (numGen - 1))
    % Compute f(x) for each of the individuals in the population
    [population] = compute_obj_function(population, numDesignVars, drMap);
    
    % Plot each individual at the generation
    xGen = (k + 1) * ones(1, popSize);
    
    for i = 1 : numel(population)
        yVal(i) = population(i).result;
    end
    
    meanVals(k + 1) = mean(yVal);
    minVals(k + 1) = min(yVal);
    
    % Select np/2 parent pairs from Pk for crossover (selection)
    %[parentPairIndices] = roulette_wheel_selection(population);
    [parentPairIndices] = tournament_selection(population, constraintStruct, numDesignVars);
    
    % Generate a new population (crossover)
    [newPopulation] = single_point_crossover(population, parentPairIndices, numDesignVars);
    
    % Randomly mutate some points in the population (mutation)
    [mutatedPopulation] = random_mutation(newPopulation, numDesignVars);
    
    % Reassign to new population
    [population] = mutatedPopulation;
    
    % Convert all numbers from binary to decimal
    [population] = convert_all_binary_design_variables(population);
    
    % Increase generation count
    genVec(k + 1) = k + 1;
    k = k + 1 
end

%% Plot mean and min
figure();
plot(genVec, meanVals, '-*');
hold on;
plot(genVec, minVals, '-o');

%% Get objective functions for final values
[population] = compute_obj_function(population, numDesignVars, drMap);

%% Filter out all non-valid results
count = 0;

for i = 1 : numel(population)
    if (population(i).M >= constraintStruct(1, 1) && population(i).M <= constraintStruct(1, 2)) && ...
        (population(i).H >= constraintStruct(2, 1) && population(i).H <= constraintStruct(2, 2)) && ...
        (population(i).R >= constraintStruct(3, 1) && population(i).R <= constraintStruct(3, 2)) && ...
        (population(i).dr >= constraintStruct(4, 1) && population(i).dr <= constraintStruct(4, 2))
        
        count = count + 1;
        viableIndices(count) = i;
    end
end
    
%% Get viable options into an array
viableSolutionsStruct = population(viableIndices);

%% Find the minimum of all viable options
for i = 1 : numel(viableSolutionsStruct)
    viableSolutionsResults(i) = viableSolutionsStruct(i).result;
end

[solution, solutionIndex] = min(viableSolutionsResults);

optDesignVars = viableSolutionsStruct(solutionIndex);

drActual = drMap(optDesignVars.dr);


