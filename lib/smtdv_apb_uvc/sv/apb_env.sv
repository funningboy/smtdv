`ifndef __APB_ENV_SV__
`define __APB_ENV_SV__

typedef class apb_master_cfg;
typedef class apb_master_agent;
typedef class apb_slave_cfg;
typedef class apb_slave_agent;

class apb_env#(
  type MCFG = apb_master_cfg,
  type MAGT = apb_master_agent,
  type SCFG = apb_slave_cfg,
  type SAGT = apb_slave_agent
  )
  extends
    smtdv_env#(
      .MCFG(MCFG),
      .MAGT(MAGT),
      .SCFG(SCFG),
      .SAGT(SAGT)
  );

  typedef apb_env#(MCFG, MAGT, SCFG, SAGT) env_t;

  `uvm_component_param_utils_begin(env_t)
  `uvm_component_utils_end

  function new(string name = "apb_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : apb_env

`endif // __APB_ENV_SV__
