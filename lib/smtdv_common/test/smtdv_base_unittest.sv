
`ifndef __SMTDV_UNITTEST_SV__
`define __SMTDV_UNITTEST_SV__

//typedef class smtdv_reset_model;
//typedef class smtdv_slave_agent;
//typedef class smtdv_master_agent;
//typedef class smtdv_slave_cfg;
//typedef class smtdv_master_cfg;
//typedef class smtdv_scoreboard;

// only check compile is ok for base models
class smtdv_base_unittest
  extends
  smtdv_test;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;
  parameter NUM_OF_INITOR = 1;
  parameter NUM_OF_TARGETS = 1;

  typedef smtdv_base_unittest test_t;

  typedef virtual interface smtdv_if vv_t;
  typedef virtual interface smtdv_gen_rst_if#("smtdv_rst_if", 100, 0) rst_t;
  typedef smtdv_scoreboard#(
      ADDR_WIDTH,
      DATA_WIDTH,
      NUM_OF_INITOR,
      NUM_OF_TARGETS,
      smtdv_sequence_item #(ADDR_WIDTH,DATA_WIDTH),
      smtdv_master_agent#(ADDR_WIDTH, DATA_WIDTH, vv_t),
      smtdv_slave_agent#(ADDR_WIDTH, DATA_WIDTH, vv_t)) mst_scb_t;
  typedef smtdv_reset_model #(ADDR_WIDTH, DATA_WIDTH, rst_t) rst_mod_t;
  typedef smtdv_slave_agent#(ADDR_WIDTH, DATA_WIDTH, vv_t) slv_agt_t;
  typedef smtdv_master_agent#(ADDR_WIDTH, DATA_WIDTH, vv_t) mst_agt_t;
  typedef smtdv_slave_cfg slv_cfg_t;
  typedef smtdv_master_cfg mst_cfg_t;

  rst_t rst_vif;
  rst_mod_t rst_model;

  slv_agt_t  slave_agent[$];
  slv_cfg_t  slave_cfg[$];

  mst_agt_t  master_agent[$];
  mst_cfg_t  master_cfg[$];

  mst_scb_t      master_scb[$];

  `uvm_component_utils(smtdv_base_unittest)

  function new(string name = "smtdv_base_unittest", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //create sqlite3 db
    smtdv_sqlite3::delete_db("smtdv_db.db");
    smtdv_sqlite3::new_db("smtdv_db.db");

    // slave
    slave_cfg[0] = slv_cfg_t::type_id::create({$psprintf("slave_cfg[%0d]", 0)}, this);
    slave_agent[0] = slv_agt_t::type_id::create({$psprintf("slave_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+slave_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(slv_cfg_t)::set(null, "/.+slave_agent[*0]*/", "cfg", slave_cfg[0]);

    // master
    master_cfg[0] = mst_cfg_t::type_id::create({$psprintf("master_cfg[%0d]", 0)}, this);
    master_agent[0] = mst_agt_t::type_id::create({$psprintf("master_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+master_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(mst_cfg_t)::set(null, "/.+master_agent[*0]*/", "cfg", master_cfg[0]);

    // scoreboard
    master_scb[0] = mst_scb_t::type_id::create({$psprintf("master_scb[%0d]", 0)}, this);
    uvm_config_db#(mst_agt_t)::set(null, "/.+master_scb[*0]*/", "initor_m[0]", master_agent[0]);
    uvm_config_db#(slv_agt_t)::set(null, "/.+master_scb[*0]*/", "targets_s[0]", slave_agent[0]);

    // resetn
    rst_model = rst_mod_t::type_id::create("rst_model");
    if(!uvm_config_db#(rst_t)::get(this, "", "rst_vif", rst_vif))
      `uvm_fatal("SMTDV_NO_VIF",{"VIRTUAL INTERFACE MUST BE SET FOR: ",get_full_name(),".rst_vif"});
    rst_model.create_rst_monitor(rst_vif);

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    rst_model.add_component(this);
    rst_model.set_rst_type(ALL_RST);
    rst_model.show_components(0);
  endfunction


endclass

`endif // end of __SMTDV_UNITTEST_SV__
