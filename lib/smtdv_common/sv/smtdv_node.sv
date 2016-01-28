
`ifndef __SMTDV_NODE_SV__
`define __SMTDV_NODE_SV__

typedef class smtdv_agent;
typedef class smtdv_sequence;

/*
* smtdv basic node
*/
class smtdv_node
  extends
  uvm_object;

  typedef smtdv_node node_t;

  bit has_finalize = FALSE;

  `uvm_object_param_utils_begin(node_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_node");
    super.new(name);
  endfunction : new

  extern virtual function void finalize();

endclass : smtdv_node

function void smtdv_node::finalize();
  has_finalize = TRUE;
endfunction : finalize


`endif // __ SMTDV_NODE_SV__
