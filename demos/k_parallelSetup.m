% <purpose of this file>
%
% Author:  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date  :  27-Jun-2016 22:04:18
%


addpath('..');

numIterations = 500;

if isempty(gcp('nocreate')),
    parpool();
end

obj = ProgressBar(numIterations, ...
    'UpdateRate', 5, ...
    'Parallel', true, ...
    'Title', 'Parallel' ...
    );


parfor iIteration = 1:numIterations,
    pause(0.1);
    
    obj.updateParallel();
end
obj.close();







% End of file: k_parallelSetup.m
