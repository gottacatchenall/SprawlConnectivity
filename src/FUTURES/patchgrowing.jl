struct PatchGrowingModel{NT,AT}
    neighborhood::NT
    α::AT
end
PatchGrowingModel(; neighborhood=Moore(1),α = 3.0) = PatchGrowingModel(neighborhood,α)

function growpatch!(patchgrowth::PatchGrowingModel, potential)

    addedcells = 1
    seed = get_seed(potential)
    
    devcells = []
    for off in offsets(patchgrowth.neighborhood)
        cd = seed .+ off
        if inbounds(potential, cd)
            p = potential[cd...]
            rand() < p
        end
    end

    return addedcells
end

function get_seed(potential)

    # this is how the original paper does it.
    sz = size(potential)
    coords = rand(DiscreteUniform(1,sz[1])), rand(DiscreteUniform(1,sz[2]))
    while true 
        if rand() < potential[coords...]
            return coords
        end
    end
end

