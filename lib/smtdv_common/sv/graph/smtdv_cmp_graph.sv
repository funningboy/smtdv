
`ifndef __SMTDV_CMP_GRAPH_SV__
`define __SMTDV_CMP_GRAPH_SV__

//typedef class smtdv_base_item;
//typedef class smtdv_component;
typedef class smtdv_graph;
typedef class smtdv_cmp_node;
typedef class smtdv_cmp_edge;


class smtdv_cmp_graph#(
  type NODE = smtdv_cmp_node#(uvm_component, smtdv_base_item),
  type EDGE = smtdv_cmp_edge#(NODE, NODE, smtdv_base_item)
  )extends
  smtdv_graph#(
    .NODE(NODE),
    .EDGE(EDGE)
  );

  typedef smtdv_cmp_graph#(NODE, EDGE) graph_t;

  `uvm_object_param_utils_begin(graph_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_cmp_graph");
    super.new(name);
  endfunction : new

endclass : smtdv_cmp_graph


`endif // __SMTDV_CMP_GRAPH_SV__
