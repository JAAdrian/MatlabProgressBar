% <purpose of this file>
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  21-Jun-2016 17:13:27
%

clear;
close all;
clc;

addpath('..');

numIterations = 1e3;

%% Simple setup WITHOUT known number of iterations

obj = ProgressBar();

for iIteration = 1:numIterations,
    pause(1e-1);
    
    obj.update();
end
obj.close();





% End of file: a_ProgressBarWithoutTotal_demo.m
