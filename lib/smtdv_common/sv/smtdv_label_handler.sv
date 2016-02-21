
`ifndef __SMTDV_LABEL_HANDLER_SV__
`define __SMTDV_LABEL_HANDLER_SV__

/* a static global label handler,
* collect label item from whole system and do itself run task
*
*/
class smtdv_label_handler
  extends
  uvm_object;

  typedef smtdv_run_label lab_t;
  typedef smtdv_label_handler hdler_t;
  typedef uvm_component cmp_t;

  static bit has_finalize = FALSE;
  static longint uuid = -1;
  static cmp_t cmp;
  static lab_t  label_q[$];

  `uvm_object_param_utils_begin(hdler_t)
    `uvm_field_queue_object(label_q, UVM_ALL_ON)
  `uvm_object_utils_end

  extern static function void register(uvm_component icmp);
  extern static function void add(lab_t label);
  extern static function void del(lab_t label);
  extern static function void finalize();
  extern static function void run();

  //static
endclass : smtdv_label_handler

/*
* default smtdv_label_handler should be registered at uvm_test level
*/
function void smtdv_label_handler::register(uvm_component icmp);
  assert(icmp);
  if (!$cast(cmp, icmp))
    `uvm_error("SMTDV_UCAST_CMP",
        {$psprintf("UP CAST TO SMTDV CMP FAIL")})
endfunction : register


function void smtdv_label_handler::add(lab_t label);
  if (has_finalize) return;
  assert(label);
  label_q.push_back(label);
endfunction : add


function void smtdv_label_handler::del(lab_t label);
  int idx_q[$];

  if (has_finalize) return;
  assert(label);

  idx_q = label_q.find_index with (item == label);
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

// TODO
function void smtdv_label_handler::run();
  begin : run_labels
  foreach (label_q[i]) begin
  end
  end
endfunction : run

`endif // end of __SMTDV_LABEL_HANDLER_SV__
