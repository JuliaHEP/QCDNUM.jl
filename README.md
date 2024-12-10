# QCDNUM.jl

[![Documentation for stable version](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaHEP.github.io/QCDNUM.jl/stable)
[![Documentation for development version](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaHEP.github.io/QCDNUM.jl/dev)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md)
[![Build Status](https://github.com/JuliaHEP/QCDNUM.jl/workflows/CI/badge.svg)](https://github.com/JuliaHEP/QCDNUM.jl/actions/workflows/CI.yml)
[![Codecov](https://codecov.io/gh/JuliaHEP/QCDNUM.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaHEP/QCDNUM.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

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
