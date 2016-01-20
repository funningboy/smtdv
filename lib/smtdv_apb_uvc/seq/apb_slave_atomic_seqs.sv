
`ifndef __APB_SLAVE_ATOMIC_SEQS_SV__
`define __APB_SLAVE_ATOMIC_SEQS_SV__

//typedef class apb_slave_base_seq;

class apb_slave_1w1r_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    apb_slave_base_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef apb_slave_1w1r_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "apb_slave_1w1r_seq");
    super.new(name);
  endfunction : new

endclass : apb_slave_1w1r_seq

`endif // end of __APB_SLAVE_ATOMIC_SEQS_SV__
