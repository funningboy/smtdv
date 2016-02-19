
`ifndef __SMTDV_SEQ_EDGE_SV__
`define __SMTDV_SEQ_EDGE_SV__

//typedef class smtdv_sequence;
typedef class smtdv_seq_node;
typedef class smtdv_seq_graph;


class smtdv_seq_edge#(
  type SOURCE = smtdv_seq_node,
  type SINK = SOURCE
  ) extends
    smtdv_edge#(
      .SOURCE(SOURCE),
      .SINK(SINK)
  );

  typedef smtdv_seq_edge#(SOURCE, SINK) edge_t;
  typedef SOURCE node_t;
  typedef smtdv_seq_graph#(node_t, edge_t) graph_t;
  typedef uvm_object bgraph_t;

  graph_t graph;

  `uvm_object_param_utils_begin(edge_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_seq_edge");
    super.new(name);
  endfunction : new

  extern virtual function void register(uvm_object parent=null);

endclass : smtdv_seq_edge

/*
* cast from object to smtdv_seq_graph
*/
function void smtdv_seq_edge::register(uvm_object parent=null);
  if (!$cast(graph, parent))
    `uvm_error("SMTDV_UCAST_SEQ_GRAPH",
        {$psprintf("UP CAST TO SMTDV SEQ_GRAPH FAIL")})

endfunction : register


`endif // __SMTDV_SEQ_EDGE_SV__
