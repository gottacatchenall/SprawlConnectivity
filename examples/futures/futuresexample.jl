using SprawlConnectivity
using DynamicGrids
using DynamicGrids: CellRule, SetCellRule, applyrule, Rule, Ruleset,Neighborhood,Moore;
using ColorSchemes, Colors, BenchmarkTools
using SimpleSDMLayers
using SimpleSDMLayers: SimpleSDMPredictor, EarthEnv, LandCover
using Plots
using Distributions: DiscreteUniform

ENV["RASTERDATASOURCES_PATH"] = "/home/michael/data/";

cmap = ["black", "salmon1", "darkolivegreen1", "springgreen", "palegreen3", "seagreen4", "bisque", "dodgerblue"];
cscheme = ColorScheme([color(i) for i in cmap ]);
layers = [9,1,2,3,4,7,12];

mtl = (bottom=45., left=-76, right=-72., top=47.5);
mtlregion = (bottom=43., left=-77.6, right=-70., top=48.);
landcover = convert.(Float32, SimpleSDMPredictor(EarthEnv, LandCover, layers; full=false, mtl...)) 
consensus = mosaic(x -> last(findmax(x)), landcover)
heatmap(consensus, c=cmap[2:end], frame=:box, legend=:none, aspectratio=1)



urbscore = convert(Float32, SimpleSDMPredictor(EarthEnv, LandCover, 9; full=false, mtl...)) 
initpotential = Matrix{Float64}(broadcast(i -> min(0.01(i + 10),1), urbscore).grid')
initcover = Matrix{Int64}(consensus.grid)

using CSV, Tables, DataFrames
CSV.write("./assets/initcover.csv", Tables.table(initcover), writeheader=false)
CSV.write("./assets/initpotential.csv", Tables.table(initpotential), writeheader=false)


##
#
#
#
using SprawlConnectivity, DynamicGrids
using CSV, Tables, DataFrames, Colors, ColorSchemes
initpotential = Matrix{Float64}(CSV.read("./assets/initpotential.csv", DataFrame))
initcover = Matrix{Float64}(CSV.read("./assets/initcover.csv", DataFrame))

rule = FuturesSprawlModel{Tuple{:P,:C}}(demand=ConstantDemandModel(100))

flip(A) = A[end:-1:begin, begin:1:end]


cmap = ["black", "salmon1", "darkolivegreen1", "springgreen", "palegreen3", "seagreen4", "bisque", "dodgerblue"];
cscheme = ColorScheme([color(i) for i in cmap ]);

output = ArrayOutput((P=initpotential, C=initcover) ; tspan=1:200)

output = GifOutput((P=flip(initpotential), C=flip(initcover)) ;  # flip initial condition because gif flips the output for some reason
    filename="./testfutures.gif", 
    tspan=1:200, fps=25, 
    scheme=cscheme, minval=(0,0), maxval=(1,7))

sim!(output, rule)
