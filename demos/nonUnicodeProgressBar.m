% Demo of using ASCII hashes instead of the fancy Unicode blocks.
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
%

clear;
close all;

addpath('..');

numIterations = 100;


%% Demo of Not Using Unicode Characters
b = ProgressBar(numIterations, ...
    'UseUnicode', false, ...
    'Title', 'ASCII' ...
    );

for iIteration = 1:numIterations
    pause(0.1);
    
    b([], [], []);
end
b.release();

