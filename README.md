ProgressBar
=======================

A drawback in MATLAB's own `waitbar()` function is the lack of some functionalities and the loss of speed due to the rather laggy GUI updating process.
Therefore, this MATLAB class aims to provide a smart progress bar in the command window and is optimized for progress information in simple iterations or large frameworks.

A design target was to mimic the best features of the progress bar [tqdm](https://github.com/tqdm/tqdm) for Python. Thus, this project features a Unicode-based bar and some numeric information about the current progress and the mean iterations per second

![](example.gif)

Supported features include (and are planned):
- [x] TQDM Unicode blocks
- [x] optional constructor switch for optional ASCII number signs (hashes)
- [x] optional bar title
- [x] optional visual update interval in Hz [defaults to 10 Hz]
- [x] when no total number of iterations is passed the bar shows the elapsed time, the number of (elapsed) iterations and iterations/s
- [x] nested bars (at the moment only one nested bar is supported [one parent, one child])
- [x] `printMessage()` method for debug printing (or the like)
- [x] print an info when a run was not successful
- [x] support another meaningful 'total of something' measure where the number of items is less meaningful (for example non-uniform processing time) such as total file size (processing multiple files with different file size). At the moment, the only alternative supported unit is `Bytes`
- [x] when the internal updating process is faster than the actual updates via `update()`, the internal counter and printing of the process bar stops until the next update to save processing time
- [x] linear ETA estimate over all last iterations
- [ ] incorporate a symbol at end of bar to indicate finished status (maybe a checkmark or a colored bullet?)
- [ ] have a template functionality like in [minibar](https://github.com/canassa/minibar). Maybe use `regexprep()`?


**Note**:  
Be sure to have a look at the [Known Issues](#known-issues) section for current known bugs and possible work-arounds.

Dependencies
-------------------------

No dependencies to toolboxes. The code has been tested with MATLAB R2016a.


Installation
-------------------------

Put the files `ProgressBar.m` and `progress.m` into your MATLAB path or the directory of your MATLAB project.


Usage
-------------------------

Detailed information and examples about all features of `ProgressBar` are stated in the demos in the `demos` directory.

Nevertheless, the basic work flow is to instantiate a `ProgressBar` object and use the `update()` method to update the progress state. All settings are done using *name-value* pairs in the constructor. Thus, `ProgressBar` only has public read-only properties. It is advisable to call the object's `close()` method after the loop is finished to clean up the internal state and avoid possibly unrobust behavior of following progress bars.

**Usage**  
`obj = ProgressBar(totalIterations, varargin)`

A simple but quite common example looks like this:
```matlab
numIterations = 10e3;

% instantiate an object with an optional title and an update rate of 5 Hz,
% i.e. 5 bar updates per seconds, to save printing load.
progBar = ProgressBar(numIterations, ...
    'Title', 'Iterating...', ...
    'UpdateRate', '5' ...
    );
    
% begin the actual loop and update the object's progress state
for iIteration = 1:numIterations,
    % do some processing

    progBar.update();
end
% call the 'close()' method to clean up
progBar.close();
```

A neat way to completely get rid of the conventional `update()` method is to use the `progress()` wrapper class. It implements the `subsref()` method and thus acts similar to an iterator in Python. A progress bar will be printed without the further need to call `update()`. Be aware that functionalities like `printMessage()`, printing success information or a different step size than 1 are not supported with `progress()`.

See the example below:
```matlab
numIterations = 10e3;

% create the loop using the progress() class
for iIteration = progress(1:numIterations),
    % do some processing
end
```


On Deck
-------------------------

- [ ] improve demos
- [x] improve documentation
- [x] make a tester


Known Issues
-------------------------------

#### The Bar Gets Longer with Each Iteration

There seems to be a problem with the default font `Monospaced` at least on Windows. If this behavior is problematic change the font for the command window to a different monospaced font, preferably with proper Unicode support.

#### Strange Symbols in the Progress Bar

The display of the updating progress bar is highly dependent on the **font** you use in the command window. Be sure to use a proper font that can handle Unicode characters. Otherwise be sure to always use the `'Unicode', false` switch in the constructor.

#### Remaining Timer objects

Sometimes, if the user cancels a loop in which a progress bar was used, the destructor is not called properly and the timer object remains in memory. This can lead to strange behavior of the next progress bar instantiated because it thinks it is nested. If you encounter strange behavior like wrong line breaks or disappearing progress bars after the bar has finished, just call the following to delete all remaining timer objects in memory.

```matlab
delete(timerfindall('Tag', 'ProgressBar'));
```


License
----------------------

The code is licensed under BSD 3-Clause as stated in the `LICENSE` file
