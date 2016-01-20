`ifndef __UART_LOOPBACK_TEST_SV__
`define __UART_LOOPBACK_TEST_SV__

/* drive rx while tx is received */
class uart_loopback_test
  extends
  `UART_BASE_TEST;

  `uvm_component_utils(`UART_LOOPBACK_TEST)

  function new(string name = "uart_loopback_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    // override passive RX loopback seq
    super.build_phase(phase);

    // Set the default sequence for master as tx
    uvm_config_db#(uvm_object_wrapper)::set(this,
      "*slave_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `RX_LOOPBACK_BASE_SEQ::type_id::get());

    // Set the default sequence for master as tx
    uvm_config_db#(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `TX_INCR_PAYLOAD_SEQ::type_id::get());

  endfunction : build_phase

endclass

`endif // __UART_LOOPBACK_TEST_SV__
