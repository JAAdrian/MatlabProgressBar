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
%


properties (Access = private)
    IterationList;
    ProgressBar;
end

methods
    % Class Constructor
    function obj = progress(in, varargin)
        if ~nargin
            return;
        end
        
        obj.IterationList = in;
        
        % pass all varargins to ProgressBar()
        obj.ProgressBar = ProgressBar(length(in), varargin{:});
    end
    
    % Class Destructor
    function delete(obj)
        % call the destructor of the ProgressBar() object
        if ~isempty(obj.ProgressBar)
            obj.ProgressBar.release();
        end
    end
    
    function [varargout] = subsref(obj, S)
    % This method implements the subsref method and only calls the update()
    % method of ProgressBar. The actual input 'S' is passed to the default
    % subsref method of the class of obj.IterationList.
    
        obj.ProgressBar.step([], [], []);
        varargout = {subsref(obj.IterationList, S)};
    end
    
    function [m, n] = size(obj)
    % This method implements the size() function for the progress() class.
    
        [m, n] = size(obj.IterationList);
    end
end
end

