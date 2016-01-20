`ifndef __UART_SEQ_TEST_SV__
`define __UART_SEQ_TEST_SV__

class uart_seq_test
  extends
   `UART_BASE_TEST;

  `uvm_component_utils(`UART_SEQ_TEST)

  function new(string name = "uart_seq_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    // override passive RX loopback seq
    set_type_override_by_type(`RX_LOOPBACK_BASE_SEQ::get_type(), `RX_INCR_PAYLOAD_SEQ::get_type());
    super.build_phase(phase);

    // Set the default sequence for master as tx
    uvm_config_db#(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `TX_INCR_PAYLOAD_SEQ::type_id::get());

  endfunction : build_phase

endclass

`endif // __UART_SEQ_TEST_SV__
