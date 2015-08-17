
`ifndef __APB_SLAVE_SEQS_CB_SV__
`define __APB_SLAVE_SEQS_CB_SV__

class apb_slave_event_seq_cb #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    apb_slave_base_seq(ADDR_WIDTH, DATA_WIDTH);

    `uvm_object_utils_begin(`APB_SLAVE__SEQ)
    `uvm_object_utils_end

endclass

`endif // end of __APB_SLAVE_SEQS_CB_SV__

