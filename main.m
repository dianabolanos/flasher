clc;
clear all;
close all;

[xOpt, fOpt, exitFlag, iter, opt, count, counter] = flasher_optimization();

% Remap and flip variables
drMap = 0.2 : 1E-4 : .4;

fOpt = -fOpt*.0254;
xOpt(4) = drMap(xOpt(4));

save HW_5.mat;