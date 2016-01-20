namespace eval uvmmltcl {
    namespace export uvm_ml_phase uvm_ml_print_tree uvm_ml_print_connections uvm_ml_trace_register uvm_ml

#Where to look for the uvm_ml_ext tcl package
lappend auto_path $::env(UVM_ML_HOME)/ml/facilities/debug

#pkgIndex in backplane defines the required uvm_ml_ext tcl package
package require uvm_ml_ext

#handle the uvm_ml_phase commands defined in uvm_ml_ext package
# -stop_at and -remove_stop
proc uvm_ml_phase {arg1 {arg2 ""} {arg3 ""} {arg4 ""}} {
    uvm_ml_ext::uvm_ml_phase $arg1 $arg2 $arg3 $arg4
    if { $arg1 == "-run" } { run }
}

proc uvm_ml_print_tree {{arg1 ""} {arg2 ""} {arg3 ""} {arg4 ""} {arg5 ""} {arg6 ""} {arg7 ""} {arg8 ""} {arg9 ""} {arg10 ""}} {
    uvm_ml_ext::uvm_ml_print_tree $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10
}

proc uvm_ml_print_connections {{arg1 ""} {arg2 ""} {arg3 ""} {arg4 ""}} {
    uvm_ml_ext::uvm_ml_print_connections $arg1 $arg2 $arg3 $arg4
}

proc uvm_ml_trace_register {{arg1 ""}} {
    uvm_ml_ext::uvm_ml_trace_register $arg1
}

#handle the new generic format - common prefix "uvm_ml" followed by space before the specific command
proc uvm_ml {{arg1 ""} {arg2 ""} {arg3 ""} {arg4 ""} {arg5 ""} {arg6 ""} {arg7 ""} {arg8 ""} {arg9 ""} {arg10 ""}} {
    uvm_ml_ext::uvm_ml $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10

#??    if { $arg1 == "phase" && {[lsearch -exact {$arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10 } "-run"] >= 0 } } { run }
    if { $arg1 == "phase" && $arg2 == "-run" } { run }


}

}
namespace import uvmmltcl::*
