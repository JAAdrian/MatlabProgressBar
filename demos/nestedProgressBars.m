% Demo of nested bars. At this point only one nested bar is supported
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
%


addpath('..');

numOuterIterations = 3;
numInnerIterations = 15;


%% Nested Bars without Inner Update Rate
% be sure to set the update rate to inf to disable a timed printing of the bar!
b1 = ProgressBar(numOuterIterations, ...
    'UpdateRate', inf, ...
    'Title', 'Loop 1' ...
    );

% helper method to print a first progress bar before the inner loop starts.
% This prevents a blank line until the first b1.step() is called.
b1.setup([], [], []);
for iOuterIteration = 1:numOuterIterations
    b2 = ProgressBar(numInnerIterations, ...
        'UpdateRate', inf, ...
        'Title', 'Loop 2' ...
        );
    b2.setup([], [], []);
    
    for jInnerIteration = 1:numInnerIterations
        b2(1, [], []);
        
        pause(0.1);
    end
    b2.release();
    
    b1(1, [], []);
end
b1.release();



%% Nested Bars WITH Inner Update Rate
numInnerIterations = 50e3;

% be sure to set the update rate to inf to disable a timed printing of the bar!
b1 = ProgressBar(numOuterIterations, ...
    'UpdateRate', inf, ...
    'Title', 'Loop 1' ...
    );

b1.setup([], [], []);
for iOuterIteration = 1:numOuterIterations
    % this progress can have an update rate!
    b2 = ProgressBar(numInnerIterations, ...
        'UpdateRate', 5, ...
        'Title', 'Loop 2' ...
        );
    b2.setup([], [], []);
    
    for jInnerIteration = 1:numInnerIterations    
        b2.step(1, [], []);
    end
    b2.release();
    
    b1.step(1, [], []);
end
b1.release();


