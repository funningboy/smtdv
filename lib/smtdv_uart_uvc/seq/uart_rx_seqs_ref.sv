
`ifndef __UART_RX_SEQS_REF_SV__
`define __UART_RX_SEQS_REF_SV__

class rx_incr_payload_seq #(
)extends
  `UART_INCR_PAYLOAD_SEQ;

  `uvm_declare_p_sequencer(`UART_RX_SEQUENCER)

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`RX_INCR_PAYLOAD_SEQ)
   `uvm_object_utils_end

    function new(string name="rx_incr_payload_seq");
      super.new(name);
    endfunction
endclass

class rx_bad_parity_seq #(
) extends
  `UART_BAD_PARITY_SEQ;

   `uvm_declare_p_sequencer(`UART_RX_SEQUENCER)

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`RX_BAD_PARITY_SEQ)
   `uvm_object_utils_end

    function new(string name="rx_bad_parity_seq");
      super.new(name);
    endfunction
endclass


class rx_transmit_seq #(
) extends
  `UART_TRANSMIT_SEQ;

   `uvm_declare_p_sequencer(`UART_RX_SEQUENCER)

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`RX_TRANSMIT_SEQ)
   `uvm_object_utils_end

    function new(string name="rx_transmit_seq");
      super.new(name);
    endfunction
endclass


class rx_short_transmit_seq #(
) extends
  `UART_SHORT_TRANSMIT_SEQ;

  `uvm_declare_p_sequencer(`UART_RX_SEQUENCER)

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`RX_SHORT_TRANSMIT_SEQ)
   `uvm_object_utils_end

    function new(string name="rx_short_transmit_seq");
      super.new(name);
    endfunction
endclass


`endif // __UART_RX_SEQS_REF_SV__
