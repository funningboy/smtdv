
`ifndef __SMTDV_THREAD_HANDLER_SV__
`define __SMTDV_THREAD_HANDLER_SV__

typedef class smtdv_component;
typedef class smtdv_run_thread;

/**
* smtdv_thread_handler
* a basic thread handler to run itself(CMP) registered threads,
* like swap, stall, run
*
* @class smtdv_agent
*
*/
class smtdv_thread_handler #(
  type CMP = smtdv_component
  ) extends
  uvm_object;

  typedef smtdv_run_thread#(CMP) th_t;
  typedef smtdv_thread_handler#(CMP) hdler_t;

  CMP cmp;
  bit has_finalize = FALSE;
  longint uuid = -1;

  th_t thread_q[$];

  `uvm_object_param_utils_begin(hdler_t)
    `uvm_field_queue_object(thread_q, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "smtdv_thread_handler", CMP parent=null);
    super.new(name);
    cmp = parent;
  endfunction : new

  extern virtual function void register(CMP cmp);
  extern virtual function void add(th_t thread);
  extern virtual function void del(th_t thread);
  extern virtual function int successes();
  extern virtual function int fails();
  extern virtual function void finalize();
  extern virtual task run();

endclass : smtdv_thread_handler

/*
* get num of success threads
*/
function int smtdv_thread_handler::successes();
endfunction : successes

/*
* get num of fail threads
*/
function int smtdv_thread_handler::fails();
endfunction : fails

/*
* register handler to main component
*/
function void smtdv_thread_handler::register(CMP cmp);
  assert(cmp);
  this.cmp = cmp;
endfunction : register

/**
 *  add smtdv_run_thread to thread handler before finalize is done
 *  @return void
 */
function void smtdv_thread_handler::add(th_t thread);
  if (has_finalize) return;
  assert(thread);
  thread_q.push_back(thread);
endfunction : add

/**
*  del smtdv_run_thread from thread handler before finalize is done
*  @return void
*/
function void smtdv_thread_handler::del(th_t thread);
  int idx_q[$];

  if (has_finalize) return;
  assert(thread);

  idx_q= thread_q.find_index with (item == thread);
  if(idx_q.size() == 1) begin
    thread_q.delete(idx_q[0]);
    `uvm_info(get_full_name(),
    $sformatf("Delete a run thread called \"%s\" in run thread queue", thread.get_name()),
    UVM_FULL)
  end
  else begin
    `uvm_error("SMTDV_THHANDLER_ERR",
      $sformatf("find %0d run threads called \"%s\" in the run thread queue",
      idx_q.size(), thread.get_name()))
  end
endfunction : del


/**
 *  lock thread handler while all func calls are done
 *  @return void
 */
function void smtdv_thread_handler::finalize();
  has_finalize = TRUE;
endfunction : finalize


/**
 *  fork registered threads, and join all
 *
 */
task smtdv_thread_handler::run();
  begin: run_threads
  foreach (thread_q[i]) begin
    if (!thread_q[i].has_finalize) begin
      automatic int k;
      k = i;
      `uvm_info(get_full_name(),
        $sformatf("start to run thread \"%s\" in run thread queue", thread_q[k].get_name()),
        UVM_FULL)
        fork
          thread_q[k].run();
        join_none
        thread_q[i].has_finalize = TRUE;
      end
    end
  end
endtask : run


`endif // end of __SMTDV_THREAD_HANDLER_SV__
