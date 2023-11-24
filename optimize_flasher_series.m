function [flashDia] = optimize_flasher_series(x)
    % Specify file paths
    baseDir = pwd;
    
    % Append file names to path
    inpath = strcat(string(baseDir) + '\', 'in.csv');
    outpath = strcat(string(baseDir) + '\', 'out.csv');
    mathpath = strcat(string(baseDir) + '\', 'flasher_optimization.wls > NUL'); %  > NUL is turned on to suppress output
    
    % Box constraints 
    boxHeight = 0.3048;
    boxWidth = 0.5588;
    
    % Pass variables to v
    v = x; % Variables M, H, R, dr

    writematrix(v, inpath);

    % Run script in mathematica
    tic
    dos(mathpath);
    toc
    
    % Read in the results and assign to variables
    vNEW=readmatrix(outpath);

    CPicDia=vNEW(3, 1); %Crease pattern incircle diameter
    ffDia=vNEW(5, 1);   %folded form circumcircle diameter
    OPh=vNEW(6, 1);     %outermost panel height

    % Scale the dimensions appropriately
    if ((boxHeight / OPh) <= (boxWidth / ffDia))
        flashDia = CPicDia * (boxHeight / OPh);
    else
        flashDia = CPicDia * (boxWidth / ffDia);
    end
    
    % Save data
    save FlasherInfo.Mat
end