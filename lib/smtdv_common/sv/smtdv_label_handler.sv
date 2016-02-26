
`ifndef __SMTDV_LABEL_HANDLER_SV__
`define __SMTDV_LABEL_HANDLER_SV__

typedef class smtdv_test;
typedef class smtdv_run_label;
typedef class smtdv_label_handler;

/* a static global label handler,
* collect label item from whole system and do itself run task
*
*/
class smtdv_label_handler
  extends
  uvm_object;

  typedef smtdv_run_label lab_t;
  typedef smtdv_label_handler hdler_t;
  typedef smtdv_test test_t;
  typedef smtdv_queue#(lab_t) queue_t;

  static test_t test;
  static queue_t mbox;

  bit has_finalize = FALSE;

  `uvm_object_param_utils_begin(hdler_t)
    //`uvm_field_queue_object(label_q, UVM_ALL_ON)
  `uvm_object_utils_end

  extern static function void register(uvm_component parent);
  extern static function void add(lab_t label, bit on=TRUE);
  extern static function void del(lab_t label);
  extern static function void finalize();
  extern static function void run();

endclass : smtdv_label_handler

/*
* default smtdv_label_handler should be registered at uvm_test level
*/
function void smtdv_label_handler::register(uvm_component parent);
  if (!$cast(test, parent))
    `uvm_error("SMTDV_UCAST_CMP",
        {$psprintf("UP CAST TO SMTDV CMP FAIL")})
endfunction : register


function void smtdv_label_handler::add(lab_t label, bit on=TRUE);
  if (has_finalize) return;

  assert(label);
  label_q.push_back('{on, label});
endfunction : add


function void smtdv_label_handler::del(lab_t label);
  int idx_q[$];

  if (has_finalize) return;

  assert(label);
  idx_q = label_q.find_index with (item.lab == label);
  if (idx_q.size() == 1) begin
    label_q.delete(idx_q[0]);
  end
  else begin
    `uvm_error("SMTDV_LBHANDLER_ERR",
      $sformatf("find %0d run label called \"%s\" in the monitor run label queue",
      idx_q.size(), label.get_name()))
  end
endfunction : del


function void smtdv_label_handler::finalize();
  has_finalize = TRUE;
endfunction : finalize


function void smtdv_label_handler::run();
  begin : run_labels
    foreach (label_q[i]) begin
      if (!label_q[i].lab.has_finalize) begin
        automatic int k;
        k = i;

        if (test.has_debug)
          `uvm_info(get_full_name(),
             $sformatf("start to run label \"%s\" in run label queue", label_q[k].lab.get_name()), UVM_FULL)

        fork
          label_q[k].lab.run();
        join_none
        label_q[k].lab.has_finalize = TRUE;
      end
    end
  end
endfunction : run

`endif // end of __SMTDV_LABEL_HANDLER_SV__
