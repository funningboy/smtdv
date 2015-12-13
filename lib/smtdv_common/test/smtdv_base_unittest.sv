
`ifndef __SMTDV_UNITTEST_SV__
`define __SMTDV_UNITTEST_SV__

typedef virtual interface smtdv_if vv;

// only check compile is ok for base models
class smtdv_base_unittest extends smtdv_test;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;
  parameter NUM_OF_INITOR = 1;
  parameter NUM_OF_TARGETS = 1;

  smtdv_slave_agent#(vv)  slave_agent[$];
  smtdv_slave_cfg         slave_cfg[$];

  smtdv_master_agent#(vv) master_agent[$];
  smtdv_master_cfg        master_cfg[$];

  smtdv_scoreboard#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS) scb;

  `uvm_component_utils(smtdv_base_unittest)

  function new(string name = "smtdv_base_unittest", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    slave_cfg[0] = smtdv_slave_cfg::type_id::create({$psprintf("slave_cfg[%0d]", 0)}, this);
    slave_agent[0] = smtdv_slave_agent#(vv)::type_id::create({$psprintf("slave_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+slave_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(smtdv_slave_cfg)::set(null, "/.+slave_agent[*0]*/", "cfg", slave_cfg[0]);

    master_cfg[0] = smtdv_master_cfg::type_id::create({$psprintf("master_cfg[%0d]", 0)}, this);
    master_agent[0] = smtdv_master_agent#(vv)::type_id::create({$psprintf("master_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+master_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(smtdv_master_cfg)::set(null, "/.+master_agent[*0]*/", "cfg", master_cfg[0]);

  endfunction

endclass

`endif // end of __SMTDV_UNITTEST_SV__
