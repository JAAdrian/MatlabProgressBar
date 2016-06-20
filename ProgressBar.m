classdef ProgressBar < handle
%PROGRESSBAR <purpose in one line!>
% -------------------------------------------------------------------------
% <Detailed description of the function>
%
% ProgressBar Properties:
%	propA - <description>
%	propB - <description>
%
% ProgressBar Methods:
%	doThis - <description>
%	doThat - <description>
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  17-Jun-2016 16:08:45
%

% Version:  v0.1   initial version, 17-Jun-2016 16:08 (JA)
%


properties (Access = private)
    bar = '';
    IterationCounter = 1;
end


properties (SetAccess = private, GetAccess = public)
    Title = '';
    Total;
    Unit = '';
end


properties (Access = public)
    UpdateRate;
end



methods
    function [self] = ProgressBar(total, varargin)
        if ~nargin,
           return;
        end
        
        % parse input arguments
        self.parseInputs(total, varargin{:});
        
        
        % see if there is already a timer object and register the new
        % ProgressBar object
        objList = self.getObjectList();
        if isempty(objList),
            t = timer();
            self.setObjectList(t);
        end
        
    end
    
    function [] = update(self, n, wasSuccessful)
        if nargin < 3 || isempty(wasSuccessful),
            wasSuccessful = true;
        end
        if nargin < 2 || isempty(n),
            n = 1;
        end
        validateattributes(n, ...
            {'numeric'}, ...
            {'scalar', 'positive', 'real', 'nonnan', 'finite', 'nonempty'} ...
            );
        validateattributes(wasSuccessful, ...
            {'logical', 'numeric'}, ...
            {'scalar', 'binary', 'nonnan', 'nonempty'} ...
            );
        
        self.incrementIterationCounter(n);
        
        self.printProgressBar();
    end
    
    function [] = printMessage(self)
        
    end
    
    function [] = close(self)
        
    end
    
    function [] = delete(self)
        self.close();
    end
end


methods (Access = private)
    function [] = parseInputs(self, total, varargin)
        p = inputParser;
        p.FunctionName = mfilename;
        
        p.addRequired('total', ...
            @(in) validateattributes(in, ...
            {'numeric'}, ...
            {'scalar', 'integer', 'positive', 'real', 'nonnan', 'finite'} ...
            ) ...
            );
        
        p.addParameter('Unit', 'Integers', ...
            @(in) any(validatestring(in, {'Integers', 'Bytes'})) ...
            );
        p.addParameter('Title', '', ...
            @(in) validateattributes(in, {'char'}, {'nonempty'}) ...
            );
        
        p.parse(total, varargin{:});
        
        % grab inputs
        self.Total = p.Results.total;
        self.Unit = p.Results.Unit;
        self.Title = p.Results.Title;
    end
    
    function [] = printTitle(self)
        fprintf(1, '', self);
    end
    
    function [] = setupBar(self)
        self.bar = sprintf('x', self);
    end
    
    function [] = printProgressBar(self)
        t = self.getTimer();
        
        fprintf(1, 'x', self);
    end
    
    function [] = incrementIterationCounter(self, n)
        self.IterationCounter = self.IterationCounter + n;
    end
    
    function [] = setObjectList(self, newObj) %#ok<INUSL>
        ProgressBar.objectList(newObj);
    end
    
    function [list] = getObjectList(self) %#ok<MANU>
        list = ProgressBar.objectList();
    end
    
    function [timerObject] = getTimer(self) %#ok<MANU>
        timerObject = self.getObjectList();
        timerObject = timerObject{1};
    end
end

methods (Access = private, Static = true)
    function list = objectList(newObject)
        % http://stackoverflow.com/a/14571266
        persistent ProgObjects;
        
        if nargin,
            ProgObjects = [ProgObjects; {newObject}];
        end
        
        list = ProgObjects;
    end
end







end

function [thisBlock] = getBlock(idx)
% idx ranges from 1 to 9, since the HTML 'left blocks' range from 1 to 8
% excluding the 'space' but this function also returns the space as first
% block

blocks = [
    blanks(1);
    char(9615);
    char(9614);
    char(9613);
    char(9612);
    char(9611);
    char(9610);
    char(9609);
    char(9608);
    ];

thisBlock = blocks(idx);
end

function [] = backspace(numChars)
fprintf(1, repmat('\b', 1, numChars));
end





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

% End of file: ProgressBar.m
