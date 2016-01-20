<'

package uvm_ml;

import sn_uvm_ml_connector;
import sn_uvm_ml_additions.enc.e;

specman patch 0000142 using
release={15.10*}, 
error_not_release=TRUE ,
date="17/11/14",
author="UVM-ML Group",
description="This patch includes support for UVM-ML e",
patch_file_name="sn_uvm_ml.e",
must_compile=FALSE,
    
{
    
C export uvm_ml_phase_action;
      
C export simulator.create_ml_lib_adapter();
C export sn_ML_LIB_adapter.sn_ml_set_debug_mode();
C export sn_ML_LIB_adapter.sn_ml_find_connector_id_by_name();
C export sn_ML_LIB_adapter.sn_ml_get_connector_type();
C export sn_ML_LIB_adapter.sn_ml_is_export_connector();
C export sn_ML_LIB_adapter.sn_ml_get_connector_intf_name();
C export sn_ML_LIB_adapter.sn_ml_get_connector_T1_name();
C export sn_ML_LIB_adapter.sn_ml_get_connector_T2_name();
C export sn_ML_LIB_adapter.sn_ml_try_put_bitstream();
C export sn_ML_LIB_adapter.sn_ml_can_put();
C export sn_ML_LIB_adapter.sn_ml_try_get_bitstream();
C export sn_ML_LIB_adapter.sn_ml_can_get();
C export sn_ML_LIB_adapter.sn_ml_try_peek_bitstream();
C export sn_ML_LIB_adapter.sn_ml_can_peek();
C export sn_ML_LIB_adapter.sn_ml_put_bitstream_request();
C export sn_ML_LIB_adapter.sn_ml_get_bitstream_request();
C export sn_ML_LIB_adapter.sn_ml_peek_bitstream_request();
C export sn_ML_LIB_adapter.sn_ml_transport_bitstream_request();
C export sn_ML_LIB_adapter.sn_ml_get_requested_bitstream();
C export sn_ML_LIB_adapter.sn_ml_peek_requested_bitstream();
C export sn_ML_LIB_adapter.sn_ml_get_requested_bitstream();
C export sn_ML_LIB_adapter.sn_ml_turn_transaction_mapping_off();
C export sn_ML_LIB_adapter.sn_ml_notify_end_task();
C export sn_ML_LIB_adapter.sn_ml_nb_transport_bitstream();
C export sn_ML_LIB_adapter.sn_ml_write_bitstream();
C export sn_ML_LIB_adapter.sn_ml_tlm2_b_transport_request();
C export sn_ML_LIB_adapter.sn_bp_tlm2_b_transport_response();
C export sn_ML_LIB_adapter.sn_ml_tlm2_nb_transport_fw();
C export sn_ML_LIB_adapter.sn_ml_tlm2_nb_transport_bw();
C export sn_ML_LIB_adapter.sn_ml_tlm2_transport_dbg();
C export sn_ML_LIB_adapter.sn_ml_create_child();
C export sn_ML_LIB_adapter.sn_ml_notify_phase();
C export sn_ML_LIB_adapter.sn_ml_transmit_phase();
C export sn_ML_LIB_adapter.sn_ml_out();
C export sn_ML_LIB_adapter.sn_ml_init_phases();
C export sn_ML_LIB_adapter.sn_ml_notify_config();
C export sn_uvm_ml_wakeup_srv_provider.sn_ml_register_time_cb();
C export sn_uvm_ml_wakeup_srv_provider.sn_ml_remove_time_cb();
C export sn_ML_LIB_adapter.sn_ml_get_num_children();
C export sn_ML_LIB_adapter.sn_ml_get_child_name();
C export sn_ML_LIB_adapter.sn_ml_get_component_type_name();
C export sn_ML_LIB_adapter.sn_ml_is_port();
C export sn_ML_LIB_adapter.sn_ml_print_srv_print_request();
C export sn_ML_LIB_adapter.sn_uvm_ml_transmit_phase_wrap();
C export sn_ML_LIB_adapter.sn_uvm_ml_notify_phase_wrap();
}

'>
