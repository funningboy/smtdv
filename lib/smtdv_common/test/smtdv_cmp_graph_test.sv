`ifndef __SMTDV_CMP_GRAPH_TEST_SV__
`define __SMTDV_CMP_GRAPH_TEST_SV__

// typedef class smtdv_node;
// typedef class smtdv_edge;
// typedef class smtdv_cmp_graph;

/*
* test component(agent) graph by using graph theory
*/
class smtdv_cmp_graph_test
  extends
  smtdv_base_unittest;

  typedef smtdv_cmp_graph_test test_t;
  typedef smtdv_cmp_graph graph_t;
  typedef smtdv_node node_t;
  typedef smtdv_cmp_node#(mst_agt_t) mst_agt_node_t; // bind master agent as cmp node
  typedef smtdv_cmp_node#(slv_agt_t) slv_agt_node_t; // bind slave agent as cmp node
  typedef smtdv_edge edge_t; // mastet/slave slave/master/ edge

  graph_t graph;
  mst_agt_node_t mst_agt_nodes[$]; // masters
  slv_agt_node_t slv_agt_nodes[$]; // slaves
  edge_t nedges[$]; // edges

  int nodeid = 0;
  int edgeid = 0;
//  const int
//  const int

  typedef struct {
    int sourceid;
    int sinkid;
    int weight;
    int delay;
  } nedge_tb_t;
//  nedege

  `uvm_component_utils(smtdv_cmp_graph_test)

  function new(string name = "smtdv_cmp_graph_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void test_directed_graph();
  extern virtual function void test_find_all_initors();
  extern virtual function void test_find_all_targets();
//  extern virtual function void test_graph_nodes();
//  extern virtual function void test_graph_edges();
//  extern virtual function void test_graph_worker();
//  extern virtual function void test graph_async();

  /*
  *  register all tests at run_phase
  */
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
//    test_graph_nodes();
//    test_graph_edges();
    test_find_all_initors();
    test_find_all_targets();
    test_directed_graph();
//    test_graph_worker();
//    test_graph_async();
  endtask : run_phase

endclass : smtdv_cmp_graph_test

function void smtdv_cmp_graph_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    // create graph
    graph = graph_t::type_id::create("cmp_graph");

    // bind node[0] as master_agent[0]
    mst_agt_nodes.push_back(
        mst_agt_node_t::type_id::create({$psprintf("mst_agt_node[%0d]", nodeid)})
    );
    mst_agt_nodes[$].set(master_agent[0]);
    graph.add_node(nodeid++, mst_agt_nodes[$]);

    // node[1]
    slv_agt_nodes.push_back(
        slv_agt_node_t::type_id::create({$psprintf("slv_agt_node[%0d]", nodeid)})
    );
    graph.add_node(nodeid++, slv_agt_nodes[$]);

    // node[2]
    mst_agt_nodes.push_back(
        mst_agt_node_t::type_id::create({$psprintf("mst_agt_node[%0d]", nodeid)})
    );
    graph.add_node(nodeid++, mst_agt_nodes[$]);

    // node[3]
    mst_agt_nodes.push_back(
        mst_agt_node_t::type_id::create({$psprintf("mst_agt_node[%0d]", nodeid)})
    );
    graph.add_node(nodeid++, mst_agt_nodes[$]);

    // bind node[4] as slave_agent[0]
    slv_agt_nodes.push_back(
        slv_agt_node_t::type_id::create({$psprintf("slv_agt_node[%0d]", nodeid)})
    );
    slv_agt_nodes[$].set(slave_agent[0]);
    graph.add_node(nodeid++, slv_agt_nodes[$]);

    // pedge[0]: node[0] to node[1]
    nedges.push_back(
        edge_t::type_id::create({$psprintf("mst_2_slv_edge[%0d]", edgeid++)})
    );
    nedges[$].add_source(0, mst_agt_nodes[0]);
    nedges[$].add_sink(1, slv_agt_nodes[0]);
 //   nedges[$].add_attr('{0});
    graph.add_edge(nedges[$]);

    // pedge[1]: node[1] to node[2]
    nedges.push_back(
        edge_t::type_id::create({$psprintf("slv_2_mst_edge[%0d]", edgeid++)})
    );
    nedges[$].add_source(1, slv_agt_nodes[0]);
    nedges[$].add_sink(2, mst_agt_nodes[1]);
//    nedges[$].add_attr('{0});
    graph.add_edge(nedges[$]);

    // pedge[2]: node[1] to node[3]
    nedges.push_back(
        edge_t::type_id::create({$psprintf("slv_2_mst_edge[%0d]", edgeid++)})
    );
    nedges[$].add_source(1, slv_agt_nodes[0]);
    nedges[$].add_sink(3, mst_agt_nodes[2]);
//    nedges[$].add_attr('{0});
    graph.add_edge(nedges[$]);

    // pedge[3]: node[2] to node[4]
    nedges.push_back(
        edge_t::type_id::create({$psprintf("mst_2_slv_edge[%0d]", edgeid++)})
    );
    nedges[$].add_source(2, mst_agt_nodes[1]);
    nedges[$].add_sink(4, slv_agt_nodes[1]);
//    nedges[$].add_attr('{0});
    graph.add_edge(nedges[$]);

    // pedge[4]: node[3] to node[4]
    nedges.push_back(
        edge_t::type_id::create({$psprintf("mst_2_slv_edge[%0d]", edgeid++)})
    );
    nedges[$].add_source(3, mst_agt_nodes[2]);
    nedges[$].add_sink(4, slv_agt_nodes[1]);
//    nedges[$].add_attr('{0});
    graph.add_edge(nedges[$]);

    //finalize
    graph.finalize();
endfunction : build_phase


/*
* test directed graph
*/
function void smtdv_cmp_graph_test::test_directed_graph();
  // direct graph test
  if(!graph.is_directed_graph())
    `uvm_error("smtdv_cmp_graph_TEST",
        {$psprintf("graph must be directed graph")})
endfunction : test_directed_graph

/*
* test find all initors and self binded cmp ptr test
*/
function void smtdv_cmp_graph_test::test_find_all_initors();
  int initors[];
  mst_agt_node_t mst_node;
  mst_agt_t mst_agt;

  graph.find_all_initors(initors);

  // check initors.size()
  if (initors.size()!=1)
    `uvm_error("smtdv_cmp_graph_TEST",
        {$psprintf("initors.size() must be eq 1 not %d", initors.size())})

  // check node cast
  if (!$cast(mst_node, graph.get_node(initors[0])))
    `uvm_error("smtdv_cmp_graph_TEST",
        {$psprintf("$cast(mst_agt_node_t,node_t) fail")})

  // check node binded
  mst_agt = mst_node.get();
  if (!mst_agt.cfg.has_force)
    `uvm_error("smtdv_cmp_graph_TEST",
        {$psprintf("get bined mst_agt.cfg.has_force must be TRUE")})

endfunction : test_find_all_initors

/*
* test find all targets and self binded cmp ptr test
*/
function void smtdv_cmp_graph_test::test_find_all_targets();
  int targets[];
  slv_agt_node_t slv_node;
  slv_agt_t slv_agt;

  graph.find_all_targets(targets);

  // check targets.size()
  if (targets.size()!=1)
    `uvm_error("smtdv_cmp_graph_TEST",
        {$psprintf("targets.size() must be eq 1 not %d", targets.size())})

  // check node cast
  if (!$cast(slv_node, graph.get_node(targets[0])))
    `uvm_error("smtdv_cmp_graph_TEST",
        {$psprintf("$cast(slv_agt_node_t,node_t) fail")})

  // check node binded
  slv_agt = slv_node.get();
  if (!slv_agt.cfg.has_force)
    `uvm_error("smtdv_cmp_graph_TEST",
        {$psprintf("get bined slv_agt.cfg.has_force must be TRUE")})

endfunction : test_find_all_targets


`endif // __SMTDV_CMP_GRAPH_TEST_SV__
