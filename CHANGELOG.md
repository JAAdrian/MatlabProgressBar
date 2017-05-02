# Changelog

## v3.0.0, 02-May-2017

The whole class has been re-factored to be a **MATLAB System Object**
- Since updating a progress bar is an iterative process with a setup/reset/release paradigm, this object type fits the purpose best
- Due to the System Object class structure, multiple methods have been renamed and optional input arguments for the `step()` (formerly `update()`) method are now mandatory. See the example in `README.md`.

The bar's **title** is now mandatory and has a default string: `'Processing'`. Notable change is that if the title exceeds the length of 20 characters the title will act like a banner and cycle with a shift of 3 characters each time the bar is updated. This way, the progress bar can have a constant width (for now, 90 characters seem to fit many screens).
