`ifndef __AHB_ENV_SV__
`define __AHB_ENV_SV__

typedef class ahb_master_cfg;
typedef class ahb_master_agent;
typedef class ahb_slave_cfg;
typedef class ahb_slave_agent;

class ahb_env#(
  type MCFG = ahb_master_cfg,
  type MAGT = ahb_master_agent,
  type SCFG = ahb_slave_cfg,
  type SAGT = ahb_slave_agent
  )extends
    smtdv_env#(
      .MCFG(MCFG),
      .MAGT(MAGT),
      .SCFG(SCFG),
      .SAGT(SAGT)
  );

  typedef ahb_env#(MCFG, MAGT, SCFG, SAGT) env_t;

  `uvm_component_param_utils_begin(env_t)
  `uvm_component_utils_end

  function new(string name = "ahb_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : ahb_env

`endif // __AHB_ENV_SV__
