
`ifndef __SMTDV_CMP_EDGE_SV__
`define __SMTDV_CMP_EDGE_SV__

typedef class smtdv_sequence_item;
typedef class smtdv_cmp_node;

class smtdv_cmp_edge#(
  type SOURCE = smtdv_cmp_node,
  type SINK = smtdv_cmp_node,
  type T1 = smtdv_sequence_item
  ) extends
    smtdv_edge#(
      .SOURCE(SOURCE),
      .SINK(SINK)
  );

  typedef smtdv_cmp_edge#(SOURCE, SINK, T1) edge_t;
  T1 item;

  `uvm_object_param_utils_begin(edge_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_cmp_edge");
    super.new(name);
  endfunction : new

//  extern virtual function void update_item(T1 item);

endclass : smtdv_cmp_edge

`endif // __SMTDV_CMP_EDGE_SV__
