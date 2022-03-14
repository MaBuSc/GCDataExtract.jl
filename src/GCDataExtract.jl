module GCDataExtract
using XLSX
#"C:/Users/manfr/OneDrive/Skrivbord/RGA-data/F057-058"
function make_xlsx(folder::String)
    df = HelpFunctions.get_df(folder)
    typeof(df[!, :AccTime])
    resultfile = folder * "/results.xlsx"
    if isfile(resultfile)
        rm(resultfile)
        XLSX.writetable(resultfile, df)
    else
        XLSX.writetable(resultfile, df)
    end
    #CSV.write(folder * "/results.csv", df; delim = "\t")
    #@__DIR__ refererar till mappen med script
    #pkg.activate
    #pkg.incanciate

end # module

end