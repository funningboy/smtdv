`ifndef __XBUS_1W1R_TEST_SV__
`define __XBUS_1W1R_TEST_SV__

class xbus_1w1r_test
  extends `XBUS_BASE_TEST;

  `uvm_component_utils(`XBUS_1W1R_TEST)

  function new(string name = "xbus_1w1r_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `XBUS_MASTER_1W1R_SEQ::type_id::get());
  endfunction

endclass

`endif // end of __XBUS_1W1R_TEST_SV__
