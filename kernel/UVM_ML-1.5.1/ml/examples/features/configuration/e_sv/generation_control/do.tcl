
#irun -snload top.e -mltypemap_input do.tcl

configure_code -uvm_ml_oa

maptypes -from_type "e:packet" -base_name sn_xb -to_lang sv
