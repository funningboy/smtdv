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

  string err_msg;
  time timestamp = $time;

  // status run, idle, dead...

  `uvm_object_param_utils_begin(th_t)
    `uvm_field_int(has_finalize, UVM_DEFAULT)
    `uvm_field_int(has_fail, UVM_DEFAULT)
    `uvm_field_int(timestamp, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "smtdv_run_thread", uvm_component parent=null);
    super.new(name);
    register(parent);
   endfunction : new

  extern virtual function void update_timestamp();
  extern virtual function void register(uvm_component parent);
  extern virtual function void pre_do();
  extern virtual function void mid_do();
  extern virtual function void post_do();
  extern virtual function void callback();
  extern virtual task run();

endclass : smtdv_run_thread

/*
* register thread to main component
*/
function void smtdv_run_thread::register(uvm_component parent);
  if (!$cast(cmp, parent))
    `uvm_error("SMTDV_UCAST_CMP",
        {$psprintf("UP CAST TO SMTDV CMP FAIL")})

endfunction : register

/**
 *  override this when start of run task
 */
function void smtdv_run_thread::pre_do();
endfunction : pre_do

/**
 *  override this when mid of run task
 */
function void smtdv_run_thread::mid_do();
endfunction : mid_do


/**
 *  override this when end of run task
 */
function void smtdv_run_thread::post_do();
endfunction: post_do


/**
 *  override this when running task
 */
task smtdv_run_thread::run();
  `uvm_info(get_full_name(), $sformatf("Starting run thread ..."), UVM_HIGH)
  pre_do();
  mid_do();
  post_do();
endtask : run

/**
* need be called at top thread when smtdv_thread_handler is run into debug mode
*/
function void smtdv_run_thread::update_timestamp();
  timestamp = $time;
endfunction : update_timestamp

/*
* virtual callback func must be imp at top level
*/
function void smtdv_run_thread::callback();
endfunction : callback


`endif // end of __SMTDV_THREAD_SV__
