
`ifndef __CDN_CPU_M1_SV__
`define __CDN_CPU_M1_SV__

// type override for self coverage group, update addr, data
class cdn_cpu_m1_cover_group #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32)
  extends
  ahb_collect_cover_group(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .CFG(ahb_master_cfg),
    .SEQR(ahb_master_sequencer#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef cdn_cpu_m1_cover_group#(ADDR_WIDTH, DATA_WIDTH) cov_grp_t

  `uvm_object_param_utils_begin(cov_grp_t)
  `uvm_object_utils_end

  covergroup cdn_cpu_m1_coverage;
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
//    ahb_trx:
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
  endgroup : cdn_cpu_m1_coverage

  function new(string name = "cdn_cpu_m1_cover_group");
    super.new(name);
    cdn_cpu_m1_coverage = new();
  endfunction : new

  virtual task run();
    forever begin
      this.cmp.cbox.get(item);
      cdn_cpu_m1_coverage.sample();
    end
  endtask : run

endclass : cdn_cpu_m1_cover_group


class cdn_cpu_m1_cfg
  extends
  ahb_master_cfg;

  typedef cdn_cpu_m1_cfg cfg_t;

  `uvm_object_param_utils_begin(cfg_t)
  `uvm_object_utils_end

  function new(string name = "cdn_cpu_m1_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction : new

endclass : cdn_cpu_m1_cfg


// use Master UVC to drive cdn bus slave port
class cdn_cpu_m1_agent #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32)
  extends
  ahb_master_agent#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  );

  typedef cdn_cpu_m1_agent#(ADDR_WIDTH, DATA_WIDTH) agent_t;
  typedef cdn_cpu_m1_cover_group#(ADDR_WIDTH, DATA_WIDTH) cov_grp_t;

  cov_grp_t th5;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "cdn_cpu_m1_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th5 = cov_grp_t::type_id::create("cdn_cpu_m1_cover_group", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    th5.register(this.mon);
    this.mon.th_handler.del(this.mon.th4);
    this.mon.th_handler.add(th5);
  endfunction : connect_phase

endclass : cdn_cpu_m1_agent


`endif // __CDN_CPU_m1_SV__
