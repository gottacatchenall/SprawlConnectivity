using SprawlConnectivity
using SimpleSDMLayers
using SimpleSDMLayers: SimpleSDMPredictor, EarthEnv, LandCover
using Plots
using Colors, ColorSchemes

const URBAN,EVERDECID,EVERGREEN,DECIDUOUS,MIXEDFOREST,AGRICULTURE,WATER = 1:7

ENV["RASTERDATASOURCES_PATH"] = "/home/michael/data/";
layers = [9,1,2,3,4,7,12];
cmap = ["black", "salmon1", "darkolivegreen1", "springgreen", "palegreen3", "seagreen4", "bisque", "dodgerblue"];
cscheme = ColorScheme([color(i) for i in cmap ]);

metro = (bottom=45., left=-76.5, right=-70., top=48.);
landcover = convert.(Float32, SimpleSDMPredictor(EarthEnv, LandCover, layers; full=false, metro...)) 
consensus = mosaic(x -> last(findmax(x)), landcover)
heatmap(consensus, c=cmap[2:end], frame=:box, legend=:none, aspectratio=1)

using DynamicGrids;
using DynamicGrids: NeighborhoodRule;

struct SprawlRule{R,W,NT,CT,FT} <: NeighborhoodRule{R,W}
    neighborhood::NT
    cityinvasionprob::CT
    farminvasionprob::FT
end 
SprawlRule{R,W}(; neighborhood=Moore(1), cityinvasionprob=0.01, farminvasionprob=0.005) where {R,W} = SprawlRule{R,W}(neighborhood, cityinvasionprob, farminvasionprob)


forest = [EVERDECID, EVERGREEN, DECIDUOUS,MIXEDFOREST]

function DynamicGrids.applyrule(data, rule::SprawlRule{R,W}, cell, index) where {R,W}
    cell == WATER && return WATER
    cell == URBAN && return URBAN

    if cell ∈ forest
        if AGRICULTURE in neighbors(rule)
            return (rand() <= rule.farminvasionprob ? AGRICULTURE : cell)
        else
            return cell
        end
    else
        if URBAN in neighbors(rule)
            return (rand() <= rule.cityinvasionprob ? URBAN : AGRICULTURE)
        else
            return AGRICULTURE
        end
    end
    @error "got an invalid cell value $cell as input"
end 

init = Matrix{Int64}(consensus.grid)
output = GifOutput(init[end:-1:1,1:1:end];  # flip initial condition because gif flips the output for some reason
    filename="./examples/northeast_sprawl.gif", 
    tspan=1:200, fps=25, 
    scheme=cscheme, minval=0, maxval=7)

rule = SprawlRule(neighborhood=VonNeumann(3),cityinvasionprob=0.005, farminvasionprob=0.005)
sim!(output, rule)