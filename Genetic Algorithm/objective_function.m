function [f] = objective_function(designVars, mapping)
    % Map last variable
    try
        designVars(4) = mapping(designVars(4));
    catch
        if (designVars(4) == 0)
            designVars(4) = mapping(1);
        end
    end
    
    f = flasher_function(designVars);
end