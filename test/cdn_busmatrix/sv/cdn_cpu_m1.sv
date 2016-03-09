
`ifndef __CDN_CPU_M1_SV__
`define __CDN_CPU_M1_SV__



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
//  typedef cdn_cpu_m1_cover_group#(ADDR_WIDTH, DATA_WIDTH) cov_grp_t;

//  cov_grp_t th6;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "cdn_cpu_m1_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
//    th6 = cov_grp_t::type_id::create("cdn_cpu_m1_cover_group", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
//    th6.register(this.mon);
//    this.mon.th_handler.del(this.mon.th4);
//    this.mon.th_handler.add(th6);
  endfunction : connect_phase

endclass : cdn_cpu_m1_agent


`endif // __CDN_CPU_m1_SV__
