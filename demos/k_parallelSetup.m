% Demo of the parallel functionality using a parfor loop. This script may
% throw errors if you don't own the Parallel Processing Toolbox.
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date  :  27-Jun-2016 22:04:18
%


addpath('..');

numIterations = 500;

if isempty(gcp('nocreate'))
    parpool();
end



%% Without knowledge of total number of iterations

% Instantiate the object with the 'IsParallel' switch set to true and save
% the aux. files in the pwd.
obj = ProgressBar([], ...
    'IsParallel', true, ...
    'WorkerDirectory', pwd, ...
    'Title', 'Parallel 1' ...
    );


parfor iIteration = 1:numIterations
    pause(0.1);
    
    % USE THIS FUNCTION AND NOT THE STEP() METHOD OF THE OBJECT!!!
    updateParallel([], pwd);
end
obj.release();




%% With knowledge of total number of iterations

% Instantiate the object with the 'Parallel' switch set to true and save
% the aux. files in the default directory (tempdir)
obj = ProgressBar(numIterations, ...
    'IsParallel', true, ...
    'Title', 'Parallel 2' ...
    );


parfor iIteration = 1:numIterations
    pause(0.1);
    
    % USE THIS FUNCTION AND NOT THE STEP() METHOD OF THE OBJECT!!!
    updateParallel();
end
obj.release();


% End of file: k_parallelSetup.m
