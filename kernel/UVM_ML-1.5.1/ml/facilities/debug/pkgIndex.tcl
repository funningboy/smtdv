package require Tcl 8.4

#location of shared object library for uvm_ml_ext tcl package

set UVM_ML_BITNESS ""
if { $::tcl_platform(wordSize) == 8 } {set UVM_ML_BITNESS "/64bit"}

#
package ifneeded "uvm_ml_ext" 1.0 \
    [list load [file join $dir ../../libs/debug/$::env(UVM_ML_COMPILER_VERSION)$UVM_ML_BITNESS libuvm_ml_debug[info sharedlibextension]] uvm_ml_ext]
