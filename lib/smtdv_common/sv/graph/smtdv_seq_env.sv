`ifndef __SMTDV_SEQ_ENV_SV__
`define __SMTDV_SEQ_ENV_SV__

//typedef class uvm_sequence_item
//typedef class smtdv_sequence
typedef class smtdv_seq_graph_builder;

class smtdv_seq_env
  extends
  uvm_sequence;

  typedef smtdv_seq_env seq_env_t;
  typedef smtdv_seq_graph_builder seq_blder_t;
  typedef uvm_object obj_t;

  seq_blder_t seq_blder;

  `uvm_object_param_utils_begin(seq_env_t)
    `uvm_field_object(seq_blder, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "smtdv_seq_env");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    obj_t parent;
    super.pre_body();

    seq_blder = seq_blder_t::type_id::create("smtdv_seq_graph_builder");

    if (!$cast(parent, this))
      `uvm_error("SMTDV_DCAST_SEQ_GRAPH",
        {$psprintf("DOWN CAST TO SMTDV SEQ_GRAPH FAIL")})

    seq_blder.register(parent);
  endtask : pre_body

endclass : smtdv_seq_env

`endif // __SMTDV_SEQ_ENV_SV__
