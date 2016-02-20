`ifndef __SMTDV_BASE_VSEQ_SV__
`define __SMTDV_BASE_VSEQ_SV__


class smtdv_base_vseq
  extends
  smtdv_seq_env;

  typedef smtdv_base_vseq vseq_t;
  typedef smtdv_attr attr_t;
  typedef uvm_object obj_t;
  typedef uvm_component bcmp_t;
//  typedef smtdv_virtual_sequencer vseqr_t;
  typedef smtdv_seq_node#(obj_t, bcmp_t) node_t;

  typedef struct {
    int uuid;
    int sourceid;
    int sinkid;
    string desc;
  } edge_tb_t;

  typedef struct {
    int uuid;
    obj_t seq;  // bind basic seq
    obj_t seqr; // bind seq to v/pseqr
    int prio;
    string desc;
  } node_tb_t;

  typedef struct {
    node_tb_t nodes[$];
    edge_tb_t edges[$];
  } graph_tb_t;

  graph_tb_t graph;
  node_t node;
  bcmp_t bseqr;
  obj_t bseq;
//  vseqr_t vseqr;

  `uvm_object_param_utils_begin(vseq_t)
  `uvm_object_utils_end

//  `uvm_declare_p_sequencer(vseqr_t)

  function new(string name = "smtdv_base_vseq");
    super.new(name);
  endfunction : new

  virtual task pre_body();
    super.pre_body();

//    if (!$cast(vseqr, this.get_sequencer()))
//      `uvm_error("SMTDV_UCAST_V/PSEQR",
//         {$psprintf("UP CAST TO SMTDV V/PSEQR FAIL")})

  endtask : pre_body


  virtual task body();
    `include "smtdv_seq_dec.svh"
    super.body();

    seq_blder._create_seq_graph();

    foreach(graph.nodes[i]) begin
      if (graph.nodes[i].uuid != seq_blder.nodeid)
        `uvm_error("SMTDV_SEQ_BUILDER",
            {$psprintf("SEQ GRAPH NODEID %d NOT FOUND %d", graph.nodes[i].uuid, seq_blder.nodeid)})

      if (!$cast(bseq, graph.nodes[i].seq))
        `uvm_error("SMTDV_DCAST_SEQ",
            {$psprintf("DOWN CAST TO SMTDV SEQ FAIL")})

      if (!$cast(bseqr, graph.nodes[i].seqr))
        `uvm_error("SMTDV_DCAST_V/PSEQ",
            {$psprintf("DOWN CAST TO SMTDV V/PSEQ FAIL")})

      seq_blder._create_seq_node(bseq, bseqr);
      bseq = graph.nodes[i].seq;
      node = seq_blder.seq_graph.get_node(i);
      `include "smtdv_seq_bind.svh"
    end

    foreach(graph.edges[i]) begin
      if (graph.edges[i].uuid != seq_blder.edgeid)
        `uvm_error("SMTDV_SEQ_BUILDER",
            {$psprintf("SEQ GRAPH EDGEID %d NOT FOUND %d", graph.edges[i].uuid, seq_blder.edgeid)})

      seq_blder._create_seq_edge(
          graph.edges[i].sourceid,
          graph.edges[i].sinkid
      );
    end

    seq_blder._finalize_seq_graph();
  endtask : body

endclass : smtdv_base_vseq


`endif // __SMTDV_BASE_VSEQ_SV__
