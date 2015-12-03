
`ifndef __SMTDV_ENV_SV__
`define __SMTDV_ENV_SV__

class smtdv_env extends smtdv_component#(uvm_env);

  //as virtual class should be implemented at top level env
  //smtdv_cfg   master_cfg[$];
  //smtdv_agent master_agent[$];
  //smtdv_cfg   slave_cfg[$];
  //smtdv_agent slave_agent[$];

  function new(string name = "smtdv_env", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass : smtdv_env

`endif // end of __SMTDV_ENV_SV__
