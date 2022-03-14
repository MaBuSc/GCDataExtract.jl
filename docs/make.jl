using Documenter
using GCDataExtract

makedocs(
    sitename = "GCDataExtract",
    format = Documenter.HTML(),
    modules = [GCDataExtract]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
