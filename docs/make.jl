using Documenter

include("pages.jl")

makedocs(
  sitename="HydraulicComponents",
  warnonly=[:cross_references, :example_block],
  pages=pages)

if get(ENV, "CI", nothing) == "true"
  deploydocs(;
    repo="github.com/JuliaComputing/HydraulicComponents",
    branch="jhub-pages",
    push_preview=true
  )
end
