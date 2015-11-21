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
    //set_type_override_by_type(`UART_RX_SEQUENCER::get_type(), `UART_TX_SEQUENCER::get_type());

    super.build_phase(phase);

    // Set the default sequence for the tx and rx
    uvm_config_db#(uvm_object_wrapper)::set(this,
      "*tx_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `TX_INCR_PAYLOAD_SEQ::type_id::get());

  endfunction : build_phase

endclass

`endif // __UART_SEQ_TEST_SV__
