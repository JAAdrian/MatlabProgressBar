% <purpose of this file>
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  21-Jun-2016 17:14:36
%


addpath('..');

numOuterIterations = 3;
numInnerIterations = 20;



%% Nested Bars without inner update rate

obj1 = ProgressBar(numOuterIterations, ...
    'UpdateRate', inf, ...
    'Title', 'Loop 1' ...
    );

obj1.start();
for iOuterIteration = 1:numOuterIterations,
    obj2 = ProgressBar(numInnerIterations, ...
        'UpdateRate', inf, ...
        'Title', 'Loop 2' ...
        );
    
    for jInnerIteration = 1:numInnerIterations,
        obj2.update();
        
        pause(0.1);
    end
    obj2.close();
    
    obj1.update();
end
obj1.close();



%% Nested Bars WITH inner update rate

numInnerIterations = 50e3;

% Don't have an update rate here!!!!
obj1 = ProgressBar(numOuterIterations, ...
    'UpdateRate', inf, ...
    'Title', 'Loop 1' ...
    );

obj1.start();
for iOuterIteration = 1:numOuterIterations,
    obj2 = ProgressBar(numInnerIterations, ...
        'UpdateRate', 5, ...
        'Title', 'Loop 2' ...
        );
    
    for jInnerIteration = 1:numInnerIterations,        
        obj2.update();
    end
    obj2.close();
    
    obj1.update();
end
obj1.close();





% End of file: c_NestedProgressBars_demo.m
