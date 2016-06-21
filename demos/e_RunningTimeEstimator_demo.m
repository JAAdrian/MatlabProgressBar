% <purpose of this file>
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  21-Jun-2016 17:15:28
%

clear;
close all;
clc;

addpath('..');

numIterations = 1e3;

%% Different time estimators

obj = ProgressBar(numIterations, ...
    'Title', 'Est. Order Test', ...
    'EstimatorOrder', 5);


for iIteration = 1:numIterations,
    pause(1e-1);
    
    obj.update();
end
obj.close();


% End of file: e_RunningTimeEstimator_demo.m
