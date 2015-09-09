
`ifndef __XBUS_TEST_SV__
`define __XBUS_TEST_SV__

class xbus_base_test extends smtdv_test;

  parameter ADDR_WIDTH = `XBUS_ADDR_WIDTH;
  parameter BYTEN_WIDTH = `XBUS_BYTEN_WIDTH;
  parameter DATA_WIDTH = `XBUS_DATA_WIDTH;

  `XBUS_VIF vif;
  `XBUS_RST_VIF xbus_rst_vif;

  `XBUS_SLAVE_AGENT slave_agent[$];
  `XBUS_SLAVE_CFG slave_cfg[$];

  `XBUS_MASTER_AGENT master_agent[$];
  `XBUS_MASTER_CFG master_cfg[$];

  smtdv_reset_model #(`XBUS_RST_VIF) xbus_rst_model;

  `uvm_component_utils(`XBUS_BASE_TEST)

  function new(string name = "xbus_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    string slave_cfg0;
    super.build_phase(phase);

    // slave cfg, agent
    slave_cfg0 = {$psprintf("slave_cfg[%0d]", 0)};
    slave_cfg[0] = `XBUS_SLAVE_CFG::type_id::create(slave_cfg0, this);
    slave_cfg[0].has_force = 0;
    slave_cfg[0].has_coverage = 1;
    slave_cfg[0].has_export = 1;
    slave_agent[0] = `XBUS_SLAVE_AGENT::type_id::create("slave_agent[0]", this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+slave_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(`XBUS_SLAVE_CFG)::set(null, "/.+slave_agent[*0]*/", "cfg", slave_cfg[0]);

    // master cfg, agent
    master_cfg[0] = `XBUS_MASTER_CFG::type_id::create("master_cfg[0]", this);
    master_cfg[0].has_force = 1;
    master_cfg[0].has_coverage = 1;
    master_cfg[0].has_export = 1;
    master_agent[0] = `XBUS_MASTER_AGENT::type_id::create("master_agent[0]", this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+master_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(`XBUS_MASTER_CFG)::set(null, "/.+master_agent[*0]*/", "cfg", master_cfg[0]);

    // resetn
    xbus_rst_model = smtdv_reset_model#(`XBUS_RST_VIF)::type_id::create("xbus_rst_model");
    if(!uvm_config_db#(`XBUS_RST_VIF)::get(this, "", "xbus_rst_vif", xbus_rst_vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".xbus_rst_vif"});
    xbus_rst_model.create_rst_monitor(xbus_rst_vif);

    //sqlite3
    smtdv_sqlite3::delete_db("xbus_db.db");
    smtdv_sqlite3::new_db("xbus_db.db");
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    xbus_rst_model.add_component(this);
    xbus_rst_model.set_rst_type(ALL_RST);
    xbus_rst_model.show_components(0);
  endfunction


endclass

`endif // __XBUS_TEST_SV__
