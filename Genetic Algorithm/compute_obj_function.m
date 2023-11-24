function [population] = compute_obj_function(population, numDesignVars, mapping)
    for i = 1 : numel(population)
        % Convert from binary to decimal
        for j = 1 : numDesignVars
            convertedDesignVars(j) = bi2de(fliplr(population(i).individual(j).variables));
        end
        
        population(i).result = -objective_function(convertedDesignVars, mapping);
    end
end