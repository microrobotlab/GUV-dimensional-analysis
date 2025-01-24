# Dimensional analysis of GUVs

The file `VesicleStatistics.jl` contains functions for importing and analysing dimensional data of GUVs.

## Installation

Required: [Julia](https://julialang.org/) v1.10

1. clone the GitHub repository locally
2. from the local folder, open the terminal and enter the Julia package manager `pkg`
3. `instantiate` the environment to install the Base.cache_dependencies
4. add `include("VesicleStatistics.jl")` to import the functions

## Main functions

### `importVData`

This function imports vesicle data from a `.csv` file.
It assumes the file to have an `Area` column containing the area of each detected GUV.
The function returns the data in a dataframe, to which it adds a column with diameters in μm (calculated from the area).
If the area is in pixels, the `px_μm` argument can be passed to convert pixels to μm.

### `HistDiameters`

This function plots an histogram of the diameters.

### `HistLNDist`

This function plots the histogram of the diameters, fits a LogNormal distribution to the diameter data and plots the distribution and its peak over the histogram.

### `StatSigDiffLN`

This function checks if two population of GUVs have a statistically significance difference in diameters, assuming a LogNormal distribution.