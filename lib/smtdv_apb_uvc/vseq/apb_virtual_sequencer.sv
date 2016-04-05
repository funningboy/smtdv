
`ifndef __APB_VIRTUAL_SEQUENCER_SV__
`define __APB_VIRTUAL_SEQUENCER_SV__


//typedef class apb_master_agent;

class apb_virtual_sequencer
  extends
  uvm_sequencer;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef apb_virtual_sequencer vseqr_t;
  typedef apb_master_agent#(ADDR_WIDTH, DATA_WIDTH) apb_magt_t;
  typedef apb_slave_agent#(ADDR_WIDTH, DATA_WIDTH) apb_sagt_t;
  typedef virtual interface smtdv_gen_rst_if#("apb_rst_if", 100, 0) rst_t;
  typedef smtdv_reset_model#(ADDR_WIDTH, DATA_WIDTH, rst_t) rst_mod_t;

  // prefer to use apb_32x32_magt_t if more typedefs
  apb_magt_t apb_magts[$];
  apb_sagt_t apb_sagts[$];
  rst_mod_t rst_model;

  `uvm_component_param_utils_begin(vseqr_t)
  `uvm_component_utils_end

  function new(string name = "apb_virtual_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : apb_virtual_sequencer


`endif // __APB_VIRTUAL_SEQUENCER_SV__
