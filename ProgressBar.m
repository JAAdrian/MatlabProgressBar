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
    Bar = '';
    IterationCounter = 1;
    NumBlocks = 8; % number of HTML 'left blocks'
    
    SelfIndex;
end


properties (SetAccess = private, GetAccess = public)
    Title = '';
    Total;
    Unit = '';
end


properties (Access = public)
    UpdateRate;
end

properties ( Constant, Access = private )
    MaxColumnsOnScreen = 80;
end



methods
    function [self] = ProgressBar(total, varargin)
        if ~nargin,
           return;
        end
        
        % parse input arguments
        self.parseInputs(total, varargin{:});
        
        
        % add a new timer object if there is none and register the new
        % ProgressBar object
        objList = self.getObjectList();
        if isempty(objList),
            t = timer();
            self.addToObjectList(t);
        end
        self.addToObjectList(self);
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
        
        self.printStatus();
        
        self.incrementIterationCounter(n);
    end
    
    function [] = printMessage(self)
        
    end
    
    function [] = summary(self)
        
    end
    
    function [] = close(self)
        self.printStatus('nuke');
        
        list = self.getObjectList();
        if ~isempty(list) && length(list) <= 2,
            self.clearObjectList();
        else
            self.removeMeFromObjectList();
        end
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
        self.Unit  = p.Results.Unit;
        self.Title = p.Results.Title;
        
        self.setupBar();
    end
    
    function [] = setupBar(self)
        [~, postBar] = getProgBarFormatString();
        
        self.Bar = blanks(self.MaxColumnsOnScreen - length(postBar));
    end
    
    function [] = printStatus(self, clearFlag)
        if nargin > 1 && ~isempty(clearFlag) && strcmp(clearFlag, 'nuke'),
            clear('len');
            return;
        end
        persistent len;
        
        t = self.getTimer();
        
        if ~isempty(len),
            fprintf(1, backspace(len));
        end
        
        % 1: Title
        % 2: percent
        % 3: progBar string
        % 4: interationCounter
        % 5: Total
        % 6: ET.minutes
        % 7: ET.seconds
        % 8: ETA.minutes
        % 9: ETA.seconds
        % 10: it/s
        len = fprintf(1, getProgBarFormatString(), ...
            self.Title, ...
            round(self.IterationCounter / self.Total * 100), ...
            self.getCurrentBar, ...
            self.IterationCounter, ...
            self.Total, ...
            0, ...
            1, ...
            0, ...
            1, ...
            5 ...
            );
    end
    
    function [barString] = getCurrentBar(self)
        fractionOfOneBlock = 1 / length(self.Bar);
        
        if ~mod(self.IterationCounter / self.Total, fractionOfOneBlock),
            idx = floor((self.IterationCounter - 1) / self.NumBlocks) + 1;
            
            self.Bar(idx) = ...
            getBlock(mod(self.IterationCounter - 1, self.NumBlocks) + 1);
        end
        
        barString = self.Bar;
    end
    
    function [] = incrementIterationCounter(self, n)
        self.IterationCounter = self.IterationCounter + n;
    end
    
    function [list] = getObjectList(self) %#ok<MANU>
        list = ProgressBar.objectList();
    end
    
    function [] = addToObjectList(self, newObj) %#ok<INUSL>
        ProgressBar.objectList(newObj);
    end
    
    function [] = removeMeFromObjectList(self) %#ok<MANU>
        ProgressBar.objectList(-1);
    end
    
    function [] = clearObjectList(self) %#ok<MANU>
        ProgressBar.objectList('nuke');
    end
    
    function [timerObject] = getTimer(self)
        timerObject = self.getObjectList();
        
        if ~isempty(timerObject),
            timerObject = timerObject{1};
        end
    end
end

methods (Access = private, Static = true)
    function [list] = objectList(newObject)
        % http://stackoverflow.com/a/14571266
        persistent ProgObjects;
        
        if nargin,
            switch class(newObject),
                case {'timer', 'ProgressBar'},
                    ProgObjects = [ProgObjects; {newObject}];
                case 'numeric',
                    ProgObjects = ProgObjects(1:end-1);
                case 'char',
                    clear('ProgObjects');
            end
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
    char(9615);
    char(9614);
    char(9613);
    char(9612);
    char(9611);
    char(9610);
    char(9609);
    char(9608);
    ];

thisBlock = blocks(min(idx, length(blocks)));
end

function [str] = backspace(numChars)
str = repmat('\b', 1, numChars);
end

function [format, postString] = getProgBarFormatString()
% this is adapted from tqdm
postString =  ' %i/%i [%02.0f:%02.0f<%02.0f:%02.0f, %.2f it/s]';
format = ['%s\t%i%%  |%s|' postString];
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
