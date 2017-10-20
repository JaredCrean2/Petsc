# Interacting with the Petsc Options Database
export PetscOptionsSetValue, PetscOptionsClearValue, PetscOptionsView, PetscSetOptions, PetscClearOptions


typealias PetscViewer Ptr{Void}

function PetscOptionsSetValue(arg1::AbstractString,arg2::AbstractString)
    ccall((:PetscOptionsSetValue,petsc),PetscErrorCode,(Cstring, Cstring),arg1,arg2)
end

function PetscOptionsView(arg1::PetscViewer=C_NULL)
    ccall((:PetscOptionsView,petsc),PetscErrorCode,(PetscViewer,),arg1)
end

function PetscOptionsClearValue(arg1::AbstractString)
    ccall((:PetscOptionsClearValue,petsc),PetscErrorCode,(Cstring,),arg1)
end


"""
  Convenience wrapper for using a dictionary to set options
"""
function PetscSetOptions(opts::Dict)

  for (key, value) in opts
    PetscOptionsSetValue(key, value)
  end

end

function PetscClearOptions(opts::Dict)

  for key in keys(opts)
    PetscOptionsClearValue(key)
  end

end


