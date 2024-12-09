# This file is a part of QCDNUM.jl, licensed under the MIT License (MIT).

using Test
using QCDNUM
import Documenter

Documenter.DocMeta.setdocmeta!(
    QCDNUM,
    :DocTestSetup,
    :(using QCDNUM);
    recursive=true,
)
Documenter.doctest(QCDNUM)
