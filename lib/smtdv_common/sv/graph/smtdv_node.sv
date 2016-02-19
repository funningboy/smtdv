
`ifndef __SMTDV_NODE_SV__
`define __SMTDV_NODE_SV__

//typeded struct smtdv_attr;
typedef class smtdv_graph;
typedef class smtdv_edge;

/*
* smtdv basic node
*/
class smtdv_node
  extends
  uvm_object;

  typedef smtdv_attr attr_t;
  typedef smtdv_node node_t;
  typedef smtdv_edge#(node_t, node_t) edge_t;
  typedef smtdv_graph#(node_t, edge_t) graph_t;
  typedef uvm_object bgraph_t;

  int in_q[$];  // input edgeids queue
  int out_q[$]; // output edgeids queue

  attr_t attr;
  graph_t graph;

  bit has_finalize = FALSE;
  bit has_lock = FALSE;
  bit has_visit = FALSE;

  `uvm_object_param_utils_begin(node_t)
    `uvm_field_queue_int(in_q, UVM_ALL_ON)
    `uvm_field_queue_int(out_q, UVM_ALL_ON)
    `uvm_field_object(graph, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "smtdv_node");
    super.new(name);
  endfunction : new

  extern virtual function void register(uvm_object parent=null);
  extern virtual function bit is_lock();
  extern virtual function void lock();
  extern virtual function void unlock();
  extern virtual function void finalize();
  extern virtual function void add_in_edge(int edgeid);
  extern virtual function void add_out_edge(int edgeid);
  extern virtual function void get_in_edges(ref int edgeids[$]);
  extern virtual function void get_out_edges(ref int edgeids[$]);
  extern virtual function bit has_in_edge(int edgeid);
  extern virtual function bit has_out_edge(int edgeid);
  extern virtual function void add_attr(attr_t iattr);
  extern virtual function attr_t get_attr();
  extern virtual function void update_attr(attr_t iattr);
  extern virtual function void dump();

  extern virtual task async_try_lock();
  extern virtual task async_try_unlock();
  extern virtual task run();
  extern virtual task pre_do();
  extern virtual task post_do();
  extern virtual task mid_do();

endclass : smtdv_node

/*
* cast from object to smtdv_graph
*/
function void smtdv_node::register(uvm_object parent=null);
  if (!$cast(graph,parent))
    `uvm_error("SMTDV_UCAST_GRAPH",
        {$psprintf("UP CAST TO SMTDV GRAPH FAIL")})

endfunction : register

function bit smtdv_node::is_lock();
  return has_lock == TRUE;
endfunction : is_lock

/*
* try lock when all input nodes are unlocked
*/
function void smtdv_node::lock();
  assert(is_lock()==FALSE);
  has_lock = TRUE;
endfunction : lock

function void smtdv_node::unlock();
  assert(is_lock()==TRUE);
  has_lock = FALSE;
endfunction : unlock

function void smtdv_node::finalize();
  has_finalize = TRUE;
endfunction : finalize

function void smtdv_node::add_in_edge(int edgeid);
  if(has_finalize) return;
  in_q.push_back(edgeid);
endfunction : add_in_edge

function void smtdv_node::add_out_edge(int edgeid);
  if(has_finalize) return;
  out_q.push_back(edgeid);
endfunction : add_out_edge

function void smtdv_node::get_in_edges(ref int edgeids[$]);
  foreach(in_q[i]) edgeids.push_back(in_q[i]);
endfunction : get_in_edges

function void smtdv_node::get_out_edges(ref int edgeids[$]);
  foreach(out_q[i]) edgeids.push_back(out_q[i]);
endfunction : get_out_edges

function bit smtdv_node::has_in_edge(int edgeid);
  return edgeid inside {in_q};
endfunction : has_in_edge

function bit smtdv_node::has_out_edge(int edgeid);
  return edgeid inside {out_q};
endfunction : has_out_edge

/*
* add default attr
*/
function void smtdv_node::add_attr(smtdv_node::attr_t iattr);
  if(has_finalize) return;
  attr = iattr;
endfunction : add_attr

/*
* update attr
*/
function void smtdv_node::update_attr(smtdv_node::attr_t iattr);
  attr = iattr;
endfunction : update_attr

/*
* get attr
*/
function smtdv_node::attr_t smtdv_node::get_attr();
  return attr;
endfunction : get_attr

function void smtdv_node::dump();
endfunction : dump

task smtdv_node::run();
   pre_do();
   mid_do();
   post_do();
endtask : run

/*
* wait all input nodes, edges are completed
*/
task smtdv_node::async_try_lock();
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
      wait(!node.is_lock());
      `SMTDV_SWAP(tedge.attr.delay);
    end
  join
  lock();
endtask : async_try_lock

/*
* make sure all outputs nodes, edges are free to lock
*/
task smtdv_node::async_try_unlock();
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


task smtdv_node::pre_do();
  fork
    async_try_lock();
  join_none
  wait(is_lock());
endtask : pre_do


task smtdv_node::mid_do();
  `uvm_info(get_full_name(), $sformatf("Starting run node ..."), UVM_HIGH)
  `SMTDV_SWAP(attr.delay)
endtask : mid_do


task smtdv_node::post_do();
  fork
    async_try_unlock();
  join_none
  wait(!is_lock());
endtask : post_do


`endif // __ SMTDV_NODE_SV__
