
`ifndef __SMTDV_THREAD_HANDLER_SV__
`define __SMTDV_THREAD_HANDLER_SV__

class smtdv_thread_handler #(type CFG = uvm_object)
  extends smtdv_component#(uvm_component);

  CFG cfg;
  bit has_on = 1;
  longint uuid = -1;

  smtdv_run_thread thread_q[$];

  `uvm_component_param_utils_begin(smtdv_thread_handler#(CFG))
    // Cadence doesn't support this registration
    `uvm_field_queue_object(thread_q, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "smtdv_thread_handler", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void add(smtdv_run_thread thread);
    if (thread == null) return;
    thread_q.push_back(thread);
  endfunction

  virtual function void del(smtdv_run_thread thread);
    int idx_q[$];

    if(thread == null) return;

    idx_q= thread_q.find_index with (item == thread);
    if(idx_q.size() == 1) begin
      thread_q.delete(idx_q[0]);
      `uvm_info(get_full_name(),
        $sformatf("Delete a run thread called \"%s\" in run thread queue", thread.get_name()),
        UVM_FULL)
      end
    else begin
      `uvm_error(get_full_name(),
        $sformatf("find %0d run threads called \"%s\" in the monitor run thread queue",
          idx_q.size(), thread.get_name()))
      end
  endfunction

  virtual function void finalize();
  endfunction

  virtual task run();
    begin: run_threads
      foreach (thread_q[i]) begin
        if (~thread_q[i].has_finalize) begin
          automatic int k;
          k = i;
          `uvm_info(get_full_name(),
            $sformatf("start to run thread \"%s\" in run thread queue", thread_q[k].get_name()),
            UVM_FULL)
          fork
            thread_q[k].run();
          join_none
          thread_q[i].has_finalize = 1'b1;
        end
      end
    end
  endtask

endclass

`endif // end of __SMTDV_THREAD_HANDLER_SV__
