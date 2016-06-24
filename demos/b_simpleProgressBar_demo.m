% <purpose of this file>
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  21-Jun-2016 17:12:41
%

clear;
close all;
clc;

addpath('..');

numIterations = 50;


%% Simple setup WITH known number of iterations

obj = ProgressBar(numIterations, ...
    'Title', 'Progress' ...
    );

for iIteration = 1:numIterations,
    pause(0.1);
    
    obj.update();
end
obj.close();


%% Now with different step size

obj = ProgressBar(numIterations, ...
    'Title', 'Step Size 2' ...
    );

for iIteration = 1:2:numIterations,
    pause(0.1);
    
    obj.update(2);
end
obj.close();

%% Simulate an iteration which takes longer so the timed printing stops

pauses = [0.1*ones(numIterations/2-1,1); 2; 0.1*ones(numIterations/2,1)];

obj = ProgressBar(numIterations, ...
    'Title', 'Waiting' ...
    );

for iIteration = 1:numIterations,
    pause(pauses(iIteration));
    
    obj.update();
end
obj.close();




% End of file: b_simpleProgressBar_demo.m
