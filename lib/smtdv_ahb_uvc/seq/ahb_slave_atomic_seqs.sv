
`ifndef __AHB_SLAVE_ATOMIC_SEQS_SV__
`define __AHB_SLAVE_ATOMIC_SEQS_SV__

//typedef class ahb_slave_base_seq;

class ahb_slave_1w1r_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    ahb_slave_base_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef ahb_slave_1w1r_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_slave_1w1r_seq");
    super.new(name);
  endfunction : new

endclass : ahb_slave_1w1r_seq


`endif // end of __AHB_SLAVE_ATOMIC_SEQS_SV__
