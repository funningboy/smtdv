`ifndef __SMTDV_DIRECTED_GRAPH_TEST_SV__
`define __SMTDV_DIRECTED_GRAPH_TEST_SV__

// typedef class smtdv_graph
// typedef class smtdv_node
// typedef class smtdv_edge

class smtdv_directed_graph_test
  extends
  smtdv_base_test;

  typedef smtdv_attr attr_t;

  typedef struct {
    int sourceid;
    int sinkid;
    attr_t attr;
  } edge_tb_t;
  edge_tb_t edge_tb[$] = '{
    '{0, 2, '{0, 0, -1, -1}},
    '{1, 2, '{1, 1, -1, -1}},
    '{2, 3, '{2, 2, -1, -1}},
    '{2, 4, '{1, 1, -1, -1}},
    '{2, 5, '{1, 1, -1, -1}},
    '{3, 5, '{1, 1, -1, -1}},
    '{4, 5, '{1, 1, -1, -1}}
  };

  typedef struct {
    attr_t attr;
  } node_tb_t;
  node_tb_t node_tb[$] = '{
    '{'{0, 0, -1, -1}},
    '{'{1, 1, -1, -1}},
    '{'{2, 2, -1, -1}},
    '{'{1, 1, -1, -1}},
    '{'{1, 1, -1, -1}},
    '{'{1, 1, -1, -1}}
  };

  /* expected all search paths from initors to targets*/
  typedef struct {
    int q[$];
  } expect_visits_t;

  typedef struct {
    expect_visits_t q[$];
  } expect_paths_t;

  typedef struct {
    int sourceid;
  } expect_key_t;

  /*
  * systemverilog doesn't work for the key of hash is not a integer type
  * Using non-integer types as an index for associative arrays is not implemented yet
  */
  expect_paths_t expect_path_m[int] = '{
    0: '{
         '{
           '{'{0, 2, 3, 5}},
           '{'{0, 2, 4, 5}},
           '{'{0, 2, 5}}
          }
        },

    1: '{
          '{
            '{'{1, 2, 3, 5}},
            '{'{1, 2, 4, 5}},
            '{'{1, 2, 5}}
          }
        }
  };

  /* expected all search ranks by sorting attr */
  typedef struct {
    int weight;
    int q[$];
  } expect_rvisits_t;

  typedef struct {
    expect_rvisits_t q[$];
  } expect_ranks_t;
  expect_ranks_t expect_rank_m[int] = '{
    0: '{
         '{
           '{3, '{0, 2, 3, 5}},
           '{2, '{0, 2, 4, 5}},
           '{1, '{0, 2, 5}}
          }
        },

    1: '{
         '{
           '{4, '{1, 2, 3, 5}},
           '{3, '{1, 2, 4, 5}},
           '{2, '{1, 2, 5}}
          }
        }
  };

  typedef smtdv_directed_graph_test test_t;
  typedef smtdv_node node_t;
  typedef smtdv_edge#(node_t, node_t) edge_t;
  typedef smtdv_graph#(node_t, edge_t) graph_t;
  typedef smtdv_base_algorithm#(node_t, edge_t, graph_t) alg_t;

  graph_t graph;
  alg_t alg;

  node_t nodes[$];
  edge_t edges[$];

  int nodeid = 0;
  int edgeid = 0;
  const int maxnodes = 6;
  const int maxedges = 7;

  `uvm_component_utils(smtdv_directed_graph_test)

  function new(string name = "smtdv_directed_graph_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void test_graph_nodes();
  extern virtual function void test_graph_edges();
  extern virtual function void test_find_initors();
  extern virtual function void test_find_targets();
  extern virtual function void test_directed_graph();
  extern virtual function void test_find_paths();
  extern virtual function void test_rank_paths();

  /*
  *  register all tests at run_phase
  */
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    test_graph_nodes();
    test_graph_edges();
    test_find_initors();
    test_find_targets();
    test_directed_graph();
    test_find_paths();
    test_rank_paths();
  endtask : run_phase

endclass : smtdv_directed_graph_test

/*
* build up graph topology
*/
function void smtdv_directed_graph_test::build_phase(uvm_phase phase);
    int sourceid, sinkid;

    super.build_phase(phase);

    // create graph
    graph = graph_t::type_id::create("smtdv_graph");
    graph.debug = TRUE;

    // create node[0] ~ node[5]
    foreach(node_tb[i]) begin
      nodes.push_back(
          node_t::type_id::create({$psprintf("node[%0d]", nodeid)})
      );
      nodes[$].add_attr('{
        node_tb[i].attr.weight,
        node_tb[i].attr.delay,
        $time,
        $time
      });
      nodes[$].register(graph);
      graph.add_node(nodeid++, nodes[$]);
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
        edge_tb[i].attr.weight,
        edge_tb[i].attr.delay,
        $time,
        $time
      });
      edges[$].register(graph);
      graph.add_edge(edges[$]);
      // link correlation edge to node
      nodes[sourceid].add_out_edge(edgeid);
      nodes[sinkid].add_in_edge(edgeid);
      edgeid++;
    end

    graph.finalize();
    graph.dump();
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

  pedge.update_attr('{1, 0, $time, $time});
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

  // create algorithm
  alg = alg_t::type_id::create("smtdv_base_algorithm");
  alg.set_graph(graph);

  // direct graph test
  if(!alg.is_directed_graph())
    `uvm_error("SMTDV_DIRECTED_GRAPH_TEST",
        {$psprintf("graph must be directed graph")})

endfunction : test_directed_graph

/*
* test find all initors and self binded cmp ptr test
*/
function void smtdv_directed_graph_test::test_find_initors();
  int initors[$];

  // create algorithm
  alg = alg_t::type_id::create("smtdv_base_algorithm");
  alg.set_graph(graph);
  alg.find_initors(initors);

  // check initors.size()
  if (initors.size()!=2)
    `uvm_error("SMTDV_DIRECTED_GRAPH_TEST",
        {$psprintf("initors.size() must be eq 2 not %d", initors.size())})

  initors.delete();
endfunction : test_find_initors

/*
* test find all targets and self binded cmp ptr test
*/
function void smtdv_directed_graph_test::test_find_targets();
  int targets[$];

  // create algorithm
  alg = alg_t::type_id::create("smtdv_base_algorithm");
  alg.set_graph(graph);
  alg.find_targets(targets);

  // check targets.size()
  if (targets.size()!=1)
    `uvm_error("SMTDV_DIRECTED_GRAPH_TEST",
        {$psprintf("targets.size() must be eq 1 not %d", targets.size())})

  targets.delete();
endfunction : test_find_targets

/*
* test find all visitable paths
*/
function void smtdv_directed_graph_test::test_find_paths();
endfunction : test_find_paths

/*
* find all rank paths order by sorting attr type
*/
function void smtdv_directed_graph_test::test_rank_paths();
endfunction : test_rank_paths


`endif // __SMTDV_DIRECTED_GRAPH_TEST_SV__
