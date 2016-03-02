
`ifndef __SMTDV_LABEL_HANDLER_SV__
`define __SMTDV_LABEL_HANDLER_SV__

typedef class smtdv_test;
typedef class smtdv_run_label;

/* a static global label handler,
* collect label item from whole system and do itself run task
*
*/
class smtdv_label_handler
  extends
  uvm_object;

  typedef uvm_component cmp_t;
  typedef uvm_object obj_t;
  typedef smtdv_base_item item_t;
  typedef smtdv_label_handler hdler_t;
  typedef smtdv_test test_t;
  typedef smtdv_run_label lab_t;
  typedef smtdv_queue#(item_t) item_q_t;

  typedef struct {
    bit[0:0] on;
    lab_t lab;
  } label_t;
  static label_t label_q[$];

  static test_t test;
  static item_q_t item_q;
  static bit has_finalize = FALSE;

  `uvm_object_param_utils_begin(hdler_t)
    //`uvm_field_queue_object(label_q, UVM_ALL_ON)
  `uvm_object_utils_end

  extern static task push_item(item_t item);
  extern static function void register(uvm_component parent);
  extern static function void add(lab_t label, bit on=TRUE);
  extern static function void del(lab_t label);
  extern static function void finalize();
  extern static task run();
  extern static task dec_labels();
  extern static task spawn_labels();

endclass : smtdv_label_handler

task smtdv_label_handler::push_item(item_t item);
  item_q.async_push_back(item);
endtask : push_item

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


task smtdv_label_handler::dec_labels();
  item_q = item_q_t::type_id::create("item_q");

  foreach (label_q[i]) begin
    if (!label_q[i].lab.has_finalize) begin
      //if (test.has_debug)
      //  `uvm_info(get_full_name(),
      //     $sformatf("start to run label \"%s\" in run label queue", label_q[i].lab.get_name()), UVM_FULL)

      // call by itself
      //label_q[i].lab.has_finalize = TRUE;
    end
  end
endtask : dec_labels


task smtdv_label_handler::spawn_labels();
  item_t item;

  forever begin
    item_q.async_prio_get(0, item);

    foreach(label_q[i]) begin
      if (label_q[i].on) begin
        label_q[i].lab.update_item(item);
        label_q[i].lab.run();
      end
    end

  end

endtask : spawn_labels


task smtdv_label_handler::run();
  dec_labels();

  fork
    spawn_labels();
  join_none

endtask : run

`endif // end of __SMTDV_LABEL_HANDLER_SV__
