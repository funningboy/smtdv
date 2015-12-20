`ifndef __SMTDV_MASTER_CFG_SV__
`define __SMTDV_MASTER_CFG_SV__

typedef class smtdv_slave_cfg;
typedef class smtdv_cfg;

class smtdv_map_slave_cfg
  extends
    smtdv_cfg;

  smtdv_slave_cfg cfg;
  int unsigned id;
  int unsigned start_addr;
  int unsigned end_addr;

  typedef smtdv_map_slave_cfg mp_cfg_t;

  // interrupt callback when preload seq is completed
  event interrupt;
  // select preload/reproduce img when fw ini is completed
  int preload = 0;

  `uvm_object_param_utils_begin(mp_cfg_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_master_cfg", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

endclass : smtdv_map_slave_cfg


class smtdv_master_cfg
  extends
    smtdv_cfg;

  typedef smtdv_map_slave_cfg mp_cfg_t;
  typedef smtdv_master_cfg m_cfg_t;
  typedef smtdv_slave_cfg s_cfg_t;

  mp_cfg_t mcfg;
  mp_cfg_t map_cfgs[$];

  rand bit has_retry;

  constraint c_has_retry { has_retry inside {[FALSE:TRUE]}; }

  `uvm_object_param_utils_begin(m_cfg_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_master_cfg", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void delete_slave();
  extern virtual function void add_slave(s_cfg_t cfg, int id, int unsigned start_addr, int unsigned end_addr);
  extern virtual function int find_slave(int unsigned addr);

endclass : smtdv_master_cfg


function void smtdv_master_cfg::delete_slave();
endfunction


function void smtdv_master_cfg::add_slave(s_cfg_t cfg, int id, int unsigned start_addr, int unsigned end_addr);
  mcfg = new();
  mcfg.cfg = cfg;
  mcfg.id = id;
  mcfg.start_addr = start_addr;
  mcfg.end_addr = end_addr;
  map_cfgs.push_back(mcfg);
endfunction : add_slave


function int smtdv_master_cfg::find_slave(int unsigned addr);
  int founds[$];
  founds = map_cfgs.find_index(item)  with (item.start_addr <= addr && addr < item.end_addr);
  if (founds.size()==1) begin
    $cast(mcfg, map_cfgs[founds[0]]);
    return mcfg.id;
  end
  return -1;
endfunction


`endif // __SMTDV_MASTER_CFG_SV__
