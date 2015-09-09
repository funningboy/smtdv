 source $::env(UVM_ML_HOME)/ml/facilities/debug/uvm_ml_sim.tcl
set version [ncsim -version]
regexp {(1.\..)} $version  ver
if { $ver == 13.1 } {
source [ncroot]/tools/uvm/uvm_lib/additions/sv/files/tcl/uvm_sim.tcl
} else {
source [ncroot]/tools/methodology/UVM/CDNS-1.1d/additions/sv/files/tcl/uvm_sim.tcl
}


