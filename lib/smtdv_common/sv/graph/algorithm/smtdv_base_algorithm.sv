
`ifndef __SMTDV_BASE_ALGORITHM_SV__
`define __SMTDV_BASE_ALGORITHM_SV__

typedef class smtdv_edge;
typedef class smtdv_node;
typedef class smtdv_graph;

class smtdv_base_algorithm#(
  type NODE = smtdv_node,
  type EDGE = smtdv_edge#(NODE, NODE),
  type GRAPH = smtdv_graph#(NODE, EDGE)
  )extends
  uvm_object;

  typedef smtdv_base_algorithm#(NODE, EDGE, GRAPH) alg_t;

  GRAPH G;
  bit has_debug = FALSE;

  `uvm_object_param_utils_begin(alg_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_base_algorithm");
    super.new(name);
  endfunction : new

  extern virtual function void set_graph(GRAPH graph);
  extern virtual function void find_initors(ref int nodeids[$]);
  extern virtual function void find_targets(ref int nodeids[$]);
  extern virtual function void find_startids(int startid=-1, ref int startids[$]);
  extern virtual function void find_endids(int endid=-1, ref int endids[$]);
//  extern virtual function void sort_nodes(attr);
//  extern virtual function void sort_edges(attr);
//  extern virtual function void sort_paths(attr);
//
  extern virtual function bit is_directed_graph();
  extern virtual function bit is_circular_graph();

endclass : smtdv_base_algorithm


/*
* set graph
*/
function void smtdv_base_algorithm::set_graph(GRAPH graph);
  G = graph;
endfunction : set_graph

/*
* find_initors, get all unique initors
*/
function void smtdv_base_algorithm::find_initors(ref int nodeids[$]);
  EDGE tedge;
  int founds[$], sinkids[$];
  for(int i=0; i<G.edge_q.size(); i++) begin
    tedge = G.edge_q.get(i);
    if (!G.is_sink(tedge.sourceid, sinkids)) begin
      founds = nodeids.find_first_index(item) with (item == tedge.sinkid);
      if (founds.size()==0)
        nodeids.push_back(tedge.sourceid);
    end
  end
endfunction : find_initors

/*
* find_targets, get all unique targets
*/
function void smtdv_base_algorithm::find_targets(ref int nodeids[$]);
  EDGE tedge;
  int founds[$], sourceids[$];
  for(int i=0; i<G.edge_q.size(); i++) begin
    tedge = G.edge_q.get(i);
    if (!G.is_source(tedge.sinkid, sourceids)) begin
      founds = nodeids.find_first_index(item) with (item == tedge.sinkid);
      if (founds.size()==0)
        nodeids.push_back(tedge.sinkid);
    end
  end
endfunction : find_targets

/*
* startids, default startids = initorids
*/
function void smtdv_base_algorithm::find_startids(int startid=-1, ref int startids[$]);
  if (startid ==-1) begin
    find_initors(startids);
    return;
  end
  if (G.has_node(startid))
    startids.push_back(startid);
endfunction : find_startids

/*
* endids, default endids = targetids
*/
function void smtdv_base_algorithm::find_endids(int endid=-1, ref int endids[$]);
  if (endid == -1) begin
    find_targets(endids);
    return;
  end
  if (G.has_node(endid))
    endids.push_back(endid);
endfunction : find_endids

/*
* check is directed graph
*/
function bit smtdv_base_algorithm::is_directed_graph();
  int initors[$];
  int targets[$];
  find_initors(initors);
  find_targets(targets);
  return initors.size() > 0 && targets.size() > 0;
endfunction : is_directed_graph

/*
* check is circular graph
*/
function bit smtdv_base_algorithm::is_circular_graph();
  return !is_directed_graph();
endfunction : is_circular_graph

`endif //__SMTDV_BASE_ALGORITHM_SV__
