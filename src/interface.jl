using Parameters
using HDF5

export GridParams, EvolutionParams
export SPLINTParams
export save_params

"""
    GridParams

Struct for holding the QCDNUM grid parameters.
"""
@with_kw struct GridParams
    "x boundaries of grid"
    x_min::Vector{Float64} = [1.0e-4]
    "x grid weights"
    x_weights::Vector{Int32} = [1]
    "number of x grid boundaries"
    x_num_bounds::Integer = size(x_min)[1]
    "number of x grid points"
    nx::Integer = 100
    "qq boundaries of grid"
    qq_bounds::Vector{Float64} = [2.0, 1.0e4]
    "qq grid weights"
    qq_weights::Vector{Float64} = [1.0, 1.0]
    "number of qq grid boundaries"
    qq_num_bounds::Integer = size(qq_bounds)[1]
    "number of qq grid points"
    nq::Integer = 50
    "degree of spline interpolation used"
    spline_interp::Integer = 3
end

"""
   EvolutionParams

Struct for holding all QCDNUM Parameters. 
"""
@with_kw struct EvolutionParams
    "label for file IO"
    label::String = "evolution_params"
    "order of evolution in pQCD"
    order::Integer = 3
    "coupling constant at starting scale"
    α_S::Float64 = 0.364
    "starting scale"
    q0::Float64 = 2.0
    "Grid"
    grid_params::GridParams = GridParams()
    "number of fixed flavours in FFNS"
    n_fixed_flav::Integer = 0
    "charm threshold as index of qq grid (VFNS only)"
    iqc::Integer = 3
    "bottom threshold as index of qq grid (VFNS only)"
    iqb::Integer = 15
    "top threshold as index of qq grid (VFNS only)"
    iqt::Integer = 0
    "weight table type (1<=>unpolarised)"
    weight_type::Integer = 1
    "location in QCDNUM memory of evolution output"
    output_pdf_loc::Int64 = 1
end

"""
    SplineAddresses

Lookup table for addresses of different 
structure function splines.
"""
@with_kw struct SplineAddresses
    F2up::Integer = 1
    F2dn::Integer = 2
    F3up::Integer = 3
    F3dn::Integer = 4
    FLup::Integer = 5
    FLdn::Integer = 6
    F_eP::Integer = 7
    F_eM::Integer = 8
end

"""
    SPLINTParams

Struct for storage of parameters used
with SPLINT package of QCDNUM.
"""
@with_kw struct SPLINTParams
    "label for File IO"
    label::String = "splint_params"
    "number of words in memory for user space"
    nuser::Integer = 10
    "number of steps in x"
    nsteps_x::Integer = 5
    "number of steps in qq"
    nsteps_q::Integer = 10
    "number of nodes in x"
    nnodes_x::Integer = 100
    "number of nodes in qq"
    nnodes_q::Integer = 100
    "rs constraint"
    rs::Float64 = 318.0
    "cut on rs"
    rscut::Float64 = 370.0
    "spline addresses"
    spline_addresses::SplineAddresses = SplineAddresses()
end


"""
    InputPDF(; func::Function, map::AbstractArray{<:Real})

Struct containing all necessary info to pass a PDF 
(parton distribution function) into QCDNUM.
"""
struct InputPDF{F<:Function}
    "input PDF function specified in julia"
    func::F
    "map of quark species to input distribution"
    map::Array{Float64}

    _wrapped_func::WrappedPDF
end

InputPDF(; func::Function, map::AbstractArray{<:Real}) = InputPDF(func, map, WrappedPDF(func))

function evolfg(itype::Integer, pdf::InputPDF, iq0::Integer)
    evolfg(itype, pdf._wrapped_func, pdf.map, iq0)
end


"""
    init()

High-level default initialisation for QCDNUM.
"""
function init(; banner::Bool=false, output_file::String="")

    if banner
        b = 6
    else
        b = -6
    end

    QCDNUM.qcinit(b, output_file)

    nothing
end

"""
    make_grid(grid_params)

High-level interface to build QCDNUM grid from GridParams.
"""
function make_grid(grid_params::GridParams)

    g = grid_params

    nx = QCDNUM.gxmake(g.x_min, g.x_weights, g.x_num_bounds, g.nx, g.spline_interp)

    nq = QCDNUM.gqmake(g.qq_bounds, g.qq_weights, g.qq_num_bounds, g.nq)

    return nx, nq
end

"""
    evolve(input_pdf, qcdnum_params)

High-level interface to QCD evolution with QCDNUM.
"""
function evolve(input_pdf::InputPDF, evolution_params::EvolutionParams)
    p = evolution_params

    # Set up
    QCDNUM.setord(p.order)
    QCDNUM.setalf(p.α_S, p.q0)

    # Define grids
    QCDNUM.make_grid(p.grid_params)

    # Define FFNS/VFNS
    QCDNUM.setcbt(p.n_fixed_flav, p.iqc, p.iqb, p.iqt)

    # Build weight tables
    QCDNUM.fillwt(p.weight_type)

    iq0 = QCDNUM.iqfrmq(p.q0)

    eps = QCDNUM.evolfg(p.output_pdf_loc, input_pdf, iq0)

    return eps
end

"""
    splint_init()

High-level interface to splint initialisation.
"""
function splint_init(splint_params::SPLINTParams)

    QCDNUM.ssp_spinit(splint_params.nuser)

    nothing
end

"""
    save_params(file_name, params)
 
Store the QCDNUM or SPLINT parameters for reproducibility.
"""
function save_params(file_name::String, params::Union{EvolutionParams,SPLINTParams})

    # Append if file already exists
    local open_mode
    if isfile(file_name)
        open_mode = "r+"
    else
        open_mode = "w"
    end

    # Save
    h5open(file_name, open_mode) do fid

        param_group = create_group(fid, params.label)

        for name in fieldnames(typeof(params))

            sub_thing = getfield(params, name)

            if length(fieldnames(typeof(sub_thing))) > 0

                sub_group = create_group(param_group, String(name))

                for sub_name in fieldnames(typeof(sub_thing))

                    sub_group[String(sub_name)] = getfield(sub_thing, sub_name)

                end

            else

                param_group[String(name)] = sub_thing

            end

        end

    end

    return nothing
end


"""
    load_params(file_name)

Load stored QCDNUM or SPLINT parameters.
"""
function load_params(file_name::String)

    local params_dict = Dict{String,Any}()
    local params

    h5open(file_name, "r") do fid

        # Check what is in here
        for key in keys(fid)

            if key == "evolution_params"

                # Rebuild grid
                g = fid["evolution_params/grid_params"]

                grid_params = GridParams(x_min=read(g["x_min"]), x_weights=read(g["x_weights"]),
                    x_num_bounds=read(g["x_num_bounds"]), nx=read(g["nx"]),
                    qq_bounds=read(g["qq_bounds"]), qq_weights=read(g["qq_weights"]),
                    qq_num_bounds=read(g["qq_num_bounds"]), nq=read(g["nq"]),
                    spline_interp=read(g["spline_interp"]))

                # Rebuild evolution params
                g = fid["evolution_params"]
                params = EvolutionParams(order=read(g["order"]), α_S=read(g["α_S"]),
                    q0=read(g["q0"]), grid_params=grid_params,
                    n_fixed_flav=read(g["n_fixed_flav"]),
                    iqc=read(g["iqc"]), iqb=read(g["iqb"]),
                    iqt=read(g["iqt"]), weight_type=read(g["weight_type"]),
                    output_pdf_loc=read(g["output_pdf_loc"]))

            elseif key == "splint_params"

                # Rebuild spline addresses
                g = fid["splint_params/spline_addresses"]
                spline_addresses = SplineAddresses(F2up=read(g["F2up"]), F2dn=read(g["F2dn"]),
                    F3up=read(g["F3up"]), F3dn=read(g["F3dn"]),
                    FLup=read(g["FLup"]), FLdn=read(g["FLdn"]),
                    F_eP=read(g["F_eP"]), F_eM=read(g["F_eM"]))

                # Rebuild splint_params
                g = fid["splint_params"]
                params = SPLINTParams(nuser=read(g["nuser"]), nsteps_x=read(g["nsteps_x"]),
                    nsteps_q=read(g["nsteps_q"]), nnodes_x=read(g["nnodes_x"]),
                    nnodes_q=read(g["nnodes_q"]), rs=read(g["rs"]), rscut=read(g["rscut"]),
                    spline_addresses=spline_addresses)

            else

                @error "Contents of file not recognised."

            end

            params_dict[key] = params

        end

    end

    return params_dict

end
