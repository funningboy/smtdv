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

typedef class smtdv_edge;
typedef class smtdv_node;
typedef class smtdv_queue;
typedef class smtdv_hash;


class smtdv_graph
  extends
  uvm_object;

  typedef smtdv_graph graph_t;

  typedef smtdv_node node_t;
  typedef smtdv_edge edge_t;

  typedef smtdv_queue#(edge_t) edge_q_t;
  typedef smtdv_node_hash#(int, node_t) node_m_t;

  node_m_t node_m;
  edge_q_t edge_q;

  bit has_finalize = FALSE;

  `uvm_object_param_utils_begin(graph_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_graph");
    super.new(name);
    edge_q = edge_q_t::type_id::create("edge_q");
    node_m = node_m_t::type_id::create("node_m");
  endfunction : new

  /* edge funcs */
  extern virtual function bit has_edge(int sourceid, int sinkid, ref int idx);
  extern virtual function void add_edge(edge_t pedge);
  extern virtual function void del_edge(int edgeid);
  extern virtual function bit is_source(int sourceid, ref int idxs[]);
  extern virtual function bit is_sink(int sinkid, ref int idxs[]);
  extern virtual function edge_t get_edge(int edgeid);
  extern virtual function void get_edges(ref int idxs[]);
  extern virtual function int num_of_edges();

  /* node funcs */
  extern virtual function bit has_node(int nodeid);
  extern virtual function void add_node(int nodeid, node_t node); // [nodeid] = node; hash
  extern virtual function void del_node(int nodeid);
  extern virtual function node_t get_node(int nodeid);
  extern virtual function void get_nodes(ref int idxs[]);
  extern virtual function int num_of_nodes();

  /* graph funcs */
  extern virtual function void finalize();
  extern virtual function void find_all_initors(ref int idxs[]);
  extern virtual function void find_all_targets(ref int idxs[]);
  extern virtual function bit is_directed_graph();
  extern virtual function bit is_circular_graph();
  /* find all topology paths from initors to targets */
  extern virtual function void find_all_paths(ref int paths[][]);
  /* find all circular paths and sorted by idx */
  extern virtual function void find_circular_paths(ref int paths[][]);

  extern virtual protected function void _iter_deepest_search(int sinkid, ref int searchs[$]);
  extern virtual protected function bit _is_circular_loop(ref int searchs[$]);

//  extern virtual function void export_as_dot();
//  extern virtual function void find_max_attr_paths(ref int attr, ref node_t arr[][]);

endclass : smtdv_graph

/*
* has unique edge between source and sink
*/
function bit smtdv_graph::has_edge(int sourceid, int sinkid, ref int idx);
  edge_t bedge;
  for(int i=0; i<edge_q.size(); i++) begin
    bedge = edge_q.get(i);
    if (bedge.sourceid==sourceid && bedge.sinkid==sinkid) begin
      idx = i;
      return TRUE;
    end
  end
  return FALSE;
endfunction : has_edge

/*
* add edge
*/
function void smtdv_graph::add_edge(smtdv_graph::edge_t pedge);
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
* is_source, find all unique source idxs
*/
function bit smtdv_graph::is_source(int sourceid, ref int idxs[]);
  int tidxs[$];
  edge_t bedge;
  for(int i=0; i<edge_q.size(); i++) begin
    bedge = edge_q.get(i);
    if (bedge.sourceid==sourceid) tidxs.push_back(i);
  end
  idxs = new[tidxs.size()];
  foreach(tidxs[i]) idxs[i] = tidxs[i];
  tidxs.delete();
  return (idxs.size()>0);
endfunction : is_source

/*
* is_sink, find all unique sink idxs
*/
function bit smtdv_graph::is_sink(int sinkid, ref int idxs[]);
  int tidxs[$];
  edge_t bedge;
  for(int i=0; i<edge_q.size(); i++) begin
    bedge = edge_q.get(i);
    if (bedge.sinkid==sinkid) tidxs.push_back(i);
  end
  idxs = new[tidxs.size()];
  foreach(tidxs[i]) idxs[i] = tidxs[i];
  tidxs.delete();
  return (idxs.size()>0);
endfunction : is_sink

/*
* get_edge
*/
function smtdv_graph::edge_t smtdv_graph::get_edge(int edgeid);
  if (edgeid<0 || edgeid>edge_q.size())
    `uvm_error("SMTDV_GRAPH",
        {$psprintf("found null edge at %d", edgeid)})
  return edge_q.get(edgeid);
endfunction : get_edge

/*
* get_edges
*/
function void smtdv_graph::get_edges(ref int idxs[]);
  idxs = new[edge_q.size()];
  for(int i=0; i<edge_q.size(); i++) idxs[i] = i;
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
function void smtdv_graph::add_node(int nodeid, smtdv_graph::node_t node);
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
function smtdv_graph::node_t smtdv_graph::get_node(int nodeid);
  if (!has_node(nodeid))
    `uvm_error("SMTDV_GRAPH",
        {$psprintf("found null node at %d", nodeid)})
  return node_m.get(nodeid);
endfunction : get_node

/*
* get nodes
*/
function void smtdv_graph::get_nodes(ref int idxs[]);
  node_m.keys(idxs);
endfunction : get_nodes

/*
* num_of_nodes
*/
function int smtdv_graph::num_of_nodes();
  int keys[];
  node_m.keys(keys);
  foreach(keys[i])
      $display("xxx %d\n", keys[i]);
  return keys.size();
endfunction : num_of_nodes

/*
* find_all_initors, get all unique initors
*/
function void smtdv_graph::find_all_initors(ref int idxs[]);
  edge_t bedge;
  int tidxs[$], fidxs[$], bidxs[];
  for(int i=0; i<edge_q.size(); i++) begin
    bedge = edge_q.get(i);
    if (!is_sink(bedge.sourceid, bidxs)) begin
      fidxs = tidxs.find_first_index(item) with (item == bedge.sinkid);

      tidxs = tidxs;
      tidxs.push_back(bedge.sourceid);
    end
  end
  idxs = new[tidxs.size()];
  foreach(tidxs[i]) idxs[i] = tidxs[i];
  tidxs.delete();
endfunction : find_all_initors

/*
* find_all_targets, get all unique targets
*/
function void smtdv_graph::find_all_targets(ref int idxs[]);
  edge_t bedge;
  int tidxs[$], fidxs[$], bidxs[];
  for(int i=0; i<edge_q.size(); i++) begin
    bedge = edge_q.get(i);
    if (!is_source(bedge.sinkid, bidxs)) begin
      fidxs = tidxs.find_first_index(item) with (item == bedge.sinkid);
      if (fidxs.size()==0)
        tidxs.push_back(bedge.sinkid);
    end
  end
  idxs = new[tidxs.size()];
  foreach(tidxs[i]) idxs[i] = tidxs[i];
  tidxs.delete();
  fidxs.delete();
endfunction : find_all_targets

/*
* finalize all nodes, edges, queue and hash when graph is build up completed
*/
function void smtdv_graph::finalize();
  edge_t bedge;
  node_t node;
  int keys[];
  has_finalize = TRUE;
  for(int i=0; i<edge_q.size(); i++) begin
    bedge = edge_q.get(i);
    bedge.finalize();
  end
  node_m.keys(keys);
  for(int i=0; i<keys.size(); i++) begin
    node = node_m.get(keys[i]);
    node.finalize();
  end
  // smtdv_queue doesn't support finalize yet
  //edge_q.finalize();
  node_m.finalize();
endfunction : finalize

/*
* check is directed graph
*/
function bit smtdv_graph::is_directed_graph();
  int initors[];
  int targets[];
  find_all_initors(initors);
  find_all_targets(targets);
  return initors.size() > 0 && targets.size() > 0;
endfunction : is_directed_graph

/*
* check is circular graph
*/
function bit smtdv_graph::is_circular_graph();
  return !is_directed_graph();
endfunction : is_circular_graph

/*
* find all topology paths from initors to targets
*/
function void smtdv_graph::find_all_paths(ref int paths[][]);
  if (!is_circular_graph())
    `uvm_error("SMTDV_GRAPH",
        {$psprintf("circular graph not support find all_paths")})

  //paths =

endfunction : find_all_paths

/*
* find all circular paths
*/
function void smtdv_graph::find_circular_paths(ref int paths[][]);
  int tidxs[$], searchs[$];
  edge_t bedge;
  for(int i=0; i<edge_q.size(); i++) begin
    bedge = edge_q.get(i);
    searchs.push_back(bedge.sourceid);
    _iter_deepest_search(bedge.sinkid, searchs);
  end
endfunction : find_circular_paths

/*
* iter run as deepest first search
*/
function void smtdv_graph::_iter_deepest_search(int sinkid, ref int searchs[$]);
  int bidxs[];
  edge_t bedge;
  if (is_source(sinkid, bidxs)) begin
    foreach(bidxs[i]) begin
      bedge = edge_q.get(bidxs[i]);
      searchs.push_back(bedge.sourceid);
      if (_is_circular_loop(searchs)) begin
          return;
      end
      _iter_deepest_search(bedge.sinkid, searchs);
    end
  end
endfunction : _iter_deepest_search

/*
* check it's circular loop at search list
*/
function bit smtdv_graph::_is_circular_loop(ref int searchs[$]);
  return searchs[0] == searchs[$] && searchs.size() > 1;
endfunction : _is_circular_loop

`endif // __SMTDV_GRAPH_SV__
