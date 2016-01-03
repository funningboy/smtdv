`ifndef __APB_MASTER_SEQUENCER_SV__
`define __APB_MASTER_SEQUENCER_SV__

typedef class apb_master_cfg;
typedef class apb_item;

class apb_master_sequencer #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  smtdv_sequencer #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
    .CFG(apb_master_cfg),
    .REQ(apb_item#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef apb_master_sequencer #(ADDR_WIDTH, DATA_WIDTH) seqr_t;

  `uvm_component_param_utils_begin(seqr_t)
  `uvm_component_utils_end

  function new (string name = "apb_master_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : apb_master_sequencer

`endif // end of __APB_MASTER_SEQUENCER_SV__
