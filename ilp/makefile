goal:   diag.x

PLAT = 2710_ilp64_dsyev
FOR  = ifort 


FFLAGS = -O3 -qopenmp -g -traceback -xHost 


##FFLAGS = -O0 -fpe0  -fltconsistency -stand f03 -check all -warn all -traceback -fp-stack-check  # debugging options

LAPACK = -L${MKLROOT}/lib/intel64 -lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -lm -ldl

###LAPACK = -L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -lm -ldl


#LAPACK = -mkl=parallel

#LAPACK = \
# -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_ilp64.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a ${MKLROOT}/lib/intel64/libmkl_core.a -Wl,--end-group -liomp5 -lpthread -lm -ldl

# -L${MKLROOT}/lib/intel64 -lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -lm -ldl

#/usr/local/Cluster-Apps/intel/2018.1/compilers_and_libraries_2018.1.163/linux/mkl/lib/intel64/libmkl_intel_ilp64.a \
#/usr/local/Cluster-Apps/intel/2018.1/compilers_and_libraries_2018.1.163/linux/mkl/lib/intel64/libmkl_intel_thread.a \
#/usr/local/Cluster-Apps/intel/2018.1/compilers_and_libraries_2018.1.163/linux/mkl/lib/intel64/libmkl_core.a -Wl,--end-group 

#-lpthread -lm -offload-option,mic,compiler,"-Wl,--start-group libmkl_intel_lp64.a libmkl_intel_thread.a libmkl_core.a -Wl,--end-group"


#-lmkl_scalapack_lp64 -lmkl_blacs_sgimpt_lp64 -mkl=sequential -lmpi

LIB     =  $(LAPACK)


#diag.x:       diag_dsyev.f90
#	$(FOR) -o j-diag$(PLAT).x $(FFLAGS) diag_dsyev.f90 $(LIB)


diag.x:       diag_dsyevd.f90
	$(FOR) -o j-diag$(PLAT).x $(FFLAGS) diag_dsyevd.f90 $(LIB)


#diag.o:       diag.f90 $(OBJ) 
#	$(FOR) -c diag.f90 $(FFLAGS)

clean:
	rm $(OBJ) *.mod diag.o

