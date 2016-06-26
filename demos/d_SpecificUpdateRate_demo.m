% <purpose of this file>
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  21-Jun-2016 17:14:54
%


addpath('..');

numIterations = 1e6;

%% Desired update rate should be 5 Hz

updateRateHz = 5;

% pass the number of iterations and the update cycle in Hz
obj = ProgressBar(numIterations, ...
    'UpdateRate', updateRateHz ...
    );

for iIteration = 1:numIterations,
    obj.update();
end
obj.close();








% End of file: d_SpecificUpdateRate_demo.m
