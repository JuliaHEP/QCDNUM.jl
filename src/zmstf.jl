"""
    zmfillw()

Fill weight tables for zero-mass structure function 
calculations.
"""
function zmfillw()

    nwords = Ref{Int32}()
    
    @qlccall zmfillw_(nwords::Ref{Int32})::Nothing
    
    nwords[]
end

"""
    zmwords()

Check the number of words available in the ZMSTF 
workspace and the number of words used.
"""
function zmwords()

    ntotal = Ref{Int32}()
    nused = Ref{Int32}()

    @qlccall zmwords_(ntotal::Ref{Int32}, nused::Ref{Int32})::Nothing
    
    ntotal[], nused[]
end

"""
    zmstfun()

Calculate a structure function from a linear combination 
of parton densities.

# Arguments
- `istf::Integer`: structure function index 
where (1,2,3,4) = (F_L, F_2, xF_3, f_L^').
- `def::Array{Float64}`: coeffs of the quark linear combination 
for which the structure function is to be calculated.
- `x::Array{Float64}`: list of `x` values.
- `Q2::Array{Float64}`: list of `Q2` values.
- `n::Integer`: number of items in `x`, `Q2` and `f`.
- `ichk::Integer`: flag for grid boundary checks. See QCDNUM docs.

# Returns
- `f::Array{Float64}`: list of structure functions. 
"""
function zmstfun(istf::Integer, def::Array{Float64}, x::Array{Float64},
                 Q2::Array{Float64}, n::Integer, ichk::Integer)

    istf = Ref{Int32}(istf)
    n = Ref{Int32}(n)
    ichk = Ref{Int32}(ichk)

    f = Array{Float64}(undef, n[])
    
    @qlccall zmstfun_(istf::Ref{Int32}, def::Ref{Float64}, x::Ref{Float64},
                    Q2::Ref{Float64}, f::Ref{Float64}, n::Ref{Int32},
                    ichk::Ref{Int32})::Nothing 
    
    f
end
