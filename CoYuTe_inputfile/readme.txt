
The NH3 pot file with the BODC from Roman/Sasha is in:
/rds-d2/project/dirac_vol2/rds-dirac-dp060/sergey/TROVE/pot_NH3_Roman.f90


Below are the full paths to all the input files used to construct the CoYuTe line list.

--- everything up to and including the J0-contraction ---
/rds-d2/project/dirac_vol2/rds-dirac-dp060/phil/Darwin/NH3_polyad_testing/p34_2/linelist/nosave-lower/nh3_eigen.inp
/rds-d2/project/dirac_vol2/rds-dirac-dp060/phil/Darwin/NH3_polyad_testing/p34_2/linelist/nosave-lower/nh3_ham_ext_contr.inp
/rds-d2/project/dirac_vol2/rds-dirac-dp060/phil/Darwin/NH3_polyad_testing/p34_2/linelist/nosave-lower/nh3_j0convert.inp
/rds-d2/project/dirac_vol2/rds-dirac-dp060/phil/Darwin/NH3_polyad_testing/p34_2/linelist/nosave-lower/nh3_j0eigen_j0.inp
/rds-d2/project/dirac_vol2/rds-dirac-dp060/phil/Darwin/NH3_polyad_testing/p34_2/linelist/nosave-lower/nh3_matsplit_*_*.inp
/rds-d2/project/dirac_vol2/rds-dirac-dp060/phil/Darwin/NH3_polyad_testing/p34_2/linelist/nosave-lower/nh3_j0matsplit_*_*.inp

--- saving matrices ---
/rds-d2/project/dirac_vol2/rds-dirac-dp060/phil/COSMOS/noJ0ecut/nosave-lower/contr32000/outfiles/nh3_j0eigen_j*_G*_save_32000.inp    (for J=0-10)
/rds-d2/project/dirac_vol2/rds-dirac-dp060/phil/COSMOS/noJ0ecut/nosave-lower/contr32000/nh3_j0eigen_j*_G*_save_32000.inp    (for J=11-45)

--- diagonalising matrices ---
/rds-d2/project/dirac_vol2/rds-dirac-dp060/phil/Darwin/NH3_polyad_testing/p34_2/linelist/nosave-lower/diag/contr32000/diag_inp/NH3_J*_g*.inp

--- reading eigenvecs and energies.chk back into TROVE ---
/rds-d2/project/dirac_vol2/rds-dirac-dp060/phil/Darwin/NH3_polyad_testing/p34_2/linelist/nosave-lower/diag/contr32000/read_inp/nh3_j0eigen_j*_G*_read.inp

--- calculating intensities ---
/rds-d2/project/dirac_vol2/rds-dirac-dp060/phil/linelist/intensities/BYTeDMS/inpE34/nh3_j0ext_j*-*_0-20000_E-34.inp  (although file is named 'E-34', intens truncation was E-36)
