// irun UVM_ML argument file - options for running SV
-uvmhome ${UVM_ML_HOME}/ml/frameworks/uvm/sv/1.2-ml
-sv_lib ${UVM_ML_HOME}/ml/libs/uvm_sv/${UVM_ML_COMPILER_VERSION}/libuvm_sv_ml.so
-uvmexthome ${UVM_ML_CDS_INST_DIR}/tools/methodology/UVM/CDNS-1.2

// Few verbosity flags (optional - users don't need to use these)
// Note: In ML-OA we set these to ease internal regression - users may prefer *not* to use them
+UVM_NO_RELNOTES                       
-nocopyright                           


