% Script to demonstrate the ProgressBar class
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  20-Jun-2016 13:01:01
%

clear;
close all;

numIterations = 1e5;


%% Simple setup WITH known number of iterations

obj = ProgressBar(numIterations);

for iIteration = 1:numIterations,
    pause(1e-1);
    
    obj.update();
end
obj.close();





%% Simple setup WITHOUT known number of iterations

obj = ProgressBar();

for iIteration = 1:numIterations,
    pause(1e-1);
    
    obj.update();
end
obj.close();





%% Pass success information of the current iteration

obj = ProgressBar(numIterations);

wasSuccessful = logical(binornd(1, 0.95), numIterations, 1);
for iIteration = 1:numIterations,
    pause(1e-1);
    
    obj.update(wasSuccessful(iIteration));
end
obj.close();





%% Desired update rate

updateRateHz = 10;

% pass the number of iterations and the update cycle in Hz
obj = ProgressBar(numIterations, updateRateHz);

for iIteration = 1:numIterations,
    pause(1e-1);
    
    obj.update();
end
obj.close();





%% Different time estimators

obj = ProgressBar(numIterations);

% use the last 5 iterations for ETA estimate
obj.EstimatorOrder = 5;

for iIteration = 1:numIterations,
    pause(1e-1);
    
    obj.update();
end
obj.close();








%-------------------- Licence ---------------------------------------------
% Copyright (c) 2016, J.-A. Adrian
% Institute for Hearing Technology and Audiology
% Jade University of Applied Sciences
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%	1. Redistributions of source code must retain the above copyright
%	   notice, this list of conditions and the following disclaimer.
%
%	2. Redistributions in binary form must reproduce the above copyright
%	   notice, this list of conditions and the following disclaimer in
%	   the documentation and/or other materials provided with the
%	   distribution.
%
%	3. Neither the name of the copyright holder nor the names of its
%	   contributors may be used to endorse or promote products derived
%	   from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
% TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
% HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
% TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% End of file: ProgressBar_demo.m
