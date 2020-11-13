% If the title is chosen very long it will work as a banner, rotating each step a bit further.
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
%

clear;
close all;

addpath('..');

numIterations = 50;

%% Short Title
b = ProgressBar(numIterations, ...
    'Title', 'Short' ...
    );
for iIteration = 1:numIterations
    pause(0.1);
    
    b(1, [], []);
end
b.release();

%% Long Title
numIterations = 100;

b = ProgressBar(numIterations, ...
    'Title', 'A Long Long Long Title' ...
    );
for iIteration = 1:numIterations
    pause(0.1);
    
    b(1, [], []);
end
b.release();



