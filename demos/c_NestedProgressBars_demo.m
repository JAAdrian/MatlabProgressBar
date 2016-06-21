% <purpose of this file>
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  21-Jun-2016 17:14:36
%

clear;
close all;
clc;

addpath('..');

numIterations = 1e3;


%% Nested Bars

obj1 = ProgressBar(5, ...
    'Title', 'Loop 1' ...
    );

for iOuterIteration = 1:5,
    obj1.update()
    
    obj2 = ProgressBar(numIterations / 10, ...
        'Title', 'Loop 2' ...
        );
    
    for jInnerIteration = 1:numIterations/10,
        pause(1e-2);
        
        obj2.update();
    end
%     delete(obj2);
    obj2.close();
end
obj1.close();





% End of file: c_NestedProgressBars_demo.m
