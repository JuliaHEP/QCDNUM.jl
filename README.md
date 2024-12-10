# QCDNUM.jl

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://francescacapel.com/QCDNUM.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://francescacapel.com/QCDNUM.jl/dev/) 
![CI](https://github.com/JuliaHEP/QCDNUM.jl/actions/workflows/Tests.yml/badge.svg)
[![codecov](https://codecov.io/gh/JuliaHEP/QCDNUM.jl/branch/main/graph/badge.svg?token=S6Y4SMO34D)](https://codecov.io/gh/JuliaHEP/QCDNUM.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Fast QCD evolution and convolution.

QCDNUM.jl is a Julia wrapper for Michiel Botje's [QCDNUM](https://www.nikhef.nl/~h24/qcdnum/), written in Fortran77. 
QCDNUM.jl is currently under development and more functionality and documentation will be added soon. 

Please check out the [documentation](https://francescacapel.com/QCDNUM.jl/) for more information.

## Quick start

To install QCDNUM.jl, start Julia and run

```julia
julia> using Pkg
julia> pkg"add QCDNUM"
```
