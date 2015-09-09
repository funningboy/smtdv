#!/bin/sh
# 
# ies_multistep_non_irun_e_load - 
#     invoke IES in multi-step mode using the basic ncvlog, ncelab, ncsim commands (rather than using irun)
#     with loading of the e verification environment (rather than compiling)

# preparation needed: 
SPECMAN_DLIB=${UVM_ML_HOME}/ml/libs/uvm_e/14.1/4.4/libsn_sn_uvm_ml.so; export SPECMAN_DLIB
SPECMAN_PATH=${UVM_ML_HOME}/ml/libs/uvm_e/14.1/4.4; export SPECMAN_PATH

echo -e "\n------------------------ # Step 1: Write the Specman Stub file(s) ------------------------------\n"
specman -c 'load ./top.e; write stub -ncsv my_ml_nc_stubs.sv'

echo -e "\n------------------------ # Step 2: Compile SystemVerilog files ---------------------------------\n" 
ncvlog -sv -messages $UVM_ML_HOME/ml/frameworks/uvm/sv/1.1d-ml/src/uvm_pkg.sv \
    $UVM_ML_HOME/ml/adapters/uvm_sv/uvm_ml_adapter.sv \
    -incdir $UVM_ML_HOME/ml/frameworks/uvm/sv/1.1d-ml/src -incdir $UVM_ML_HOME/ml/adapters/uvm_sv \
    ./svtop.sv ./my_ml_nc_stubs.sv

echo -e "\n------------------------ # Step 3: Elaboration -------------------------------------------------\n" 
ncelab -messages worklib.topmodule worklib.specman worklib.specman_wave
    # in some cases, to access all signals, you may need to add one more flag:    -ACCESS +rw 

echo -e "\n------------------------ # Step 4: Run the simulation ------------------------------------------\n" 
# Note: step 4 Requires env-variables SPECMAN_DLIB and SPECMAN_PATH, set at the top of this file
ncsim -ml_uvm worklib.topmodule -uvmtop SV:svtop -uvmtop e:top.e \
    -sv_lib `ncroot`/tools/uvm/uvm_lib/uvm_sv/lib/libuvmpli.so \
    -sv_lib `ncroot`/tools/uvm/uvm_lib/uvm_sv/lib/libuvmdpi.so \
    -sv_lib ${UVM_ML_HOME}/ml/libs/uvm_sv/4.4/libuvm_sv_ml.so \
    -run -exit -messages 
