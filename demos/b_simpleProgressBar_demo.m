% Demo of some standard applications with known total number of iterations
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date  :  21-Jun-2016 17:12:41
%


addpath('..');

numIterations = 50;


%% Simple setup WITH known number of iterations

obj = ProgressBar(numIterations);
for iIteration = 1:numIterations
    pause(0.1);
    
    obj.step([], [], []);
end
obj.release();




%% Simple setup WITH known number of iterations and title

obj = ProgressBar(numIterations, ...
    'Title', 'Small' ...
    );

for iIteration = 1:numIterations
    pause(0.1);
    
    obj.step([], [], []);
end
obj.release();




%% Now with a different step size

obj = ProgressBar(numIterations, ...
    'Title', 'Different Step Size' ...
    );

stepSize = 2;

for iIteration = 1:stepSize:numIterations
    pause(0.1);
    
    obj.step(stepSize, [], []);
end
obj.release();




%% Simulate an iteration which takes longer so the timed printing stops

pauses = [0.1*ones(numIterations/2-1,1); 2; 0.1*ones(numIterations/2,1)];

obj = ProgressBar(numIterations, ...
    'Title', 'Waiting' ...
    );

for iIteration = 1:numIterations
    pause(pauses(iIteration));
    
    obj.step([], [], []);
end
obj.release();

%% Simulate a progress with it/sec < 1

numIterations = 10;
obj = ProgressBar(numIterations, ...
    'Title', 'Slow Progress, Long Title' ...
    );

obj.setup([], [], []);
for iIteration = 1:numIterations
    pause(1.5);
    
    obj.step([], [], []);
end
obj.release();





% End of file: b_simpleProgressBar_demo.m
