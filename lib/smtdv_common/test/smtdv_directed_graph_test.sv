`ifndef __SMTDV_DIRECTED_GRAPH_TEST_SV__
`define __SMTDV_DIRECTED_GRAPH_TEST_SV__

// typedef class smtdv_graph
// typedef class smtdv_node
// typedef class smtdv_edge

class smtdv_directed_graph_test
  extends
  smtdv_base_unittest;

  typedef smtdv_directed_graph_test test_t;
  typedef smtdv_graph graph_t;
  typedef smtdv_node node_t;
  typedef smtdv_edge edge_t;

  graph_t graph;
  node_t nodes[$];
  edge_t edges[$];

  int nodeid = 0;
  int edgeid = 0;
  const int maxnodes = 6;
  const int maxedges = 7;

  typedef struct {
    int sourceid;
    int sinkid;
    int weight;
    int delay;
  } edge_tb_t;
  edge_tb_t edge_tb[] = '{
    '{0, 2, 0, 0},
    '{1, 2, 1, 1},
    '{2, 3, 2, 2},
    '{2, 4, 1, 1},
    '{2, 5, 1, 1},
    '{3, 5, 1, 1},
    '{4, 5, 1, 1}
  };

  `uvm_component_utils(smtdv_directed_graph_test)

  function new(string name = "smtdv_directed_graph_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void test_graph_nodes();
  extern virtual function void test_graph_edges();
  extern virtual function void test_find_all_initors();
  extern virtual function void test_find_all_targets();
  extern virtual function void test_directed_graph();
  extern virtual function void test_find_all_paths();

  /*
  *  register all tests at run_phase
  */
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    test_graph_nodes();
    test_graph_edges();
    test_find_all_initors();
    test_find_all_targets();
    test_directed_graph();
    //test_graph_worker();
    //test_graph_async();
  endtask : run_phase

endclass : smtdv_directed_graph_test

/*
* build up graph topology
*/
function void smtdv_directed_graph_test::build_phase(uvm_phase phase);
    int sourceid, sinkid;

    super.build_phase(phase);

    // create graph
    graph = graph_t::type_id::create("graph");

    // create node[0] ~ node[5]
    for(int i=0; i<maxnodes; i++) begin
      nodes.push_back(
          node_t::type_id::create({$psprintf("node[%0d]", nodeid)})
      );
      graph.add_node(nodeid, nodes[$]);
      nodeid++;
    end

    // create edge[i]: node[source] to node[sink] by edge table
    foreach(edge_tb[i]) begin
      sourceid = edge_tb[i].sourceid;
      sinkid = edge_tb[i].sinkid;

      edges.push_back(
          edge_t::type_id::create({$psprintf("edge[%0d]", edgeid)})
      );
      edges[$].add_source(sourceid, nodes[sourceid]);
      edges[$].add_sink(sinkid, nodes[sinkid]);
      edges[$].add_attr('{
          edge_tb[i].weight,
          edge_tb[i].delay
      });
      graph.add_edge(edges[$]);
      edgeid++;
    end

    graph.finalize();
endfunction : build_phase


/*
* test nodes
*/
function void smtdv_directed_graph_test::test_graph_nodes();
  node_t node;

  int num_of_nodes = graph.num_of_nodes();
  if (num_of_nodes!= maxnodes)
    `uvm_error("SMTDV_DIRECTED_GRAPH_TEST",
        {$psprintf("nodes.size() must be eq %d not %d", maxnodes, num_of_nodes)})

endfunction : test_graph_nodes

/*
* test edges
*/
function void smtdv_directed_graph_test::test_graph_edges();
  edge_t pedge;
  edge_t::attr_t attr;

  int num_of_edges = graph.num_of_edges();
  if (num_of_edges!= maxedges)
   `uvm_error("SMTDV_DIRECTED_GRAPH_TEST",
       {$psprintf("edges.size() must be eq %d not %d", maxedges, num_of_edges)})

  pedge = graph.get_edge(0);
  if (pedge.sourceid != 0 || pedge.sinkid != 2)
   `uvm_error("SMTDV_DIRECTED_GRAPH_TEST",
       {$psprintf("edges[0](sourceid, sinkid) must be (%d,%d) not (%d,%d)",
       0, 2, pedge.sourceid, pedge.sinkid)})

  pedge.update_attr('{1, 0});
  attr = pedge.get_attr();
  if (attr.weight != 1)
   `uvm_error("SMTDV_DIRECTED_GRAPH_TEST",
       {$psprintf("edges[0].attr.weight must be %d not %d",
       1, attr.weight)})

endfunction : test_graph_edges

/*
* test directed graph
*/
function void smtdv_directed_graph_test::test_directed_graph();
  // direct graph test
  if(!graph.is_directed_graph())
    `uvm_error("SMTDV_DIRECTED_GRAPH_TEST",
        {$psprintf("graph must be directed graph")})
endfunction : test_directed_graph

/*
* test find all initors and self binded cmp ptr test
*/
function void smtdv_directed_graph_test::test_find_all_initors();
  int initors[];

  graph.find_all_initors(initors);

  // check initors.size()
  if (initors.size()!=2)
    `uvm_error("SMTDV_DIRECTED_GRAPH_TEST",
        {$psprintf("initors.size() must be eq 2 not %d", initors.size())})

endfunction : test_find_all_initors

/*
* test find all targets and self binded cmp ptr test
*/
function void smtdv_directed_graph_test::test_find_all_targets();
  int targets[];

  graph.find_all_targets(targets);

  // check targets.size()
  if (targets.size()!=1)
    `uvm_error("SMTDV_DIRECTED_GRAPH_TEST",
        {$psprintf("targets.size() must be eq 1 not %d", targets.size())})

endfunction : test_find_all_targets

/*
* test find all visitable paths
*/
function void smtdv_directed_graph_test::test_find_all_paths();

endfunction : test_find_all_paths

`endif // __SMTDV_DIRECTED_GRAPH_TEST_SV__
