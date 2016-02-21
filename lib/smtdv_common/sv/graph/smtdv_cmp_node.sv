
`ifndef __SMTDV_CMP_NODE_SV__
`define __SMTDV_CMP_NODE_SV__

//typedef class smtdv_component;
//typedef class smtdv_base_item;
typedef class smtdv_cmp_edge;
typedef class smtdv_cmp_graph;

/*
* smtdv component(agent) node
*/
class smtdv_cmp_node#(
  type CMP = uvm_component,
  type T1 = smtdv_base_item
  ) extends
  smtdv_node;

  typedef smtdv_cmp_node#(CMP, T1) node_t;
  typedef smtdv_cmp_edge#(node_t, node_t, T1) edge_t;
  typedef smtdv_cmp_graph#(node_t, edge_t) graph_t;
  typedef uvm_object bgraph_t;

  CMP cmp;
  T1 item;
  mod_type_t mod;
  graph_t graph;

  `uvm_object_param_utils_begin(node_t)
    `uvm_field_object(graph, UVM_ALL_ON)
    `uvm_field_enum(mod_type_t, mod, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "smtdv_cmp_node");
    super.new(name);
  endfunction : new

  extern virtual function void set(CMP icmp, mod_type_t imod=MASTER);
  extern virtual function CMP get();
  extern virtual function void register(uvm_object parent=null);

endclass : smtdv_cmp_node

/*
* cast to smtdv_cmp_graph
*/
function void smtdv_cmp_node::register(uvm_object parent=null);
  if (!$cast(graph, parent))
    `uvm_error("SMTDV_UCAST_CMP_GRAPH",
        {$psprintf("UP CAST TO SMTDV CMP_GRAPH FAIL")})

endfunction : register

/*
* set cmp(agent) ptr
*/
function void smtdv_cmp_node::set(smtdv_cmp_node::CMP icmp, mod_type_t imod=MASTER);
  if (!$cast(cmp, icmp))
    `uvm_error("SMTDV_DCAST_CMP",
        {$psprintf("DOWN CAST TO SMTDV CMP FAIL")})

  mod = imod;
endfunction : set

/*
* get cmp(agent) ptr
*/
function smtdv_cmp_node::CMP smtdv_cmp_node::get();
  return cmp;
endfunction : get


`endif // __SMTDV_CMP_NODE_SV__
