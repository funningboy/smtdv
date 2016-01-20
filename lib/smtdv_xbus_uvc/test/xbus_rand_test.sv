

`ifndef __XBUS_RAND_TEST_SV__
`define __XBUS_RAND_TEST_SV__

class xbus_rand_test
  extends `XBUS_BASE_TEST;

  `uvm_component_utils(`XBUS_RAND_TEST)

  function new(string name = "xbus_rand_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // imp
    //set_type_override
  endfunction

endclass

`endif // end of __XBUS_RAND_TEST_SV__
