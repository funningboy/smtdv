#Convert ubus_transfer and the sequences to e using mltypemap
#The SV type is defined in ../../ex_single_lang_uvcs_lib/ubus 
#Use ./run_mltypemap.sh 
#The code generated in sv_ub_ubus_pkg.e is used in the e environment

configure_code -uvm_ml_oa
configure_type -type "sv:uvm_pkg::uvm_sequence#(ubus_pkg::ubus_transfer,ubus_pkg::ubus_transfer)" -use_existing
maptypes -from_type "sv:ubus_pkg::ubus_transfer" -from_type "sv:ubus_pkg::write_word_seq" -from_type "sv:ubus_pkg::read_word_seq" -base_name sv_ub -to_lang e
