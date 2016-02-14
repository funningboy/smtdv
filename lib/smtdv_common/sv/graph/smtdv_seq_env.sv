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
  obj_t seqs[$];

  `uvm_object_param_utils_begin(seq_env_t)
    `uvm_field_object(seq_blder, UVM_ALL_ON)
    `uvm_field_queue_object(seqs, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "smtdv_seq_env");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    obj_t parent;
    seq_blder = seq_blder_t::type_id::create("smtdv_seq_graph_builder");
    $cast(parent, this);
    seq_blder.register(parent);
  endtask : pre_body

  virtual function bit has_seq(int seqid);
    return seqid < seqs.size() && seqid >= 0;
  endfunction : has_seq

endclass : smtdv_seq_env

`endif // __SMTDV_SEQ_ENV_SV__
