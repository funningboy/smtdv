// File: sc_options.32.f
// Options needed for working with SystemC (common + 32 bit focused)

// SystemC common options (common for both 32 and 64 bit) - this should come first
-f ${UVM_ML_HOME}/ml/run_utils/sc_options.f

// SystemC options specific for 32 bit 
-spec ${UVM_ML_HOME}/ml/tools/specfiles/${IES_VERSION}/specfile.lnx86.gnu.${UVM_ML_COMPILER_VERSION}
-L${UVM_ML_HOME}/ml/libs/ncsc/${IES_VERSION}/${UVM_ML_COMPILER_VERSION}/ -L${UVM_ML_HOME}/ml/libs/ncsc/${UVM_ML_COMPILER_VERSION}/ 

