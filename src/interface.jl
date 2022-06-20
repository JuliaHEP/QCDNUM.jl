using Parameters

export GridParams, EvolutionParams
export SPLINTParams

splint_init_complete = false

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
    InputPDF

Struct containing all necessary info to pass a PDF 
(parton distribution function) into QCDNUM.
"""
@with_kw struct InputPDF
    "input PDF function specified in julia"
    func::Function
    "C-stype pointer to input func to pass to QCDNUM"
    cfunc::Base.CFunction = @cfunction($func, Float64, (Ref{Int32}, Ref{Float64}))
    "map of quark species to input distribution"
    map::Array{Float64}
end

"""
    init()

High-level default initialisation for QCDNUM.
"""
function init(; banner::Bool = false, output_file::String = "")

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
    
    eps = QCDNUM.evolfg(p.output_pdf_loc, input_pdf.cfunc, input_pdf.map, iq0)

    return eps
end

"""
    splint_init()

High-level interface to splint initialisation that 
handles multiple calls.
"""
function splint_init(splint_params::SPLINTParams)

    if !splint_init_complete
        
        QCDNUM.ssp_spinit(splint_params.nuser)

        global splint_init_complete = true

    else

        @warn "SPLINT is already initialised, skipping call to QCDNUM.ssp_spinit()"

    end

    nothing
end
