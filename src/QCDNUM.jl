module QCDNUM

using QCDNUM_jll, Libdl

include("threadsafety.jl")
include("initialisation.jl")
include("grid.jl")
include("weights.jl")
include("parameters.jl")
include("evolution.jl")
include("interpolation.jl")
include("zmstf.jl")
include("splint/splint.jl")
include("interface.jl")

end # QCDNUM
