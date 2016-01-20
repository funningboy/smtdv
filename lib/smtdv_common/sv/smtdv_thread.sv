`ifndef __SMTDV_THREAD_SV__
`define __SMTDV_THREAD_SV__

typedef class smtdv_component;

/**
* smtdv_run_thread
* a basic lightweight thread, that should be overridden at top main run thread
* ex: collect_item_thread, export_item_thread ...
*
* @class smtdv_run_thread
*
*/
class smtdv_run_thread#(
  type CMP = smtdv_component
 ) extends
  uvm_object;

  typedef smtdv_run_thread#(CMP) th_t;

  CMP cmp;
  bit has_finalize = FALSE;
  bit has_fail = FALSE;
  bit has_success = FALSE;

  // status run, idle, dead...

  `uvm_object_param_utils_begin(th_t)
    `uvm_field_int(has_finalize, UVM_DEFAULT)
    `uvm_field_int(has_fail, UVM_DEFAULT)
    `uvm_field_int(has_success, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "smtdv_run_thread", CMP parent=null);
    super.new(name);
    cmp = parent;
  endfunction : new

  extern virtual function void register(CMP icmp);
  extern virtual function void pre_do();
  extern virtual function void post_do();
  extern virtual task run();

endclass : smtdv_run_thread

/*
* register thread to main component
*/
function void smtdv_run_thread::register(CMP icmp);
  assert(icmp);
  cmp = icmp;
endfunction : register


/**
 *  override this when start of run task
 *  @return void
 */
function void smtdv_run_thread::pre_do();
endfunction : pre_do

/**
 *  override this when end of run task
 *  @return void
 */
function void smtdv_run_thread::post_do();
endfunction: post_do


/**
 *  override this when running task
 *  @return void
 */
task smtdv_run_thread::run();
  pre_do();
  `uvm_info(get_full_name(), $sformatf("Starting run thread ..."), UVM_HIGH)
  post_do();
endtask : run


`endif // end of __SMTDV_THREAD_SV__
