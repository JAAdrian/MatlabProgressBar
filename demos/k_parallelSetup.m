% <purpose of this file>
%
% Author:  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date  :  27-Jun-2016 22:04:18
%


addpath('..');

numIterations = 20e3;

if isempty(gcp('nocreate')),
    parpool();
end

obj = ProgressBar(numIterations, ...
    'UpdateRate', 1, ...
    'Parallel', true, ...
    'Title', 'Parallel' ...
    );

parfor iIteration = 1:numIterations,
    obj.updatePar();
end
obj.close();







% End of file: k_parallelSetup.m
