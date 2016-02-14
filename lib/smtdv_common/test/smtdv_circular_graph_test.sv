
`ifndef __SMTDV_CIRCULAR_GRAPH_TEST_SV__
`define __SMTDV_CIRCULAR_GRAPH_TEST_SV__

// typedef class smtdv_graph
// typedef class smtdv_node;
// typedef class smtdv_edge;

class smtdv_circular_graph_test
  extends
  smtdv_base_unittest;

  typedef struct {
    int sourceid;
    int sinkid;
    int weight;
    int delay;
  } edge_tb_t;
  edge_tb_t edge_tb[$] = '{
    '{0, 2, 0, 0},
    '{1, 2, 1, 1},
    '{2, 3, 0, 0},
    '{2, 4, 1, 1},
    '{3, 0, 0, 0},
    '{4, 0, 1, 1},
    '{0, 0, 0, 0}
  };

  /* expected all circular paths */
  typedef struct {
    int q[$];
  } expect_visits_t;

  typedef struct {
    expect_visits_t q[$];
  } expect_paths_t;

  expect_paths_t expect_path_m[int] = '{
    0: '{
         '{
           '{'{0, 2, 3, 0}},
           '{'{0, 2, 4, 0}},
           '{'{0, 0}}
          }
        }
  };

  typedef smtdv_circular_graph_test test_t;
  typedef smtdv_graph graph_t;
  typedef smtdv_node node_t;
  typedef smtdv_edge edge_t;

  graph_t graph;
  node_t nodes[$];
  edge_t edges[$];

  int nodeid = 0;
  int edgeid = 0;
  const int maxnodes = 5;
  const int maxedges = 7;

  `uvm_component_utils(smtdv_circular_graph_test)

  function new(string name = "smtdv_circular_graph_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void test_circular_graph();
  extern virtual function void test_find_all_loops();

  /*
  *  register all tests at run_phase
  */
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    test_circular_graph();
    test_find_all_loops();
  endtask : run_phase

endclass : smtdv_circular_graph_test

/*
* build up graph topology
*/
function void smtdv_circular_graph_test::build_phase(uvm_phase phase);
    int sourceid, sinkid;

    super.build_phase(phase);

    // create graph
    graph = graph_t::type_id::create("graph");
    graph.debug = TRUE;

    // create node[0] ~ node[4]
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
      // link correlation edge to node
      nodes[sourceid].add_out_edge(edgeid);
      nodes[sinkid].add_in_edge(edgeid);
      edgeid++;
    end

    graph.finalize();
endfunction : build_phase

/*
* test circular graph
*/
function void smtdv_circular_graph_test::test_circular_graph();
  // circular graph test
  if(!graph.is_circular_graph())
    `uvm_error("SMTDV_CIRCULAR_GRAPH_TEST",
        {$psprintf("graph must be circular graph")})

endfunction : test_circular_graph


/*
* test find all loops
*/
function void smtdv_circular_graph_test::test_find_all_loops();
//  smtdv_graph::paths_m_t path_m;
//  smtdv_graph::paths_t paths;
//  smtdv_graph::visits_t visits;
//  expect_paths_t expect_paths;
//  expect_visits_t expect_visits;
//  bit pass;
//
//  graph.find_circular_paths(path_m);

endfunction : test_find_all_loops


`endif //__SMTDV_CIRCULAR_GRAPH_TEST_SV__
