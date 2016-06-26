classdef progress < handle
%PROGRESS <purpose in one line!>
% -------------------------------------------------------------------------
% <Detailed description of the function>
%
% progress Properties:
%	propA - <description>
%	propB - <description>
%
% progress Methods:
%	doThis - <description>
%	doThat - <description>
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  23-Jun-2016 19:24:50
%

% Version:  v0.1   initial version, 23-Jun-2016 19:24 (JA)
%


properties (Access = private)
    TheThing;
    ProgressBar;
end

methods
    function self = progress(in, varargin)
        if ~nargin,
            return;
        end
        
        self.TheThing = in;
        self.ProgressBar = ProgressBar(length(in), varargin{:});
    end
    
    function delete(self)
        delete(self.ProgressBar);
    end
    
    function [varargout] = subsref(self, S)
        self.ProgressBar.update();
        varargout = {subsref(self.TheThing, S)};
    end
    
    function [m, n] = size(self)
        [m, n] = size(self.TheThing);
    end
end
end





% End of file: progress.m
