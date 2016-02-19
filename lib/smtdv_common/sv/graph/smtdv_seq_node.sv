
`ifndef __SMTDV_SEQ_NODE_SV__
`define __SMTDV_SEQ_NODE_SV__

//typedef class smtdv_sequence_item;
//typedef class smtdv_sequence;
typedef class smtdv_seq_edge;
typedef class smtdv_seq_graph;

/*
* smtdv sequence node
*/
class smtdv_seq_node#(
  type SEQ = uvm_object, // as uvm_sequence(uvm_sequence_item)
  type SEQR = uvm_component //as smtdv_sequencer
  ) extends
  smtdv_node;

  typedef smtdv_seq_node#(SEQ, SEQR) node_t;
  typedef smtdv_seq_edge#(node_t, node_t) edge_t;
  typedef smtdv_seq_graph#(node_t, edge_t) graph_t;
  typedef uvm_object bgraph_t;

  SEQ seq;
  SEQR seqr;
  graph_t graph;

  `uvm_object_param_utils_begin(node_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_seq_node");
    super.new(name);
  endfunction : new

  extern virtual function void register(uvm_object parent=null);
  extern virtual function void set_seq(SEQ iseq);
  extern virtual function SEQ get_seq();
  extern virtual function void set_seqr(SEQR iseqr);
  extern virtual function SEQR get_seqr();

  extern virtual task async_try_lock();
  extern virtual task async_try_unlock();
  extern virtual task mid_do();

endclass : smtdv_seq_node

/*
* cast from object to smtdv_seq_graph
*/
function void smtdv_seq_node::register(uvm_object parent=null);
  if (!$cast(graph, parent))
    `uvm_error("SMTDV_UCAST_SEQ_GRAPH",
        {$psprintf("UP CAST TO SMTDV SEQ_GRAPH FAIL")})

endfunction : register


function void smtdv_seq_node::set_seq(smtdv_seq_node::SEQ iseq);
  if (!$cast(seq, iseq))
    `uvm_error("SMTDV_DCAST_SEQ",
        {$psprintf("DOWN CAST TO SMTDV SEQ FAIL")})

endfunction : set_seq


function smtdv_seq_node::SEQ smtdv_seq_node::get_seq();
  return seq;
endfunction : get_seq


function void smtdv_seq_node::set_seqr(smtdv_seq_node::SEQR iseqr);
  if (!$cast(seqr, iseqr))
    `uvm_error("SMTDV_DCAST_SEQR",
        {$psprintf("DOWN CAST TO SMTDV SEQR FAIL")})

endfunction : set_seqr


function smtdv_seq_node::SEQR smtdv_seq_node::get_seqr();
  return seqr;
endfunction : get_seqr

/*
* wait all input nodes, edges are completed
*/
task smtdv_seq_node::async_try_lock();
  int edgeids[$];
  get_in_edges(edgeids);
  fork
    foreach(edgeids[i]) begin
      automatic int k;
      automatic node_t node;
      automatic edge_t tedge;
      k = i;
      tedge = graph.get_edge(edgeids[k]);
      node = graph.get_node(tedge.sourceid);
      wait(!node.is_lock() && node.has_visit);
      `SMTDV_SWAP(tedge.attr.delay);
    end
  join
  lock();
endtask : async_try_lock

task smtdv_seq_node::mid_do();
  has_visit = TRUE;
endtask : mid_do

task smtdv_seq_node::async_try_unlock();
  int edgeids[$];
  get_out_edges(edgeids);
  fork
    foreach(edgeids[i]) begin
      automatic int k;
      automatic node_t node;
      automatic edge_t tedge;
      k = i;
      tedge = graph.get_edge(edgeids[k]);
      node = graph.get_node(tedge.sinkid);
      assert(!node.is_lock());
      `SMTDV_SWAP(0);
    end
  join
  unlock();
endtask : async_try_unlock



`endif // __SMTDV_SEQ_NODE_SV__
