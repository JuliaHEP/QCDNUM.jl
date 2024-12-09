using QCDNUM
using Test

@testset "Grids" begin

    # Initialisation
    QCDNUM.qcinit(-6, "")

    # x grid
    nx = QCDNUM.gxmake(Float64.([1.0e-4]), Int32.([1]), 1, 100, 3)
    @test nx == 100

    # qq grid
    nq = QCDNUM.gqmake(Float64.([2e0, 1e4]), Float64.([1e0, 1e0]), 2, 50)
    @test nq == 50

    # Indices <-> grid points
    ix = QCDNUM.ixfrmx(0.1)
    @test ix == 76

    x = QCDNUM.xfrmix(ix)
    @test x ≈ 0.1

    # Check x, ix
    @test QCDNUM.xxatix(x, ix)
    @test !QCDNUM.xxatix(0.3, 1)

    # Similarly for q2 grid
    iq = QCDNUM.iqfrmq(1000.0)
    @test iq == 36

    q = QCDNUM.qfrmiq(iq)
    @test q == 877.3066621237417

    @test QCDNUM.qqatiq(q, iq)
    @test !QCDNUM.qqatiq(100.0, 1)

    # Grid params
    out = QCDNUM.grpars()
    @test out[1] == 100
    @test out[2] ≈ 1e-4
    @test out[3] == 1
    @test out[4] == 50
    @test out[5] == 2.0
    @test out[6] ≈ 1e4
    @test out[7] == 3

    # Copying grids
    x_grid = QCDNUM.gxcopy(nx)
    @test x_grid[1] ≈ 1e-4
  
    qq_grid = QCDNUM.gqcopy(nq)
    @test qq_grid[1] ≈ 2e0

    mktempdir(prefix = "test_QCDNUM_jl") do dir
        cd(dir) do
            # Weights
            for itype in [1, 2, 3]

                nw = QCDNUM.fillwt(itype)
                @test typeof(nw) == Int32

                lun = QCDNUM.nxtlun(0)
                @test QCDNUM.dmpwgt(itype, lun, string("test_dmpwgt", string(itype), ".wgt")) == nothing
                @test QCDNUM.wtfile(itype, string("test_wtfile", string(itype), ".wgt")) == nothing
                sleep(1)
                
                lun = QCDNUM.nxtlun(0)
                nwds, ierr = QCDNUM.readwt(lun, string("test_dmpwgt", string(itype), ".wgt"))
                @test ierr == 0
            end

            for itype in [1, 2, 3]
                rm(string("test_wtfile", string(itype), ".wgt"))
                rm(string("test_dmpwgt", string(itype), ".wgt"))
            end
        end
    end

    nwtot, nwuse = QCDNUM.nwused()

    @test nwtot == 2e6
    @test nwuse < nwtot
    
end
