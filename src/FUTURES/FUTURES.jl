"""
    FuturesSprawlModel

    A port of the FUTURES (Meentemeyer et al 2013) sprawl model
"""
struct FuturesSprawlModel{R,W,DT,ST,PGT} <: SetGridRule{R,W}
    demand::DT
    strategy::ST
    patchgrowing::PGT
end 

function DynamicGrids.applyrule!(data, rule::FuturesSprawlModel, (potential, cover), I)
    neededarea = getdemand(rule.demand)
    addedarea = 0.0
    while (addedarea < neededarea) 
        addedarea += growpatch!(rule.patchgrowing, potential)
    end
end