`ifndef __AHB_LOCK_WRAP_TEST_SV__
`define __AHB_LOCK_WRAP_TEST_SV__

class ahb_lock_wrap_test
  extends `AHB_BASE_TEST;

  `uvm_component_utils(`AHB_LOCK_WRAP_TEST)

  function new(string name = "ahb_lock_wrap_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `AHB_MASTER_LOCK_WRAP_SEQ::type_id::get());
  endfunction

endclass

`endif // end of __AHB_LOCK_WRAP_TEST_SV__
