struct PatchGrowingModel{KT}
    kernel::KT
end

function growpatch!(patchgrowth::PatchGrowingModel, potential)

    addedcells = 0

    seed = get_seed(potential)

    return addedcells
end

function get_seed(potential)

    # this is how the original paper does it.
    sz = size(potential)
    coords = rand(DiscreteUniform(1,sz), 2)
    if rand() < potential[coords...]
        return coords
    end
end