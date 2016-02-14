// ref : http://www.testandverification.com/wp-content/uploads/2012/07/Staffan-DVClub-July-2012.pdf
//
// ex:
// graph = new smtdv_graph();
// node0 = new smtdv_node();
// node1 = new smtdv_node();
// graph.add_node(0, node0);
// graph.add_node(1, node1);
// graph.add_edge(0, 1, '{});
//
`ifndef __SMTDV_GRAPH_SV__
`define __SMTDV_GRAPH_SV__

//typedef class smtdv_queue;
//typedef class smtdv_int_queue;
//typedef class smtdv_hash;
typedef class smtdv_edge;
typedef class smtdv_node;


class smtdv_graph#(
  type NODE = smtdv_node,
  type EDGE = smtdv_edge#(NODE, NODE)
  )extends
  uvm_object;

  typedef smtdv_graph#(NODE, EDGE) graph_t;
  typedef smtdv_queue#(EDGE) edge_q_t;
  typedef smtdv_hash#(int, NODE) node_m_t;
  typedef uvm_object obj_t;

  obj_t parent;

  node_m_t node_m;
  edge_q_t edge_q;

  bit has_finalize = FALSE;
  bit debug = FALSE;

  `uvm_object_param_utils_begin(graph_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_graph");
    super.new(name);
    edge_q = edge_q_t::type_id::create("edge_q");
    node_m = node_m_t::type_id::create("node_m");
  endfunction : new

  /* edge funcs */
  extern virtual function bit has_edge(int sourceid, int sinkid, ref int edgeid);
  extern virtual function void add_edge(EDGE pedge);
  extern virtual function void del_edge(int edgeid);
  extern virtual function bit is_source(int sourceid, ref int edgeids[$]);
  extern virtual function bit is_sink(int sinkid, ref int edgeids[$]);
  extern virtual function EDGE get_edge(int edgeid);
  extern virtual function void get_edges(ref int edgeids[$]);
  extern virtual function int num_of_edges();

  /* node funcs */
  extern virtual function bit has_node(int nodeid);
  extern virtual function void add_node(int nodeid, NODE node); // [nodeid] = node; hash
  extern virtual function void del_node(int nodeid);
  extern virtual function NODE get_node(int nodeid);
  extern virtual function void get_nodes(ref int nodeids[$]);
  extern virtual function int num_of_nodes();

  /* graph funcs */
  extern virtual function void register(uvm_object iparent);
  extern virtual function void finalize();
  extern virtual function void dump();
  // cross_node? g0. g1
  // cross_edge?
 /* export as dot graph */
//  extern virtual function void export_as_dot(string file="graph.dot");

endclass : smtdv_graph

/*
* has unique edge between source and sink
*/
function bit smtdv_graph::has_edge(int sourceid, int sinkid, ref int edgeid);
  EDGE tedge;
  for(int i=0; i<edge_q.size(); i++) begin
    tedge = edge_q.get(i);
    if (tedge.sourceid==sourceid && tedge.sinkid==sinkid) begin
      edgeid = i;
      return TRUE;
    end
  end
  return FALSE;
endfunction : has_edge

/*
* add edge
*/
function void smtdv_graph::add_edge(EDGE pedge);
  int idx =-1;
  if (has_finalize) return;
  if (has_edge(pedge.sourceid, pedge.sinkid, idx)) del_edge(idx);

  edge_q.push_back(pedge);
endfunction : add_edge

/*
* del edge
*/
function void smtdv_graph::del_edge(int edgeid);
  if (has_finalize) return;
  edge_q.delete(edgeid);
endfunction : del_edge

/*
* is_source, find all unique source edgeids
*/
function bit smtdv_graph::is_source(int sourceid, ref int edgeids[$]);
  EDGE tedge;
  bit found = FALSE;
  for(int i=0; i<edge_q.size(); i++) begin
    tedge = edge_q.get(i);
    if (tedge.sourceid==sourceid) begin
      edgeids.push_back(i);
      found = TRUE;
    end
  end
  return found;
endfunction : is_source

/*
* is_sink, find all unique sink idxs
*/
function bit smtdv_graph::is_sink(int sinkid, ref int edgeids[$]);
  EDGE tedge;
  bit found = FALSE;
  for(int i=0; i<edge_q.size(); i++) begin
    tedge = edge_q.get(i);
    if (tedge.sinkid==sinkid) begin
      edgeids.push_back(i);
      found = TRUE;
    end
  end
  return found;
endfunction : is_sink

/*
* get_edge
*/
function smtdv_graph::EDGE smtdv_graph::get_edge(int edgeid);
  if (edgeid<0 || edgeid>edge_q.size())
    `uvm_error("SMTDV_GRAPH",
        {$psprintf("found null edge at %d", edgeid)})
  return edge_q.get(edgeid);
endfunction : get_edge

/*
* get_edges
*/
function void smtdv_graph::get_edges(ref int edgeids[$]);
  for(int i=0; i<edge_q.size(); i++) edgeids.push_back(i);
endfunction : get_edges

/*
* num_of_edges
*/
function int smtdv_graph::num_of_edges();
  return edge_q.size();
endfunction : num_of_edges

/*
* has node
*/
function bit smtdv_graph::has_node(int nodeid);
 return  node_m.exists(nodeid);
endfunction : has_node

/*
* add node
*/
function void smtdv_graph::add_node(int nodeid, NODE node);
  if (has_finalize) return;
  node_m.set(nodeid, node);
endfunction : add_node

/*
* del node
*/
function void smtdv_graph::del_node(int nodeid);
  if (has_finalize) return;
  node_m.delete(nodeid);
endfunction : del_node

/*
* get node
*/
function smtdv_graph::NODE smtdv_graph::get_node(int nodeid);
  if (!has_node(nodeid))
    `uvm_error("SMTDV_GRAPH",
        {$psprintf("found null node at %d", nodeid)})
  return node_m.get(nodeid);
endfunction : get_node

/*
* get nodes
*/
function void smtdv_graph::get_nodes(ref int nodeids[$]);
  node_m.keys(nodeids);
endfunction : get_nodes

/*
* num_of_nodes
*/
function int smtdv_graph::num_of_nodes();
  int keys[$];
  int size;
  node_m.keys(keys);
  size = keys.size();
  keys.delete();
  return size;
endfunction : num_of_nodes

/*
* finalize all nodes, edges, queue and hash when graph is build up completed
*/
function void smtdv_graph::finalize();
  EDGE tedge;
  NODE node;
  int keys[$];
  has_finalize = TRUE;
  for(int i=0; i<edge_q.size(); i++) begin
    tedge = edge_q.get(i);
    tedge.finalize();
  end
  node_m.keys(keys);
  for(int i=0; i<keys.size(); i++) begin
    node = node_m.get(keys[i]);
    node.finalize();
  end
  // smtdv_queue doesn't support finalize yet
  //edge_q.finalize();
  node_m.finalize();

  if (parent==null)
    `uvm_error("SMTDV_GRAPH",
        {$psprintf("found null parent, please using register")})

endfunction : finalize

/*
* dump all nodes and edges
*/
function void smtdv_graph::dump();
  EDGE tedge;
  if (debug) begin
    `uvm_info(parent.get_full_name(),
        "-------------------------------", UVM_LOW);
    for(int i=0; i<edge_q.size(); i++) begin
      tedge = get_edge(i);
      `uvm_info(get_full_name(),
        {$psprintf("Edge(%0d): source Node(%0d)-> sink Node(%0d)", i, tedge.sourceid, tedge.sinkid)}, UVM_LOW);
    end
    `uvm_info(parent.get_full_name(),
        "-------------------------------", UVM_LOW);
  end
endfunction : dump

function void smtdv_graph::register(uvm_object iparent);
  $cast(parent, iparent);
endfunction : register

`endif // __SMTDV_GRAPH_SV__
