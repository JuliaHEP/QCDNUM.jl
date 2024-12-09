"""
    fillwt(itype)

Fill weight tables for all order and number of flavours.
`itype` is used to select un-polarised pdfs (1), polarised 
pdfs (2) or fragmentation functions (3).

# Returns
- `nwds::Integer`: number of words used in memory.
"""
function fillwt(itype::Integer)

    itype = Ref{Int32}(itype)
    nwds = Ref{Int32}()

    # For now-obsolete integer id vars
    idnum1 = Ref{Int32}()
    idnum2 = Ref{Int32}()
    
    @qlccall fillwt_(itype::Ref{Int32}, idnum1::Ref{Int32},
                   idnum2::Ref{Int32}, nwds::Ref{Int32})::Nothing
    
    nwds[]
end

"""
    dmpwgt(itype, lun, filename)

Dump weight tables of a given `itype` to `filename`.
"""
function dmpwgt(itype::Integer, lun::Integer, filename::String)

    itype = Ref{Int32}(itype)
    lun = Ref{Int32}(lun)
    
    @qlccall dmpwgt_(itype::Ref{Int32}, lun::Ref{Int32}, filename::Ptr{UInt8},
                   sizeof(filename)::Csize_t)::Nothing
    
    nothing
end

"""
    readwt(lun, filename)

Read weight tables from filename.
"""
function readwt(lun::Integer, filename::String)

    lun = Ref{Int32}(lun)
    ierr = Ref{Int32}()
    nwds = Ref{Int32}()

    # For now, obsolete integer id vars
    idnum1 = Ref{Int32}()
    idnum2 = Ref{Int32}()
    
    @qlccall readwt_(lun::Ref{Int32}, filename::Ptr{UInt8}, idnum1::Ref{Int32},
                   idnum2::Ref{Int32}, nwds::Ref{Int32}, ierr::Ref{Int32},
                   sizeof(filename)::Csize_t)::Nothing
    
    nwds[], ierr[]  
end

"""
    wtfile(itype, filename)

Maintains an up-to-date weight table in filename.
"""
function wtfile(itype::Integer, filename::String)

    itype = Ref{Int32}(itype)

    @qlccall wtfile_(itype::Ref{Int32}, filename::Ptr{UInt8},
                   sizeof(filename)::Csize_t)::Nothing
    
    nothing
end

"""
    nwused()

Returns the szie `nwtot` of the QCDNUM store (the parameter nwf0
in qcdnum.inc) and the number of words used, `nwuse`.

The output argument `ndummy` is not used at present.
"""
function nwused()

    nwtot = Ref{Int32}()
    nwuse = Ref{Int32}()

    ndummy = Ref{Int32}()
    
    @qlccall nwused_(nwtot::Ref{Int32}, nwuse::Ref{Int32},
                   ndummy::Ref{Int32})::Nothing

    nwtot[], nwuse[]
end
