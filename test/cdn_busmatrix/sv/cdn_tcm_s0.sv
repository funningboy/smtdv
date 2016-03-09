`ifndef __CDN_TCM_s0_SV__
`define __CDN_TCM_s0_SV__

class cdn_tcm_s0_cfg
  extends
  ahb_slave_cfg;

  typedef cdn_tcm_s0_cfg cfg_t;

  `uvm_object_param_utils_begin(cfg_t)
  `uvm_object_utils_end

  function new(string name = "cdn_tcm_s0_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction : new

endclass : cdn_tcm_s0_cfg


class cdn_tcm_s0_agent#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32)
  extends
  ahb_slave_agent#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  );

  typedef cdn_tcm_s0_agent#(ADDR_WIDTH, DATA_WIDTH) agent_t;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "cdn_tcm_s0_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : cdn_tcm_s0_agent


`endif // __CDN_TCM_s0_SV__
