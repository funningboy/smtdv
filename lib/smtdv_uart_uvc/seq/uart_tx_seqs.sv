`ifndef __UART_TX_SEQS_REF_SV__
`define __UART_TX_SEQS_REF_SV__

class tx_incr_payload_seq #(
)extends
  `UART_INCR_PAYLOAD_SEQ;

  `uvm_declare_p_sequencer(`UART_TX_SEQUENCER)

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`TX_INCR_PAYLOAD_SEQ)
   `uvm_object_utils_end

    function new(string name="tx_incr_payload_seq");
      super.new(name);
    endfunction
endclass

class tx_bad_parity_seq #(
) extends
  `UART_BAD_PARITY_SEQ;

   `uvm_declare_p_sequencer(`UART_TX_SEQUENCER)

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`TX_BAD_PARITY_SEQ)
   `uvm_object_utils_end

    function new(string name="tx_bad_parity_seq");
      super.new(name);
    endfunction
endclass


class tx_transmit_seq #(
) extends
  `UART_TRANSMIT_SEQ;

   `uvm_declare_p_sequencer(`UART_TX_SEQUENCER)

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`TX_TRANSMIT_SEQ)
   `uvm_object_utils_end

    function new(string name="tx_transmit_seq");
      super.new(name);
    endfunction
endclass


class tx_short_transmit_seq #(
) extends
  `UART_SHORT_TRANSMIT_SEQ;

  `uvm_declare_p_sequencer(`UART_TX_SEQUENCER)

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`TX_SHORT_TRANSMIT_SEQ)
   `uvm_object_utils_end

    function new(string name="tx_short_transmit_seq");
      super.new(name);
    endfunction
endclass


`endif // __UART_TX_SEQS_REF_SV__
