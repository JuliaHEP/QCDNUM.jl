using QCDNUM
using Test

include("pdf_functions.jl")

@testset "Structure functions" begin
    
    # C-pointer to func
    wrapped_func = WrappedPDF(func)

    # Initialise
    QCDNUM.qcinit(-6, "")

    # Grids and weights
    nx = QCDNUM.gxmake(Float64.([1.0e-4]), Int32.([1]), 1, 100, 3)
    nq = QCDNUM.gqmake(Float64.([2e0, 1e4]), Float64.([1e0, 1e0]), 2, 50)
    nw = QCDNUM.fillwt(1)

    # ZMSTF
    ntot, nused_bf = QCDNUM.zmwords()
    nw = QCDNUM.zmfillw()
    ntot, nused_af = QCDNUM.zmwords()
    @test typeof(nw) == Int32
    @test nw == nused_af - nused_bf

    # Set parameters
    QCDNUM.setord(3)
    QCDNUM.setalf(0.364, 2.0)

    # VFNS
    iqc = QCDNUM.iqfrmq(3.0)
    iqb = QCDNUM.iqfrmq(25.0)
    QCDNUM.setcbt(0, iqc, iqb, 0)

    # Evolution
    iq0 = QCDNUM.iqfrmq(2.0)
    eps = QCDNUM.evolfg(1, wrapped_func, def, iq0)
    @test typeof(eps) == Float64

    Au = 4.0/9.0 
    Ad = 1.0/9.0
    w = [0., Ad, Au, Ad, Au, Ad, 0., Ad, Au, Ad, Au, Ad, 0.]
    x = 1e-3
    q = 1e3
    
    for istf in 1:4
        f = QCDNUM.zmstfun(istf, w, [x], [q], 1, 0)
        @test typeof(f[1]) == Float64 
    end
    
end
