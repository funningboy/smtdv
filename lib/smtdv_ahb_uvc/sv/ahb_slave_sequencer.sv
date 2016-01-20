`ifndef __AHB_SLAVE_SEQUENCER_SV__
`define __AHB_SLAVE_SEQUENCER_SV__

class ahb_slave_sequencer #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_sequencer #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface ahb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(ahb_slave_cfg),
      .REQ(ahb_item#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef ahb_slave_sequencer #(ADDR_WIDTH, DATA_WIDTH) seqr_t;

  `uvm_component_param_utils_begin(seqr_t)
  `uvm_component_utils_end

  function new(string name = "ahb_slave_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : ahb_slave_sequencer

`endif //__AHB_SLAVE_SEQUENCER_SV__

