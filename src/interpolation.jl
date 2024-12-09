"""
    allfxq(iset, x, qmu2, n, ichk)

Get all flavour-pdf values for a given `x` and `mu^2`.

# Arguments
- `iset::Integer`: pdf set id (1-24).
- `x::Float64`: input value of `x`.
- `qmu2::Float64`: input value of `qmu2`.
- `n::Integer`: number of additional pdfs to be returned.
- `ichk::Integer`: flag to steer error checking. See QCDNUM 
docs. `ichk = -1` makes code faster, at the risk of not 
checking certain things.

# Returns
- `pdf::Array{Float64,2}`: pdf values over flavours.
"""
function allfxq(iset::Integer, x::Float64, qmu2::Float64,
                n::Integer, ichk::Integer)

    iset = Ref{Int32}(iset)
    x = Ref{Float64}(x)
    qmu2 = Ref{Float64}(qmu2)
    n = Ref{Int32}(n)
    ichk = Ref{Int32}(ichk)

    if n[] == 0
        pdf = Array{Float64}(undef, 13)
    else
        pdf = Array{Float64}(undef, 13, n+1)
    end
    
    @qlccall allfxq_(iset::Ref{Int32}, x::Ref{Float64}, qmu2::Ref{Float64},
                   pdf::Ref{Float64}, n::Ref{Int32}, ichk::Ref{Int32})::Nothing
    
    pdf
end

"""
    allfij(iset, ix, iq, n, ichk)

Get all flavour-pdf values for given `ix` and `iq` grid points.

# Arguments
- `iset::Integer`: pdf set id (1-24).
- `ix::Integer`: x grid point.
- `iq::Integer`: q2 grid point.
- `n::Integer`: number of additional pdfs to be returned.
- `ichk::Integer`: flag to steer error checking. See QCDNUM 
docs. `ichk = -1` makes code faster, at the risk of not 
checking certain things.

# Returns
- `pdf::Array{Float64,2}`: pdf values over flavours.
"""
function allfij(iset::Integer, ix::Integer, iq::Integer,
                n::Integer, ichk::Integer)

    iset = Ref{Int32}(iset)
    ix = Ref{Int32}(ix)
    iq = Ref{Int32}(iq)
    n = Ref{Int32}(n)
    ichk = Ref{Int32}(ichk)

    if n[] == 0
        pdf = Array{Float64}(undef, 13)
    else
        pdf = Array{Float64}(undef, 13, n+1)
    end
    
    @qlccall allfij_(iset::Ref{Int32}, ix::Ref{Int32}, iq::Ref{Int32},
                   pdf::Ref{Float64}, n::Ref{Int32}, ichk::Ref{Int32})::Nothing
    
    pdf
end


"""
    sumfxq(iset, c, isel, x, qmu2, ichk)

Return the gluon or a weighted sum of quark 
densities, depending on the selection flag, `isel`.

# `isel` values:
0: Gluon density |xg>
1: Linear combination `c` summed over _active_ flavours
2-8: Specific singlet/non-singlet quark component
9: Intrinsic heavy flavours 
12+i: Additional pdf |xf_i> in iset

See QCDNUM manual for more information.

# Arguments
- `iset::Integer`: pdf set id (1-24).
- `c::Array{Float64}`: Coefficients of quarks/anti-quarks
- `isel::Integer`: Selection flag
- `x::Float64`: input value of `x`.
- `qmu2::Float64`: input value of `qmu2`.
- `n::Integer`: number of additional pdfs to be returned.
- `ichk::Integer`: flag to steer error checking. See QCDNUM 
docs. `ichk = -1` makes code faster, at the risk of not 
checking certain things.

# Returns
- `pdf::Float64`: pdf value.
"""
function sumfxq(iset::Integer, c::Array{Float64}, isel::Integer, x::Float64,
                qmu2::Float64, ichk::Integer)

    iset = Ref{Int32}(iset)
    isel = Ref{Int32}(isel)
    x = Ref{Float64}(x)
    qmu2 = Ref{Float64}(qmu2)
    ichk = Ref{Int32}(ichk)

    pdf = @qlccall sumfxq_(iset::Ref{Int32}, c::Ref{Float64}, isel::Ref{Int32},
                         x::Ref{Float64}, qmu2::Ref{Float64},
                         ichk::Ref{Int32})::Float64
    
    pdf[]
end

"""
    sumfij(iset, c, isel, ix, iq, ichk)

Return the gluon or a weighted sum of quark 
densities, depending on the selection flag, `isel`.

# `isel` values:
0: Gluon density |xg>
1: Linear combination `c` summed over _active_ flavours
2-8: Specific singlet/non-singlet quark component
9: Intrinsic heavy flavours 
12+i: Additional pdf |xf_i> in iset

See QCDNUM manual for more information.

# Arguments
- `iset::Integer`: pdf set id (1-24).
- `c::Array{Float64}`: Coefficients of quarks/anti-quarks
- `isel::Integer`: Selection flag
- `ix::Integer`: x grid point.
- `iq::Integer`: q2 grid point.
- `n::Integer`: number of additional pdfs to be returned.
- `ichk::Integer`: flag to steer error checking. See QCDNUM 
docs. `ichk = -1` makes code faster, at the risk of not 
checking certain things.

# Returns
- `pdf::Float64`: pdf value.
"""
function sumfij(iset::Integer, c::Array{Float64}, isel::Integer, ix::Integer,
                iq::Integer, ichk::Integer)

    iset = Ref{Int32}(iset)
    isel = Ref{Int32}(isel)
    ix = Ref{Int32}(ix)
    iq = Ref{Int32}(iq)
    ichk = Ref{Int32}(ichk)

    pdf = @qlccall sumfij_(iset::Ref{Int32}, c::Ref{Float64}, isel::Ref{Int32},
                         ix::Ref{Int32}, iq::Ref{Int32},
                         ichk::Ref{Int32})::Float64
    
    pdf[]
end

"""
    bvalij(iset, id, ix, iq, ichk)

Get the value of a basis pdf at a given point (`ix`, `iq`).

# Arguments
- `iset::Integer`: pdf set id (1-24)
- `id::Integer`: basis pdf identifier from 0 to 12+n, 
where n is the number of additional pdfs in iset.
- `ix::Integer`: x index.
- `iq::Integer`: qq index.
- `ichk::Integer`: flag to steer error checking. 
See allfxq().

# Returns
- `pdf::Float64`: pdf values.
"""
function bvalij(iset::Integer, id::Integer, ix::Integer, iq::Integer, ichk::Integer)

    iset = Ref{Int32}(iset)
    id = Ref{Int32}(id)
    ix = Ref{Int32}(ix)
    iq = Ref{Int32}(iq)
    ichk = Ref{Int32}(ichk)

    pdf = @qlccall bvalij_(iset::Ref{Int32}, id::Ref{Int32}, ix::Ref{Int32},
                         iq::Ref{Int32}, ichk::Ref{Int32})::Float64

    pdf[]
end

"""
    bvalxq(iset, id, x, qq, ichk)

Get the value of a basis pdf at a given point (`x`, `qq`).

# Arguments
- `iset::Integer`: pdf set id (1-24)
- `id::Integer`: basis pdf identifier from 0 to 12+n, 
where n is the number of additional pdfs in iset.
- `x::Float64`: x value.
- `qq::Float64`: qq value.
- `ichk::Integer`: flag to steer error checking. 
See allfxq().

# Returns
- `pdf::Float64`: pdf values.
"""
function bvalxq(iset::Integer, id::Integer, x::Float64, qq::Float64, ichk::Integer)

    iset = Ref{Int32}(iset)
    id = Ref{Int32}(id)
    x = Ref{Float64}(x)
    q = Ref{Float64}(qq)
    ichk = Ref{Int32}(ichk)

    pdf = @qlccall bvalxq_(iset::Ref{Int32}, id::Ref{Int32}, x::Ref{Float64},
                         qq::Ref{Float64}, ichk::Ref{Int32})::Float64

    pdf[]
end

"""
    fvalij(iset, id, ix, iq, ichk)

Get the value of a flavour momentum density 
at a given point (`ix`, `iq`).

# Arguments
- `iset::Integer`: pdf set id (1-24)
- `id::Integer`: basis pdf identifier from -6 to 6+n, 
where n is the number of additional pdfs in iset.
- `ix::Integer`: x index.
- `iq::Intger`: qq index.
- `ichk::Integer`: flag to steer error checking. 
See allfxq().

# Returns
- `pdf::Float64`: pdf values.
"""
function fvalij(iset::Integer, id::Integer, ix::Integer, iq::Integer, ichk::Integer)

    iset = Ref{Int32}(iset)
    id = Ref{Int32}(id)
    ix = Ref{Int32}(ix)
    iq = Ref{Int32}(iq)
    ichk = Ref{Int32}(ichk)

    pdf = @qlccall fvalij_(iset::Ref{Int32}, id::Ref{Int32}, ix::Ref{Int32},
                         iq::Ref{Int32}, ichk::Ref{Int32})::Float64

    pdf[]
end

"""
    fvalxq(iset, id, x, qq, ichk)

Get the value of a flavour momentum density
at a given point (`x`, `qq`).

# Arguments
- `iset::Integer`: pdf set id (1-24)
- `id::Integer`: basis pdf identifier from -6 to 6+n, 
where n is the number of additional pdfs in iset.
- `x::Float64`: x value.
- `qq::Float64`: qq value.
- `ichk::Integer`: flag to steer error checking. 
See allfxq().

# Returns
- `pdf::Float64`: pdf values.
"""
function fvalxq(iset::Integer, id::Integer, x::Float64, qq::Float64, ichk::Integer)

    iset = Ref{Int32}(iset)
    id = Ref{Int32}(id)
    x = Ref{Float64}(x)
    q = Ref{Float64}(qq)
    ichk = Ref{Int32}(ichk)

    pdf = @qlccall fvalxq_(iset::Ref{Int32}, id::Ref{Int32}, x::Ref{Float64},
                         qq::Ref{Float64}, ichk::Ref{Int32})::Float64

    pdf[]
end

"""
    fflist(iset, c, isel, x, q, ichk)

A fast routine to generate a list of interpolated pdfs.

# Arguments
- `iset::Integer`: pdf set identifier [1-24]
- `c::Array{Float64}`: coefficients of quarks/anti-quarks
- `isel::Integer`: selection flag
- `x::Array{Float64}`: list of x values.
- `q::Array{Float64}`: list of q2 values.
- `ichk::Integer`: flag to steer error checking. See `allfxq()`.

# Returns 
- `f::Array{Float64}`: output list of pdf values.
"""
function fflist(iset::Integer, c::Array{Float64}, isel::Integer, x::Array{Float64},
                q::Array{Float64}, ichk::Integer)

    if size(x) != size(q)

        throw(DimensionMismatch("x and q must have the same length"))
        
    end

    n = size(x)[1]
    f = zeros(n)
    
    iset = Ref{Int32}(iset)
    isel = Ref{Int32}(isel)
    n = Ref{Int32}(n)
    ichk = Ref{Int32}(ichk)
    
    @qlccall fflist_(iset::Ref{Int32}, c::Ref{Float64}, isel::Ref{Int32}, x::Ref{Float64},
                   q::Ref{Float64}, f::Ref{Float64}, n::Ref{Int32}, ichk::Ref{Int32})::Nothing
    
    f
end

"""
    fftabl(ist, c, isel, x, q, n, ichk)

A fast routine to generate a table of interpolated pdfs.

- `iset::Integer`: pdf set identifier [1-24]
- `c::Array{Float64}`: coefficients of quarks/anti-quarks
- `isel::Integer`: selection flag
- `x::Array{Float64}`: list of x values.
- `q::Array{Float64}`: list of q2 values.
- `ichk::Integer`: flag to steer error checking. See `allfxq()`.

# Returns 
- `table::Matrix{Float64}`: output table of pdf values.
"""
function ftable(iset::Integer, c::Array{Float64}, isel::Integer, x::Array{Float64},
                q::Array{Float64}, ichk::Integer)

    nx = size(x)[1]
    nq = size(q)[1]
    table = zeros(nx, nq)
    
    iset = Ref{Int32}(iset)
    isel = Ref{Int32}(isel)
    nx = Ref{Int32}(nx)
    nq = Ref{Int32}(nq)
    ichk = Ref{Int32}(ichk)
    
    @qlccall ftable_(iset::Ref{Int32}, c::Ref{Float64}, isel::Ref{Int32},
                   x::Ref{Float64}, nx::Ref{Int32}, q::Ref{Float64}, nq::Ref{Int32},
                   table::Ref{Float64}, nx::Ref{Int32}, ichk::Ref{Int32})::Nothing
    
    table
end

"""
    splchk(iset, id, iq)

Return for a basis pdf at a given Q^2 grid point the 
maximum deviation between a linear interpolation and 
the spline interpolation used by QCDNUM.

To be used if having issues with evolfg or extpdf.

# Arguments
`iset::Integer`: PDF set identifier [1-24]
`id::Integer`: Identifier of a basis PDF |e^±|
`iq::Integer`: Index of a Q^2 grid point

# Returns
`epsi::Float64`: Value of the max deviation 
"""
function splchk(iset::Integer, id::Integer, iq::Integer)

    iset = Ref{Int32}(iset)
    id = Ref{Int32}(id)
    iq = Ref{Int32}(iq)

    epsi = @qlccall splchk_(iset::Ref{Int32}, id::Ref{Int32},
                          iq::Ref{Int32})::Float64

    epsi[]
end

"""
    fsplne(iset, id, x, iq)

Spline interpolation of a basis PDF in x, at the grid
point `iq`. Provided as a diagnostic tool to investigate
possible quadratic spline oscillations.

# Arguments
`iset::Integer`: PDF set identifier [1-24]
`id::Integer`: Identifier of a basis pdf |e^±|
`x::Float64`: x value
`iq::Integer`: Index of a Q^2 grid point

# Returns
`pdf::Float64`: pdf value
"""
function fsplne(iset::Integer, id::Integer, x::Float64, iq::Integer)

    iset = Ref{Int32}(iset)
    id = Ref{Int32}(id)
    x = Ref{Float64}(x)
    iq = Ref{Int32}(iq)

    pdf = @qlccall fsplne_(iset::Ref{Int32}, id::Ref{Int32},
                         x::Ref{Float64}, iq::Ref{Int32})::Float64
   
   pdf[] 
end
