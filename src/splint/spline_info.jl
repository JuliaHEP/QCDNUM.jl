"""
    isp_splinetype(ia)

Get the type of spline at address `ia`.

Possible types are:
- `-1`: x spline
- `0`: not a spline
- `1`: qq spline
- `2`: x-qq spline 
"""
function isp_splinetype(ia::Integer)

    ia = Ref{Int32}(ia)

    type = @qlccall isp_splinetype_(ia::Ref{Int32})::Int32

    type[]
end


"""
    ssp_splims(ia)

Get node limits of spline at address `ia`.

Here, u and v refer to the x and qq 
dimensions respectively.

# Returns tuple containing
- `nu::Integer`: number of nodes in u direction
- `u1::Float64`: lower u limit
- `u2::Float64`: upper u limit
- `nv::Integer`: number of nodes in v direction
- `v1::Float64`: lower v limit
- `v2::Float64`: upper v limit
- `n::Integer`: number of active nodes below kinematic limit 
"""
function ssp_splims(ia)

    ia = Ref{Int32}(ia)

    nu = Ref{Int32}()
    u1 = Ref{Float64}()
    u2 = Ref{Float64}()

    nv = Ref{Int32}()
    v1 = Ref{Float64}()
    v2 = Ref{Float64}()

    n = Ref{Int32}()

    @qlccall ssp_splims_(ia::Ref{Int32}, nu::Ref{Int32}, u1::Ref{Float64},
                       u2::Ref{Float64}, nv::Ref{Int32}, v1::Ref{Float64},
                       v2::Ref{Float64}, n::Ref{Int32})::Nothing

    nu[], u1[], u2[], nv[], v1[], v2[], n[]
end


"""
    ssp_unodes(ia, n, nu)

Copy u-nodes from spline at address `ia` 
to local array.

# Arguments
- `ia::Integer`: address of spline
- `n::Integer`: dimension of array to copy to
- `nu::Integer`: number of u-nodes copied

# Returns
- `array::Array{Float64}`: array of u-nodes
"""
function ssp_unodes(ia::Integer, n::Integer, nu::Integer)

    ia = Ref{Int32}(ia)
    n = Ref{Int32}(n)
    nu = Ref{Int32}(nu)

    array = Array{Float64}(undef, n[])

    @qlccall ssp_unodes_(ia::Ref{Int32}, array::Ref{Float64},
                       n::Ref{Int32}, nu::Ref{Int32})::Nothing

    array
end


"""
    ssp_vnodes(ia, n, nv)

Copy v-nodes from spline at address `ia` 
to local array.

# Arguments
- `ia::Integer`: address of spline
- `n::Integer`: dimension of array to copy to
- `nv::Integer`: number of v-nodes copied

# Returns
- `array::Array{Float64}`: array of v-nodes
"""
function ssp_vnodes(ia::Integer, n::Integer, nv::Integer)

    ia = Ref{Int32}(ia)
    n = Ref{Int32}(n)
    nv = Ref{Int32}(nv)

    array = Array{Float64}(undef, n[])

    @qlccall ssp_vnodes_(ia::Ref{Int32}, array::Ref{Float64},
                       n::Ref{Int32}, nv::Ref{Int32})::Nothing

    array
end


"""
    ssp_nprint(ia)

Print a list of nodes and grids for 
the spline at address `ia`.
"""
function ssp_nprint(ia::Integer)

    ia = Ref{Int32}(ia)

    @qlccall ssp_nprint_(ia::Ref{Int32})::Nothing

    nothing
end


"""
    dsp_rscut(ia)

Get the root(s) cut for the spline at `ia`.
"""
function dsp_rscut(ia::Integer)

    ia = Ref{Int32}(ia)

    rsc = @qlccall dsp_rscut_(ia::Ref{Int32})::Float64

    rsc[]
end

"""
    dsp_rsmax(ia, rsc)

Get the root(s) cut limit for the spline at `ia` and cut `rsc`.
"""
function dsp_rsmax(ia::Integer, rsc::Float64)

    ia = Ref{Int32}(ia)

    rsc_max = @qlccall dsp_rsmax_(ia::Ref{Int32}, rsc::Ref{Float64})::Float64

    rsc_max[]
end
