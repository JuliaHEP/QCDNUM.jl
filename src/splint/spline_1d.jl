"""
    isp_sxmake(istepx)

Create a 1D x spline object in memory, and return the address.
Every istep-th grid point is taken as a node point of the 
spline and the grid boundaries are always included as node
points.

# Arguments
- `istepx::Integer`: steps taken in sampling the QCDNUM x grid
"""
function isp_sxmake(istepx::Integer)

    istepx = Ref{Int32}(istepx)

    iasp = @qlccall isp_sxmake_(istepx::Ref{Int32})::Int32
    
    iasp[]
end

"""
    isp_sqmake(istepq)

Create a 1D qq spline object in memory, and return the address.
Every istep-th grid point is taken as a node point of the 
spline and the grid boundaries are always included as node
points.

# Arguments
- `istepq::Integer`: steps taken in sampling the QCDNUM qq grid
"""
function isp_sqmake(istepq::Integer)

    istepq = Ref{Int32}(istepq)

    iasp = @qlccall isp_sqmake_(istepq::Ref{Int32})::Int32
    
    iasp[]
end

"""
    ssp_sxfill(iasp, fun, iq)

Fill the 1D x spline object by passing a function. The function 
must have the signature fun(ix::Integer, iq::Integer, first::Boolean).

# Arguments
- `iasp::Integer`: address of the spline object
- `fun::Union{Base.CFunction, Ptr{Nothing}}`: function to be splined
- `iq::Integer`: fixed iq value to pass to fun
"""
function ssp_sxfill(iasp::Integer, fun::Union{Base.CFunction, Ptr{Nothing}}, iq::Integer)

    iasp = Ref{Int32}(iasp)
    iq = Ref{Int32}(iq)

    @qlccall ssp_sxfill_(iasp::Ref{Int32}, fun::Ptr{Cvoid},
                       iq::Ref{Int32})::Nothing

    nothing
end

"""
    ssp_sqfill(iasp, fun, ix)

Fill the 1D qq spline object by passing a function. The function 
must have the signature fun(ix::Integer, iq::Integer, first::Boolean).

# Arguments
- `iasp::Integer`: address of the spline object
- `fun::Union{Base.CFunction, Ptr{Nothing}}`: function to be splined
- `ix::Integer`: fixed ix value to pass to fun
"""
function ssp_sqfill(iasp::Integer, fun::Union{Base.CFunction, Ptr{Nothing}}, ix::Integer)

    iasp = Ref{Int32}(iasp)
    ix = Ref{Int32}(ix)

    @qlccall ssp_sqfill_(iasp::Ref{Int32}, fun::Ptr{Cvoid},
                       ix::Ref{Int32})::Nothing

    nothing
end


"""
    ssp_sxf123(ia, iset, def, istf, iq)

Fast structure function input for splines over x.

# Arguments
- `ia::Integer`: address of the spline object
- `iset::Integer`: QCDNUM pdf-set index
- `def::Array{Float64}`: Array of (anti-)quark
coefficients 
- `istf::Integer`: structure function index 
1<=>F_L, 2<=>F_2, 3<=>xF_3, 4<=>F_L'
- `iq::Integer`: index of qq value 
"""
function ssp_sxf123(ia::Integer, iset::Integer, def::Array{Float64},
                    istf::Integer, iq::Integer)

    ia = Ref{Int32}(ia)
    iset = Ref{Int32}(iset)
    istf = Ref{Int32}(istf)
    iq = Ref{Int32}(iq)

    @qlccall ssp_sxf123_(ia::Ref{Int32}, iset::Ref{Int32},
                       def::Ref{Float64}, istf::Ref{Int32},
                       iq::Ref{Int32})::Nothing

    nothing
end

"""
    ssp_sq123(ia, iset, def, istf, ix)

Fast structure function input for splines over qq.

# Arguments
- `ia::Integer`: address of the spline object
- `iset::Integer`: QCDNUM pdf-set index
- `def::Array{Float64}`: Array of (anti-)quark
coefficients 
- `istf::Integer`: structure function index 
1<=>F_L, 2<=>F_2, 3<=>xF_3, 4<=>F_L'
- `ix::Integer`: index of x value 
"""
function ssp_sqf123(ia::Integer, iset::Integer, def::Array{Float64},
                    istf::Integer, ix::Integer)

    ia = Ref{Int32}(ia)
    iset = Ref{Int32}(iset)
    istf = Ref{Int32}(istf)
    ix = Ref{Int32}(ix)

    @qlccall ssp_sqf123_(ia::Ref{Int32}, iset::Ref{Int32},
                       def::Ref{Float64}, istf::Ref{Int32},
                       ix::Ref{Int32})::Nothing

    nothing
end



"""
    isp_sxuser(xarr, nx)

Set your own node points in the 1D x spline in case
the automatic sampling fails.

# Arguments
- `xarr::Array{Float64}`: array of x values
- `nx::Integer`: length of xarr

# Returns
- `iasp::Integer`: address of the spline object
"""
function isp_sxuser(xarr::Array{Float64}, nx::Integer)

    nx = Ref{Int32}(nx)

    iasp = @qlccall isp_sxuser_(xarr::Ref{Float64}, nx::Ref{Int32})::Int32

    iasp[]
end

"""
    isp_squser(qarr, nq)

Set your own node points in the 1D qq spline in case
the automatic sampling fails.

# Arguments
- `qarr::Array{Float64}`: array of qq values
- `nq::Integer`: length of qarr

# Returns
- `iasp::Integer`: address of the spline object
"""
function isp_squser(qarr::Array{Float64}, nq::Integer)

    nq = Ref{Int32}(nq)

    iasp = @qlccall isp_squser_(qarr::Ref{Float64}, nq::Ref{Int32})::Int32

    iasp[]
end

"""
    dsp_funs1(ia, u, ichk)

Evaluate function for 1D spline.

Possible values of `ichk`:
- `-1`: extrapolate the spline
- `0`: return 0
- `1`: throw an error message

# Arguments
- `ia::Integer`: address of spline
- `u::Float64`: x or qq
- `ichk::Integer`: defines behaviour when outside 
spline range
"""
function dsp_funs1(ia::Integer, u::Float64, ichk::Integer)

    ia = Ref{Int32}(ia)
    u = Ref{Float64}(u)
    ichk = Ref{Int32}(ichk)

    val = @qlccall dsp_funs1_(ia::Ref{Int32}, u::Ref{Float64},
                            ichk::Ref{Int32})::Float64

    val[]
end

"""
    dsp_ints1(ia, u1, u2)

Evaluate integral of spline between u1 and u2.

The integration limits must lie inside the 
spline range. 
"""
function dsp_ints1(ia::Integer, u1::Float64, u2::Float64)

    ia = Ref{Int32}(ia)
    u1 = Ref{Float64}(u1)
    u2 = Ref{Float64}(u2)

    val = @qlccall dsp_ints1_(ia::Ref{Int32}, u1::Ref{Float64},
                            u2::Ref{Float64})::Float64

    val[]
end
