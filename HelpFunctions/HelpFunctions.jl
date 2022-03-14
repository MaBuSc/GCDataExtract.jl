module HelpFunctions
using DelimitedFiles, DataFrames, Dates

function Make_arr_from_file(source::String)
	accTime = split(source,"~")[end][1:end-4]
	io = open(replace_comma_with_dot, source)
	temp = vcat("AccTime", fill(accTime, (size(io)[1]-1, 1)))
	io = hcat(temp, io[:,2:end])
	return [io[1:1,1:4]; io[3:end-2,1:4]]
end
function replace_comma_with_dot(f::IOStream)
    return replace.(readdlm(f, '\t', String, '\n'), ","=>".")
end
function get_df(folder::String)
	
	filenames = filter(t -> endswith.(t, ".TXT") || endswith.(t, ".txt"), readdir(folder))
	filePaths = folder * "/" .* filenames

	arr_arr = [Make_arr_from_file(f)  for f ∈ filePaths]
	
	acc_time = unique([split(f,"~")[end][1:end-4] for f ∈ filenames])
    
	df_arr = Array{Union{Missing, DataFrame}}(missing, length(acc_time))
	for i ∈ 1:length(acc_time)
		temp_arr = arr_arr[1][1:1,:]
		for arr ∈ arr_arr
			if arr[2,1] == acc_time[i]
				temp_arr = [temp_arr; arr[2:end,:]]
			end
		end
		df_arr[i] = DataFrame(temp_arr[2:end,:], temp_arr[1,:])
		for c ∈ [:Time, :Quantity]
			df_arr[i][!,c] = parse.(Float64,df_arr[i][:,c])
		end
	end

	components = unique([n for d ∈ df_arr for n ∈ d.Name])
	final_df = DataFrame()
	final_df[!, :AccTime] = [String(at[1,1]) for at ∈ df_arr]
	for c in components
        final_df[!, Symbol(c)] .= 0.0
    end
	
	for i ∈ eachindex(df_arr)
		for c ∈ components
			rowidx = findall((df_arr[i].Name .== c))
			if length(rowidx) == 1
        		final_df[!, Symbol(c)][i] = df_arr[i][!, :Quantity][rowidx[1]]
			end
		end
    end
	sort!(final_df, :AccTime)
	final_df.AccTime .= replace.(final_df.AccTime, "_"=>":")
	transform!(final_df, :AccTime => (t -> DateTime.(t, "yyyy-mm-dd HH:MM:SS")) => :AccTime)
	return final_df
end

end # module