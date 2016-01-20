
`ifndef __APB_BASE_TEST_SV__
`define __APB_BASE_TEST_SV__

//typedef class apb_master_cfg;
//typedef class apb_slave_cfg;
//typedef class apb_master_agent;
//typedef class apb_slave_agent;
//typedef class apb_base_scoreboard;
//typedef class apb_item;

// 1Mx2S cluster
class apb_base_test
  extends
  smtdv_test;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;
  parameter NUM_OF_INITOR = 1;
  parameter NUM_OF_TARGETS = 2;

  typedef apb_base_test test_t;

  typedef virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH) vif_t;
  typedef virtual interface smtdv_gen_rst_if#("apb_rst_if", 100, 0) rst_t;

  typedef smtdv_reset_model#(ADDR_WIDTH, DATA_WIDTH, rst_t) rst_mod_t;

  typedef apb_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  typedef apb_master_cfg  mst_cfg_t;
  typedef apb_slave_cfg   slv_cfg_t;

  typedef apb_master_agent#(ADDR_WIDTH, DATA_WIDTH) mst_agt_t;
  typedef apb_slave_agent#(ADDR_WIDTH, DATA_WIDTH)  slv_agt_t;

  typedef apb_base_scoreboard#(
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

  `uvm_component_utils(test_t)

  function new(string name = "apb_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    bit [ADDR_WIDTH-1:0] start_addr, end_addr;
    super.build_phase(phase);

    //create sqlite3 db
    smtdv_sqlite3::delete_db("apb_db.db");
    smtdv_sqlite3::new_db("apb_db.db");

    // slave0 cfg, agent
    slave_cfg[0] = slv_cfg_t::type_id::create({$psprintf("slave_cfg[%0d]", 0)}, this);
    `SMTDV_RAND_WITH(slave_cfg[0], {
      has_force == TRUE;    // force orignal vif behavior
      has_coverage == TRUE; // turn on coverage
      has_export == TRUE;   // export to sqlite3
      has_error == TRUE;   // rsp err
    })
    slave_agent[0] = slv_agt_t::type_id::create({$psprintf("slave_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+slave_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(slv_cfg_t)::set(null, "/.+slave_agent[*0]*/", "cfg", slave_cfg[0]);

    // slave1 cfg, agent
    slave_cfg[1] = slv_cfg_t::type_id::create({$psprintf("slave_cfg[%0d]", 1)}, this);
    `SMTDV_RAND_WITH(slave_cfg[1], {
      has_force == TRUE;
      has_coverage == TRUE;
      has_export == TRUE;
      has_error == TRUE;
    })
    slave_agent[1] = slv_agt_t::type_id::create({$psprintf("slave_agent[%0d]", 1)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+slave_agent[*1]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(slv_cfg_t)::set(null, "/.+slave_agent[*1]*/", "cfg", slave_cfg[1]);

    // master cfg, agent
    master_cfg[0] = mst_cfg_t::type_id::create({$psprintf("master_cfg[%0d]", 0)}, this);
    `SMTDV_RAND_WITH(master_cfg[0], {
      has_force == TRUE;    // force original vif behavior
      has_coverage == TRUE; // turn on coverage
      has_export == TRUE;   // export to sqlite3
      has_retry == TRUE;    // retry while rsp err
    })
    start_addr = `APB_START_ADDR(0)
    end_addr = `APB_END_ADDR(0)
    master_cfg[0].add_slave(slave_cfg[0], 0, start_addr, end_addr);

    start_addr = `APB_START_ADDR(1)
    end_addr = `APB_END_ADDR(1)
    master_cfg[0].add_slave(slave_cfg[1], 1, start_addr, end_addr);

    master_agent[0] = mst_agt_t::type_id::create({$psprintf("master_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+master_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(mst_cfg_t)::set(null, "/.+master_agent[*0]*/", "cfg", master_cfg[0]);

    // scoreboard num of masters cross all slaves ex: 3*all, 2*all socreboard
    master_scb[0] = mst_scb_t::type_id::create({$psprintf("master_scb[%0d]", 0)}, this);
    uvm_config_db#(mst_agt_t)::set(null, "/.+master_scb[*0]*/", "initor_m[0]", master_agent[0]);
    uvm_config_db#(slv_agt_t)::set(null, "/.+master_scb[*0]*/", "targets_s[0]", slave_agent[0]);
    uvm_config_db#(slv_agt_t)::set(null, "/.+master_scb[*0]*/", "targets_s[1]", slave_agent[1]);

    // resetn
    rst_model = rst_mod_t::type_id::create("rst_model");
    if(!uvm_config_db#(rst_t)::get(this, "", "rst_vif", rst_vif))
      `uvm_fatal("APB_NO_VIF",{"VIRTUAL INTERFACE MUST BE SET ",get_full_name(),".rst_vif"});
    rst_model.create_rst_monitor(rst_vif);

  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    master_agent[0].mon.item_collected_port.connect(master_scb[0].initor[0]);
    slave_agent[0].mon.item_collected_port.connect(master_scb[0].targets[0]);
    slave_agent[1].mon.item_collected_port.connect(master_scb[0].targets[1]);

  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    rst_model.add_component(this);
    rst_model.set_rst_type(ALL_RST);
    rst_model.show_components(0);
  endfunction : end_of_elaboration_phase

endclass : apb_base_test

`endif // __APB_BASE_TEST_SV__
