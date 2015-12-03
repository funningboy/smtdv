`ifndef __APB_HIJACK_TEST_SV__
`define __APB_HIJACK_TEST_SV__


// check force method can been relased while slave is running into normal behavior
// mode
class apb_hijack_test
  extends `APB_BASE_TEST;

  `uvm_component_utils(`APB_HIJACK_TEST)

  function new(string name = "apb_hijack_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    // override slave base seq to err_inject seq
    set_type_override_by_type(`APB_SLAVE_BASE_SEQ::get_type(), `APB_SLAVE_HIJACK_SEQ::get_type());

    super.build_phase(phase);

    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `APB_MASTER_STL_SEQ::type_id::get());

    // override err to warning
    foreach(master_scb[i]) begin
      uvm_top.set_report_severity_id_override(UVM_ERROR, master_scb[i].get_full_name(), UVM_WARNING);
    end

    uvm_top.set_timeout(445ns);
    uvm_top.set_report_severity_id_override(UVM_FATAL, "PH_TIMEOUT", UVM_WARNING);

  endfunction

endclass

`endif // end of __APB_HIJACK_TEST_SV__
