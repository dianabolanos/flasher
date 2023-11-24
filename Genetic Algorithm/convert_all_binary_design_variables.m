function [updatedPopulation] = convert_all_binary_design_variables(population)
    for i = 1 : numel(population) % M, H, R, dr
        population(i).M = bi2de(fliplr(population(i).individual(1).variables));
        population(i).H = bi2de(fliplr(population(i).individual(2).variables));
        population(i).R = bi2de(fliplr(population(i).individual(3).variables));
        population(i).dr = bi2de(fliplr(population(i).individual(4).variables));
    end
    
    updatedPopulation = population;
end