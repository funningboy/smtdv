// irun UVM_ML argument file - options for running e 

// Must use the ML-enabled version of the UVM library (UVM-SV library)
-snshlib ${UVM_ML_HOME}/ml/libs/uvm_e/${IES_VERSION}/${UVM_ML_COMPILER_VERSION}/libsn_sn_uvm_ml.so

// Optional flags 
-nosncomp      // users should decide if/when to compile or load the e files
