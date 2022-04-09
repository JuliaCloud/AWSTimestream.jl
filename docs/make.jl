using Timestream
using Documenter

DocMeta.setdocmeta!(Timestream, :DocTestSetup, :(using Timestream); recursive=true)

makedocs(;
    modules=[Timestream],
    authors="klangner <klangner@gmail.com> and contributors",
    repo="https://github.com/klangner/Timestream.jl/blob/{commit}{path}#{line}",
    sitename="Timestream.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://klangner.github.io/Timestream.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/klangner/Timestream.jl",
    devbranch="main",
)
