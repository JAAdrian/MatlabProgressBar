% <purpose of this file>
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  21-Jun-2016 17:13:27
%

clear;
close all;
clc;

addpath('..');

numIterations = 20;


%% Simple setup WITHOUT known number of iterations

obj = ProgressBar([], 'Title', 'Test');

for iIteration = 1:numIterations,
    pause(0.1);
    
    obj.update();
end
obj.close();





% End of file: a_ProgressBarWithoutTotal_demo.m
