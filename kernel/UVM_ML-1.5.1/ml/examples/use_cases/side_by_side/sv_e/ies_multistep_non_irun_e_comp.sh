#!/bin/sh
# 
# ies_multistep_non_irun_e_comp.sh - 
#     invoke IES in multi-step mode using the basic ncvlog, ncelab, ncsim commands (rather than using irun)
#     with compilation of e verification environment (no e file to load) 

echo -e "\n------ # Step 0: Compile the e verification env. (if you want to maximize e performance) -------\n" 
sn_compile.sh ./top.e -o my_e_top -shlib -exe -32 -t tmp -s ${UVM_ML_HOME}/ml/libs/uvm_e/14.1/4.4/sn_uvm_ml

echo -e "\n------ # Step 1: Write the Specman Stub file(s) (using the executable created in step 0) -------\n"
./my_e_top -c 'write stub -ncsv my_ml_nc_stubs.sv'
# point SPECMAN-DLIB to the share object created just now, needed for step 3
SPECMAN_DLIB=./libsn_my_e_top.so; export SPECMAN_DLIB

echo -e "\n------------------------ # Step 2: Compile SystemVerilog files ---------------------------------\n" 
ncvlog -sv -messages $UVM_ML_HOME/ml/frameworks/uvm/sv/1.1d-ml/src/uvm_pkg.sv \
    $UVM_ML_HOME/ml/adapters/uvm_sv/uvm_ml_adapter.sv \
    -incdir $UVM_ML_HOME/ml/frameworks/uvm/sv/1.1d-ml/src -incdir $UVM_ML_HOME/ml/adapters/uvm_sv \
    ./svtop.sv ./my_ml_nc_stubs.sv

echo -e "\n------------------------ # Step 3: Elaboration -------------------------------------------------\n" 
ncelab -messages worklib.topmodule worklib.specman worklib.specman_wave 
    # in some cases, to access all signals, you may need to add one more flag:    -ACCESS +rw 

echo -e "\n------------------------ # Step 4: Run the simulation ------------------------------------------\n" 
# Note: step 4 Requires env-variables SPECMAN_DLIB, as set after step 1. 
#       SPECMAN_PATH need not be set if specman product files are created locally (in ./ )
ncsim -ml_uvm worklib.topmodule -uvmtop SV:svtop \
    -sv_lib `ncroot`/tools/uvm/uvm_lib/uvm_sv/lib/libuvmpli.so \
    -sv_lib `ncroot`/tools/uvm/uvm_lib/uvm_sv/lib/libuvmdpi.so \
    -sv_lib ${UVM_ML_HOME}/ml/libs/uvm_sv/4.4/libuvm_sv_ml.so \
    -run -exit -messages
