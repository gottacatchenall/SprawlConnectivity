"""
    FuturesSprawlModel

    A port of the FUTURES (Meentemeyer et al 2013) sprawl model
"""
struct FuturesSprawlModel{R,W,DT,ST,PGT} <: SetCellRule{R,W}
    demand::DT
    strategy::ST
    patchgrowing::PGT
end 

FuturesSprawlModel{R,W}(; 
    demand=ConstantDemandModel(), 
    strategy=1.0, 
    patchgrowing=PatchGrowingModel()) where {R,W} =
FuturesSprawlModel{R,W}(demand, strategy, patchgrowing)

function DynamicGrids.applyrule!(data, rule::FuturesSprawlModel, (potential, cover), index) 
    neededarea = getdemand(rule.demand)
    addedarea = 0.0
    while (addedarea < neededarea) 
        addedarea += growpatch!(rule.patchgrowing, data[:P])
    end
end