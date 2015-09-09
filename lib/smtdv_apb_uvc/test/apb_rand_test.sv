

`ifndef __APB_RAND_TEST_SV__
`define __APB_RAND_TEST_SV__

class apb_rand_test
  extends `APB_BASE_TEST;

  `uvm_component_utils(`APB_RAND_TEST)

  function new(string name = "apb_rand_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // not implement
  endfunction

endclass

`endif // end of __APB_RAND_TEST_SV__
