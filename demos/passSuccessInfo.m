% Demo of the success bool of the update() method. This can be used to print failure messages during
% the loop.
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
%

clear;
close all;

addpath('..');

numIterations = 1e2;


%% Pass Success Information of the Current Iteration
b = ProgressBar(numIterations, ...
    'Title', 'Test Success' ...
    );

% throw the dice to generate some booleans. This parameters produce a
% success rate of 95%
wasSuccessful = logical(binornd(1, 0.95, numIterations, 1));
for iIteration = 1:numIterations
    pause(0.1);
    
    b([], wasSuccessful(iIteration), []);
end
b.release();



