
`ifndef __CDN_VIRTUAL_SEQUENCER__
`define __CDN_VIRTUAL_SEQUENCER__

class cdn_virtual_sequencer
  extends
  uvm_sequencer;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef cdn_virtual_sequencer vseqr_t;
  typedef ahb_master_agent#(ADDR_WIDTH, DATA_WIDTH) ahb_magt_t;

  ahb_magt_t ahb_magts[$];

  `uvm_component_param_utils_begin(vseqr_t)
  `uvm_component_utils_end

  function new(string name = "ahb_virtual_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : ahb_virtual_sequencer


`endif // __CDN_VIRTUAL_SEQUENCER__

