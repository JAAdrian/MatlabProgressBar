% This script will show how the bar can be programmatically disabled.
% 
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
%

clear;
close all;

addpath('..');

numIterations = 25;


%% This Will Show the Bar
for iIteration = progress(1:numIterations)
    pause(0.1);
end


%% This Will Disable the Bar
for iIteration = progress(1:numIterations, 'IsActive', false)
    fprintf('New iteration...\n');
    pause(0.1);
end
