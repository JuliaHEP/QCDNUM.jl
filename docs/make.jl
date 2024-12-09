using Documenter
using QCDNUM
using Literate

# Doctest setup
DocMeta.setdocmeta!(
    QCDNUM,
    :DocTestSetup,
    :(using QCDNUM);
    recursive=true,
)

# Generate examples notebooks
gen_content_dir = joinpath(@__DIR__, "src")

quickstart_src = joinpath(@__DIR__, "..", "examples", "quickstart.jl")
example_src = joinpath(@__DIR__, "..", "examples", "example.jl")
testsgns_src = joinpath(@__DIR__, "..", "examples", "testsgns.jl")
timing_src = joinpath(@__DIR__, "..", "examples", "timing.jl")
splint_src = joinpath(@__DIR__, "..", "examples", "splint.jl")
     
Literate.markdown(quickstart_src, gen_content_dir, name="quickstart")
Literate.markdown(example_src, gen_content_dir, name="example")
Literate.markdown(testsgns_src, gen_content_dir, name="testsgns")
Literate.markdown(timing_src, gen_content_dir, name="timing")
Literate.markdown(splint_src, gen_content_dir, name="splint")

Examples1 =  ["example.md", "testsgns.md", "timing.md"]
Examples2 = ["splint.md"]

makedocs(
    sitename="QCDNUM.jl",
    modules=[QCDNUM],
    pages = [
        "Introduction" => "index.md",
        "Installation" => "installation.md",
        "Notebook tutorial" => "notebook.md",
        "Quick start" => "quickstart.md",
        "QCDNUM example jobs" => Examples1,
        "Further examples" => Examples2,
        "Available functions" => "functions.md",
   ],
    doctest = ("fixdoctests" in ARGS) ? :fix : true,
    linkcheck = false, # Nikhef QCDNUM web links may be down
    warnonly = ("nonstrict" in ARGS),
)

deploydocs(
    repo = "github.com/cescalara/QCDNUM.jl.git",
    forcepush = true,
    push_preview = true,
)
