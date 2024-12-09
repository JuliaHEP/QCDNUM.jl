using QCDNUM
using Test

include("pdf_functions.jl")

@testset "Parameters" begin

    # Initialisation
    QCDNUM.qcinit(-6, "")

    # Order
    for iord in [1, 2, 3]
        @test QCDNUM.setord(iord) == nothing
        @test QCDNUM.getord() == iord
    end

    try
        QCDNUM.setord(0)
    catch e
        @test isa(e, DomainError)
    end
    
    @test QCDNUM.setalf(0.364, 2.0) == nothing
    alfs, r2 = QCDNUM.getalf()
    @test alfs == 0.364
    @test r2 == 2.0

    @test QCDNUM.setabr(1.0, 0.0) == nothing
    ar, br = QCDNUM.getabr()
    @test ar == 1.0
    @test br == 0.0

    nx = QCDNUM.gxmake(Float64.([1.0e-4]), Int32.([1]), 1, 100, 3)
    nq = QCDNUM.gqmake(Float64.([2e0, 1e4]), Float64.([1e0, 1e0]), 2, 50)
    nw = QCDNUM.fillwt(1)

    # Evolve a test pdf set with boundaries for later
    iqc = QCDNUM.iqfrmq(3.0)
    iqb = QCDNUM.iqfrmq(25.0)
    QCDNUM.setcbt(0, iqc, iqb, 0)

    wrapped_func = WrappedPDF(func)
    iq0 = QCDNUM.iqfrmq(2.0)
    eps = QCDNUM.evolfg(1, wrapped_func, def, iq0)

    # VFNS & FFNS
    for nfix in [0, 1, 3, 4, 5, 6]
        
        @test QCDNUM.setcbt(nfix, 5, 10, 30) == nothing

        nfix_out, q2c, q2b, q2t = QCDNUM.getcbt()

        @test nfix == nfix_out

        # VFNS
        if nfix in [0, 1]

            @test q2c == QCDNUM.qfrmiq(5)
            @test q2b == QCDNUM.qfrmiq(10)
            @test q2t == QCDNUM.qfrmiq(30)
            
        end

    end

    try 
        QCDNUM.setcbt(2, 5, 10, 30)
    catch e
        @test isa(e, DomainError)
    end

    # MFNS
    for nfix in [3, 4, 5, 6]

        @test QCDNUM.mixfns(nfix, 10.0, 100.0, 1000.0) == nothing

        nfix_out, q2c, q2b, q2t = QCDNUM.getcbt()

        @test nfix_out == - nfix

        @test q2c == 10.0
        @test q2b == 100.0
        @test q2t == 1000.0
        
    end

    # Number of active flavours in test pdf set
    nf, ithresh = QCDNUM.nfrmiq(1, 5)
    @test nf == 4
    @test ithresh == 0

    # Conversion between renormalisation and factorisation scales
    rscale2 = QCDNUM.ffromr(100.0)
    @test QCDNUM.rfromf(rscale2) == 100.0

    fscale2 = QCDNUM.rfromf(100.0)
    @test QCDNUM.ffromr(fscale2) == 100.0

    # Boundaries
    @test QCDNUM.setlim(1, 5, 45) == nothing
    xmin, qmin, qmax = QCDNUM.getlim(1)
    @test xmin == QCDNUM.xfrmix(1)
    @test qmin == QCDNUM.qfrmiq(1)
    @test qmax == QCDNUM.qfrmiq(nq)

    # Evolution params
    array = QCDNUM.cpypar(1)
    @test array[1] == 3
    @test array[4] == 0
    @test array[8] == ar
    @test array[9] == br
    @test array[10] == xmin
    @test array[11] == qmin
    @test array[12] == qmax
    @test array[13] == 1

    QCDNUM.usepar(1)
    @test QCDNUM.keypar(1) == QCDNUM.keypar(0)

    for igroup in 1:6
        @test QCDNUM.keygrp(1, igroup) == QCDNUM.keygrp(0, igroup)
    end
    
    @test QCDNUM.pushcp() == nothing
    @test QCDNUM.pullcp() == nothing    
    
end
