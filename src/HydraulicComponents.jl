module HydraulicComponents

using ModelingToolkit: getdefault
using Symbolics
using SimpleUnPack: @unpack

abstract type AbstractMedium end

include("utils.jl")
include("isothermal_compressible.jl")
include("../generated/definitions.jl")
include("../generated/experiments.jl")
include("../generated/precompilation.jl")

end # module HydraulicComponents
