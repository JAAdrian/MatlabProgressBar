% <purpose of this file>
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  21-Jun-2016 17:48:54
%

clear;
close all;
clc

addpath('..');

numIterations = 1e2;


%% Pass success information of the current iteration

obj = ProgressBar(numIterations, ...
    'Title', 'Test Success' ...
    );

wasSuccessful = logical(binornd(1, 0.95, numIterations, 1));
for iIteration = 1:numIterations,
    pause(0.1);
    
    obj.update([], wasSuccessful(iIteration));
end
obj.close();






% End of file: g_PassSuccessInfo_demo.m
