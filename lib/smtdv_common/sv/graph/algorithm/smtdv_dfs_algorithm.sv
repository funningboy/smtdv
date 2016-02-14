
`ifndef __SMTDV_DFS_ALGORITHM__
`define __SMTDV_DFS_ALGORITHM__

class smtdv_dfs_algorithm
  extends
  smtdv_base_algorithm;

  typedef struct {
    int q[$];
  } visits_t;

  typedef struct {
    visits_t q[$];
  } paths_t;

  typedef smtdv_dfs_algorithm alg_t;

  int startids[$];
  int endids[$];

  `uvm_object_param_utils_begin(alg_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_dfs_algorithm");
    super.new(name);
  endfunction : new

  extern virtual function void find_paths(int startid=-1, int endid=-1, ref paths_t paths);
  //extern virtual protected function void _iter_deepest_visit(int nodeid, ref paths_t paths, ref visits_t visits);

endclass : smtdv_dfs_algorithm

/*
* find all topology paths from startid to endid if defined, otherwise default
* set is all initorids to targetids
*/
function void smtdv_graph::find_paths(int startid=-1, int targetid=-1, ref paths_t paths);
  visits_t visits;
  paths_t paths;

//  if (is_circular_graph())
//    `uvm_error("SMTDV_GRAPH",
//        {$psprintf("circular graph doesn't support find_paths")})

  find_startids(startids);
  find_endids(endids);

  foreach(startids[i]) begin
      _iter_dfs_visit(nodeid, paths, visits);
  end

endfunction : find_paths

/*
* iter run as deepest first search
*/
function void smtdv_graph::_iter_dfs_visit(int nodeid, ref paths_t paths, ref visits_t visits);
  edge_t tedges[$];
  node_t tnode;

  tnode = G.get_node(nodeid);
  tnode.get_outs(tedges);
  visits.q.push_back(nodeid);

  foreach(tedges[i]) begin
    if(tedges[i].sourceid != nodeid)
    `uvm_error("SMTDV_GRAPH",
        {$psprintf("found mismatch edge.sourceid %d and nodeid %d", tedges[i].sourceid, nodeid)})
     // stop while loop found
     if(!tedges[i].sinkid inside {visits.q})
      _iter_dfs_visit(tedges[i].sinkid, paths, visits);
  end

  if (visits.q[$] inside {endids})
    paths.q.push_back(visits);

  if (debug) _dump_visits(visits);

  if (visits.q.size()>0) void'(visits.q.pop_back());
endfunction : _iter_deepest_visit


