
`ifndef __SMTDV_RUN_LABEL_SV__
`define __SMTDV_RUN_LABEL_SV__

typedef class smtdv_component;

/**
* smtdv_run_label
* a basic lightweight recorder, that should be overridden at top main label
* task.
* ex: force_vif_label, force_replay_label
*
* @class smtdv_run_label
*
*/
class smtdv_run_label
  extends
  uvm_object;

  typedef smtdv_run_label label_t;
  typedef uvm_object obj_t;
  typedef uvm_component cmp_t;
  typedef smtdv_base_item bitem_t;

  cmp_t cmp;

  label_t pre = null;
  label_t next = null;

  bit has_finalize = FALSE;
  bit has_ready = FALSE;

  `uvm_object_param_utils_begin(label_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_run_label", uvm_component parent=null);
    super.new(name);
  endfunction : new

  extern virtual function void run(); // only for function no timing info
  extern virtual function void pre_do();
  extern virtual function void mid_do();
  extern virtual function void post_do();
  extern virtual function void flush();
  extern virtual function void callback();
  extern virtual function void populate();
  extern virtual function void update_item(bitem_t bitem);

endclass : smtdv_run_label

function void smtdv_run_label::pre_do();
endfunction : pre_do

function void smtdv_run_label::mid_do();
endfunction : mid_do

function void smtdv_run_label::post_do();
endfunction : post_do

/**
*  override this when running task
*/
function void smtdv_run_label::run();
  if (!has_finalize)
    `uvm_info(get_full_name(),
      $sformatf("Starting run label ..."), UVM_HIGH)

  has_finalize = TRUE;

  if (has_ready) begin
    pre_do();
    mid_do();
    post_do();
  end
endfunction : run

function void smtdv_run_label::callback();
endfunction : callback

function void smtdv_run_label::populate();
endfunction : populate

function void smtdv_run_label::update_item(bitem_t bitem);
endfunction : update_item

function void smtdv_run_label::flush();
endfunction : flush

`endif // __SMTDV_RUN_LABEL_SV__
