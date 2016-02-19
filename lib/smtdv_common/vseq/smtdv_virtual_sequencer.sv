
`ifndef __SMTDV_VIRTUAL_SEQUENCER_SV__
`define __SMTDV_VIRTUAL_SEQUENCER_SV__

/*
* a top level virtual sequencer
*
* @class smtdv_virtual_sequencer
*/
class smtdv_virtual_sequencer
  extends
  uvm_sequencer;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef smtdv_virtual_sequencer vseqr_t;
  typedef smtdv_master_agent#(ADDR_WIDTH, DATA_WIDTH) smtdv_magt_t;
  typedef smtdv_slave_agent#(ADDR_WIDTH, DATA_WIDTH) smtdv_sagt_t;

  smtdv_magt_t smtdv_magts[$];
  smtdv_sagt_t smtdv_sagts[$];

  `uvm_component_param_utils_begin(vseqr_t)
  `uvm_component_utils_end

  function new(string name = "smtdv_virtual_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : smtdv_virtual_sequencer

`endif // __SMTDV_VIRTUAL_SEQUENCER_SV__

