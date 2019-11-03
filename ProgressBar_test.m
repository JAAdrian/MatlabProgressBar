% ProgressBar test file to be run by the MATLAB unit test function
% 'runtests.m'
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  26-Jun-2016 19:30:27
%

clear;
close all;

fileList = dir(fullfile('demos', '*.m'));
fileNames = {fileList.name}.';
fileNames = cellfun(@(x) fullfile('demos', x), fileNames, 'uni', false);


%% run the demo files to ensure that they don't throw error
for iDemoFile = 1:length(fileList)
    run(fileNames{iDemoFile});
end

%% be sure that no timer objects are left
timerObjects = timerfindall('Tag', 'ProgressBar');
assert(isempty(timerObjects));



