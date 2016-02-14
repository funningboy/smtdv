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
  smtdv_base_test;

  typedef uvm_component bcmp_t;
  typedef smtdv_cmp_node#(bcmp_t) cmp_node_t;
  typedef smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef smtdv_cmp_edge#(cmp_node_t, cmp_node_t, item_t) cmp_edge_t;

  `uvm_component_utils(smtdv_cmp_graph_test)

  function new(string name = "smtdv_cmp_graph_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void test_circular_graph();
  extern virtual function void test_cast_masters();
  extern virtual function void test_cast_slaves();
  extern virtual function void test_collected_item();
  extern virtual task test_graph_worker();
//  extern virtual task test_graph_label_cb();

  /*
  *  register all tests at run_phase
  */
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    test_circular_graph();
    test_cast_masters();
    test_cast_slaves();
    test_collected_item();
    test_graph_worker();
//    test_graph_label_cb();
  endtask : run_phase

endclass : smtdv_cmp_graph_test

/*
* test circular graph
*/
function void smtdv_cmp_graph_test::test_circular_graph();
//  alg_t alg;
//
//  // create algorithm
//  alg = alg_t::type_id::create("smtdv_base_algorithm");
//  alg.set_graph(graph);
//
//  // circular graph test
//  if(!alg.is_circular_graph())
//    `uvm_error("SMTDV_CMP_GRAPH_TEST",
//        {$psprintf("graph must be circular graph")})
//
endfunction : test_circular_graph

/*
* test cmp_envs[0].cmp_blder.cmp_graph.node[0] can cast to right binded master
*/
function void smtdv_cmp_graph_test::test_cast_masters();
  cmp_node_t mst_node;
  mst_agt_t mst_agt;

  // check node cast
  if (!$cast(mst_node, cmp_envs[0].cmp_blder.cmp_graph.get_node(0)))
    `uvm_error("SMTDV_CMP_GRAPH_TEST",
        {$psprintf("get cast mst_node fail")})

  //update node.attr
  mst_node.attr = '{0, 0, $time, $time};

  // check node bind
  if (!$cast(mst_agt, mst_node.get()))
    `uvm_error("SMTDV_CMP_GRAPH_TEST",
        {$psprintf("get bined mst_agt fail")})

  // check mst_agt.cfg
  cmp_envs[0].mst_agts[0].cfg.has_force = FALSE;
  cmp_envs[0].mst_agts[0].cfg.has_force = TRUE;
  if (!mst_agt.cfg.has_force)
    `uvm_error("SMTDV_CMP_GRAPH_TEST",
        {$psprintf("get bined mst_agt.cfg.has_force must be TRUE fail")})

endfunction : test_cast_masters

/*
* test cmp_envs[0].cmp_blder.cmp_graph.node[1] can cast to right binded slave
*/
function void smtdv_cmp_graph_test::test_cast_slaves();
  cmp_node_t slv_node;
  slv_agt_t slv_agt;

  // check node cast
  if (!$cast(slv_node, cmp_envs[0].cmp_blder.cmp_graph.get_node(1)))
    `uvm_error("SMTDV_CMP_GRAPH_TEST",
        {$psprintf("get cast slv_node fail")})

  //update node.attr
  slv_node.attr = '{0, 0, $time, $time};

  // check node bind
  if (!$cast(slv_agt, slv_node.get()))
    `uvm_error("SMTDV_CMP_GRAPH_TEST",
        {$psprintf("get bined slv_agt fail")})

  // check mst_agt.cfg
  cmp_envs[0].slv_agts[0].cfg.has_force = FALSE;
  cmp_envs[0].slv_agts[0].cfg.has_force = TRUE;
  if (!slv_agt.cfg.has_force)
    `uvm_error("SMTDV_CMP_GRAPH_TEST",
        {$psprintf("get bined slv_agt.cfg.has_force must be TRUE fail")})

endfunction : test_cast_slaves

/*
* test collected item event can trggier right edge
*/
function void smtdv_cmp_graph_test::test_collected_item();
  cmp_edge_t cmp_edge;
  cmp_node_t mst_node, slv_node;
  mst_agt_t mst_agt;
  slv_agt_t slv_agt;
  item_t item;

  if (!$cast(cmp_edge, cmp_envs[0].cmp_blder.cmp_graph.get_edge(0)))
    `uvm_error("SMTDV_CMP_GRAPH_TEST",
        {$psprintf("get cast cmp_edge fail")})

  // field in items as full
  for(int i=0; i<20; i++) begin
    item = item_t::type_id::create({$psprintf("item[%0d]", i)});
    cmp_edge.update_item(item);
  end
  if (!cmp_edge.items.is_full() || cmp_edge.items.is_empty())
    `uvm_error("SMTDV_CMP_GRAPH_TEST",
        {$psprintf("get items.full/empty fail")})

  if (!$cast(item, cmp_edge.items.pop_back()))
    `uvm_error("SMTDV_CMP_GRAPH_TEST",
        {$psprintf("get cast item fail")})

endfunction : test_collected_item

/*
* test graph worker sorted by trx utility, ...
*/
task smtdv_cmp_graph_test::test_graph_worker();
  //cmp_envs[0].cmp_blder.cmp_graph.get_node(0);
endtask : test_graph_worker


`endif // __SMTDV_CMP_GRAPH_TEST_SV__
