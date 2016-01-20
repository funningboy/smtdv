
`ifndef __SMTDV_ENV_SV__
`define __SMTDV_ENV_SV__

typedef class smtdv_master_cfg;
typedef class smtdv_master_agent;
typedef class smtdv_slave_cfg;
typedef class smtdv_slave_agent;
typedef class smtdv_scoreboard;

// link each master to all slaves
class smtdv_env#(
  type MCFG = smtdv_master_cfg,
  type MAGT = smtdv_master_agent,
  type SCFG = smtdv_slave_cfg,
  type SAGT = smtdv_slave_agent,
  type MSCB = smtdv_scoreboard
  ) extends
    smtdv_component#(uvm_env);

  typedef smtdv_env#(MCFG, MAGT, SCFG, SAGT) env_t;

  MCFG master_cfg[$];
  MAGT master_agent[$];
  SCFG slave_cfg[$];
  SAGT slave_agent[$];

  `uvm_component_param_utils_begin(env_t)
    `uvm_field_queue_object(master_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(master_agent, UVM_ALL_ON)
    `uvm_field_queue_object(slave_cfg, UVM_ALL_ON)
    `uvm_field_queue_object(slave_agent, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "smtdv_env", uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : smtdv_env

`endif // end of __SMTDV_ENV_SV__
