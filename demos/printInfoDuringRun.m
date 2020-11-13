% Demo of the printMessage() method. In 3 iterations an info message is printed.
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
%

clear;
close all;

addpath('..');

numIterations = 1e2;


%% Simple Setup and Print a Message in Desired Iterations
b = ProgressBar(numIterations, ...
    'Title', 'Progress' ...
    );

for iIteration = 1:numIterations
    b(1, [], []);
    
    if iIteration == 30 || iIteration == 50 || iIteration == 70
        b.printMessage(sprintf('Hello! @Iteration %i', iIteration));
    end
    
    pause(0.1);
end
b.release();

