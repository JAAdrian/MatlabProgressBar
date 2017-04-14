% Demo how to manipulate the update rate
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date  :  21-Jun-2016 17:14:54
%


addpath('..');

numIterations = 1e6;


%% Desired update rate should be 10 Hz (the default is 5 Hz)

updateRateHz = 10;

% pass the number of iterations and the update cycle in Hz
obj = ProgressBar(numIterations, ...
    'UpdateRate', updateRateHz ...
    );

for iIteration = 1:numIterations
    obj.step(1, [], []);
end
obj.release();




%% No desired update rate
% (incorporate a pause to prevent faster updates than MATLAB can print)

numIterations = 100;

updateRateHz = inf;

% pass the number of iterations and the update cycle in Hz
obj = ProgressBar(numIterations, ...
    'UpdateRate', updateRateHz ...
    );

for iIteration = 1:numIterations
    obj.step(1, [], []);
    
    pause(0.1);
end
obj.release();








% End of file: c_SpecificUpdateRate_demo.m
