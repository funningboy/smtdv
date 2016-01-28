
`ifndef __SMTDV_SEQ_NODE_SV__
`define __SMTDV_SEQ_NODE_SV__

/*
* smtdv sequence node
*/
class smtdv_seq_node#(
  type SEQ = smtdv_sequence // as uvm_sequence
  ) extends
  smtdv_node;

  typedef smtdv_seq_node#(SEQ) node_t;

  SEQ seq;

  `uvm_object_param_utils_begin(node_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_seq_node");
    super.new(name);
  endfunction : new

  extern virtual function void set(SEQ iseq);
  extern virtual function SEQ get();
// is_sequence_item()

endclass : smtdv_seq_node

function void smtdv_seq_node::set(SEQ iseq);
  seq = iseq;
endfunction : set

function smtdv_seq_node::SEQ smtdv_seq_node::get();
  return seq;
endfunction : get

`endif // __SMTDV_SEQ_NODE_SV__
