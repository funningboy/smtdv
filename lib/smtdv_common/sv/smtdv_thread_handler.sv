
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
class smtdv_thread_handler#(
  type CMP = smtdv_component
  ) extends
  uvm_object;

  typedef smtdv_run_thread#(CMP) th_t;
  typedef smtdv_thread_handler#(CMP) hdler_t;

  CMP cmp;
  bit has_finalize = FALSE;

  time prestamp; // pre timestamp
  time curstamp; // cur timestamp
  rand longint timewin;
  rand longint sampwin;

  typedef struct {
    bit[0:0] on;
    th_t th;
  } thread_t;
  thread_t thread_q[$]; // thread queue

  constraint c_timewin { timewin inside {[1000:5000]}; } // watch time window is in range [1000:5000]ns
  constraint c_sampwin { sampwin inside {[100:300]};   } // sample watch time window

  `uvm_object_param_utils_begin(hdler_t)
    // not work for "unpack struct"
    //`uvm_field_queue_object(thread_q, UVM_ALL_ON)
    `uvm_field_int(prestamp, UVM_ALL_ON)
    `uvm_field_int(curstamp, UVM_ALL_ON)
    `uvm_field_int(timewin, UVM_ALL_ON)
    `uvm_field_int(sampwin, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "smtdv_thread_handler", uvm_component parent=null);
    super.new(name);
    register(parent);
  endfunction : new

  extern virtual function void register(uvm_component parent);
  extern virtual function void add(th_t thread, bit on=TRUE);
  extern virtual function void del(th_t thread);
  extern virtual function int succes();
  extern virtual function int fails();
  extern virtual function void finalize();
  extern virtual task run();
  extern virtual task watch();
  extern virtual task timer();
  extern virtual function void callback();

endclass : smtdv_thread_handler

/*
* get num of success threads
*/
function int smtdv_thread_handler::succes();
  return 0;
endfunction : succes

/*
* get num of fail threads
*/
function int smtdv_thread_handler::fails();
  return 0;
endfunction : fails

/*
* register handler to main component
*/
function void smtdv_thread_handler::register(uvm_component parent);
  if (!$cast(cmp, parent))
    `uvm_error("SMTDV_UCAST_CMP",
        {$psprintf("UP CAST TO SMTDV CMP FAIL")})

endfunction : register

/**
 *  add smtdv_run_thread to thread handler before finalize is done
 *  @return void
 */
function void smtdv_thread_handler::add(th_t thread, bit on=TRUE);
  if (has_finalize) return;
  assert(thread);
  thread_q.push_back('{on, thread});
endfunction : add

/**
*  del smtdv_run_thread from thread handler before finalize is done
*  @return void
*/
function void smtdv_thread_handler::del(th_t thread);
  int idx_q[$];

  if (has_finalize) return;
  assert(thread);

  idx_q= thread_q.find_index with (item.th == thread);

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
      if (!thread_q[i].th.has_finalize) begin
        automatic int k;
        k = i;

        // debug scoreboard.cmp.cfg???
        //if (cmp.cfg.has_debug)

        `uvm_info(get_full_name(),
           $sformatf("start to run thread \"%s\" in run thread queue", thread_q[k].th.get_name()), UVM_FULL)

        fork
          thread_q[k].th.run();
        join_none
        thread_q[k].th.has_finalize = TRUE;
      end
    end
  end
endtask : run


/*
*  start to watch threads are health or not
*/
task smtdv_thread_handler::watch();
  if (cmp.cfg.has_timer) begin: watch_threads
    prestamp = $time;
    fork
      timer();
    join_none
  end
endtask : watch


task smtdv_thread_handler::timer();
  `SMTDV_SWAP(sampwin)
  curstamp = $time;

  if ((curstamp-prestamp)>=timewin) begin
    foreach (thread_q[i]) begin
      if (!thread_q[i].on)
        continue;

      if (curstamp - thread_q[i].th.timestamp > timewin) begin
        thread_q[i].th.has_fail = TRUE;
        thread_q[i].th.err_msg =
            {$psprintf("RUN OUT OF THREAD LIFETIME, PLEASE ADD .update_timestamp() AT %s", get_full_name())};
        `uvm_error("SMTDV_WATCHDOG",
          thread_q[i].th.err_msg);
      end
    end
  end
  else begin
    prestamp = curstamp;
  end
endtask : timer


function void smtdv_thread_handler::callback();
endfunction : callback


`endif // end of __SMTDV_THREAD_HANDLER_SV__
