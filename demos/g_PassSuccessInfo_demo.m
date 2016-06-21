% <purpose of this file>
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  21-Jun-2016 17:48:54
%

clear;
close all;



%% Pass success information of the current iteration

obj = ProgressBar(numIterations);

wasSuccessful = logical(binornd(1, 0.95), numIterations, 1);
for iIteration = 1:numIterations,
    pause(1e-2);
    
    obj.update(wasSuccessful(iIteration));
end
obj.close();






% End of file: g_PassSuccessInfo_demo.m
