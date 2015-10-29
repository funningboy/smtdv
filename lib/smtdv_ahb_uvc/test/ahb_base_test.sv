
`ifndef __AHB_TEST_SV__
`define __AHB_TEST_SV__

// 1Mx2S
class ahb_base_test extends smtdv_test;

  parameter ADDR_WIDTH = `AHB_ADDR_WIDTH;
  parameter DATA_WIDTH = `AHB_DATA_WIDTH;
  parameter NUM_OF_INITOR = 1;
  parameter NUM_OF_TARGETS = 1;

  `AHB_RST_VIF ahb_rst_vif;

  `AHB_SLAVE_AGENT slave_agent[$];
  `AHB_SLAVE_CFG slave_cfg[$];

  `AHB_MASTER_AGENT master_agent[$];
  `AHB_MASTER_CFG master_cfg[$];

  `AHB_BASE_SCOREBOARD master_scb[$];

  smtdv_reset_model #(`AHB_RST_VIF) ahb_rst_model;

  `uvm_component_utils(`AHB_BASE_TEST)

  function new(string name = "ahb_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  // lookup table expect from .xml or .yaml
  virtual function void build_phase(uvm_phase phase);
    bit [ADDR_WIDTH-1:0] start_addr, end_addr;
    super.build_phase(phase);

    // slaves cfg, agent
    slave_cfg[0] = `AHB_SLAVE_CFG::type_id::create({$psprintf("slave_cfg[%0d]", 0)}, this);
    `SMTDV_RAND_WITH(slave_cfg[0], {
      has_force == 0;
      has_coverage == 1;
      has_export == 1;
      has_error == 0;
      has_retry == 1;
      has_split == 0;
    })
    slave_agent[0] = `AHB_SLAVE_AGENT::type_id::create({$psprintf("slave_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+slave_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(`AHB_SLAVE_CFG)::set(null, "/.+slave_agent[*0]*/", "cfg", slave_cfg[0]);

    // masters cfg, agent
    master_cfg[0] = `AHB_MASTER_CFG::type_id::create({$psprintf("master_cfg[%0d]", 0)}, this);
    `SMTDV_RAND_WITH(master_cfg[0], {
      has_force == 1;
      has_coverage == 1;
      has_export == 1;
      has_busy == 1;
    })
    start_addr = `AHB_START_ADDR(0)
    end_addr = `AHB_END_ADDR(0)
    master_cfg[0].add_slave(slave_cfg[0], 0, start_addr, end_addr);
    master_agent[0] = `AHB_MASTER_AGENT::type_id::create({$psprintf("master_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+master_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(`AHB_MASTER_CFG)::set(null, "/.+master_agent[*0]*/", "cfg", master_cfg[0]);

    // scoreboard num of masters cross all slaves ex: 3*all, 2*all socreboard
    // base is eq num of master
    master_scb[0] = `AHB_BASE_SCOREBOARD::type_id::create({$psprintf("master_scb[%0d]", 0)}, this);

    // resetn
    ahb_rst_model = smtdv_reset_model#(`AHB_RST_VIF)::type_id::create("ahb_rst_model");
    if(!uvm_config_db#(`AHB_RST_VIF)::get(this, "", "ahb_rst_vif", ahb_rst_vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".ahb_rst_vif"});
    ahb_rst_model.create_rst_monitor(ahb_rst_vif);

    //sqlite3
    smtdv_sqlite3::delete_db("ahb_db.db");
    smtdv_sqlite3::new_db("ahb_db.db");
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    master_agent[0].mon.item_collected_port.connect(master_scb[0].initor[0]);
    slave_agent[0].mon.item_collected_port.connect(master_scb[0].targets[0]);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    ahb_rst_model.add_component(this);
    ahb_rst_model.set_rst_type(ALL_RST);
    ahb_rst_model.show_components(0);
  endfunction

  virtual function void check_phase(uvm_phase phase);
  endfunction

endclass

`endif // __AHB_TEST_SV__
