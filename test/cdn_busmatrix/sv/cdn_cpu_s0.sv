
`ifndef __CDN_CPU_S0_SV__
`define __CDN_CPU_S0_SV__

//
class cdn_cpu_s0_agent #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  `AHB_MASTER_AGENT;

  `uvm_component_param_utils_begin(`CDN_CPU_S0_AGENT)
  `uvm_component_utils_end

  function new(string name = "cdn_cpu_s0_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

endclass


class cdn_cpu_s0_cfg
 extends
  `AHB_MASTER_CFG;

  `uvm_object_param_utils_begin(`CDN_CPU_S0_CFG)
  `uvm_object_utils_end

  function new(string name = "cdn_cpu_s0_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

endclass

// type override for self coverage group, update addr, data
class cdn_cpu_s0_cover_group #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  `AHB_COLLECT_COVER_GROUP;

   `uvm_object_param_utils_begin(`CDN_CPU_S0_COVER_GROUP)
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

    function new(string name = "cdn_cpu_s0_cover_group");
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
class cdn_cpu_s0_stl_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    `AHB_MASTER_STL_SEQ;

    `uvm_sequence_utils(`CDN_CPU_S0_STL_SEQ, `AHB_MASTER_SEQUENCER)

    function new(string name = "ahb_master_stl_seq");
      super.new(name);
    endfunction

    virtual task body();
      m_file = "../stl/cdn_cpu_s0.stl";
      super.body();
    endtask

endclass


`endif // __CDN_CPU_S0_SV__
