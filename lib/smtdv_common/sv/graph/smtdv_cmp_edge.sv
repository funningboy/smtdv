
`ifndef __SMTDV_CMP_EDGE_SV__
`define __SMTDV_CMP_EDGE_SV__

//typedef class smtdv_base_item;
//typedef class smtdv_component;
typedef class smtdv_cmp_node;
typedef class smtdv_cmp_graph;


class smtdv_cmp_edge#(
  type SOURCE = smtdv_cmp_node#(uvm_component, uvm_sequence_item),
  type SINK = SOURCE,
  type T1 = uvm_sequence_item,
  integer SIZE = 10 // collected latest trxs when label event has triigered from monitor
  ) extends
    smtdv_edge#(
      .SOURCE(SOURCE),
      .SINK(SINK)
  );

  typedef smtdv_cmp_edge#(SOURCE, SINK, T1) edge_t;
  typedef smtdv_cmp_graph#(SOURCE, edge_t) graph_t;
  typedef smtdv_phy_queue#(SIZE, T1) queue_t;
  typedef uvm_object bgraph_t;

  queue_t items;
  graph_t graph;

  `uvm_object_param_utils_begin(edge_t)
    `uvm_field_object(graph, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "smtdv_cmp_edge");
    super.new(name);
    items = queue_t::type_id::create("items");
  endfunction : new

  extern virtual function void register(uvm_object parent=null);
  extern virtual function void update_item(T1 item);

endclass : smtdv_cmp_edge

/*
* cast from object to smtdv_cmp_graph
*/
function void smtdv_cmp_edge::register(uvm_object parent=null);
  if (!$cast(graph, parent))
    `uvm_error("SMTDV_UCAST_SEQ_GRAPH",
        {$psprintf("UP CAST TO SMTDV SEQ_GRAPH FAIL")})

endfunction : register


function void smtdv_cmp_edge::update_item(smtdv_cmp_edge::T1 item);
  items.shit_left(item);
endfunction : update_item

`endif // __SMTDV_CMP_EDGE_SV__
