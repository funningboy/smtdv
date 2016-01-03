
`ifndef __APB_MASTER_CFG_SEQ_SV__
`define __APB_MASTER_CFG_SEQ_SV__

//typedef class apb_item;
//typedef class apb_master_cfg;
//typedef class apb_master_sequencer;

class apb_master_cfg_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    apb_master_1w_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  );

  typedef apb_master_cfg_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_cfg_seq");
    super.new(name);
  endfunction : new

 endclass : apb_master_cfg_seq

`endif // __APB_MASTER_CFG_SEQ_SV__
