`ifndef __APB_SLAVE_SEQUENCER_SV__
`define __APB_SLAVE_SEQUENCER_SV__

typedef class apb_slave_cfg;
typedef class apb_item;

class apb_slave_sequencer#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_sequencer#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(apb_slave_cfg),
      .REQ(apb_item#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH) seqr_t;

  `uvm_component_param_utils_begin(seqr_t)
  `uvm_component_utils_end

  function new(string name = "apb_slave_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : apb_slave_sequencer

`endif //__APB_SLAVE_SEQUENCER_SV__

