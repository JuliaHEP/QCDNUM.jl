# Introduction

Fast QCD evolution and convolution: QCDNUM.jl solves the [DGLAP evolution equations](https://en.wikipedia.org/wiki/DGLAP_evolution_equations), which describe the evolution of parton distribution functions with varying energy scales. 

Hadrons, such as protons and neutrons, are made up of quarks held together by the strong force. At high energy scales, the valence quarks that define these hadrons exist in a sea of virtual quarks and gluons. The parton distribution functions (often abbreviated to PDFs) describe this structure and are of fundamental importance to our understanding of quantum chromodynamics (QCD), as well as its application to a range of processes, from LHC physics to the development of cosmic ray air showers in the Earth's atmosphere. PDFs can be extracted from accelerator measurements in which hadrons are probed through collisions with electrons, and the DGLAP equations are widely used for this purpose.

QCDNUM.jl is a Julia wrapper for Michiel Botje's [QCDNUM](https://www.nikhef.nl/~h24/qcdnum/), written in Fortran77. The Julia interface offers several interesting advantages:
* Easily install and use the original QCDNUM without having to compile it on your system - all set up is taken care of behind the scenes in a cross-platform way thanks to [BinaryBuilder](https://binarybuilder.org) and [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil)
* Interface your QCDNUM-based code with Julia's rich functionality and package ecosystem 
* Work interactively with easy file IO, plotting and debugging in e.g. [Jupyter](https://jupyter.org) notebooks
* Write more accessible code with the high-level Julia interface provided, in addition to all functions available in QCDNUM

**Have you not used QCDNUM before, but are interested to see what QCDNUM.jl can do?** Our high-level Julia interface may be more accessible for you. Check out the **quick start example** where we demonstrate the main functionality.

**Are you a long-time user of QCDNUM in Fortran or C++?** All the standard QCDNUM functions have corresponding Julia versions. So, translating your old code or starting a new project should be a quick and intuitive! Check out the **QCDNUM example jobs**. These are Julia versions of the test jobs of the original QCDNUM. 

The source code, along with Julia scripts for all examples can be found in the [GitHub repository](https://github.com/JuliaHEP/QCDNUM.jl).

This documentation gives an overview of the Julia implementation. More details can be found in the [QCDNUM docs](https://www.nikhef.nl/~h24/qcdnum/).

If you are interested in extracting parton densities from accelerator data, you may also want to check out our [PartonDensity.jl](https://github.com/cescalara/PartonDensity.jl) project.

## Citation

Original QCDNUM software: M. Botje, Comput. Phys. Commun. 182(2011)490, [arXiv:1005.1481](https://arxiv.org/abs/1005.1481). 

QCDNUM.jl: Coming soon!

