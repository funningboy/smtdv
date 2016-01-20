// sc_options.f: irun UVM_ML argument file - options needed for running SystemC (common for both 32 and 64 bit machines)


// Note: the -sysc option should come first before all all other SystemC related options 
//       (it specifies to irun option that SystemC is used). 
-sysc 

// selecting GCC version
-gcc_vers ${UVM_ML_COMPILER_VERSION}  


// needed for UVM-SC quasi static components (they create dynamic processes after elaboration)
-DSC_INCLUDE_DYNAMIC_PROCESSES

// options for including the UVM-SC framework and adapter
-I${UVM_ML_HOME}/ml/frameworks/uvm/sc   
-I${UVM_ML_HOME}/ml/adapters/uvm_sc 
-I${UVM_ML_HOME}/ml/adapters/uvm_sc/common 
-I${UVM_ML_HOME}/ml/adapters/uvm_sc/ncsc
