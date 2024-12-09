"""
    isp_s2make(istepx, istepq)

Create a spline object in memory, and return the address.
Every istep-th grid point is taken as a node point of the 
spline and the grid boundaries are always included as node
points.

# Arguments
- `istepx::Integer`: steps taken in sampling the QCDNUM x grid
- `istepq::Integer`: steps taken in sampling the QCDNUM qq grid
"""
function isp_s2make(istepx::Integer, istepq::Integer)

    istepx = Ref{Int32}(istepx)
    istepq = Ref{Int32}(istepq)

    iasp = @qlccall isp_s2make_(istepx::Ref{Int32}, istepq::Ref{Int32})::Int32
    
    iasp[]
end

"""
    ssp_s2fill(iasp, fun, rs)

Fill the spline object by passing a function. The function 
must have the signature fun(ix::Integer, iq::Integer, first::Boolean).

# Arguments
- `iasp::Integer`: address of the spline object
- `fun::Union{Base.CFunction, Ptr{Nothing}}`: function to be splined
- `rs::Float64`: set a sqrt(s) cut - 0 for no kinematic cut 
"""
function ssp_s2fill(iasp::Integer, fun::Union{Base.CFunction, Ptr{Nothing}}, rs::Float64)

    iasp = Ref{Int32}(iasp)
    rs = Ref{Float64}(rs)

    @qlccall ssp_s2fill_(iasp::Ref{Int32}, fun::Ptr{Cvoid}, rs::Ref{Float64})::Nothing
    nothing
end




"""
    ssp_s2f123(ia, iset, def, istf, rs)

Fast structure function input for 2D 
splines over x and qq.

# Arguments
- `ia::Integer`: address of the spline object
- `iset::Integer`: QCDNUM pdf-set index
- `def::Array{Float64}`: Array of (anti-)quark
coefficients 
- `istf::Integer`: structure function index 
1<=>F_L, 2<=>F_2, 3<=>xF_3, 4<=>F_L'
- `rs::Float64`: sqrt(s) cut - 0 for no kinematic cut
"""
function ssp_s2f123(ia::Integer, iset::Integer, def::Array{Float64},
                    istf::Integer, rs::Float64)

    ia = Ref{Int32}(ia)
    iset = Ref{Int32}(iset)
    istf = Ref{Int32}(istf)
    rs = Ref{Float64}(rs)

    @qlccall ssp_s2f123_(ia::Ref{Int32}, iset::Ref{Int32},
                       def::Ref{Float64}, istf::Ref{Int32},
                       rs::Ref{Float64})::Nothing

    nothing
end

"""
    isp_s2user(xarr, nx, qarr, nq)

Set your own node points in the spline in case
the automatic sampling fails.

The routine will discard points outside the x-qq 
evolution grid, round the remaining nodes down to 
the nearest grid-point and then sort them in 
ascending order, discarding equal values. Thus you
are allowed to enter un-sorted scattered arrays.

# Arguments
- `xarr::Array{Float64}`: array of x values
- `nx::Integer`: length of xarr
- `qarr::Array{Float64}`: array of qq values
- `nq::Integer`: length of qarr

# Returns
- `iasp::Integer`: address of the spline object
"""
function isp_s2user(xarr::Array{Float64}, nx::Integer,
                    qarr::Array{Float64}, nq::Integer)

    nx = Ref{Int32}(nx)
    nq = Ref{Int32}(nq)

    iasp = @qlccall isp_s2user_(xarr::Ref{Float64}, nx::Ref{Int32},
                              qarr::Ref{Float64}, nq::Ref{Int32})::Int32

    iasp[]
end

"""
    dsp_funs2(ia, x, q, ichk)

Evaluate function for 2D spline.

Possible values of `ichk`:
- `-1`: extrapolate the spline
- `0`: return 0
- `1`: throw an error message

# Arguments
- `ia::Integer`: address of spline
- `x::Float64`: x value
- `q::Float64`: qq value
- `ichk::Integer`: defines behaviour when outside 
spline range
"""
function dsp_funs2(ia::Integer, x::Float64, q::Float64, ichk::Integer)

    ia = Ref{Int32}(ia)
    x = Ref{Float64}(x)
    q = Ref{Float64}(q)
    ichk = Ref{Int32}(ichk)

    val = @qlccall dsp_funs2_(ia::Ref{Int32}, x::Ref{Float64},
                            q::Ref{Float64}, ichk::Ref{Int32})::Float64

    val[]
end

"""
    dsp_ints2(ia, x1, x2, q1, q2, rs, np)

Evaluate integral of spline between x1, x2, q1 and q2.
Also takes care of rscut and integrations makes use of N-point 
Gauss quadrature, as defined by the choice of np.

The integration limits must lie inside the 
spline range.
"""
function dsp_ints2(ia::Integer, x1::Float64, x2::Float64,
                   q1::Float64, q2::Float64, rs::Float64, np::Integer)

    ia = Ref{Int32}(ia)
    x1 = Ref{Float64}(x1)
    x2 = Ref{Float64}(x2)
    q1 = Ref{Float64}(q1)
    q2 = Ref{Float64}(q2)
    rs = Ref{Float64}(rs)
    np = Ref{Int32}(np)

    val = @qlccall dsp_ints2_(ia::Ref{Int32}, x1::Ref{Float64},
                            x2::Ref{Float64}, q1::Ref{Float64},
                            q2::Ref{Float64}, rs::Ref{Float64},
                            np::Ref{Int32})::Float64

    val[]
end


