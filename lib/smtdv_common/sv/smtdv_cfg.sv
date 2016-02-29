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

  rand bit has_debug;        // turn on debug mode

  rand bit has_force;    // force virtual vif to drive DUT without normal DUT behavior, ex: preloading img or debug
  rand bit has_coverage; // coverage report
  rand bit has_export;   // export to smtdv sqlite3 database
  rand bit has_notify;   // callback to event listener when notify event is triggered
  rand bit has_error;    // support err response
  rand bit has_block;    // block trx
  rand bit has_timer;    // turn on timer
  rand bit has_flush;    // flush all seqs at seqr

  rand bit clock_req;    // Master Cfg =1, Slave Cfg =0

  int stlid;  // replay preload stl id

  constraint c_has_debug { has_debug inside {FALSE, TRUE}; }
  constraint c_has_error { has_error inside {FALSE, TRUE}; }
  constraint c_has_force { has_force inside {FALSE, TRUE}; }
  constraint c_has_export { has_export inside {FALSE, TRUE}; }
  constraint c_has_notify { has_notify inside {FALSE, TRUE}; }
  constraint c_has_coverage { has_coverage inside {FALSE, TRUE}; }
  constraint c_has_block { has_block inside {FALSE}; }
  constraint c_has_timer { has_timer inside {TRUE}; }
  constraint c_has_flush { has_flush inside {FALSE}; }

  `uvm_object_param_utils_begin(cfg_t)
    `uvm_field_int(has_debug, UVM_DEFAULT)
    `uvm_field_int(has_block, UVM_DEFAULT)
    `uvm_field_int(has_force, UVM_DEFAULT)
    `uvm_field_int(has_coverage, UVM_DEFAULT)
    `uvm_field_int(has_export, UVM_DEFAULT)
    `uvm_field_int(has_notify, UVM_DEFAULT)
    `uvm_field_int(has_error, UVM_DEFAULT)
    `uvm_field_int(has_block, UVM_DEFAULT)
    `uvm_field_int(has_timer, UVM_DEFAULT)
    `uvm_field_int(has_flush, UVM_DEFAULT)
    `uvm_field_int(clock_req, UVM_DEFAULT)
    `uvm_field_int(stlid, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "smtdv_cfg", uvm_component parent=null);
    super.new(name);
    if (!$cast(cmp, parent))
      `uvm_error("SMTDV_UCAST_CMP",
        {$psprintf("UP CAST TO SMTDV CMP FAIL")})

  endfunction : new

endclass : smtdv_cfg


`endif // __SMTDV_CFG_SV__

