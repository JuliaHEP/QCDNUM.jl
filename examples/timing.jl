# # Timing evolution and structure function evaluation

# Based on the `timing.f` test job.

using QCDNUM
using Printf

# Again, we start by defining the necessary inputs...

xmin = Float64.([1e-5, 0.2, 0.4, 0.6, 0.75])
iwt = Int32.([1, 2, 4, 8, 16])
ngx = 5
nxin = 100
iosp = 3
nx = 0
qlim = Float64.([2e0, 1e4])
wt = Float64.([1e0, 1e0])
ngq = 2
nqin = 50
nq = 1
itype = 1
filename = "weights/unpolarised.wgt"
iord = 3
as0 = 0.364
r20 = 2.0
q2c = 3.0
q2b = 25.0
q0 = 2.0
nfin = 0
iqt = 999;

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

proton = Float64.([4.,1.,4.,1.,4.,1.,0.,1.,4.,1.,4.,1.,4.])/9.0;
xx = Array{Float64}(undef, 1000)
q2 = Array{Float64}(undef, 1000)

roots = 300
shera = roots*roots
xlog1 = log(xmin[1])
xlog2 = log(0.99)
qlog1 = log(qlim[1])
qlog2 = log(qlim[ngq])
ntot = 1
while (ntot < 1001)
    rval = rand()
    xlog = xlog1 + rval*(xlog2-xlog1)
    xxxx = exp(xlog)
    rval = rand()
    qlog = qlog1 + rval*(qlog2-qlog1)
    qqqq = exp(qlog)
    if (qqqq <= xxxx*shera)
        xx[ntot] = xxxx
        q2[ntot] = qqqq
        global ntot += 1
    end
end

# Now, we set up QCDNUM and time many evolution and
# structure function evaluations.

QCDNUM.qcinit(-6, " ")
nx = QCDNUM.gxmake(xmin, iwt, ngx, nxin, iosp)
nq = QCDNUM.gqmake(qlim, wt, ngq, nqin)
nw = QCDNUM.fillwt(1)
nw = QCDNUM.zmfillw()
QCDNUM.setord(iord)
QCDNUM.setalf(as0, r20)
iqc = QCDNUM.iqfrmq(q2c)
iqb = QCDNUM.iqfrmq(q2b)
QCDNUM.setcbt(nfin, iqc, iqb, iqt)
iq0 = QCDNUM.iqfrmq(q0)

@printf(" Wait: 1000 evols and 2.10^6 stfs will take ... ")
@time begin
    for iter in 1:1000
        eps = QCDNUM.evolfg(itype, wrapped_func, def, iq0)
        ff = QCDNUM.zmstfun(1, proton, xx, q2, 1000, 1)
        ff = QCDNUM.zmstfun(2, proton, xx, q2, 1000, 1)
    end
end
