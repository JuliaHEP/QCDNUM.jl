using QCDNUM
using Test

include("pdf_functions.jl")

@testset "Evolution & interpolation" begin

    # C-pointer to func
    wrapped_func = WrappedPDF(func)
    func_ext_c = @cfunction(func_ext, Float64, (Ref{Int32}, Ref{Float64}, Ref{Float64}, Ref{UInt8}))
    func_usr_c = @cfunction(func_usr, Float64, (Ref{Int32}, Ref{Float64}, Ref{Float64}, Ref{UInt8}))

    # Initialise
    QCDNUM.qcinit(-6, "")

    # Grids and weights
    nx = QCDNUM.gxmake(Float64.([1.0e-4]), Int32.([1]), 1, 100, 3)
    nq = QCDNUM.gqmake(Float64.([2e0, 1e4]), Float64.([1e0, 1e0]), 2, 50)
    nw = QCDNUM.fillwt(1)

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
    @test eps < 0.1

    # For SGNS 
    QCDNUM.qstore("write", 1, float(1))
    QCDNUM.qstore("write", 2, float(iq0))

    # Interpolation
    x = 1e-3
    q = 1e3
    c = [0., 0., 1., 0., 1., 0., 0., 0., 1., 0., 1., 0., 0.]

    pdf = QCDNUM.allfxq(1, x, q, 0, 1)
    @test pdf[1] == 0.0
    @test size(pdf)[1] == 13

    pdfs_xq = QCDNUM.sumfxq(1, c, 0, x, q, 1)
    @test pdfs_xq > 0
    
    ix = QCDNUM.ixfrmx(x)
    iq = QCDNUM.iqfrmq(q)
    
    pdf = QCDNUM.allfij(1, ix, iq, 0, 1)
    @test pdf[1] == 0.0
    @test size(pdf)[1] == 13

    pdfs_ij = QCDNUM.sumfij(1, c, 0, ix, iq, 1)
    @test pdfs_ij > 0
    @test isapprox(pdfs_ij, pdfs_xq, rtol=0.1)
    
    for id in 0:12
        pdf_ij = QCDNUM.bvalij(1, id, ix, iq, 1)
        pdf_xq = QCDNUM.bvalxq(1, id, x, q, 1)
        @test isapprox(pdf_ij, pdf_xq, rtol=0.1)        
    end

    for id in -6:6
        pdf_ij = QCDNUM.fvalij(1, id, ix, iq, 1)
        pdf_xq = QCDNUM.fvalxq(1, id, x, q, 1)
        @test isapprox(pdf_ij, pdf_xq, rtol=0.1)
    end

    # Check number of PDF tables
    ntables = QCDNUM.nptabs(1)
    @test ntables == 13

    # Check evolution type
    type = QCDNUM.ievtyp(1)
    @test type == 1

    # alpha_S
    asmz, nf, ierr = QCDNUM.asfunc(8315.25)
    @test asmz ≈ 0.1180167650168159
    @test nf == 5
    @test ierr == 0

    for n in -2:20
        for iq in 1:nq
            asn, ierr = QCDNUM.altabn(1, iq, n)
            @test asn > 0
            @test ierr == 0
        end
    end

    # PDF copy
    QCDNUM.pdfcpy(1, 2)
    
    ntables = QCDNUM.nptabs(2)
    @test ntables == 13

    type = QCDNUM.ievtyp(2)
    @test type == 1

    for id in -6:6
        pdf_ij_1 = QCDNUM.fvalij(1, id, ix, iq, 1)
        pdf_ij_2 = QCDNUM.fvalij(2, id, ix, iq, 1)
        @test pdf_ij_1 == pdf_ij_2
    end

    # PDF copy via extpdf
    epsi = QCDNUM.extpdf(func_ext_c, 3, 0, 0.0)
    @test epsi < 0.05

    ntables = QCDNUM.nptabs(3)
    @test ntables == 13

    type = QCDNUM.ievtyp(3)
    @test type == 4

    for id in -6:6
        pdf_ij_1 = QCDNUM.fvalij(1, id, ix, iq, 1)
        pdf_ij_3 = QCDNUM.fvalij(3, id, ix, iq, 1)
        @test isapprox(pdf_ij_1, pdf_ij_3, rtol=0.001)
    end

    # PDF copy via usrpdf
    epsi = QCDNUM.usrpdf(func_usr_c, 4, 12, 0.0)
    @test epsi < 0.05
    
    ntables = QCDNUM.nptabs(4)
    @test ntables == 13

    type = QCDNUM.ievtyp(4)
    @test type == 5
    
    for id in 0:12
        pdf_ij_1 = QCDNUM.bvalij(1, id, ix, iq, 1)
        pdf_ij_4 = QCDNUM.bvalij(4, id, ix, iq, 1)
        @test isapprox(pdf_ij_1, pdf_ij_4, rtol=0.001)        
    end

    # Fast interpolation - list
    x_vals = 10 .^ range(-3, stop=-1, length=20)
    q2_vals = 10 .^ range(1, stop=3, length=20)

    f = QCDNUM.fflist(1, c, 0, x_vals, q2_vals, 1)
    @test size(f) == size(x_vals)

    try
        f = QCDNUM.fflist(1, c, 0, x_vals[1:10], q2_vals, 1)
    catch e
        @test isa(e, DimensionMismatch)
    end

    # Fast interpolation - table
    table = QCDNUM.ftable(1, c, 1, x_vals[1:10], q2_vals, 1)
    @test size(table) == (size(x_vals[1:10])[1], size(q2_vals)[1])

end
