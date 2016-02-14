

`ifndef __SMTDV_SEQ_GRAPH_SV__
`define __SMTDV_SEQ_GRAPH_SV__

//typedef class smtdv_sequence;
typedef class smtdv_graph;
typedef class smtdv_seq_node;
typedef class smtdv_seq_edge;

class smtdv_seq_graph#(
  type NODE = smtdv_seq_node,
  type EDGE = smtdv_seq_edge#(smtdv_seq_node, smtdv_seq_node)
  )extends
  smtdv_graph#(
    .NODE(NODE),
    .EDGE(EDGE)
  );

  typedef smtdv_seq_graph#(NODE, EDGE) graph_t;

  `uvm_object_param_utils_begin(graph_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_seq_graph");
    super.new(name);
  endfunction : new

endclass : smtdv_seq_graph


`endif // __SMTDV_SEQ_GRAPH_SV__
