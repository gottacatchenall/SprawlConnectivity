
# Meentame

# Spatially explicit surface of the development poten-tial submodel (POTENTIAL) 
# ranges from high (red) to low (blue)development likelihood. Gray denotes development as of 1996.
# (B)County-level forecasts of per capita land consumption (DEMAND).Status quo trendlines are shown in blue. 
# Gray dashed lines denotealternative scenarios of land consumption. (C) Range of power func-tions (INCENTIVES) 
# for transforming the development potential(P) surface. (Color figure available online.)


"""
    DemandModel    

    A demand model for FuturesSprawlModel

"""
abstract type DemandModel end 

struct ConstantDemandModel{T}
    constant::T
end 
ConstantDemandModel(; constant=10. ) = ConstantDemandModel(constant)


function getdemand(dm::ConstantDemandModel)
    return dm.constant
end



