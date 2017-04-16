% <purpose of this file>
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date  :  14-Apr-2017 21:49:26
%


addpath('..');

numIterations = 100;

%% Short Title
obj = ProgressBar(numIterations, ...
    'Title', 'Short' ...
    );
for iIteration = 1:numIterations
    pause(0.1);
    
    obj.step(1, [], []);
end
obj.release();

%% Long Title
numIterations = 100;

obj = ProgressBar(numIterations, ...
    'Title', 'A Long Long Long Title' ...
    );
for iIteration = 1:numIterations
    pause(0.1);
    
    obj.step(1, [], []);
end
obj.release();




% End of file: h_titleBanner.m
