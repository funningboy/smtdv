`ifndef __SMTDV_CMP_GRAPH_BUILDER_SV__
`define __SMTDV_CMP_GRAPH_BUILDER_SV__

// typedef class smtdv_sequence_item
typedef class smtdv_attr;
typedef class smtdv_cmp_node;
typedef class smtdv_cmp_edge;
typedef class smtdv_cmp_graph;
typedef class smtdv_cmp_env;


class smtdv_cmp_graph_builder#(
  type MCFG = smtdv_master_cfg,
  type MAGT = smtdv_master_agent,
  type SCFG = smtdv_slave_cfg,
  type SAGT = smtdv_slave_agent,
  type T1 = smtdv_sequence_item
  ) extends
    smtdv_component#(uvm_env);

  typedef smtdv_attr attr_t;

  typedef struct {
    int nodeid;
    attr_t attr;
  } node_tb_t;
  node_tb_t mst_node_tb[$];   // master node
  node_tb_t slv_node_tb[$];   // slave node

  typedef struct {
    int edgeid;
    int sourceid;
    int sinkid;
    attr_t attr;
  } edge_tb_t;

  edge_tb_t cmp_wedge_tb[$];   // write edge from master to slave
  edge_tb_t cmp_redge_tb[$];   // read edge from slave to master

  typedef smtdv_cmp_graph_builder#(MCFG, MAGT, SCFG, SAGT, T1) cmp_blder_t;
  typedef smtdv_cmp_env#(MCFG, MAGT, SCFG, SAGT, T1) cmp_env_t;
  typedef smtdv_cmp_node#(MAGT) mst_node_t;
  typedef smtdv_cmp_node#(SAGT) slv_node_t;
  typedef uvm_component bcmp_t;
  typedef smtdv_cmp_node#(bcmp_t, T1) cmp_node_t;
  typedef smtdv_cmp_edge#(cmp_node_t, cmp_node_t, T1) cmp_edge_t;
  typedef smtdv_cmp_graph#(cmp_node_t, cmp_edge_t) cmp_graph_t;
  typedef uvm_object obj_t;

  MCFG mst_cfg;
  MAGT mst_agt;
  SCFG slv_cfg;
  SAGT slv_agt;
  T1 item;

  cmp_env_t cmp_env;
  cmp_graph_t cmp_graph;
  cmp_blder_t cmp_blder;

  cmp_node_t cmp_nodes[$];
  cmp_edge_t cmp_edges[$];

  bcmp_t bcmp;
  obj_t benv, bgraph, bnode, bedge;

  int nodeid = 0;
  int edgeid = 0;

  `uvm_component_param_utils_begin(cmp_blder_t)

  `uvm_component_utils_end

  function new(string name = "smtdv_cmp_graph_builder", uvm_component parent=null);
    super.new(name, parent);
    if (!$cast(cmp_env, parent))
      `uvm_error("SMTDV_UCAST_SEQ_ENV",
         {$psprintf("UP CAST TO SMTDV SEQ_ENV FAIL")})

  endfunction : new

  //extern virtual function void register(uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);

  extern virtual function void _create_cmp_graph();
  extern virtual function void _create_master_cmp_node(int mstid);
  extern virtual function void _create_slave_cmp_node(int slvid);
  extern virtual function void _create_write_cmp_edge(int mstid, int slvid);
  extern virtual function void _create_read_cmp_edge(int slvid, int mstid);
  extern virtual function void _finalize_cmp_graph();

  // top graph func
  //extern virtual static function void create_top_cmp_edge(

endclass : smtdv_cmp_graph_builder


function void smtdv_cmp_graph_builder::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (cmp_env==null)
    `uvm_error("SMTDV_CMP_GRAPH_BUILDER_ERR",
        $psprintf({"FIND NULL CMP_ENV, PLEASE REGISTER CMP_ENV FIRST"}))

  _create_cmp_graph();

endfunction : build_phase


function void smtdv_cmp_graph_builder::_create_cmp_graph();
  obj_t parent;
  if (cmp_graph==null) begin
    cmp_graph = cmp_graph_t::type_id::create("smtdv_cmp_graph");

    if (!$cast(parent, this))
      `uvm_error("SMTDV_DCAST_SEQ_BUILDER",
         {$psprintf("DOWN CAST TO SMTDV SEQ_BUILDER FAIL")})

    cmp_graph.register(parent);
    cmp_graph.debug = TRUE;

    if (!$cast(bgraph, cmp_graph))
      `uvm_error("SMTDV_DCAST_GRAPH",
        {$psprintf("DOWN CAST TO SMTDV GRAPH FAIL")})

    // register to top graph builder
  end
endfunction : _create_cmp_graph


function void smtdv_cmp_graph_builder::_create_master_cmp_node(int mstid);
  if (cmp_graph.has_finalize)
    return;
  if (!cmp_env.has_master(mstid))
    return;

  mst_node_tb[mstid] = '{
      nodeid,
      `SMTDV_DEFAULT_ATTR
  };

  cmp_nodes.push_back(
      cmp_node_t::type_id::create({$psprintf("mst_agt_node[%0d]", nodeid)})
  );

  if (!$cast(bcmp, cmp_env.mst_agts[mstid]))
    `uvm_error("SMTDV_DCAST_CMP",
        {$psprintf("DOWN CAST TO SMTDV CMP FAIL")})

  cmp_nodes[$].set(bcmp);
  cmp_env.mst_agts[mstid].set(cmp_nodes[$]);
  cmp_nodes[$].add_attr(mst_node_tb[mstid].attr);
  cmp_nodes[$].register(bgraph);
  cmp_graph.add_node(nodeid++, cmp_nodes[$]);
endfunction : _create_master_cmp_node


function void smtdv_cmp_graph_builder::_create_slave_cmp_node(int slvid);
  if (cmp_graph.has_finalize)
    return;
  if (!cmp_env.has_slave(slvid))
    return;

  slv_node_tb[slvid] = '{
      nodeid,
      `SMTDV_DEFAULT_ATTR
  };

  cmp_nodes.push_back(
      cmp_node_t::type_id::create({$psprintf("slv_agt_node[%0d]", nodeid)})
  );

  if (!$cast(bcmp, cmp_env.slv_agts[slvid]))
    `uvm_error("SMTDV_DCAST_CMP",
        {$psprintf("DOWN CAST TO SMTDV CMP FAIL")})

  cmp_nodes[$].set(bcmp);
  cmp_env.slv_agts[slvid].set(cmp_nodes[$]);
  cmp_nodes[$].add_attr(slv_node_tb[slvid].attr);
  cmp_nodes[$].register(bgraph);
  cmp_graph.add_node(nodeid++, cmp_nodes[$]);
endfunction : _create_slave_cmp_node

// write edge, master node to slave node
function void smtdv_cmp_graph_builder::_create_write_cmp_edge(int mstid, int slvid);
  int sourceid, sinkid;

  if (cmp_graph.has_finalize)
    return;
  if (!cmp_env.has_master(mstid) || !cmp_env.has_slave(slvid))
    return;

  sourceid = mst_node_tb[mstid].nodeid;
  sinkid = slv_node_tb[slvid].nodeid;

  cmp_wedge_tb[mstid] = '{
      edgeid,
      sourceid,
      sinkid,
      `SMTDV_DEFAULT_ATTR
  };

  cmp_edges.push_back(
      cmp_edge_t::type_id::create({$psprintf("mst_2_slv_edge[%0d][%0d]", sourceid, sinkid)})
  );

  cmp_edges[$].add_source(sourceid, cmp_nodes[sourceid]);
  cmp_edges[$].add_sink(sinkid, cmp_nodes[sinkid]);
  cmp_edges[$].add_attr(cmp_wedge_tb[mstid].attr);
  cmp_edges[$].register(bgraph);
  cmp_graph.add_edge(cmp_edges[$]);
  cmp_nodes[sourceid].add_out_edge(edgeid);
  cmp_nodes[sinkid].add_in_edge(edgeid);
  edgeid++;
endfunction : _create_write_cmp_edge

// read edge, slave node to master node
function void smtdv_cmp_graph_builder::_create_read_cmp_edge(int slvid, int mstid);
  int sourceid, sinkid;

  if (cmp_graph.has_finalize)
    return;
  if (!cmp_env.has_master(mstid) || !cmp_env.has_slave(slvid))
    return;

  sourceid = slv_node_tb[slvid].nodeid;
  sinkid = mst_node_tb[mstid].nodeid;

  cmp_redge_tb[slvid] = '{
      edgeid,
      sourceid,
      sinkid,
      `SMTDV_DEFAULT_ATTR
  };

  cmp_edges.push_back(
      cmp_edge_t::type_id::create({$psprintf("slv_2_mst_edge[%0d][%0d]", sourceid, sinkid)})
  );

  cmp_edges[$].add_source(sourceid, cmp_nodes[sourceid]);
  cmp_edges[$].add_sink(sinkid, cmp_nodes[sinkid]);
  cmp_edges[$].add_attr(cmp_redge_tb[slvid].attr);
  cmp_edges[$].register(bgraph);
  cmp_graph.add_edge(cmp_edges[$]);
  cmp_nodes[sourceid].add_out_edge(edgeid);
  cmp_nodes[sinkid].add_in_edge(edgeid);
  edgeid++;
endfunction : _create_read_cmp_edge


function void smtdv_cmp_graph_builder::_finalize_cmp_graph();
  cmp_graph.finalize();
  if (cmp_graph.debug)
    cmp_graph.dump();
endfunction : _finalize_cmp_graph


function void smtdv_cmp_graph_builder::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  // explore all edges from master to slave if autogen is TRUE
  if (cmp_env.autogen) begin
    foreach(cmp_env.mst_agts[i])
      _create_master_cmp_node(i);

    foreach(cmp_env.slv_agts[i])
      _create_slave_cmp_node(i);

    foreach(cmp_env.mst_agts[i])
      foreach(cmp_env.slv_agts[j])
        _create_write_cmp_edge(i, j);

    foreach(cmp_env.slv_agts[i])
      foreach(cmp_env.mst_agts[j])
        _create_read_cmp_edge(i, j);
  end
endfunction : connect_phase


function void smtdv_cmp_graph_builder::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  _finalize_cmp_graph();
endfunction : end_of_elaboration_phase

`endif // __SMTDV_GRAPH_BUILDER_SV__

