
`ifndef __SMTDV_CMP_NODE_SV__
`define __SMTDV_CMP_NODE_SV__

/*
* smtdv component(agent) node
*/
class smtdv_cmp_node#(
  type CMP = smtdv_agent
  ) extends
  smtdv_node;

  typedef smtdv_cmp_node#(CMP) node_t;

  CMP cmp;

  `uvm_object_param_utils_begin(node_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_cmp_node");
    super.new(name);
  endfunction : new

  extern virtual function void set(CMP icmp);
  extern virtual function CMP get();

// is_componment()

endclass : smtdv_cmp_node

/*
* set cmp(agent) ptr
*/
function void smtdv_cmp_node::set(CMP icmp);
  cmp = icmp;
endfunction : set

/*
* get cmp(agent) ptr
*/
function smtdv_cmp_node::CMP smtdv_cmp_node::get();
  return cmp;
endfunction : get


`endif // __SMTDV_CMP_NODE_SV__
