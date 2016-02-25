
`ifndef __SMTDV_RUN_LABEL_SV__
`define __SMTDV_RUN_LABEL_SV__

typedef class smtdv_component;
typedef class smtdv_cfg;
typedef class smtdv_sequence_item;

/**
* smtdv_run_label
* a basic lightweight label task, that should be overridden at top main label
* task.
* ex: update_cfg_label, export_path_label
*
* @class smtdv_run_label
*
*/
class smtdv_run_label#(
  type CMP = uvm_component
  ) extends
    uvm_object;

  typedef smtdv_run_label#(CMP) label_t;

  bit has_finalize = FALSE;
  CMP cmp;

  `uvm_object_param_utils_begin(label_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_run_label", uvm_component parent=null);
    super.new(name);
    register(parent);
  endfunction : new

  extern virtual function void register(uvm_component parent);
  extern virtual function void run(); // only for function no timing info
  extern virtual function void pre_do();
  extern virtual function void mid_do();
  extern virtual function void post_do();

endclass : smtdv_run_label

/*
* register cmp to label
*/
function void smtdv_run_label::register(uvm_component parent);
endfunction : register

function void smtdv_run_label::pre_do();
endfunction : pre_do

function void smtdv_run_label::mid_do();
endfunction : mid_do

function void smtdv_run_label::post_do();
endfunction : post_do

/**
*  override this when running task
*  @return void
*/
function void smtdv_run_label::run();
  `uvm_info(get_full_name(),
      $sformatf("Starting run label ..."), UVM_HIGH)

  pre_do();
  post_do();
endfunction : run


`endif // __SMTDV_RUN_LABEL_SV__
