classdef ProgressBar < handle
%PROGRESSBAR A class to provide a convenient and useful progress bar
% -------------------------------------------------------------------------
% This class mimics the design and some features of the TQDM
% (https://github.com/tqdm/tqdm) progress bar in python. All optional
% functionalities are set via name-value pairs in the constructor after the
% argument of the total numbers of iterations used in the progress (which
% can also be empty if unknown or even neglected if no name-value pairs are
% passed). The central class' method is 'update()' to increment the
% progress state of the object.
%
% Usage:  obj = ProgressBar()
%         obj = ProgressBar(total)
%         obj = ProgressBar(total, varargin)
%
% where 'total' is the total number of iterations.
%
%
% ProgressBar Properties (read-only):
%   Total - the total number of iterations [default: []]
%   Title - the progress bar's title shown in front [default: '']
%   Unit - the unit of the update process. Can either be 'Iterations' or
%          'Bytes' [default: 'Iterations']
%   UpdateRate - the progress bar's update rate in Hz. Defines the printing
%                update interval [default: 10 Hz]
%
%
% ProgressBar Methods:
%   ProgressBar - class constructor
%   close - clean up and finish the progress bar's internal state
%   printMessage - print some infos during the iterations. Messages get
%                  printed above the bar and the latter shifts one row down
%   start - normally not to be used! Tiny helper function when setting up
%           nested loops to print a parent bar before the first update
%           occured. When the inner loop takes long, a nasty white space is
%           shown in place of the parent bar until the first update takes
%           place. This function can be used to remedy this.
%   update - the central update method to increment the internal progress
%            state
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  17-Jun-2016 16:08:45
%

% History:  v1.0  working ProgressBar with and without knowledge of total
%                 number of iterations, 21-Jun-2016 (JA)
%           v2.0  support for update rate, 21-Jun-2016 (JA)
%           v2.1  colored progress bar, 22-Jun-2016 (JA)
%           v2.3  nested bars, 22-Jun-2016 (JA)
%           v2.4  printMessage() and info when iteration was not
%                 successful, 23-Jun-2016 (JA)
%           v2.5  Support 'Bytes' as unit, 23-Jun-2016 (JA)
%           v2.5.1 bug fixing, 23-Jun-2016 (JA)
%           v2.7  introduce progress loop via wrapper class,
%                 23- Jun-2016 (JA)
%           v2.7.1 bug fixing, 25-Jun-2016 (JA)
%           v2.8  support ASCII symbols, 25-Jun-2016 (JA)
%


properties ( SetAccess = private, GetAccess = public )
    Total;
    Title      = '';
    Unit       = 'Iterations';
    UpdateRate = 10;
end

properties ( Access = private )
    Bar = '';
    IterationCounter = 0;
    
    NumWrittenCharacters = 0;
    LastBlock = 0;
    LastMainBlock = 1;
    FractionMainBlock;
    FractionBlock;
    
    HasTotalIterations = false;
    HasBeenUpdated = false;
    HasFiniteUpdateRate = true;
    
    ShouldUseUnicode = true;
    BlockCharacterFunction = @getUnicodeBlock;
    
    IsTimerRunning = false;
    
    TicObject;
    TimerObject;
    
    TotalBarWidth = 90;
end

properties ( Constant, Access = private )
    MinBarLength = 10;
    
    NumBlocks = 8; % HTML 'left blocks' go in eigths
    
    TimerTagName = 'ProgressBar';
end

properties ( Access = private, Dependent)
    IsThisBarNested;
end




methods
    function [self] = ProgressBar(total, varargin)
        if nargin,
            % parse input arguments
            self.parseInputs(total, varargin{:});
        end
        
        % check if prog. bar runs in deployed mode and if yes switch to
        % ASCII symbols and a smaller bar width
        if isdeployed,
            self.ShouldUseUnicode = true;
            self.TotalBarWidth = 72;
        end
        
        % setup the function to retrieve ASCII symbols if desired
        if ~self.ShouldUseUnicode,
            self.BlockCharacterFunction = @getAsciiBlock;
        end
        
        % add a new timer object with the standard tag name
        self.TimerObject = timer(...
            'Tag', self.TimerTagName, ...
            'ObjectVisibility', 'off' ...
            );

        % register the new tic object
        self.TicObject = tic;
        
        if self.HasTotalIterations,
            % initialize the progress bar and pre-compute some measures
            self.setupBar();
            self.computeBlockFractions();
        end
        
        if self.HasFiniteUpdateRate,
            self.setupTimer();
        end
        
        if self.IsThisBarNested,
            fprintf(1, '\n');
        end
    end
    
    function delete(self)
        % delete timer
        if self.IsTimerRunning,
            self.stopTimer();
        end
        
        if self.IsThisBarNested,
            % when this prog bar was nested, remove it from the command
            % line and get back to the end of the parent bar. 
            % +1 due to the line break
            fprintf(1, backspace(self.NumWrittenCharacters + 1));
        elseif self.IterationCounter && ~self.IsThisBarNested,
            % when a non-nested progress bar has been plotted, hit return
            fprintf(1, '\n');
        end
        
        % if the bar was not nested clear the static timer list, else
        % unregister latest timer
        delete(self.TimerObject);
    end
    
    
    
    function [] = start(self)
        self.printProgressBar();
    end
    
    
    
    
    function [] = update(self, n, wasSuccessful, shouldPrintNextProgBar)
        if nargin < 4 || isempty(shouldPrintNextProgBar),
            shouldPrintNextProgBar = false;
        end
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
        validateattributes(shouldPrintNextProgBar, ...
            {'logical', 'numeric'}, ...
            {'scalar', 'binary', 'nonnan', 'nonempty'} ...
            );
        
        
        self.incrementIterationCounter(n);
        
        if ~self.IsTimerRunning && self.HasFiniteUpdateRate,
            self.startTimer();
        end
        
        
        if ~wasSuccessful,
            infoMsg = sprintf('Iteration %i was not successful!', ...
                self.IterationCounter);
            self.printMessage(infoMsg, shouldPrintNextProgBar);
        end
        
        if ~self.HasFiniteUpdateRate,
            self.printProgressBar();
        end
        
        if         ~isempty(self.Total) ...
                && self.IterationCounter == self.Total ...
                && self.HasFiniteUpdateRate,
            
            self.stopTimer();
        end
    end
    
    
    
    
    function [] = printMessage(self, msg, shouldPrintNextProgBar)
        if nargin < 3 || isempty(shouldPrintNextProgBar),
            shouldPrintNextProgBar = false;
        end
        validateattributes(shouldPrintNextProgBar, ...
            {'logical', 'numeric'}, ...
            {'scalar', 'binary', 'nonempty', 'nonnan'} ...
            );
        
        fprintf(1, backspace(self.NumWrittenCharacters));
        
        fprintf(1, '\t');
        fprintf(1, msg);
        fprintf(1, '\n');
        
        self.NumWrittenCharacters = 0;
        
        if shouldPrintNextProgBar,
            self.printProgressBar();
        end
    end
    
    
    
    
    function [] = close(self)
        delete(self);
    end
    
    
    
    
    function [yesNo] = get.IsThisBarNested(self)
        yesNo = length(self.getTimerList()) > 1;
    end
end





methods (Access = private)
    function [] = parseInputs(self, total, varargin)
        p = inputParser;
        p.FunctionName = mfilename;
        
        % total number of iterations
        p.addRequired('Total', @checkInputOfTotal);
        
        % unit of progress measure
        p.addParameter('Unit', self.Unit, ...
            @(in) any(validatestring(in, {'Iterations', 'Bytes'})) ...
            );
        
        % bar title
        p.addParameter('Title', self.Title, ...
            @(in) validateattributes(in, {'char'}, {'nonempty'}) ...
            );
        
        % update rate
        p.addParameter('UpdateRate', self.UpdateRate, ...
            @(in) validateattributes(in, ...
                {'numeric'}, ...
                {'scalar', 'positive', 'real', 'nonempty', 'nonnan'} ...
                ) ...
            );
        
        % progress bar width
        p.addParameter('Width', self.TotalBarWidth, ...
            @(in) validateattributes(in, ...
                {'numeric'}, ...
                {'scalar', 'positive', 'real', 'nonempty', 'nonnan'} ...
                ) ...
            );
        
        % don't use Unicode symbols
        p.addParameter('Unicode', self.ShouldUseUnicode, ...
            @(in) validateattributes(in, ...
                {'logical', 'numeric'}, ...
                {'scalar', 'binary', 'nonnan', 'nonempty'} ...
                ) ...
            );
       
        % parse all arguments...
        p.parse(total, varargin{:});
        
        % ...and grab them
        self.Total = p.Results.Total;
        self.Unit  = p.Results.Unit;
        self.Title = p.Results.Title;
        self.UpdateRate = p.Results.UpdateRate;
        self.TotalBarWidth = p.Results.Width;
        self.ShouldUseUnicode = p.Results.Unicode;
        
        if ~isempty(self.Total),
            self.HasTotalIterations = true;
        end
        if isinf(self.UpdateRate),
            self.HasFiniteUpdateRate = false;
        end
    end
    
    
    
    
    function [] = computeBlockFractions(self)
        self.FractionMainBlock = 1 / length(self.Bar);
        self.FractionBlock = self.FractionMainBlock / self.NumBlocks;
    end
    
    
    
    
    function [] = setupBar(self)
        [~, preBarFormat, postBarFormat] = self.returnFormatString();
        
        % insert worst case inputs to get (almost) maximum length of bar
        preBar = sprintf(preBarFormat, self.Title, 100);
        postBar = sprintf(postBarFormat, ...
            self.Total, ...
            self.Total, ...
            100, 100, 100, 100, 100, 100, 1e3);
        
        lenBar = self.TotalBarWidth - length(preBar) - length(postBar);
        lenBar = max(lenBar, self.MinBarLength);
        
        self.Bar = blanks(lenBar);
    end
    
    
    
    
    function [] = printProgressBar(self)
        fprintf(1, backspace(self.NumWrittenCharacters));
        
        formatString = self.returnFormatString();
        argumentList = self.returnArgumentList();
        
        self.NumWrittenCharacters = fprintf(1, ...
            formatString, ...
            argumentList{:} ...
            );
    end
    
    
    
    
    
    function [format, preString, postString] = returnFormatString(self)
        % this is adapted from tqdm

        if strcmp(self.Unit, 'Bytes');
            unitStrings = {'K', 'KB'};
        else
            unitStrings = {'', 'it'};
        end
        
        
        
        if self.HasTotalIterations,
            if ~isempty(self.Title),
                preString  = '%s:  %03.0f%%  ';
            else
                preString  = '%03.0f%%  ';
            end
            
            centerString = '|%s|';
            
            postString = ...
                [' %i', unitStrings{1}, '/%i', unitStrings{1}, ...
                ' [%02.0f:%02.0f:%02.0f<%02.0f:%02.0f:%02.0f, %.2f ', ...
                unitStrings{2}, '/s]'];
            
            format = [preString, centerString, postString];
        else
            preString  = '';
            postString = '';
            
            if ~isempty(self.Title),
                format = ['%s:  %i', unitStrings{1}, ...
                    ' [%02.0f:%02.0f:%02.0f, %.2f ', unitStrings{2}, '/s]'];
            else                
                format = ['%i', unitStrings{1}, ' [%02.0f:%02.0f:%02.0f, %.2f ', ...
                    unitStrings{2}, '/s]'];
            end
        end
    end

    
    
    
    function [argList] = returnArgumentList(self)
        % elapsed time (ET)
        thisTimeSec = toc(self.TicObject);
        etHoursMinsSecs = convertTime(thisTimeSec);

        % iterations per second
        iterationsPerSecond = self.IterationCounter / thisTimeSec;
        
        scaledIteration = self.IterationCounter;
        scaledTotal     = self.Total;
        if strcmp(self.Unit, 'Bytes'),
            % let's show KB
            scaledIteration     = round(scaledIteration / 1000);
            scaledTotal         = round(scaledTotal / 1000);
            iterationsPerSecond = iterationsPerSecond / 1000;
        end
        
        if self.HasTotalIterations,
            % 1 : Title
            % 2 : progress percent
            % 3 : progBar string
            % 4 : iterationCounter
            % 5 : Total
            % 6 : ET.hours
            % 7 : ET.minutes
            % 8 : ET.seconds
            % 9 : ETA.hours
            % 10: ETA.minutes
            % 11: ETA.seconds
            % 12: it/s
            
            % estimated time of arrival (ETA)
            [etaHoursMinsSecs] = self.estimateETA(thisTimeSec);
            
            if self.IterationCounter,
                argList = {
                    self.Title, ...
                    round(self.IterationCounter / self.Total * 100), ...
                    self.getCurrentBar, ...
                    scaledIteration, ...
                    scaledTotal, ...
                    etHoursMinsSecs(1), ...
                    etHoursMinsSecs(2), ...
                    etHoursMinsSecs(3), ...
                    etaHoursMinsSecs(1), ...
                    etaHoursMinsSecs(2), ...
                    etaHoursMinsSecs(3), ...
                    iterationsPerSecond ...
                    };
            else
                % if startMethod() calls this method return the empty bar
                
                argList = {
                    self.Title, ...
                    round(self.IterationCounter / self.Total * 100), ...
                    self.Bar, ... % <- this is different to above!
                    scaledIteration, ...
                    scaledTotal, ...
                    etHoursMinsSecs(1), ...
                    etHoursMinsSecs(2), ...
                    etHoursMinsSecs(3), ...
                    etaHoursMinsSecs(1), ...
                    etaHoursMinsSecs(2), ...
                    etaHoursMinsSecs(3), ...
                    iterationsPerSecond ...
                    };
            end
        else
            % 1: Title
            % 2: iterationCounter
            % 3: ET.hours
            % 4: ET.minutes
            % 5: ET.seconds
            % 6: it/s
            
            argList = {
                self.Title, ...
                scaledIteration, ...
                etHoursMinsSecs(1), ...
                etHoursMinsSecs(2), ...
                etHoursMinsSecs(3), ...
                iterationsPerSecond ...
                };
        end

        if isempty(self.Title),
            argList = argList(2:end);
        end
    end
    
    
    
    
    function [barString] = getCurrentBar(self)
        lenBar = length(self.Bar);
        currProgress = self.IterationCounter / self.Total;
        
        thisMainBlock = min(ceil(currProgress / self.FractionMainBlock), lenBar);
        
        continuousBlockIndex = ceil(currProgress / self.FractionBlock);
        thisBlock = mod(continuousBlockIndex, self.NumBlocks) + 1;
        
        if thisBlock > self.LastBlock || thisMainBlock > self.LastMainBlock,
            % fix for non-full last blocks when steps are large
            self.Bar(1:max(thisMainBlock-1, 0)) = ...
                repmat(self.BlockCharacterFunction(inf), 1, thisMainBlock - 1);
            
            if self.IterationCounter == self.Total,
                self.Bar = repmat(self.BlockCharacterFunction(inf), 1, lenBar);
            else
                self.Bar(thisMainBlock) = self.BlockCharacterFunction(thisBlock);
            end
            
            self.LastBlock = thisBlock;
            self.LastMainBlock = thisMainBlock;
        end
        
        barString = self.Bar;
    end
    
    
    
    
    function [etaHoursMinsSecs] = estimateETA(self, elapsedTime)
        progress = self.IterationCounter / self.Total;
        
        remainingSeconds = elapsedTime * ((1 / progress) - 1);
        
        etaHoursMinsSecs = convertTime(remainingSeconds);
    end
    
    
    
    
    function [] = setupTimer(self)
        self.TimerObject.BusyMode = 'drop';
        self.TimerObject.ExecutionMode = 'fixedSpacing';
        
        self.TimerObject.TimerFcn = @(~, ~) self.timerCallback();
        self.TimerObject.StopFcn  = @(~, ~) self.timerCallback();
        
        updatePeriod = round(1 / self.UpdateRate * 1000) / 1000;
        self.TimerObject.Period = updatePeriod;
    end
    
    
    
    
    function [] = startTimer(self)
        start(self.TimerObject);
        self.IsTimerRunning = true;
    end
    
    
    
    
    function [] = stopTimer(self)
        stop(self.TimerObject);
        self.IsTimerRunning = false;
    end
    
    
    
    
    function [] = timerCallback(self)
        if self.HasBeenUpdated,
            self.printProgressBar();
        else
            self.stopTimer();
        end
        
        self.HasBeenUpdated = false;
    end
    
    
    
    
    function [] = incrementIterationCounter(self, n)
        self.IterationCounter = self.IterationCounter + n;
        
        self.HasBeenUpdated = true;
    end
    
    
    
    
    function [list] = getTimerList(self)
        list = timerfindall('Tag', self.TimerTagName);
    end
end

end



function [thisBlock] = getUnicodeBlock(idx)
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

function [thisBlock] = getAsciiBlock(idx)
% idx ranges from 1 to 9, since the HTML 'left blocks' range from 1 to 8
% excluding the 'space' but this function also returns the space as first
% block

blocks = repmat('#', 1, 8);

thisBlock = blocks(min(idx, length(blocks)));
end


function [str] = backspace(numChars)
str = repmat(sprintf('\b'), 1, numChars);
end


function [hoursMinsSecs] = convertTime(secondsIn)
% fast implementation using mod() from
% http://stackoverflow.com/a/21233409

hoursMinsSecs = floor(mod(secondsIn, [0, 3600, 60]) ./ [3600, 60, 1]);
end


function [yesNo] = checkInputOfTotal(total)
isTotalEmpty = isempty(total);

if isTotalEmpty,
    yesNo = isTotalEmpty;
    return;
else
    validateattributes(total, ...
        {'numeric'}, ...
        {'scalar', 'integer', 'positive', 'real', 'nonnan', 'finite'} ...
        );
end
end




% End of file: ProgressBar.m
