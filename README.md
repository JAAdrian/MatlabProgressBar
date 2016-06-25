ProgressBar
=======================

Should look like [TQDM](https://github.com/tqdm/tqdm) and uses [left blocks](http://www.w3schools.com/charsets/ref_utf_block.asp)


Dependencies
-------------------------

No dependencies to toolboxes. The code has been tested with MATLAB r2016a.


Installation
-------------------------


Usage
-------------------------


To Do
-------------------------

- [ ] improve demos
- [ ] improve documentation
- [ ] make tests?





How to set [static "properties"](http://stackoverflow.com/a/14571266) in MATLAB. This could be useful for the handling of multiple, global ProgressBar objects and the global timer.


Feature Request
----------------------

- [x] TQDM blocks
- [x] Section names etc.
- [x] visual update interval
- [x] when no `numIterations` is passed we state the ET and number of iterations and it/s
- [x] nested bars
- [x] printMessage() method for debug printing (or similar)
- [x] print an info when a run was not successful
- [x] we can support another meaningful 'total of something' measure where the number of items is less meaningful (for example non-uniform processing time) such as total file size (processing multiple files with different file size)
- [x] when updating process is faster than the updates, stop the counter to save processing time
- [x] linear ETA estimate over all last iterations
- [ ] have a template functionality like in [minibar](https://github.com/canassa/minibar). Maybe use `regexprep()`?
