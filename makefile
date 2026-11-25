PLAT   = _pdsyev_intel
FOR    = mpiifort
FFLAGS = -O3 -ipo -no-prec-div -fp-model fast=2 -xHost

SCALAPACK = -lmkl_scalapack_lp64 -lmkl_blacs_sgimpt_lp64 -mkl=sequential -lmpi

#LIB    =  $(SCALAPACK)
#LIB    =  -lmkl_scalapack_ilp64 -lmkl_intel_ilp64 -lmkl_sequential -lmkl_core -lmkl_blacs_openmpi_lp64 -lpthread -lm

LIB = -lmkl_scalapack_lp64 -lmkl_blacs_intelmpi_lp64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm

#LIB = -lmkl_scalapack_lp64 -lmkl_intel_lp64 -lmkl_blacs_openmpi_lp64 -lmkl_sequential -lmkl_core -lpthread

OBJ = accuracy.o timer.o input.o pdlaprnt_local.o

default:   diag$(PLAT).x

diag$(PLAT).x:  $(OBJ) diag_pdsyev_write_vec_parallel_v3.o
	$(FOR) $(FFLAGS) -o diag$(PLAT).x $(OBJ) diag_pdsyev_write_vec_parallel_v3.o $(LIB)

diag_pdsyev_write_vec_parallel_v3.o:  diag_pdsyev_write_vec_parallel_v3.f90 $(OBJ) 
	$(FOR) -c diag_pdsyev_write_vec_parallel_v3.f90 $(FFLAGS)

pdlaprnt_local.o: pdlaprnt_local.f
	$(FOR) -c pdlaprnt_local.f $(FFLAGS)

accuracy.o:  accuracy.f90
	$(FOR) -c accuracy.f90 $(FFLAGS)

timer.o:  timer.f90 accuracy.o
	$(FOR) -c timer.f90 $(FFLAGS)

input.o:  input.f90 accuracy.o
	$(FOR) -c input.f90 $(FFLAGS)

clean:
	rm $(OBJ) *.mod diag_pdsyev.o *.x

