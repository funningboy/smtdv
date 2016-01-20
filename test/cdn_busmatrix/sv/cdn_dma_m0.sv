
`ifndef __CDN_DMA_M0_SV__
`define __CDN_DMA_M0_SV__

//
class cdn_dma_m0_agent #(
    ADDR_WIDTH = 14,
    DATA_WIDTH = 32
  ) extends
  `AHB_SLAVE_AGENT;

  `uvm_component_param_utils_begin(`CDN_DMA_M0_AGENT)
  `uvm_component_utils_end

  function new(string name = "cdn_dma_m0_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

endclass


class cdn_dma_m0_cfg
 extends
  `AHB_SLAVE_CFG;

  `uvm_object_param_utils_begin(`CDN_DMA_M0_CFG)
  `uvm_object_utils_end

  function new(string name = "cdn_dma_m0_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

endclass


// type override for self coverage group, update addr, data
class cdn_dma_m0_cover_group #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  `AHB_COLLECT_COVER_GROUP;

   `uvm_object_param_utils_begin(`CDN_DMA_M0_COVER_GROUP)
   `uvm_object_utils_end

    covergroup ahb_coverage;
      ahb_addr : coverpoint item.addr {
        bins zero = {0};
        bins non_zero = {[1:32'hffff_ffff]};
      }
      ahb_rw : coverpoint item.trs_t {
        bins read = {RD};
        bins write = {WR};
      }
      ahb_data : coverpoint item.unpack_data(item.data_idx) {
        bins zero = {0};
        bins non_zero = {[1:32'hffff_ffff]};
      }
      ahb_rsp : coverpoint item.rsp {
        bins ok = {OKAY};
        bins err = {ERROR};
        bins retry = {RETRY};
        bins split = {SPLIT};
      }
      ahb_lock : coverpoint item.hmastlock {
        bins lock = {1};
        bins unlock = {0};
      }
      ahb_trx  : cross ahb_addr, ahb_rw, ahb_data, ahb_rsp, ahb_lock;
    endgroup

    function new(string name = "cdn_dma_m0_cover_group");
      super.new(name);
      ahb_coverage = new();
    endfunction

    virtual task run();
      forever begin
        this.cmp.cbox.get(item);
        ahb_coverage.sample();
      end
    endtask

endclass

// type override for self seq, ex: init, specific seq ...
class cdn_dma_m0_basic_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `AHB_SLAVE_BASE_SEQ;

    `uvm_sequence_utils(`CDN_DMA_M0_BASIC_SEQ, `AHB_SLAVE_SEQUENCER)

    function new(string name = "cdn_dma_m0_basic_seq");
      super.new(name);
    endfunction

endclass

// scoreboard

`endif // __CDN_DMA_M0_SV__
