# using Statistics
using CSV
using DataFrames
using Plots
using Distributions
using HypothesisTests
# using Combinatorics

# Data import and diameters calculation
# ===
function importVData(file_path::String; px_μm::Float64=1.0)
    df = CSV.read(file_path,DataFrame)
    df.Diameters_μm = diameter.(df.Area) / px_μm
    return df
end

diameter(area) = sqrt(area/π) 

# Statistic significance of differences
# ===
# Structure to store test results
struct SSD
    FTest::VarianceFTest
    tTest::TwoSampleTTest
end

# Function for testing the statistical significance of mean differences between diameters of samples (assuming LogNormal distribution)
function StatSigDiffLN(dLN1::Vector{<:Real}, dLN2::Vector{<:Real}; p_Ftest::Float64=0.05)
    # Transform to Normal
    xN1, xN2 = log.(dLN1), log.(dLN2)
    # Do Normal variables have equal variance? Fischer test
    FTest = VarianceFTest(xN1,xN2)
    # Execute t-test on Normal variables
    tTest = (pvalue(FTest) < p_Ftest) ? UnequalVarianceTTest(xN1,xN2) : EqualVarianceTTest(xN1,xN2)
    # Create and return results structure
    ssd = SSD(FTest,tTest)
    return ssd
end;

# Visualization
# ===
# Function for plotting histogram and fitted LogNormal distribution
function HistDiameters(diameters::Vector{<:Real}; d_step::Integer=5, label::String="", fillalpha::Float64=0.5, color=1)
    ceil_to(n::Integer,x) = ceil( Int, x/n ) * n
    hist_lim = ceil_to( d_step, maximum(diameters) )
    b_range = 0:d_step:hist_lim
    N = length( diameters )
    h = histogram(diameters, bins=b_range, label="$label (N=$N)", color=color, fillalpha=fillalpha, linewidth=0, xlabel="diameters (μm)", ylabel="counts")
    return h
end;

function PlotLNDist!(histogram::Plots.Plot, d::LogNormal, N::Integer; d_step::Integer=5,color=1)
    plot!(histogram,x->pdf(d,x)*N*d_step,label="LogNormal",color=color,linewidth=2)
    peak_d = mode(d)
    scatter!([peak_d], [pdf(d,peak_d)*N*d_step],label="$(round(peak_d,digits=1)) (μm)", color=color)
    return nothing
end;

function HistLNDist(diameters::Vector{<:Real}; d_step::Integer=5, label::String="", fillalpha::Float64=0.5, color=1)
    h = HistDiameters(diameters, d_step=d_step, label=label, fillalpha=fillalpha, color=color)
    d = fit(LogNormal,diameters)
    N = length(diameters)
    PlotLNDist!(h, d, N, d_step=d_step, color=color)
    display(h)
    return d
end;