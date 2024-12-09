_splint_init_complete = false

"""
    isp_spvers()

SPLINT version as a date.
"""
function isp_spvers()

    ver = @qlccall isp_spvers_()::Int32

    ver[]
end

"""
    ssp_spinit(nuser)

Initialise SPLINT - should be called before other 
SPLINT functions.

# Arguments
- `nuser::Integer`: the number of words reserved for user storage 
"""
function ssp_spinit(nuser::Integer)

    nuser = Ref{Int32}(nuser)

    if !_splint_init_complete
        
        @qlccall ssp_spinit_(nuser::Ref{Int32})::Nothing

        global _splint_init_complete = true

    else

        @warn "SPLINT is already initialised, skipping call to QCDNUM.ssp_spinit()"

    end
    
    nothing
end
