"""
    ssp_erase(ia)

Clear the memory from `ia` onwards. `ia`=0 can 
also be used to erase all spline objects in 
memory.
"""
function ssp_erase(ia::Integer)

    ia  = Ref{Int32}(ia)

    @qlccall ssp_erase_(ia::Ref{Int32})::Nothing

    nothing
end


"""
    isp_spsize(ia)

Get used space for spline `ia`, or total memory size when 
`ia = 0`.
"""
function isp_spsize(ia::Integer)

    ia = Ref{Int32}(ia)

    nw = @qlccall isp_spsize_(ia::Ref{Int32})::Int32

    nw[]
end

"""
    ssp_spdump(ia, filename)

Dump spline at address `ia` to `filename`.
"""
function ssp_spdump(ia::Integer, filename::String)

    ia = Ref{Int32}(ia)

    @qlccall ssp_spdump_(ia::Ref{Int32}, filename::Ptr{UInt8},
                       sizeof(filename)::Csize_t)::Nothing

    nothing
end

"""
    ssp_spread(filename)

Read spline from `filename` and return address `ia`.
"""
function isp_spread(filename::String)

    ia = @qlccall isp_spread_(filename::Ptr{UInt8}, sizeof(filename)::Csize_t)::Int32

    ia[]
end

"""
    ssp_spsetval(ia, i, val)

Store some extra info, `val`, along with the spline at `ia`.

# Arguments
- `ia::Integer`: spline address.
- `i::Integer`: storage index, runs from 1-100.
- `val::Float64`: value to store.
"""
function ssp_spsetval(ia::Integer, i::Integer, val::Float64)

    ia = Ref{Int32}(ia)
    i = Ref{Int32}(i)
    val = Ref{Float64}(val)

    @qlccall ssp_spsetval_(ia::Ref{Int32}, i::Ref{Int32}, val::Ref{Float64})::Nothing

    nothing
end

"""
    dsp_spsgtval(ia, i)

Get some extra info, `val`, from the spline `ia`.

# Arguments
- `ia::Integer`: spline address.
- `i::Integer`: storage index, runs from 1-100.

# Returns
- `val::Float64`: value to store.
"""
function dsp_spgetval(ia::Integer, i::Integer)

    ia = Ref{Int32}(ia)
    i = Ref{Int32}(i)

    val = @qlccall dsp_spgetval_(ia::Ref{Int32}, i::Ref{Int32})::Float64

    val[]
end
