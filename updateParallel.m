function [dirName, pattern] = updateParallel(stepSize, workerDirName)
%UPDATEPARALLEL Update function when ProgressBar is used in parallel setup
% -------------------------------------------------------------------------
% This function replaces the update() method of the ProgressBar() class
% when a progress in a parfor loop should be displayed. The function writes
% to a temp file in the local temp dir. Each worker will call a copy of
% this function and if a persistent file name variable is not yet set a
% unique file name will be generated and a binary file will be initialized.
% Each worker remembers it's own file name to write to and will update its
% own current progress and write it to file. The ProgressBar() class will
% handle the management of all worker files.
% 
%
% Usage: [dirName, pattern] = updateParallel(stepSize)
%
%   Input:   ---------
%           stepSize - the size of the progress step when the function is
%                      called. This can be used to pass the number of
%                      processed bytes when using 'Bytes' as units. If
%                      bytes are used be sure to pass only integer values.
%                      [default: stepSize = 1]
%           workerDirName - directory where the auxiliary files will be
%                           written to. Typically, the files are irrelevant
%                           to the user so the default is the local temp
%                           directory. If this is unconvenient, the
%                           directory can be specified.
%                           [default: workerDirName = tempdir]
%
%  Output:   ---------
%        dirName - the directory name where the worker file was written to.
%                  This is an auxiliary function output which is used by
%                  the ProgressBar() class. Typically not be of interest
%                  for the user. The variable is only returned if no input
%                  arguments were passed!
%        filePattern - the common beginning of every file name before the
%                      unique part begins. This is an auxiliary function
%                      output which is used by the ProgressBar() class.
%                      Typically not be of interest for the user. The
%                      variable is only returned if no input arguments were
%                      passed!
%        
%
%
% Author:  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date  :  28-Jun-2016 16:52
%

% History:  v0.1  initial version, 28-Jun-2016 (JA)
%


% some constants
persistent workerFileName;
filePattern = 'progbarworker_';

% input parsing and validating
narginchk(0, 2);

if nargin < 2 || isempty(workerDirName),
    workerDirName = tempdir;
end
if nargin <1 || isempty(stepSize),
    stepSize = 1;
end
if ~nargin && nargout,
    if isempty(workerFileName),
        dirName = workerDirName;
    else
        dirName = fileparts(workerFileName);
    end
    pattern = [filePattern, '*'];
    
    return;
end

validateattributes(stepSize, ...
    {'numeric'}, ...
    {'scalar', 'positive', 'integer', 'real', 'nonnan', ...
    'finite', 'nonempty'} ...
    );



% if the function is called the first time the persistent variable is
% initialized and the worker file is created. The condition is skipped in
% the following calls.
if isempty(workerFileName),
    uuid = char(java.util.UUID.randomUUID);
    workerFileName = fullfile(workerDirName, [filePattern, uuid]);
    
    fid = fopen(workerFileName, 'wb');
    fwrite(fid, 0, 'uint64');
    fclose(fid);
end

% this part is executed every time the function is called:
% open the binary file and increment the existing progress with stepSize
fid = fopen(workerFileName, 'r+b');
if fid > 0,
    status = fread(fid, 1, 'uint64');
    
    fseek(fid, 0, 'bof');
    fwrite(fid, status + stepSize, 'uint64');
    
    fclose(fid);
end







% End of file: updateParallel.m
