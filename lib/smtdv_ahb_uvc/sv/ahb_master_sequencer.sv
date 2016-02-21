`ifndef __AHB_MASTER_SEQUENCER_SV__
`define __AHB_MASTER_SEQUENCER_SV__

typedef class ahb_master_cfg;
typedef class ahb_sequence_item;

class ahb_master_sequencer #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  smtdv_sequencer #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .VIF(virtual interface ahb_if#(ADDR_WIDTH, DATA_WIDTH)),
    .CFG(ahb_master_cfg),
    .REQ(ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef ahb_master_sequencer #(ADDR_WIDTH, DATA_WIDTH) seqr_t;

  `uvm_component_param_utils_begin(seqr_t)
  `uvm_component_utils_end

  function new (string name = "ahb_master_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : ahb_master_sequencer

`endif // end of __AHB_MASTER_SEQUENCER_SV__
