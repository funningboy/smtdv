`ifndef __SMTDV_CFG_SV__
`define __SMTDV_CFG_SV__

/*
* smtdv_cfg
*
    * @class smtdv_cfg
*/
class smtdv_cfg
  extends
  uvm_object;

  typedef smtdv_cfg cfg_t;

  uvm_component cmp;

  mod_type_t mod;
  rand bit has_force = TRUE;    // force virtual vif to drive DUT without normal DUT behavior, ex: preloading img or debug
  rand bit has_coverage = TRUE; // coverage report
  rand bit has_export = TRUE;   // export to smtdv sqlite3 database
  rand bit has_notify = TRUE;   // callback to event listener when notify event is triggered
  rand bit has_error = TRUE;    // support err response

  rand bit clock_req = 0; // Master Cfg =1, Slave Cfg =0

  constraint c_has_error { has_error == TRUE; }
  constraint c_has_force { has_force == TRUE; }
  constraint c_has_export { has_export == TRUE; }
  constraint c_has_notify { has_notify == TRUE; }
  constraint c_has_coverage { has_coverage == TRUE;}

  `uvm_object_param_utils_begin(cfg_t)
    `uvm_field_int(has_force, UVM_DEFAULT)
    `uvm_field_int(has_coverage, UVM_DEFAULT)
    `uvm_field_int(has_export, UVM_DEFAULT)
    `uvm_field_int(has_notify, UVM_DEFAULT)
    `uvm_field_int(has_error, UVM_DEFAULT)
    `uvm_field_int(clock_req, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "smtdv_cfg", uvm_component parent=null);
    super.new(name);
    cmp = parent;
  endfunction : new

endclass : smtdv_cfg


`endif // __SMTDV_CFG_SV__

