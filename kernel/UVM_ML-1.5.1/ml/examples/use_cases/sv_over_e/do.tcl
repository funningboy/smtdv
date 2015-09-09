#Convert xbus_trans_s to SV using mltypemap
#The e type is defined in ../../uvcs/xbus_simple
#The code in the generated sn_xb.svh was used in sv/xbus_trans.sv
#irun -snload ../../uvcs/xbus_simple/e/xbus_top.e -mltypemap_input do.tcl

configure_code -uvm_ml_oa
configure_type -type "e:MASTER cdn_xbus::xbus_trans_s" \
   -skip_field driver \
   -skip_field bus_name \
   -skip_field check_error
configure_type -type "e:cdn_xbus::xbus_trans_s" \
   -skip_field master_name \
   -skip_field slave_name  
configure_type -type "e:MONITOR cdn_xbus::xbus_trans_s" \
   -skip_field waits \
   -skip_field error_pos_mon
maptypes -from_type "e:cdn_xbus::xbus_trans_s" \
   -base_name sn_xb -to_lang sv
