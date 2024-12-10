# Installation

To use the QCDNUM.jl Julia interface to QCDNUM, you simply need to install QCDNUM.jl as described below. The compilation and linking of the original Fortran code is handled by [BinaryBuilder](https://github.com/JuliaPackaging/BinaryBuilder.jl) and [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil).

The QCDNUM Julia wrapper can be installed either from the GitHub repository via using Julia's package manager (best if you just want to use the code) or cloned from GitHub and installed from a local directory (best if you want to develop and contribute to the source code).

## Simple installation

In the Julia REPL:

```
using Pkg
pkg"add QCDNUM"
```

## Development installation 

- Clone the github repository, e.g. via the command line:
```
git clone  https://github.com/JuliaHEP/QCDNUM.jl.git
```

- Enter the directory and start Julia interpreter
```
cd QCDNUM.jl
julia
```

-  Open the Julia package management environment pressing ``]``.

```
julia> ]
```

 - Execute 
```
pkg> generate QCDNUM
...... 
pkg>  dev .
```
 - Exit the package manager using backspace or pressing `Ctrl+C`

## Checking the installation

In both cases the QCDNUM package will be available via `using QCDNUM`.
To show the available functions, execute:
```@repl
using QCDNUM

names(QCDNUM, all=true)
```

## Package removal

To remove package execute

```
julia> using Pkg
```
followed by 

```
julia> Pkg.rm("QCDNUM")
```
