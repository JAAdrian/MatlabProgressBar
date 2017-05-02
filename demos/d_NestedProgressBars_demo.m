% Demo of nested bars. At this point only one nested bar is supported
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date  :  21-Jun-2016 17:14:36
%


addpath('..');

numOuterIterations = 3;
numInnerIterations = 20;



%% Nested Bars without inner update rate

% be sure to set the update rate to inf to disable a timed printing of the
% bar!
obj1 = ProgressBar(numOuterIterations, ...
    'UpdateRate', inf, ...
    'Title', 'Loop 1' ...
    );

% helper method to print a first progress bar before the inner loop starts.
% This prevents a blank line until the first obj1.step() is called.
obj1.setup([], [], []);
for iOuterIteration = 1:numOuterIterations
    obj2 = ProgressBar(numInnerIterations, ...
        'UpdateRate', inf, ...
        'Title', 'Loop 2' ...
        );
    obj2.setup([], [], []);
    
    for jInnerIteration = 1:numInnerIterations
        obj2.step(1, [], []);
        
        pause(0.1);
    end
    obj2.release();
    
    obj1.step(1, [], []);
end
obj1.release();




%% Nested Bars WITH inner update rate

numInnerIterations = 50e3;

% be sure to set the update rate to inf to disable a timed printing of the
% bar!
obj1 = ProgressBar(numOuterIterations, ...
    'UpdateRate', inf, ...
    'Title', 'Loop 1' ...
    );

obj1.setup([], [], []);
for iOuterIteration = 1:numOuterIterations
    % this progress can have an update rate!
    obj2 = ProgressBar(numInnerIterations, ...
        'UpdateRate', 5, ...
        'Title', 'Loop 2' ...
        );
    obj2.setup([], [], []);
    
    for jInnerIteration = 1:numInnerIterations    
        obj2.step(1, [], []);
    end
    obj2.release();
    
    obj1.step(1, [], []);
end
obj1.release();





% End of file: d_NestedProgressBars_demo.m
