# This file is a part of QCDNUM.jl, licensed under the MIT License (MIT).

module QCDNUMHDF5Ext

using QCDNUM
using QCDNUM: GridParams, EvolutionParams, SplineAddresses, SPLINTParams

import HDF5


QCDNUM._io_type(::Val{:hdf5}) = HDF5.File

function QCDNUM.save_params(::Type{HDF5.File}, file_name::String, params::Union{EvolutionParams,SPLINTParams})
    # Append if file already exists
    local open_mode
    if isfile(file_name)
        open_mode = "r+"
    else
        open_mode = "w"
    end

    HDF5.h5open(file_name, open_mode) do trg
        QCDNUM.save_params(trg, params)
    end
end

function QCDNUM.save_params(trg::HDF5.H5DataStore, params::Union{EvolutionParams,SPLINTParams})
    param_group = HDF5.create_group(trg, params.label)

    for name in fieldnames(typeof(params))
        sub_thing = getfield(params, name)

        if length(fieldnames(typeof(sub_thing))) > 0
            sub_group = HDF5.create_group(param_group, String(name))
            for sub_name in fieldnames(typeof(sub_thing))
                sub_group[String(sub_name)] = getfield(sub_thing, sub_name)
            end
        else
            param_group[String(name)] = sub_thing
        end
    end

    return nothing
end


function QCDNUM.load_params(::Type{HDF5.File}, file_name::String)
    HDF5.h5open(file_name, "r") do src
        QCDNUM.load_params(src)
    end
end

function QCDNUM.load_params(src::HDF5.H5DataStore)
    local params_dict = Dict{String,Any}()
    local params

    # Check what is in here
    for key in keys(src)
        if key == "evolution_params"

            # Rebuild grid
            g = src["evolution_params/grid_params"]

            grid_params = GridParams(x_min=read(g["x_min"]), x_weights=read(g["x_weights"]),
                x_num_bounds=read(g["x_num_bounds"]), nx=read(g["nx"]),
                qq_bounds=read(g["qq_bounds"]), qq_weights=read(g["qq_weights"]),
                qq_num_bounds=read(g["qq_num_bounds"]), nq=read(g["nq"]),
                spline_interp=read(g["spline_interp"]))

            # Rebuild evolution params
            g = src["evolution_params"]
            params = EvolutionParams(order=read(g["order"]), α_S=read(g["α_S"]),
                q0=read(g["q0"]), grid_params=grid_params,
                n_fixed_flav=read(g["n_fixed_flav"]),
                iqc=read(g["iqc"]), iqb=read(g["iqb"]),
                iqt=read(g["iqt"]), weight_type=read(g["weight_type"]),
                output_pdf_loc=read(g["output_pdf_loc"]))

        elseif key == "splint_params"

            # Rebuild spline addresses
            g = src["splint_params/spline_addresses"]
            spline_addresses = SplineAddresses(F2up=read(g["F2up"]), F2dn=read(g["F2dn"]),
                F3up=read(g["F3up"]), F3dn=read(g["F3dn"]),
                FLup=read(g["FLup"]), FLdn=read(g["FLdn"]),
                F_eP=read(g["F_eP"]), F_eM=read(g["F_eM"]))

            # Rebuild splint_params
            g = src["splint_params"]
            params = SPLINTParams(nuser=read(g["nuser"]), nsteps_x=read(g["nsteps_x"]),
                nsteps_q=read(g["nsteps_q"]), nnodes_x=read(g["nnodes_x"]),
                nnodes_q=read(g["nnodes_q"]), rs=read(g["rs"]), rscut=read(g["rscut"]),
                spline_addresses=spline_addresses)

        else

            @error "Contents of file not recognised."

        end

        params_dict[key] = params

    end

    return params_dict

end


end # module QCDNUMHDF5Ext
