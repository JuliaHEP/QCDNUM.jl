"""
    ssp_uwrite(i, val)

Write something to the reserved user space.

# Arguments
- `i::Integer`: where to write, from 1 to nuser
- `val::Float`: what to write
"""
function ssp_uwrite(i::Integer, val::Float64)

    i = Ref{Int32}(i)
    val = Ref{Float64}(val)

    @qlccall ssp_uwrite_(i::Ref{Int32}, val::Ref{Float64})::Nothing

    nothing
end

"""
    dsp_uread(i)

Read something from the reserved user space.

# Arguments
- `i::Integer`: where to read, from 1 to nuser

# Returns
- `val::Float64`: what is read
"""
function dsp_uread(i::Integer)

    i = Ref{Int32}(i)

    val = @qlccall dsp_uread_(i::Ref{Int32})::Float64

    val[]
end
