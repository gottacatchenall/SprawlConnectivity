module SprawlConnectivity

using DynamicGrids
using DynamicGrids: CellRule, SetCellRule, applyrule, offsets, Rule,Ruleset,Neighborhood,Moore;
using ColorSchemes, Colors, BenchmarkTools
using Distributions

include(joinpath("FUTURES", "demand.jl"));
include(joinpath("FUTURES", "patchgrowing.jl"));
include(joinpath("FUTURES", "potential.jl"));
include(joinpath("FUTURES", "FUTURES.jl"));

export ConstantDemandModel
export getpotential, getdemand, getseed, growpatch!
export FuturesSprawlModel;


include(joinpath("forms.jl"));
include(joinpath("urbangrowth.jl"));


end # module



"""

neighbors_rule = let prob_combustion=0.0001, prob_regrowth=0.01
    Neighbors(Moore(1)) do neighborhood, cell
        if cell == ALIVE
            if BURNING in neighborhood
                BURNING
            else
                rand() <= prob_combustion ? BURNING : ALIVE
            end
        elseif cell == BURNING
            DEAD
        else
            rand() <= prob_regrowth ? ALIVE : DEAD
        end
    end
end

# Set up the init array and output (using a Gtk window)
init = fill(ALIVE, 400, 400)
output = GifOutput(init;
    filename="forestfire.gif", tspan=1:200, fps=25,
    minval=DEAD, maxval=BURNING,
    imagegen=Image(scheme=ColorSchemes.rainbow, zerocolor=RGB24(0.0))
)

sim!(output, neighbors_rule)

"""