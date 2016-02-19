
`ifndef __SMTDV_AHB_TEST_SV__
`define __SMTDV_AHB_TEST_SV__

typedef class ahb_base_env;
//typedef class ahb_virtual_sequencer;


class ahb_base_test
  extends
  smtdv_test;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef ahb_base_test test_t;
  typedef virtual interface ahb_if#(ADDR_WIDTH, DATA_WIDTH) vif_t;
  typedef ahb_master_cfg mst_cfg_t;
  typedef ahb_master_agent#(ADDR_WIDTH, DATA_WIDTH) mst_agt_t;
  typedef ahb_slave_cfg slv_cfg_t;
  typedef ahb_slave_agent#(ADDR_WIDTH, DATA_WIDTH) slv_agt_t;
  typedef ahb_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef ahb_base_env#(ADDR_WIDTH, DATA_WIDTH,
      vif_t,
      mst_cfg_t,
      mst_agt_t,
      slv_cfg_t,
      slv_agt_t,
      item_t
  ) env_t;
  typedef ahb_virtual_sequencer vseqr_t;


  typedef virtual interface smtdv_gen_rst_if#("ahb_rst_if", 100, 0) rst_t;
  typedef smtdv_reset_model #(ADDR_WIDTH, DATA_WIDTH, rst_t) rst_mod_t;

  vseqr_t vseqr;
  rst_t rst_vif;
  rst_mod_t rst_model;
  env_t cmp_envs[$];

  `uvm_component_utils(ahb_base_test)

  function new(string name = "ahb_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //create sqlite3 db
    smtdv_sqlite3::delete_db("ahb_db.db");
    smtdv_sqlite3::new_db("ahb_db.db");

    // virtual seqr
    vseqr = vseqr_t::type_id::create({$psprintf("vseqr")}, this);

    // cmp_envs
    cmp_envs[0] = env_t::type_id::create({$psprintf("ahb_env[%0d]", 0)}, this);

    // resetn
    rst_model = rst_mod_t::type_id::create("rst_model");
    if(!uvm_config_db#(rst_t)::get(this, "", "rst_vif", rst_vif))
      `uvm_fatal("AHB_NO_VIF",{"VIRTUAL INTERFACE MUST BE SET ",get_full_name(),".rst_vif"});
    rst_model.create_rst_monitor(rst_vif);

  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vseqr.ahb_magts[0] = cmp_envs[0].mst_agts[0];
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    rst_model.add_component(this);
    rst_model.set_rst_type(ALL_RST);
    rst_model.show_components(0);
  endfunction : end_of_elaboration_phase

endclass : ahb_base_test

`endif // __AHB_BASE_ENV_SV__
