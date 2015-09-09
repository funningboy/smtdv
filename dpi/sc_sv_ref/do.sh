#!/bin/sh
# Dry-run output: the command(s) used to run this test are echoed below:
# (Note: you can run these commands 'as is' in Bourne-Shell; for more information, run 'demo.sh -help')

# set_variables_command :
UVM_HOME=${UVM_ML_HOME}/ml/frameworks/uvm/sv/1.1d-ml; export UVM_HOME

# dpi_compile_command :
${UVM_ML_LD} -m64 -fPIC -g -fPIC -I/stec/apps/mentor/questa_sim_10.4c/questasim/include -shared -DQUESTA -o /stec/tw/users/schen/prj/smartdv/kernel/UVM_ML-1.5.1/ml/examples/use_cases/side_by_side/sc_sv/libuvm_dpi.64.so ${UVM_ML_HOME}/ml/frameworks/uvm/sv/1.1d-ml/src/dpi/uvm_dpi.cc

# questa_library_preparation_command :
vlib /stec/tw/users/schen/prj/smartdv/kernel/UVM_ML-1.5.1/ml/examples/use_cases/side_by_side/sc_sv/work

# questa_compile_command :
vlog -dpicppinstall /stec/tw/users/schen/local/bin/g++ -64 -suppress 2218,2181  +define+USE_UVM_ML_RUN_TEST +incdir+${UVM_ML_HOME}/ml/frameworks/uvm/sv/1.1d-ml/src +incdir+${UVM_ML_HOME}/ml/frameworks/uvm/sv/1.1d-ml +incdir+${UVM_ML_HOME}/ml/frameworks/uvm/sv/1.1d-ml/tlm2 +incdir+${UVM_ML_HOME}/ml/frameworks/uvm/sv/1.1d-ml/base +incdir+. +incdir+${UVM_ML_HOME}/ml/frameworks/uvm/sv/1.1d-ml/macros +incdir+${UVM_ML_HOME}/ml/adapters/uvm_sv -sv +acc -l questa_comp.64.log -timescale 1ns/1ns  ${UVM_ML_HOME}/ml/frameworks/uvm/sv/1.1d-ml/src/uvm.sv ${UVM_ML_HOME}/ml/adapters/uvm_sv/uvm_ml_adapter.sv ./test.sv 

# osci_compile_command :
${UVM_ML_LD} -g -fPIC -o /stec/tw/users/schen/prj/smartdv/kernel/UVM_ML-1.5.1/ml/examples/use_cases/side_by_side/sc_sv/liball_osci_questa.64.so ./sc.cpp -m64 -fPIC   -Xlinker -rpath -Xlinker ${UVM_ML_HOME}/ml/libs/osci/2.3/4.4//64bit -Xlinker -Bsymbolic -L${UVM_ML_HOME}/ml/libs/osci/2.3/4.4//64bit -luvm_sc_fw_osci -luvm_sc_ml_osci -shared -I${OSCI_INSTALL}/include  -I${UVM_ML_HOME}/ml/adapters/uvm_sc/  -I${UVM_ML_HOME}/ml/adapters/uvm_sc/osci -I${UVM_ML_HOME}/ml/frameworks/uvm/sc -I. 

# questa_run_command :
vsim  -c -do 'run -all; exit -f' -64 -dpioutoftheblue 1 -sv_lib /stec/tw/users/schen/prj/smartdv/kernel/UVM_ML-1.5.1/ml/examples/use_cases/side_by_side/sc_sv/libuvm_dpi.64 -gblso ${UVM_ML_HOME}/ml/libs/backplane/4.4/64bit/libuvm_ml_bp.so -sv_lib ${UVM_ML_HOME}/ml/libs/uvm_sv/4.4/64bit/libuvm_sv_ml -gblso ${UVM_ML_HOME}/ml/libs/uvm_sv/4.4/64bit/libuvm_sv_ml.so    -gblso /stec/tw/users/schen/prj/smartdv/kernel/UVM_ML-1.5.1/ml/examples/use_cases/side_by_side/sc_sv/liball_osci_questa.64.so  -sv_lib ${UVM_ML_HOME}/ml/libs/osci/2.3/4.4/64bit/libuvm_sc_fw_osci -sv_lib ${UVM_ML_HOME}/ml/libs/osci/2.3/4.4/64bit/libuvm_sc_ml_osci -l questa_osci_proc.64.log topmodule  

# tops_and_test_commands :
# Note: uvm tops & test are defined procedurally in code 
# see 'uvm_ml_run_test' in docs & in file test.sv for various ways to set them
