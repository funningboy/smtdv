
`ifndef __CDN_DMA_M0_SV__
`define __CDN_DMA_M0_SV__

class cdn_dma_m0_cfg
  extends
  ahb_master_cfg;

  typedef cdn_dma_m0_cfg cfg_t;

  `uvm_object_param_utils_begin(cfg_t)
  `uvm_object_utils_end

  function new(string name = "cdn_dma_m0_cfg",  uvm_component parent=null);
    super.new(name, cmp);
  endfunction : new

endclass : cdn_dma_m0_cfg

//
class cdn_dma_m0_agent #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32)
  extends
  ahb_master_agent#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  );

  typedef cdn_dma_m0_agent#(ADDR_WIDTH, DATA_WIDTH) agent_t;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "cdn_dma_m0_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : cdn_dma_m0_agent


`endif // __CDN_DMA_M0_SV__
