% Demo of the parallel functionality using a parfor loop. This script may throw errors if you don't
% own the Parallel Processing Toolbox.
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
%

clear;
close all;

addpath('..');

numIterations = 500;

if isempty(gcp('nocreate'))
    parpool();
end


%% Without Knowledge of Total Number of Iterations
% Instantiate the object with the 'IsParallel' switch set to true and save
% the aux. files in the default directory (tempdir)
b = ProgressBar([], ...
    'IsParallel', true, ...
    'Title', 'Parallel 1' ...
    );

% ALWAYS CALL THE SETUP() METHOD FIRST!!!
b.setup([], [], []);
parfor iIteration = 1:numIterations
    pause(0.1);
    
    % USE THIS FUNCTION AND NOT THE STEP() METHOD OF THE OBJECT!!!
    updateParallel();
end
b.release();


%% With Knowledge of Total Number of Iterations
% Instantiate the object with the 'Parallel' switch set to true and save
% the aux. files in the current working directory (pwd)
b = ProgressBar(numIterations, ...
    'IsParallel', true, ...
    'WorkerDirectory', pwd(), ...
    'Title', 'Parallel 2' ...
    );

% ALWAYS CALL THE SETUP() METHOD FIRST!!!
b.setup([], [], []);
parfor iIteration = 1:numIterations
    pause(0.1);
    
    % USE THIS FUNCTION AND NOT THE STEP() METHOD OF THE OBJECT!!!
    updateParallel([], pwd);
end
b.release();


