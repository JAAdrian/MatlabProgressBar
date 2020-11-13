% This script shows all currently implemented features one by one.
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
%

clear;
close all;

addpath('..');

numIterations = 25;


%% Easy Setup WITH Known Number of Iterations
% This should be your every-day solution if you don't care for additional feature and just want to
% have a progress bar for your for-loop
for iIteration = progress(1:numIterations)
    pause(0.3);
end

% You can do the same thing but alter any bar's property (learn about those later on). For example,
% customize the shown bar title in the front.
for iIteration = progress(1:numIterations, 'Title', 'New Title')
    pause(0.3);
end


%% Setup WITHOUT Known Number of Iterations
% If you just want to keep track of iterations, use the main class and don't pass a total number of
% iterations. Here, we instanciate a progress bar object and use it for iteration updates.
b = ProgressBar();

counter = 0;
while counter < numIterations
    counter = counter + 1;
    pause(0.3);
    
    b(1, [], []);
end
b.release();


% You can do the same thing but alter any bar's property (learn about those later on). For example,
% customize the shown bar title in the front.
b = ProgressBar([], 'Title', 'Test');

counter = 0;
while counter < numIterations
    counter = counter + 1;
    pause(0.3);
    
    b(1, [], []);
end
b.release();


%% Custom Print Update Rate
% The default update rate is 5 Hz. We can change it for smoother looks.
numIterations = 5e5;

% change the update rate to, e.g., 10 Hz
b = ProgressBar(numIterations, ...
    'UpdateRate', 10 ...
    );

for iIteration = 1:numIterations
    b(1, [], []);
end
b.release();


% Set the upate rate to infinity to print at every call of the progress bar
updateRateHz = inf;
numIterations = 100;

% pass the number of iterations and the update cycle in Hz
b = ProgressBar(numIterations, ...
    'UpdateRate', updateRateHz ...
    );

for iIteration = 1:numIterations
    b(1, [], []);
    
    pause(0.1);
end
b.release();






