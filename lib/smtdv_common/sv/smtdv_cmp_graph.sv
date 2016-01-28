
`ifndef __SMTDV_CMP_GRAPH_SV__
`define __SMTDV_CMP_GRAPH_SV__

typedef class smtdv_graph;
typedef class smtdv_cmp_node;
typedef class smtdv_cmp_edge;

class smtdv_cmp_graph
  extends
  smtdv_graph;

  typedef smtdv_cmp_graph graph_t;

  `uvm_object_param_utils_begin(graph_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_cmp_graph");
    super.new(name);
  endfunction : new

endclass : smtdv_cmp_graph


`endif // __SMTDV_CMP_GRAPH_SV__
