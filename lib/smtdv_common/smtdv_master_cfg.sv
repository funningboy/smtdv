`ifndef __SMTDV_MASTER_CFG_SV__
`define __SMTDV_MASTER_CFG_SV__

typedef class smtdv_slave_cfg;

class smtdv_map_slave_cfg
  extends
    smtdv_cfg;

  smtdv_slave_cfg cfg;
  int unsigned id;
  int unsigned start_addr;
  int unsigned end_addr;

  `uvm_object_param_utils_begin(smtdv_map_slave_cfg)
  `uvm_object_utils_end

  function new(string name = "smtdv_master_cfg", smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

endclass

class smtdv_master_cfg
  extends
    smtdv_cfg;

  smtdv_map_slave_cfg mcfg;
  smtdv_map_slave_cfg map_cfgs[$];

  `uvm_object_param_utils_begin(smtdv_master_cfg)
  `uvm_object_utils_end

  function new(string name = "smtdv_master_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

  virtual function void delete_slave();
  endfunction

  virtual function void add_slave(smtdv_slave_cfg cfg, int id, int unsigned start_addr, int unsigned end_addr);
    mcfg = new();
    mcfg.cfg = cfg;
    mcfg.id = id;
    mcfg.start_addr = start_addr;
    mcfg.end_addr = end_addr;
    map_cfgs.push_back(mcfg);
  endfunction

  virtual function int find_slave(int unsigned addr);
    int founds[$];
    founds = map_cfgs.find_index(item)  with (item.start_addr <= addr && addr < item.end_addr);
    if (founds.size()==1) begin
      $cast(mcfg, map_cfgs[founds[0]]);
      return mcfg.id;
    end
    return -1;
  endfunction

endclass

`endif // __SMTDV_MASTER_CFG_SV__
