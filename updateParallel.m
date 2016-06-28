function [dirName, pattern] = updateParallel(stepSize)
%UPDATEPARALLEL <purpose in one line!>
% -------------------------------------------------------------------------
% <Detailed description of the function>
%
% Usage: [y] = updateParallel(input)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author:  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date  :  28-Jun-2016 16:52
%

% History:  v0.1  initial version, 28-Jun-2016 (JA)
%

persistent workerFileName;
workerDirName  = tempdir;
filePattern = 'progbarworker_';


% input parsing and validating
if (nargin < 2 || isempty(stepSize)) && ~nargout,
    stepSize = 1;
end
if (nargin < 2 || isempty(stepSize)) && nargout,
    dirName = workerDirName;
    pattern = [filePattern, '*'];
    
    return;
end

validateattributes(stepSize, ...
    {'numeric'}, ...
    {'scalar', 'positive', 'integer', 'real', 'nonnan', ...
    'finite', 'nonempty'} ...
    );

if isempty(workerFileName),
    uuid = char(java.util.UUID.randomUUID);
    workerFileName = fullfile(workerDirName, [filePattern, uuid]);
    
    fid = fopen(workerFileName, 'wb');
    fwrite(fid, 0, 'uint64');
    fclose(fid);
end

fid = fopen(workerFileName, 'r+b');
if fid > 0,
    status = fread(fid, 1, 'uint64');
    
    fseek(fid, 0, 'bof');
    fwrite(fid, status + stepSize, 'uint64');
    
    fclose(fid);
end







% End of file: updateParallel.m
