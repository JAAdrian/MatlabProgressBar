% Demo of using ASCII hashes instead of the fancy Unicode blocks.
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date  :  25-Jun-2016 14:26:43
%


addpath('..');

numIterations = 100;


%% Don't use unicode characters

obj = ProgressBar(numIterations, ...
    'UseUnicode', false, ...
    'Title', 'ASCII' ...
    );

for iIteration = 1:numIterations
    pause(0.1);
    
    obj.step([], [], []);
end
obj.release();






% End of file: j_NonUnicodeProgressBar.m
