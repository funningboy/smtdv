
`ifndef __AHB_BASE_TEST_SV__
`define __AHB_BASE_TEST_SV__

//typedef class ahb_master_cfg;
//typedef class ahb_slave_cfg;
//typedef class ahb_master_agent;
//typedef class ahb_slave_agent;
//typedef class ahb_base_scoreboard;
//typedef class ahb_item;

// 1Mx2S
class ahb_base_test
  extends
  smtdv_test;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;
  parameter NUM_OF_INITOR = 1;
  parameter NUM_OF_TARGETS = 1;

  typedef ahb_base_test test_t;

  typedef virtual interface ahb_if#(ADDR_WIDTH, DATA_WIDTH) vif_t;
  typedef virtual interface smtdv_gen_rst_if#("ahb_rst_if", 100, 0) rst_t;

  typedef smtdv_reset_model #(ADDR_WIDTH, DATA_WIDTH, rst_t) rst_mod_t;

  typedef ahb_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  typedef ahb_master_cfg  mst_cfg_t;
  typedef ahb_slave_cfg   slv_cfg_t;

  typedef ahb_master_agent#(ADDR_WIDTH, DATA_WIDTH) mst_agt_t;
  typedef ahb_slave_agent#(ADDR_WIDTH, DATA_WIDTH)  slv_agt_t;

  typedef ahb_base_scoreboard#(
    ADDR_WIDTH,
    DATA_WIDTH,
    NUM_OF_INITOR,
    NUM_OF_TARGETS
  ) mst_scb_t;

  mst_cfg_t master_cfg[$];
  mst_agt_t master_agent[$];

  slv_cfg_t slave_cfg[$];
  slv_agt_t slave_agent[$];

  mst_scb_t master_scb[$];

  rst_t rst_vif;
  rst_mod_t rst_model;

  function new(string name = "ahb_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  // lookup table expect from .xml or .yaml
  virtual function void build_phase(uvm_phase phase);
    bit [ADDR_WIDTH-1:0] start_addr, end_addr;
    super.build_phase(phase);

    // create sqlite3 db
    smtdv_sqlite3::delete_db("ahb_db.db");
    smtdv_sqlite3::new_db("ahb_db.db");

    // slaves cfg, agent
    slave_cfg[0] = slv_cfg_t::type_id::create({$psprintf("slave_cfg[%0d]", 0)}, this);
    `SMTDV_RAND_WITH(slave_cfg[0], {
      has_force == TRUE;
      has_coverage == TRUE;
      has_export == TRUE;
      has_error == TRUE;
      has_retry == TRUE;
      has_split == FALSE;
    })
    slave_agent[0] = slv_agt_t::type_id::create({$psprintf("slave_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+slave_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(slv_cfg_t)::set(null, "/.+slave_agent[*0]*/", "cfg", slave_cfg[0]);

    // masters cfg, agent
    master_cfg[0] = mst_cfg_t::type_id::create({$psprintf("master_cfg[%0d]", 0)}, this);
    `SMTDV_RAND_WITH(master_cfg[0], {
      has_force == 1;
      has_coverage == 1;
      has_export == 1;
      has_busy == 0;
    })
    start_addr = `AHB_START_ADDR(0)
    end_addr = `AHB_END_ADDR(0)
    master_cfg[0].add_slave(slave_cfg[0], 0, start_addr, end_addr);

    master_agent[0] = mst_agt_t::type_id::create({$psprintf("master_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+master_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(mst_cfg_t)::set(null, "/.+master_agent[*0]*/", "cfg", master_cfg[0]);

    // scoreboard num of masters cross all slaves ex: 3*all, 2*all socreboard
    master_scb[0] = mst_scb_t::type_id::create({$psprintf("master_scb[%0d]", 0)}, this);
    uvm_config_db#(mst_agt_t)::set(null, "/.+master_scb[*0]*/", "initor_m[0]", master_agent[0]);
    uvm_config_db#(slv_agt_t)::set(null, "/.+master_scb[*0]*/", "targets_s[0]", slave_agent[0]);

    // resetn
   rst_model = rst_mod_t::type_id::create("rst_model");
    if(!uvm_config_db#(rst_t)::get(this, "", "rst_vif", rst_vif))
      `uvm_fatal("AHB_NO_VIF",{"VIRTUAL INTERFACE MUST BE SET ",get_full_name(),".rst_vif"});
    rst_model.create_rst_monitor(rst_vif);
   endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    master_agent[0].mon.item_collected_port.connect(master_scb[0].initor[0]);
    slave_agent[0].mon.item_collected_port.connect(master_scb[0].targets[0]);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    rst_model.add_component(this);
    rst_model.set_rst_type(ALL_RST);
    rst_model.show_components(0);
  endfunction : end_of_elaboration_phase

endclass : ahb_base_test

`endif // __AHB_BASE_TEST_SV__
