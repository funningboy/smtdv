
`ifndef __SMTDV_APB_TEST_SV__
`define __SMTDV_APB_TEST_SV__

typedef class apb_base_env;
//typedef class apb_virtual_sequencer;

/*
* a basic apb test
*/
class apb_base_test
  extends
  smtdv_test;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  typedef apb_base_test test_t;
  typedef virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH) vif_t;
  typedef apb_master_cfg mst_cfg_t;
  typedef apb_master_agent#(ADDR_WIDTH, DATA_WIDTH) mst_agt_t;
  typedef apb_slave_cfg slv_cfg_t;
  typedef apb_slave_agent#(ADDR_WIDTH, DATA_WIDTH) slv_agt_t;
  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef apb_base_env#(ADDR_WIDTH, DATA_WIDTH,
      vif_t,
      mst_cfg_t,
      mst_agt_t,
      slv_cfg_t,
      slv_agt_t,
      item_t
  ) env_t;

  // prefer to use apb_32x32_env_t not env_t;
  // apb_32x32_env;

  typedef apb_virtual_sequencer vseqr_t;

  typedef virtual interface smtdv_gen_rst_if#("apb_rst_if", 100, 0) rst_t;
  typedef smtdv_reset_model#(ADDR_WIDTH, DATA_WIDTH, rst_t) rst_mod_t;

  vseqr_t vseqr;
  rst_t rst_vif;
  rst_mod_t rst_model;
  env_t cmp_envs[$];

  `uvm_component_utils(apb_base_test)

  function new(string name = "apb_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //create sqlite3 db
    smtdv_sqlite3::delete_db("apb_db.db");
    smtdv_sqlite3::new_db("apb_db.db");

    // virtual seqr
    vseqr = vseqr_t::type_id::create({$psprintf("vseqr")}, this);

    // cmp_envs
    cmp_envs[0] = env_t::type_id::create({$psprintf("apb_env[%0d]", 0)}, this);

    // resetn
    rst_model = rst_mod_t::type_id::create("rst_model");
    if(!uvm_config_db#(rst_t)::get(this, "", "rst_vif", rst_vif))
      `uvm_fatal("APB_NO_VIF",{"VIRTUAL INTERFACE MUST BE SET ",get_full_name(),".rst_vif"});
    rst_model.create_rst_monitor(rst_vif);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vseqr.apb_magts[0] = cmp_envs[0].mst_agts[0];
    vseqr.rst_model = rst_model;
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    rst_model.add_component(this);
    rst_model.set_rst_type(ALL_RST);
    rst_model.show_components(0);
  endfunction : end_of_elaboration_phase

endclass : apb_base_test

`endif // __APB_BASE_TEST_SV__
