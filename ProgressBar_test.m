% ProgressBar test file to be run by the MATLAB unit test function
% 'runtests.m'
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  26-Jun-2016 19:30:27
%

clear;
close all;

fileList = dir('demos');

% discard '.' and '..'
fileList = fileList(3:end);


%% run the demo files to check that they don't throw error
for iDemoFile = 1:length(fileList),
    run(fullfile('demos', fileList(iDemoFile).name));
end

%% be sure that no timer objects are left
timerObjects = timerfindall('Tag', 'ProgressBar');
assert(isempty(timerObjects));






% End of file: ProgressBar_test.m
