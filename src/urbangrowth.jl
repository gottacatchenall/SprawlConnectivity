


abstract type GrowthModel{R,W} <: DynamicGrids.SetCellRule{R,W} end 


"""
ExpansionGrowth

> It increases the built-up area from the boundaries of the urbanized area, 
fostering a greater extension of the urban cover. 
Some authors named it edge-expansion, edge or fringe growth.
> Sapena and Ruiz 2021

"""
struct ExpansionGrowth{R,W} <: GrowthModel{R,W} end 

"""
CompactGrowth

    > This pattern fosters a more compact urban form by processes such as densification, 
    coalescence, intensification or infilling among disconnected urban patches. Also 
    called land recycling or re-used land, such as barren land growth.
    > Sapena and Ruiz 2021

"""
struct CompactGrowth{R,W} <: GrowthModel{R,W} 
    
end 

"""
DispersedGrowth

    > When low-density urban growth occurs out of the city boundaries in a scattered 
    form, it is a process of decentralization and suburbanization; some authors relate 
    it to unplanned or spontaneous urban growth. It is also known isolated, outlying, 
    discontinuous, diffuse, sprawl, fragmented or scattered growth, among other terms.
    > Sapena and Ruiz 2021
"""
struct DispersedGrowth{R,W} <: GrowthModel{R,W} 

end 


"""
    RoadBasedGrowth

    The urban growth takes place along linear structures such as highway or railway 
    axes, also called ribbon, strip, and linear branch growth.
    > Sapena and Ruiz 2021

"""
struct RoadBasedGrowth{R,W,DT,PT,RT} <: GrowthModel{R,W} 
    demand::DT
    potential::PT # lattice with values of each cells potential for development (Meenemeyer et al 2012)
    roads::RT   # a lattice with 1s with pixels that are road, 0 else 
end


"""
LeapfrogGrowth

    > When secondary new centers emerge at different distances from the inner city with 
    vacant land interspersed. It can be found as cluster or new satellite agglomerations.
    It is usually large, compact and dense growth
    > Sapena and Ruiz 2021

"""
struct LeapfrogGrowth{R,W,KT,DT,PT} <: GrowthModel{R,W} 
    leapfrogkernel::KT
    demand::DT
    potential::PT # lattice with values of each cells potential for development (Meenemeyer et al 2012)
end 

