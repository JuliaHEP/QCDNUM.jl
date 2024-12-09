# This file is a part of QCDNUM.jl, licensed under the MIT License (MIT).

import Test
import Aqua
import QCDNUM

Test.@testset "Package ambiguities" begin
    Test.@test isempty(Test.detect_ambiguities(QCDNUM))
end # testset

Test.@testset "Aqua tests" begin
    Aqua.test_all(
        QCDNUM,
        ambiguities = true
    )
end # testset
