
`ifndef __SMTDV_GRAPH_SCHEDULER_SV__
`define __SMTDV_GRAPH_SCHEDULER_SV__

typedef class smtdv_node;
typedef class smtdv_edge;
typedef class smtdv_graph;

class smtdv_graph_scheduler#(
  type NODE = smtdv_node,
  type EDGE = smtdv_edge#(smtdv_node, smtdv_node),
  type GRAPH = smtdv_graph
  )extends
  smtdv_component#(uvm_env);

  typedef smtdv_graph_scheduler#(NODE, EDGE, GRAPH) schdlr_t;

  GRAPH graph;
  NODE node;
  EDGE tedge;

  `uvm_object_param_utils_begin(schdlr_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_graph_scheduler");
    super.new(name);
  endfunction : new

  extern virtual function void register(GRAPH parent);
  extern virtual task run();
endclass : smtdv_graph_scheduler

function void smtdv_graph_scheduler::register(smtdv_graph_scheduler::GRAPH parent);
  graph = parent;
endfunction : register

task smtdv_graph_scheduler::run();
  int nodeids[$];

  graph.get_nodes(nodeids);
  fork
    foreach(nodeids[i]) begin
      automatic int k;
      automatic NODE node;
      k = i;
      node = graph.get_node(nodeids[k]);
      node.run();
    end
  join

endtask : run


`endif // __SMTDV_GRAPH_SCHEDULER_SV__
