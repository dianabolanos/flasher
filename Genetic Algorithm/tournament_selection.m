function [parentPairIndices] = tournament_selection(population, constraintMatrix, numDesignVars)
    % Conduct first and second rounds
    [round1Winners] = tournament_round(population, constraintMatrix, numDesignVars)';
    [round2Winners] = tournament_round(population, constraintMatrix, numDesignVars)';
    
    % Create pairings
    parentPairIndices = [round1Winners round2Winners];
end