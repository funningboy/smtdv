
`ifndef __SMTDV_SEQ_GRAPH_BUILDER_SV__
`define __SMTDV_SEQ_GRAPH_BUILDER_SV__

//typedef class smtdv_sequence
typedef class smtdv_attr;
typedef class smtdv_seq_node;
typedef class smtdv_seq_edge;
typedef class smtdv_seq_graph;
typedef class smtdv_seq_env;

/*
* must be imp at vsequence
*/
class smtdv_seq_graph_builder
  extends
  uvm_object;

  typedef smtdv_attr attr_t;

  typedef struct {
    int nodeid;
    attr_t attr;
  } node_tb_t;
  node_tb_t seq_node_tb[$];

  typedef struct {
    int edgeid;
    int sourceid;
    int sinkid;
    attr_t attr;
  } edge_tb_t;
  edge_tb_t seq_edge_tb[$];

  typedef smtdv_seq_graph_builder seq_blder_t;
  typedef uvm_component bcmp_t; // sequencer
  typedef uvm_object bseq_t;    // sequence
  typedef smtdv_seq_env seq_env_t;
  typedef smtdv_seq_node#(bseq_t, bcmp_t) seq_node_t;
  typedef smtdv_seq_edge#(seq_node_t, seq_node_t) seq_edge_t;
  typedef smtdv_seq_graph#(seq_node_t, seq_edge_t) seq_graph_t;
  typedef uvm_object obj_t;

  seq_env_t seq_env;
  seq_graph_t seq_graph;
  seq_blder_t seq_blder;

  seq_node_t seq_nodes[$];
  seq_edge_t seq_edges[$];

  obj_t benv, bgraph, bnode, bedge;

  bseq_t bseq;
  bcmp_t bcmp;

  int nodeid = 0;
  int edgeid = 0;

  `uvm_object_param_utils_begin(seq_blder_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_seq_graph_builder");
    super.new(name);
  endfunction : new

  extern virtual function void register(uvm_object parent);
  extern virtual function void _create_seq_graph();
  extern virtual function void _create_seq_node(bseq_t bseq, bcmp_t bseqr);
  extern virtual function void _create_seq_edge(int sourceid, int sinkid);
  extern virtual function void _finalize_seq_graph();

endclass : smtdv_seq_graph_builder


function void smtdv_seq_graph_builder::register(uvm_object parent);
  if (!$cast(seq_env, parent))
    `uvm_error("SMTDV_UCAST_SEQ_ENV",
        {$psprintf("UP CAST TO SMTDV SEQ_ENV FAIL")})

endfunction : register


function void smtdv_seq_graph_builder::_create_seq_graph();
  obj_t parent;

  if (seq_graph==null) begin
    seq_graph = seq_graph_t::type_id::create({$psprintf("smtdv_seq_graph")});

    if (!$cast(parent, this))
    `uvm_error("SMTDV_DCAST_SEQ_ENV",
        {$psprintf("DOWN CAST TO SMTDV SEQ_ENV FAIL")})

    seq_graph.register(parent);
    seq_graph.has_debug = TRUE;

    if (!$cast(bgraph, seq_graph))
    `uvm_error("SMTDV_DCAST_GRAPH",
        {$psprintf("DOWN CAST TO SMTDV GRAPH FAIL")})

    // register to top graph builder
  end
endfunction : _create_seq_graph


function void smtdv_seq_graph_builder::_create_seq_node(bseq_t bseq, bcmp_t bseqr);
  if (seq_graph.has_finalize)
    return;

  seq_node_tb[nodeid] = '{
      nodeid,
      `SMTDV_DEFAULT_ATTR
  };

  seq_nodes.push_back(
      seq_node_t::type_id::create({$psprintf("seq_node[%0d]", nodeid)})
  );

  seq_nodes[$].set_seq(bseq);
  seq_nodes[$].set_seqr(bseqr);
  seq_nodes[$].add_attr(seq_node_tb[nodeid].attr);
  seq_nodes[$].register(bgraph);
  seq_graph.add_node(nodeid, seq_nodes[$]);
  nodeid++;
endfunction : _create_seq_node


function void smtdv_seq_graph_builder::_create_seq_edge(int sourceid, int sinkid);
  if (seq_graph.has_finalize)
    return;

  if ((sourceid < 0 || sourceid >= nodeid) ||
      (sinkid < 0 || sinkid >= nodeid))
    return;

  seq_edge_tb[edgeid] = '{
      edgeid,
      sourceid,
      sinkid,
      `SMTDV_DEFAULT_ATTR
  };

  seq_edges.push_back(
    seq_edge_t::type_id::create({$psprintf("seq_edge[%0d]", edgeid)})
  );

  seq_edges[$].add_source(sourceid, seq_nodes[sourceid]);
  seq_edges[$].add_sink(sinkid, seq_nodes[sinkid]);
  seq_edges[$].add_attr(seq_edge_tb[edgeid].attr);
  seq_edges[$].register(bgraph);
  seq_graph.add_edge(seq_edges[$]);
  seq_nodes[sourceid].add_out_edge(edgeid);
  seq_nodes[sinkid].add_in_edge(edgeid);
  edgeid++;
endfunction : _create_seq_edge


function void smtdv_seq_graph_builder::_finalize_seq_graph();
  seq_graph.finalize();

  if (seq_graph.has_debug)
    seq_graph.dump();

endfunction : _finalize_seq_graph


`endif // __SMTDV_SEQ_GRAPH_BUILDER_SV__
