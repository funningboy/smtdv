`ifndef __SMTDV_THREAD_SV__
`define __SMTDV_THREAD_SV__

typedef class smtdv_component;

/**
* smtdv_run_thread
* a lightweight thread recorder to record each cmp's status
*
*
* @class smtdv_run_thread
*
*/
class smtdv_run_thread #(
  type CMP = smtdv_component
 ) extends
  uvm_object;

  typedef smtdv_run_thread#(CMP) th_t;

  CMP cmp;
  bit [0:0] has_finalize = 0;
  // status run, idle, dead...

  `uvm_object_param_utils_begin(th_t)
    `uvm_field_int(has_finalize, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "smtdv_run_thread", CMP parent=null);
    super.new(name);
    cmp = parent;
  endfunction : new

  extern virtual function void pre_do();
  extern virtual function void post_do();
  extern virtual task run();

endclass : smtdv_run_thread


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
