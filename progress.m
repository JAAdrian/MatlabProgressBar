classdef progress < handle
%PROGRESS Wrapper class to provide an iterator object for loop creation
% -------------------------------------------------------------------------
% This class provides the possibility to create an iterator object in
% MATLAB to make the handling of ProgressBar() even easier. The following
% example shows the usage. Although no ProgressBar() is called by the user,
% a progress bar is shown. The input arguments are the same as for
% ProgressBar(), so please refer to the documentation of ProgressBar().
%
% Note that this implementation is slower than the conventional
% ProgressBar() class since the subsref() method is called with
% non-optimized values in every iteration.
%
% =========================================================================
% Example:
%
% for k = progress(1:100)
%   % do some processing
% end
%
% Or with additional name-value pairs:
%
% for k = progress(1:100, ...
%     'Title', 'Computing...' ...
%     )
%
%   % do some processing
% end
%
% =========================================================================
%
% progress Properties:
%	none
%
% progress Methods:
%	progress - class constructor
%
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  23-Jun-2016 19:24:50
%

% Version:  v1.0  initial version, 23-Jun-2016 (JA)
%           v1.1  rename variables and update documentation,
%                 26-Jun-2016 (JA)
%


properties (Access = private)
    IterationList;
    ProgressBar;
    CurrentFont
end

methods
    % Class Constructor
    function self = progress(in, varargin)
        s = settings;
        if ~isunix && strcmp(s.matlab.fonts.codefont.Name.ActiveValue,'Monospaced') % workaround for bug "Bar Gets Longer With Each Iteration" on windows systems
            self.CurrentFont = s.matlab.fonts.codefont.Name.ActiveValue; % store current font
            s.matlab.fonts.codefont.Name.TemporaryValue = 'Courier New'; % change to Courier New Font, which is shipped by every windows distro since Windows 3.1
        end
        if ~nargin
            return;
        end
        self.IterationList = in;
        
        % pass all varargins to ProgressBar()
        self.ProgressBar = ProgressBar(length(in), varargin{:});
    end
    
    % Class Destructor
    function delete(self)
        if ~isunix && ~isempty(self.CurrentFont) % restore previously used font
            s = settings;
            s.matlab.fonts.codefont.Name.TemporaryValue = self.CurrentFont;
        end
        % call the destructor of the ProgressBar() object
        self.ProgressBar.release();
    end
    
    function [varargout] = subsref(self, S)
    % This method implements the subsref method and only calls the update()
    % method of ProgressBar. The actual input 'S' is passed to the default
    % subsref method of the class of self.IterationList.
    
        self.ProgressBar.step([], [], []);
        varargout = {subsref(self.IterationList, S)};
    end
    
    function [m, n] = size(self)
    % This method implements the size() function for the progress() class.
    
        [m, n] = size(self.IterationList);
    end
end
end

