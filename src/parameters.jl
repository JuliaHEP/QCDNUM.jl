"""
    setord(iord)

Set order of perturbative QCD calculations.
`iord` = 1, 2, 3 for LO, NLO and NNLO respectively.
By default, `iord = 2`.
"""
function setord(iord::Integer)

    if iord < 1 || iord > 3

        throw(DomainError(iord, "iord must be 1, 2 or 3"))
        
    end
    
    iord = Ref{Int32}(iord)
    
    @qlccall setord_(iord::Ref{Int32})::Nothing

    nothing
end

"""
    getord()

Get order of perturbative QCD calculations.
`iord` = 1, 2, 3 for LO, NLO and NNLO respectively.
By default, `iord = 2`.
"""
function getord()

    iord = Ref{Int32}()

    @qlccall getord_(iord::Ref{Int32})::Nothing

    iord[]
end

"""
    setalf(alfs, r2)

Set the starting value of `alpha_S` and the starting 
renormalisation scale `r2`. By default `alpha_S(m_Z^2) = 0.118`.
"""
function setalf(alfs::Float64, r2::Float64)
    
    alfs = Ref{Float64}(alfs)
    r2 = Ref{Float64}(r2)
    
    @qlccall setalf_(alfs::Ref{Float64}, r2::Ref{Float64})::Nothing
    
    nothing
end

"""
    getalf()

Set the starting value of `alpha_S` and the starting 
renormalisation scale `r2`. By default `alpha_S(m_Z^2) = 0.118`.
"""
function getalf()

    alfs = Ref{Float64}()
    r2 = Ref{Float64}()

    @qlccall getalf_(alfs::Ref{Float64}, r2::Ref{Float64})::Nothing

    alfs[], r2[]
end

"""
    setcbt(nfix, iqc, iqb, iqt)

Select FFNS or VFNS, and thresholds on `mu_F^2` if necessary.

# Arguments
- `nfix::Integer`: number of flavours in the FFNS. For VNFS set
`nfix = 0`.
- `iqc/b/t::Integer`: grid indices of the heavy flavour thresholds 
in the VFNS. Ignored if FFNS.
"""
function setcbt(nfix::Integer, iqc::Integer, iqb::Integer, iqt::Integer)

    if nfix < 0 || nfix > 6 || nfix == 2

        throw(DomainError(nfix, "nfix must be 0, 1, 3, 4, 5 or 6"))
        
    end
    
    nfix = Ref{Int32}(nfix)
    iqc = Ref{Int32}(iqc)
    iqb = Ref{Int32}(iqb)
    iqt = Ref{Int32}(iqt)
    
    @qlccall setcbt_(nfix::Ref{Int32}, iqc::Ref{Int32},
                   iqb::Ref{Int32}, iqt::Ref{Int32})::Nothing
    
    nothing
end

"""
    mixfns(nfix, r2c, r2b, r2t)

Select the MFNS mode and set thresholds on mu_R^2.

# Arguments
- `nfix::Integer`: Fixed number of flavours for MFNS. Can be 
in the range [3, 6].
- `r2c/b/t::Float64`: Thresholds defined on the renormalisation scale
mu_R^2 for c, b and t.   
"""
function mixfns(nfix::Integer, r2c::Float64, r2b::Float64, r2t::Float64)

    if nfix < 3 || nfix > 6

        throw(DomainError(nfix, "nfix must be in the range [3, 6]"))
        
    end
    
    nfix = Ref{Int32}(nfix)
    r2c = Ref{Float64}(r2c)
    r2b = Ref{Float64}(r2b)
    r2t = Ref{Float64}(r2t)

    @qlccall mixfns_(nfix::Ref{Int32}, r2c::Ref{Float64}, r2b::Ref{Float64},
                   r2t::Ref{Float64})::Nothing

    nothing
end

"""
    getcbt()

Return the current threshold settings for the FFNS or VFNS.

# Returns
- `nfix::Integer`: number of flavours in the FFNS. For VNFS set
`nfix = 0`.
- `qc/b/t::Float64`: q2 values of the heavy flavour thresholds 
in the VFNS. Ignored if FFNS.
"""
function getcbt()

    nfix = Ref{Int32}()
    q2c = Ref{Float64}()
    q2b = Ref{Float64}()
    q2t = Ref{Float64}()

    @qlccall getcbt_(nfix::Ref{Int32}, q2c::Ref{Float64},
                   q2b::Ref{Float64}, q2t::Ref{Float64})::Nothing
    
    nfix[], q2c[], q2b[], q2t[]
end

"""
    nfrmiq(iset, iq)

Returns the number of active flavours `nf` at a 
q2 grid point `iq`.

# Arguments
- `iset::Integer`: pdf set identifier.
- `iq::Integer`: q2 grid point.

# Returns
- `nf::Integer`: number of active flavours. 0 if `iq` is 
outside the q2 grid.
- `ithresh::Integer`: threshold indicator that is set to
+1(-1) if `iq` is at a threshold with the larger (smaller)
number of flavours, 0 otherwise. 
"""
function nfrmiq(iset::Integer, iq::Integer)

    iset = Ref{Int32}(iset)
    iq = Ref{Int32}(iq)

    ithresh = Ref{Int32}()

    nf = @qlccall nfrmiq_(iset::Ref{Int32}, iq::Ref{Int32},
                         ithresh::Ref{Int32})::Int32

    nf[], ithresh[]
end

"""
    setabr(ar, br)

Define the relation between the factorisation scale mu_F^2
and the renormalisation scale mu_R^2.

mu_R^2 = `ar` mu_F^2 + `br`.
"""
function setabr(ar::Float64, br::Float64)

    ar = Ref{Float64}(ar)
    br = Ref{Float64}(br)

    @qlccall setabr_(ar::Ref{Float64}, br::Ref{Float64})::Nothing

    nothing
end

"""
    getabr()

Get the relation between the factorisation scale mu_F^2
and the renormalisation scale mu_R^2.

mu_R^2 = `ar` mu_F^2 + `br`.
"""
function getabr()

    ar = Ref{Float64}()
    br = Ref{Float64}()

    @qlccall getabr_(ar::Ref{Float64}, br::Ref{Float64})::Nothing

    ar[], br[]
end

"""
    rfromf(fscale2)

Convert the factorisation scale, mu_F^2, to the renormalisation
scale, mu_R^2. 
"""
function rfromf(fscale2::Float64)

    fscale2 = Ref{Float64}(fscale2)

    rscale2 = @qlccall rfromf_(fscale2::Ref{Float64})::Float64

    rscale2[]
end

"""
    rfromf(fscale2)

Convert the renormalisation scale, mu_R^2, to the factorisation
scale, mu_F^2. 
"""
function ffromr(rscale2::Float64)

    rscale2 = Ref{Float64}(rscale2)

    fscale2 = @qlccall ffromr_(rscale2::Ref{Float64})::Float64

    fscale2[]
end


"""
    setlim(ixmin, iqmin, iqmax)

Restrict the range of a pdf evolution or import to 
only part of the x-q2 grid.

`ixmin`, `iqmin` and `iqmax` re-define the range of the grid.
To release a cut, eneter a value of 0. Fatal error if the cuts 
result in a kinematic domain that is too small or empty.
"""
function setlim(ixmin::Integer, iqmin::Integer, iqmax::Integer)

    ixmin = Ref{Int32}(ixmin)
    iqmin = Ref{Int32}(iqmin)
    iqmax = Ref{Int32}(iqmax)

    dum = Ref{Float64}()
    
    @qlccall setlim_(ixmin::Ref{Int32}, iqmin::Ref{Int32},
                   iqmax::Ref{Int32}, dum::Ref{Float64})::Nothing
    
    nothing
end

"""
    getlim(iset)

Read current grid boundary values for a pdf set `iset`.

# Returns
- `xmin::Float64`: min x boundary
- `qmin::Float64`: min q2 boundary
- `qmax::Float64`: max q2 boundary
"""
function getlim(iset::Integer)

    iset = Ref{Int32}(iset)

    xmin = Ref{Float64}()
    qmin = Ref{Float64}()
    qmax = Ref{Float64}()

    dum = Ref{Float64}()
    
    @qlccall getlim_(iset::Ref{Int32}, xmin::Ref{Float64},
                   qmin::Ref{Float64}, qmax::Ref{Float64},
                   dum::Ref{Float64})::Nothing

    xmin[], qmin[], qmax[]
end

"""
    cpypar(iset)

Copy the evolution parameters of a pdf set to a local array.
The array has the following param values:

- 1: `iord` 
- 2: `alfas` 
- 3: `r2alf` 
- 4: `nfix` 
- 5: `q2c`
- 6: `q2b`
- 7: `q2t` 
- 8: `ar` 
- 9: `br` 
- 10:` xmin`
- 11:` qmin` 
- 12:` qmax` 

In addition to the evolution parameters is given the pdf type in array(13): 
1 = unpolarised, 2 = polarised, 3 = time-like, 4 = external, 5 = user.

# Arguments
- `iset::Integer`: pdf set identifier. 

# Returns
- `array::Vector{Float64}`
"""
function cpypar(iset::Integer)

    iset = Ref{Int32}(iset)

    n = 13
    array = zeros(13)  

    n = Ref{Int32}(n)
    
    @qlccall cpypar_(array::Ref{Float64}, n::Ref{Int32},
                   iset::Ref{Int32})::Nothing

    array
end


"""
    keypar(iset)

Returns the parameter key of the pdf in `iset`.
Useful to check if parameters match with.
"""
function keypar(iset::Integer)

    iset = Ref{Int32}(iset)

    key = @qlccall keypar_(iset::Ref{Int32})::Float64
    
    key[]
end

"""
    keygrp(iset, igroup)

Returns the parameter key of the pdf group in `iset`.
Useful to check if parameters match. Like a more specific
keypar.

`igroup` can be:

- 1: order
- 2: alpha_S
- 3: fnsandthresholds
- 4: scale
- 5: cutes
- 6: all
"""
function keygrp(iset::Integer, igroup::Integer)

    iset = Ref{Int32}(iset)
    igroup = Ref{Int32}(igroup)

    key = @qlccall keygrp_(iset::Ref{Int32}, igroup::Ref{Int32})::Float64
    
    key[]
end


"""
    usepar(iset)

Activate the parameters of `iset`, ie. copy them to
`iset = 0` and re-initialise the active look-up tables.
"""
function usepar(iset::Integer)

    iset = Ref{Int32}(iset)

    @qlccall usepar_(iset::Ref{Int32})::Nothing
    
    nothing
end

"""
    pushcp()

Push the current parameters to LIFO stack
(temporarily stash them).
"""
function pushcp()

    @qlccall pushcp_()::Nothing
    
end

"""
    pushcp()

Pull the current parameters from LIFO stack
(load stashed parameters).
"""
function pullcp()

    @qlccall pullcp_()::Nothing
    
end

