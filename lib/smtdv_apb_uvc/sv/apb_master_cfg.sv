`ifndef __APB_MASTER_CFG_SV__
`define __APB_MASTER_CFG_SV__

typedef class apb_slave_cfg;

class apb_map_slave_cfg
  extends
    smtdv_cfg;

    `APB_SLAVE_CFG cfg;
    int id;
    int start_addr;
    int end_addr;

  `uvm_object_param_utils_begin(`APB_MAP_SLAVE_CFG)
  `uvm_object_utils_end

  function new(string name = "apb_master_cfg", smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

endclass

class apb_master_cfg
  extends
    smtdv_cfg;

  bit block_psel = 0;
  bit block_penable = 0;

  `APB_MAP_SLAVE_CFG mcfg;
  `APB_MAP_SLAVE_CFG map_cfgs[$];

  `uvm_object_param_utils_begin(`APB_MASTER_CFG)
    `uvm_field_int(block_psel, UVM_DEFAULT)
    `uvm_field_int(block_penable, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "apb_master_cfg",  smtdv_component cmp=null);
    super.new(name, cmp);
  endfunction

  virtual function void add_slave(`APB_SLAVE_CFG cfg, int id, int start_addr, int end_addr);
    mcfg = new();
    mcfg.cfg = cfg;
    mcfg.id = id;
    mcfg.start_addr = start_addr;
    mcfg.end_addr = end_addr;
    map_cfgs.push_back(mcfg);
  endfunction

  virtual function int find_slave(int addr);
    int founds[$];
    founds = map_cfgs.find_index(item)  with (item.start_addr <= addr && addr < item.end_addr);
    assert(founds.size()==1);
    $cast(mcfg, map_cfgs[founds[0]]);
    return mcfg.id;
  endfunction

endclass

`endif // __APB_MASTER_CFG_SV__
