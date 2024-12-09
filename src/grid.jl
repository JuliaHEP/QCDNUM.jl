
"""
    gxmake(xmin, iwt, n, nxin, iord)

Define a logarithmically-spaced `x` grid.

# Arguments
- `xmin::Array{Float64,1}`: an input array containitn `n` values 
of `x` in ascending order. `xmin[1]` defines the lower end of the grid 
and other values define approx positions where the point density
will change according to the values set in `iwt`.
- `iwt::Array{Int32,1}`: input integer weights given in ascending order 
and must always be an integer multiple of the previous weight.
- `n::Integer`: number of values specified in `xmin` and `iwt`.
- `nxin::Integer`: Requested number of grid points.
- `iord::Integer`: iord = 2(3) for linear(quadratic) spline interpolation.

# Returns
- `nxout::Integer`: the number of generated grid points. 
"""
function gxmake(xmin::Array{Float64,1}, iwt::Array{Int32,1}, n::Integer, nxin::Integer, iord::Integer)

    n = Ref{Int32}(n)
    nxin = Ref{Int32}(nxin)
    iord = Ref{Int32}(iord)
    nxout = Ref{Int32}()
    
    @qlccall gxmake_(xmin::Ref{Float64}, iwt::Ref{Int32}, n::Ref{Int32},
                   nxin::Ref{Int32}, nxout::Ref{Int32}, iord::Ref{Int32})::Nothing
    
    nxout[]
end

"""
    gqmake(qarr, wgt, n, nqin)

Define a logarithmically-spaced `mu_F^2` grid on which the parton
densities are evolved.

# Arguments
- `qarr::Array{Float64,1}`: input array containing `n` values of `mu^2`
in ascending order. The lower edge of the grid should be above 0.1 GeV^2.
- `wgt::Array{Float64,1}`: relative grip point density in each region
defined by `qarr`.
- `n::Integer`: number of values in `qarr` and `wgt` (n>=2).
- `nqin::Integer`: requested number of grid points.

# Returns
- `nqout::Integer`: number of generated grid points.
"""
function gqmake(qarr::Array{Float64,1}, wgt::Array{Float64,1}, n::Integer, nqin::Integer)

    n = Ref{Int32}(n)
    nqin = Ref{Int32}(nqin)
    nqout = Ref{Int32}()
    
    @qlccall gqmake_(qarr::Ref{Float64}, wgt::Ref{Float64}, n::Ref{Int32},
                   nqin::Ref{Int32}, nqout::Ref{Int32})::Nothing
    
    nqout[]
end

"""
    ixfrmx(x)

Get grid point index of closest grid point at or 
below `x` value.
"""
function ixfrmx(x::Float64)

    x = Ref{Float64}(x)

    ix = @qlccall ixfrmx_(x::Ref{Float64})::Int32

    ix[]    
end

"""
    xfrmix(ix)

Get `x` value at grid point `ix`.
"""
function xfrmix(ix::Integer)

    ix = Ref{Int32}(ix)

    x = @qlccall xfrmix_(ix::Ref{Int32})::Float64

    x[]    
end

"""
    xxatix(x, ix)

Check if `x` coincides with a grid point `ix`.

# Returns
`out::Bool`: `true` or `false`
"""
function xxatix(x::Float64, ix::Integer)

    x = Ref{Float64}(x)
    ix = Ref{Int32}(ix)

    out = @qlccall xxatix_(x::Ref{Float64}, ix::Ref{Int32})::UInt8

    Bool(out[])
end

"""
    iqfrmq(q2)

Get grid point index of the closest grid point at or 
below `q2` value. 
"""
function iqfrmq(q2::Float64)

    q2 = Ref{Float64}(q2)
    
    iq = @qlccall iqfrmq_(q2::Ref{Float64})::Int32
    
    iq
end

"""
    qfrmiq(iq)

Get `q2` value at grid point `iq`.
"""
function qfrmiq(iq::Integer)

    iq = Ref{Int32}(iq)

    q2 = @qlccall qfrmiq_(iq::Ref{Int32})::Float64

    q2[]    
end

"""
    qqatiq(q, iq)

Check if `q2` coincides with a grid point `iq`.

# Returns
`out::Bool`: `true` or `false`
"""
function qqatiq(q::Float64, iq::Integer)

    q = Ref{Float64}(q)
    iq = Ref{Int32}(iq)

    out = @qlccall qqatiq_(q::Ref{Float64}, iq::Ref{Int32})::UInt8

    Bool(out[])
end

"""
    grpars()

Get the current grid definitions.

# Returns
`nx::Integer`: number of points in x grid.
`xmi::Float64`: lower boundary of x grid.
`xma::Float64`: upper boundary of x grid.
`nq::Integer`: number of points in qq grid.
`qmi::Float64`: lower boundary of qq grid.
`qma::Float64`: upper boundary of qq grid.
`iord::Integer`: order of spline interpolation.
"""
function grpars()

    nx = Ref{Int32}()
    xmi = Ref{Float64}()
    xma = Ref{Float64}()
    nq = Ref{Int32}()
    qmi = Ref{Float64}()
    qma = Ref{Float64}()
    iord = Ref{Int32}()

    @qlccall grpars_(nx::Ref{Int32}, xmi::Ref{Float64}, xma::Ref{Float64},
                   nq::Ref{Int32}, qmi::Ref{Float64}, qma::Ref{Float64},
                   iord::Ref{Int32})::Nothing

    nx[], xmi[], xma[], nq[], qmi[], qma[], iord[]
end

"""
    gxcopy(n)

Copy the current `x` grid into an array of length `n`. 
"""
function gxcopy(n::Integer)

    n = Ref{Int32}(n)
    array = Array{Float64}(undef, n[])
    nx = Ref{Int32}()

    @qlccall gxcopy_(array::Ref{Float64}, n::Ref{Int32}, nx::Ref{Int32})::Nothing

    array
end

"""
    gqcopy(n)

Copy the current `mu^2` grid into an array of length `n`. 
"""
function gqcopy(n::Integer)

    n = Ref{Int32}(n)
    array = Array{Float64}(undef, n[])
    nx = Ref{Int32}()

    @qlccall gqcopy_(array::Ref{Float64}, n::Ref{Int32}, nx::Ref{Int32})::Nothing

    array
end
