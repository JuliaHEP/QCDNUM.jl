# # SPLINT package example

# `SPLINT` is a QCDNUM add-on for converting results computed on the
# evolution grid to cubic splines. This is convenient for
# integrating/differentiating these results.

using QCDNUM
using Printf

# ### Example evolution grid

# First, we need a QCDNUM evolution grid to work with.
# For this, we use the QCDNUM example program described in the `example` notebook. 

xmin = Float64.([1.0e-4])
iwt = Int32.([1])
ng = 1
nxin = 100
iosp = 3
nx = 10

qq = Float64.([2e0, 1e4])
wt = Float64.([1e0, 1e0])
nq = 1
nqin = 60
ngq = 2
itype = 1

as0 = 0.364
r20 = 2.0

q2c = 3.0
q2b = 25.0
q0 = 2.0
iqt = 999

def = Float64.([0., 0., 0., 0., 0.,-1., 0., 1., 0., 0., 0., 0., 0.,     
      0., 0., 0., 0.,-1., 0., 0., 0., 1., 0., 0., 0., 0.,      
      0., 0., 0.,-1., 0., 0., 0., 0., 0., 1., 0., 0., 0.,      
      0., 0., 0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0.,      
      0., 0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0.,      
      0., 0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      
      0., 0.,-1., 0., 0., 0., 0., 0., 0., 0., 1., 0., 0.,      
      0., 0., 1., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      
      0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      
      0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      
      0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.,      
      0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.]);

nfin = 0
x = 1.0e-3
q = 1.0e3
pdf = Array{Float64}(undef, 13)
qmz2 = 8315.25;

function func(ipdf, x)::Float64
    i = ipdf[]
    xb = x[]
    adbar = 0.1939875
    f = 0
    if (i == 0) 
        ag = 1.7
        f = ag * xb^-0.1 * (1.0-xb)^5.0
    end
    if (i == 1)
        ad = 3.064320
        f = ad * xb^0.8 * (1.0-xb)^4.0
    end
    if (i == 2)
        au = 5.107200
        f = au * xb^0.8 * (1.0-xb)^3.0
    end
    if (i == 3) 
        f = 0.0
    end
    if (i == 4)
        f = adbar * xb^-0.1 * (1.0-xb)^6.0
    end
    if (i == 5) 
        f = adbar * xb^-0.1 * (1.0-xb)^6.0 * (1.0-xb)
    end
    if (i == 6)
        xdbar = adbar * xb^-0.1 * (1.0-xb)^6.0
        xubar = adbar * xb^-0.1 * (1.0-xb)^6.0 * (1.0-xb)
        f = 0.2 * (xdbar + xubar)
    end
    if (i == 7)
        f = 0.0
    end
    if (i == 8)
        f = 0.0
    end
    if (i == 9)
        f = 0.0
    end
    if (i == 10)
        f = 0.0
    end
    if (i == 11)
        f = 0.0
    end
    if (i == 12)
        f = 0.0
    end
    return f
end

wrapped_func = WrappedPDF(func)

# Let's set up and run this example evolution.

QCDNUM.qcinit(-6, " ")
nx = QCDNUM.gxmake(xmin, iwt, ng, nxin, iosp)
nq = QCDNUM.gqmake(qq, wt, ngq, nqin)
nw = QCDNUM.fillwt(itype)
QCDNUM.setord(3)
QCDNUM.setalf(as0, r20)
iqc = QCDNUM.iqfrmq(q2c)
iqb = QCDNUM.iqfrmq(q2b)
iqt = QCDNUM.iqfrmq(1e11)
QCDNUM.setcbt(0, iqc, iqb, 0)
iq0 = QCDNUM.iqfrmq(q0)
eps = QCDNUM.evolfg(itype, wrapped_func, def, iq0)
pdf = QCDNUM.allfxq(itype, x, q, 0, 1)
asmz, a, b = QCDNUM.asfunc(qmz2)
csea = 2*pdf[3];

@printf("x, q, CharmSea = %0.4e, %0.4e, %0.4e\n", x, q, csea)
@printf("as(mz2) = %0.4e", asmz)

# ### SPLINT
#
# For the SPLINT example, we need a PDF stored and the
# corresponding `iset` and `ipdf`. We will use this to
# input the function to spline. 

iset = itype
ipdf = 1; # component of PDF, -6 to 6

QCDNUM.fvalij(iset, ipdf, 1, 1, 1) # check we get values

# Now that we have run the example program,
# we can load SPLINT, and write `iset` and `ipdf` to
# the user space.

QCDNUM.ssp_spinit(100)
QCDNUM.ssp_uwrite(1, Float64(iset))
QCDNUM.ssp_uwrite(2, Float64(ipdf))

# Make spline object

iasp = QCDNUM.isp_s2make(5, 5)

# Define function to read from QCDNUM into spline

function func(ix, iq, first)::Float64
    
    ix = ix[] # deref ptr
    iq = iq[]

    iset = Int32(QCDNUM.dsp_uread(1))
    ipdf = Int32(QCDNUM.dsp_uread(2))
    
    return QCDNUM.fvalij(iset, ipdf, ix, iq, 1)
end

fun = @cfunction(func, Float64, (Ref{Int32}, Ref{Int32}, Ref{UInt8}))

# Fill the spline and set no kinematic limit
QCDNUM.ssp_s2fill(iasp, fun, 0.0)

# We can use some helper functions to query the spline properties...

QCDNUM.isp_splinetype(iasp)

nu, u1, u2, nv, v1, v2, n = QCDNUM.ssp_splims(iasp)

# ... or copy the nodes locally and print a summary.

xarray = QCDNUM.ssp_unodes(iasp, nu, nu);
qqarray = QCDNUM.ssp_vnodes(iasp, nv, nv);

QCDNUM.ssp_nprint(iasp)

# There are routines to evaluate the function and
# its integral at desired x and qq values/ranges.

x = 0.1
q = 100.0
QCDNUM.dsp_funs2(iasp, x, q, 1)

x1 = 0.01
x2 = 0.1
q1 = 10.0
q2 = 100.0
rs = 370.0
np = 4
QCDNUM.dsp_ints2(iasp, x1, x2, q1, q2, rs, np)

# It is also possible to set user nodes, if the
# automatically chosen ones are not satisfactory.

xarr = Float64.([1e-2, 5e-2, 1e-1, 0.5])
qarr = Float64.([10, 1e2, 1e3, 5e3])
nx = length(xarr)
nq = length(qarr)

iasp = QCDNUM.isp_s2user(xarr, nx, qarr, nq)

# Let's check the update nodes:

QCDNUM.ssp_nprint(iasp)




