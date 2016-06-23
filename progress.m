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

% End of file: progress.m
