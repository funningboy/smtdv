
`ifndef __SMTDV_ADAPTER_AGENT_SV__
`define __SMTDV_ADAPTER_AGENT_SV__

/*
* back2back Slave 2 Master fw controler
*/
class smtdv_adapter_agent#(
  type MCFG = smtdv_master_cfg,
  type MAGT = smtdv_master_agent,
  type SCFG = smtdv_slave_cfg,
  type SAGT = smtdv_slave_agent
);

endclass : smtdv_adapter_agent

`endif // __SMTDV_ADAPTER_AGENT_SV__
