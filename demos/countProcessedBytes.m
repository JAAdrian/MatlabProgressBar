% Demo of another counting unit. At this point, only 'Bytes' is supported as alternative.
%
% Author:  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
%

clear;
close all;

addpath('..');

% set up some dummy file sizes and 'processing times' for each file
dummyFile = {rand(1e3, 1), rand(5e2, 1), rand(1e5, 1), rand(1e5, 1)};
filePause = [1, 0.5, 3, 3];

numTotalBytes = sum(cellfun(@(x) size(x, 1), dummyFile));


%% Work with Size of Processed Bytes WITHOUT Knowledge of Total Bytes
b = ProgressBar([], ...
    'Unit', 'Bytes', ...
    'Title', 'Test Bytes 1' ...
    );

for iFile = 1:length(dummyFile)
    buffer = dummyFile{iFile};
    
    pause(filePause(iFile));
    b(length(buffer), [], []);
end
b.release();



%% Work With Size of Processed Bytes WITH Knowledge of Total Bytes
b = ProgressBar(numTotalBytes, ...
    'Unit', 'Bytes', ...
    'Title', 'Test Bytes 2' ...
    );

for iFile = 1:length(dummyFile)
    buffer = dummyFile{iFile};
        
    pause(filePause(iFile));
    b.step(length(buffer), [], []);
end
b.release();




