"""
    ssp_extrapu(ia, n)

Define the extrapolation at the kinematic
limit for a spline at address `ia`.

The extrapolation index `n` can be:
- `0`: constant
- `1`: linear
- `2`: quadratic
- `3`: cubic
"""
function ssp_extrapu(ia, n)

    ia = Ref{Int32}(ia)
    n = Ref{Int32}(n)

    @qlccall ssp_extrapu_(ia::Ref{Int32}, n::Ref{Int32})::Nothing

    nothing
end

"""
    ssp_extrapv(ia, n)

Define the extrapolation at the kinematic
limit for a spline at address `ia`.

The extrapolation index `n` can be:
- `0`: constant
- `1`: linear
- `2`: quadratic
- `3`: cubic
"""
function ssp_extrapv(ia, n)

    ia = Ref{Int32}(ia)
    n = Ref{Int32}(n)

    @qlccall ssp_extrapv_(ia::Ref{Int32}, n::Ref{Int32})::Nothing

    nothing
end
