
`ifndef __APB_VIRTUAL_SEQUENCER_SV__
`define __APB_VIRTUAL_SEQUENCER_SV__


//typedef class apb_master_agent

class apb_virtual_sequencer
  extends
  uvm_sequencer;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef apb_virtual_sequencer vseqr_t;
  typedef apb_master_agent#(ADDR_WIDTH, DATA_WIDTH) apb_magt_t;

  apb_magt_t apb_magt[$];

  `uvm_component_param_utils_begin(vseqr_t)
  `uvm_component_utils_end

  function new(string name = "apb_virtual_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : apb_virtual_sequencer


`endif // __APB_VIRTUAL_SEQUENCER_SV__
