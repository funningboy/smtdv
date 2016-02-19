
`ifndef __SMTDV_CMP_ENV_SV__
`define __SMTDV_CMP_ENV_SV__

//typedef class smtdv_master_cfg;
//typedef class smtdv_master_agent;
//typedef class smtdv_slave_cfg;
//typedef class smtdv_slave_agent;
//typedef class smtdv_scoreboard;
//typedef class smtdv_sequence_item;
typedef class smtdv_cmp_graph_builder;


// link each master to all slaves
class smtdv_cmp_env#(
  type MCFG = smtdv_master_cfg,
  type MAGT = smtdv_master_agent,
  type SCFG = smtdv_slave_cfg,
  type SAGT = smtdv_slave_agent,
  type T1 = smtdv_sequence_item
  ) extends
    smtdv_component#(uvm_env);

  typedef smtdv_cmp_env#(MCFG, MAGT, SCFG, SAGT, T1) cmp_env_t;
  typedef smtdv_cmp_graph_builder#(MCFG, MAGT, SCFG, SAGT, T1) cmp_blder_t;
  typedef MCFG mst_cfg_t;
  typedef MAGT mst_agt_t;
  typedef SCFG slv_cfg_t;
  typedef SAGT slv_agt_t;

  mst_cfg_t mst_cfg;
  slv_cfg_t slv_cfg;
  mst_agt_t mst_agt;
  slv_agt_t slv_agt;

  MCFG mst_cfgs[$];
  MAGT mst_agts[$];
  SCFG slv_cfgs[$];
  SAGT slv_agts[$];

  cmp_blder_t cmp_blder;
  bit autogen = TRUE;

  `uvm_component_param_utils_begin(cmp_env_t)
    `uvm_field_queue_object(mst_cfgs, UVM_ALL_ON)
    `uvm_field_queue_object(mst_agts, UVM_ALL_ON)
    `uvm_field_queue_object(slv_cfgs, UVM_ALL_ON)
    `uvm_field_queue_object(slv_agts, UVM_ALL_ON)
    `uvm_field_object(cmp_blder, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "smtdv_cmp_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  /*
  * must be called after top build phase has built
  */
  virtual function void build_phase(uvm_phase phase);
    cmp_blder  = cmp_blder_t::type_id::create("smtdv_cmp_graph_builder", this);
  endfunction : build_phase

  virtual function bit has_master(int mstid);
    return mstid < mst_agts.size() && mstid >= 0;
  endfunction : has_master

  virtual function bit has_slave(int slvid);
    return slvid < slv_agts.size() && slvid >= 0;
  endfunction : has_slave

endclass : smtdv_cmp_env

`endif // end of __SMTDV_CMP_ENV_SV__
