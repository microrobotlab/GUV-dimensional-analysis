# This script runs on toy data to show the basic usage of functions
# ===

# Import functions
include("VesicleStatistics.jl")

# Import data (area, pixels) and add diameters (μm) given a scale factor (pixels per μm); px_μm can be omitted if area is already in μm²
file_path = joinpath("DATA","example.csv")
data = importVData(file_path, px_μm = 8.0)

# Plot a simple histogram
HistDiameters(data.Diameters_μm)
# Plot the histogram and fit a LogNormal distribution
HistLNDist(data.Diameters_μm)

# Test if two samples have a statistically significant difference between their diameter distributions
StatSigDiffLN(data.Diameters_μm,data.Diameters_μm)