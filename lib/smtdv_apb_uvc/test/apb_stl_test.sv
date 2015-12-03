`ifndef __APB_STL_TEST_SV__
`define __APB_STL_TEST_SV__

class apb_stl_test
  extends `APB_BASE_TEST;

  `uvm_component_utils(`APB_STL_TEST)

  function new(string name = "apb_stl_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `APB_MASTER_STL_SEQ::type_id::get());
  endfunction

//  check trx with sqlite3 db
endclass

`endif // end of __APB_STL_TEST_SV__
