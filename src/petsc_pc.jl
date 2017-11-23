export PC, PCCreate, PCSetFromOptions, KSPGetPC, KSPSetPC, PCSetType, PCGetType, PCFactorSetUseInPlace, PCFactorGetUseInPlace, PCSetReusePreconditioner, PCGetReusePreconditioner, PCFactorSetAllowDiagonalFill, PCFactorGetAllowDiagonalFill, PCFactorSetLevels, PCFactorGetLevels, PCSetReusePreconditioner, PCGetReusePreconditioner, PCBJacobiGetSubKSP, PCFactorSetFill, PCJacobiSetType, PCJacobiGetType

# Shell PC
export PCShellSetApply, PCShellSetApplyTranspose, PCShellSetSetUp,
       PCShellSetContext, PCShellGetContext

# developer PC interface
export PCApply, PCSetUp, PCApplyTranspose, PCApplyTransposeExists

# preconditioner contex
# the KSP object creates the PC contex, so we don't provide a constructor
type PC
  pobj::Ptr{Void}
end

global const PC_NULL = PC(C_NULL)

function PCCreate(comm::MPI.Comm)
  arg2 = Ref{Ptr{Void}}() 
  ccall((:PCCreate,petsc),PetscErrorCode,(comm_type,Ptr{Ptr{Void}}),comm,arg2)

  return PC(arg2[])
end

function PetscDestroy(arg1::PC)
  if arg1.pobj != C_NULL
    ccall((:PCDestroy,petsc),PetscErrorCode,(Ptr{Ptr{Void}},),&arg1.pobj)
  end
end


function PCSetFromOptions(arg1::PC)
    ccall((:PCSetFromOptions,petsc),PetscErrorCode,(Ptr{Void},),arg1.pobj)
end


function KSPGetPC(ksp::KSP)
    arr = Array(Ptr{Void}, 1)
    ccall((:KSPGetPC,petsc),PetscErrorCode,(Ptr{Void},Ptr{Void}),ksp.pobj, arr)
    return PC(arr[1])
end

function KSPSetPC(ksp::KSP, pc::PC)
    ccall((:KSPSetPC,petsc),PetscErrorCode,(Ptr{Void},Ptr{Void}),ksp.pobj, pc.pobj)
    return nothing
end


function PCSetType(pc::PC, pctype::PCType)
    ccall((:PCSetType,petsc),PetscErrorCode,(Ptr{Void},Cstring), pc.pobj, pctype)
end

function PCGetType(pc::PC)
    arr = Array(Ptr{UInt8}, 1)
    ccall((:PCGetType,petsc),PetscErrorCode,(Ptr{Void},Ptr{Ptr{UInt8}}), pc.pobj, arr)
    return bytestring(arr[1])
end

function PCShellSetApply(arg1::PC,arg2::Ptr{Void})
    ccall((:PCShellSetApply,petsc),PetscErrorCode,(Ptr{Void},Ptr{Void}),arg1.pobj,arg2)
end

function PCShellSetApplyTranspose(arg1::PC,arg2::Ptr{Void})
    ccall((:PCShellSetApplyTranspose,petsc),PetscErrorCode,(Ptr{Void},Ptr{Void}),arg1.pobj,arg2)
end


function PCShellSetSetUp(arg1::PC,arg2::Ptr{Void})
    ccall((:PCShellSetSetUp,petsc),PetscErrorCode,(Ptr{Void},Ptr{Void}),arg1.pobj,arg2)
end

function PCShellSetContext(arg1::PC,arg2::Ptr{Void})
    ccall((:PCShellSetContext,petsc),PetscErrorCode,(Ptr{Void},Ptr{Void}),arg1.pobj,arg2)
end

function PCShellGetContext(arg1::PC)
    arg2 = Ref{Ptr{Void}}()
    ccall((:PCShellGetContext,petsc),PetscErrorCode,(Ptr{Void},Ref{Ptr{Void}}),arg1.pobj,arg2)

    return arg2[]
end





function PCFactorSetUseInPlace(pc::PC, arg2::PetscBool)
    ccall((:PCFactorSetUseInPlace,petsc),PetscErrorCode,(Ptr{Void},PetscBool),pc.pobj, arg2)
end

function PCFactorGetUseInPlace(pc::PC)
    arr = Array(PetscBool, 1)
    ccall((:PCFactorGetUseInPlace,petsc),PetscErrorCode,(Ptr{Void},Ptr{PetscBool}), pc.pobj, arr)
    return arr[1]
end


function PCSetReusePreconditioner(pc::PC,arg2::PetscBool)
    ccall((:PCSetReusePreconditioner,petsc),PetscErrorCode,(Ptr{Void},PetscBool), pc.pobj, arg2)
end


function PCGetReusePreconditioner(pc::PC)
    arr = Array(PetscBool, 1)
    ccall((:PCGetReusePreconditioner,petsc),PetscErrorCode,(Ptr{Void}, Ptr{PetscBool}), pc.pobj, arr)
    return arr[1]
end

function PCFactorSetAllowDiagonalFill(pc::PC,arg2::PetscBool)
    ccall((:PCFactorSetAllowDiagonalFill,petsc),PetscErrorCode,(Ptr{Void},PetscBool), pc.pobj, arg2)
end

function PCFactorGetAllowDiagonalFill(pc::PC)
   arr = Array(PetscBool, 1)
    ccall((:PCFactorGetAllowDiagonalFill,petsc),PetscErrorCode,(Ptr{Void},Ptr{PetscBool}), pc.pobj, arr)
    return arr[1]
end

function PCFactorSetLevels(pc::PC,arg2::PetscInt)
    ccall((:PCFactorSetLevels,petsc),PetscErrorCode,(Ptr{Void}, PetscInt), pc.pobj, arg2)
end

function PCFactorGetLevels(pc::PC)
    arr = Array(PetscInt, 1)
    ccall((:PCFactorGetLevels,petsc),PetscErrorCode,(Ptr{Void},Ptr{PetscInt}),pc.pobj, arr)
    return arr[1]
end


function PCSetReusePreconditioner(pc::PC, arg2::PetscBool)
    ccall((:PCSetReusePreconditioner,petsc),PetscErrorCode,(Ptr{Void}, PetscBool), pc.pobj, arg2)
end

function PCGetReusePreconditioner(pc::PC)
    arr = Array(PetscBool, 1)
    ccall((:PCGetReusePreconditioner,petsc),PetscErrorCode,(Ptr{Void},Ptr{PetscBool}), pc.pobj, arr)
    return arr[1]
end

function PCBJacobiGetSubKSP(pc::PC)
    n_local_arr = Array(PetscInt, 1)
    first_local = Array(PetscInt, 1)
    ksp_ptrarr = Array(Ptr{Ptr{Void}}, 1)
    ccall((:PCBJacobiGetSubKSP,petsc),PetscErrorCode,(Ptr{Void},Ptr{PetscInt},Ptr{PetscInt},Ptr{Ptr{Ptr{Void}}}), pc.pobj, n_local_arr, first_local, ksp_ptrarr)

    n_local = n_local_arr[1]
    ksp_ptrarr2 = pointer_to_array(ksp_ptrarr[1], n_local)

    ksp_arr = Array(KSP, n_local)
    for i=1:n_local
      ksp_arr[i] = KSP(ksp_ptrarr2[i])
    end

    return n_local, first_local[1], ksp_arr
end

function PCFactorSetFill(pc::PC, fill::PetscReal)
    ccall((:PCFactorSetFill,petsc),PetscErrorCode,(Ptr{Void}, PetscReal), pc.pobj, fill)
end

function PCJacobiSetType(pc::PC, jacobitype::PCJacobiType)
    ccall((:PCJacobiSetType,petsc),PetscErrorCode,(Ptr{Void}, PCJacobiType), pc.pobj, jacobitype)
end

function PCJacobiGetType(pc::PC)
    arr = Array(PCJacobiType, 1)
    ccall((:PCJacobiGetType,petsc),PetscErrorCode,(Ptr{Void},Ptr{PCJacobiType}),pc.pobj, arr)
    return arr[1]
end

function PCApply(arg1::PC,arg2::PetscVec,arg3::PetscVec)
  println("pc.pobj = ", arg1.pobj)
    ccall((:PCApply,petsc),PetscErrorCode,(Ptr{Void},Ptr{Void},Ptr{Void}),arg1.pobj ,arg2.pobj, arg3.pobj)
end

function PCApplyTranspose(arg1::PC,arg2::PetscVec,arg3::PetscVec)
    ccall((:PCApplyTranspose,petsc),PetscErrorCode,(Ptr{Void},Ptr{Void},Ptr{Void}),arg1.pobj ,arg2.pobj, arg3.pobj)
end

function PCApplyTransposeExists(arg1::PC)
    arg2 = Ref{PetscBool}()
    ccall((:PCApplyTransposeExists,petsc),PetscErrorCode,(PC,Ptr{PetscBool}),arg1,arg2)

    return arg2[] == 1
end

function PCSetUp(arg1::PC)
    ccall((:PCSetUp,petsc),PetscErrorCode,(Ptr{Void},),arg1.pobj)
end


