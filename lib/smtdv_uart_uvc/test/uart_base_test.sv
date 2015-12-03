
`ifndef __UART_TEST_SV__
`define __UART_TEST_SV__

// 1Mx1S
class uart_base_test
  extends
    smtdv_test;

  // one to one check
  parameter NUM_OF_INITOR = 1;
  parameter NUM_OF_TARGETS = 1;

  `UART_RST_VIF uart_rst_vif;

  `UART_SLAVE_AGENT slave_agent[$];
  `UART_SLAVE_CFG slave_cfg[$];

  `UART_MASTER_AGENT master_agent[$];
  `UART_MASTER_CFG master_cfg[$];

  `UART_BASE_SCOREBOARD master_scb[$]; // tx -> rx

  smtdv_reset_model #(`UART_RST_VIF) uart_rst_model;

  `uvm_component_utils(`UART_BASE_TEST)

  function new(string name = "uart_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    string slave_cfg0, master_cfg0, master_cfg1;
    super.build_phase(phase);

    //sqlite3
    smtdv_sqlite3::delete_db("uart_db.db");
    smtdv_sqlite3::new_db("uart_db.db");

    // tx0 cfg, agent
    master_cfg0 = {$psprintf("master_cfg[%0d]", 0)};
    master_cfg[0] = `UART_MASTER_CFG::type_id::create(master_cfg0, this);
    `SMTDV_RAND_WITH(master_cfg[0], {
        has_force == 1;
        has_coverage == 1;
        has_export == 1;
        parity_en == 1;
        char_length == 3; // as char_len = 8
      })
    master_agent[0] = `UART_MASTER_AGENT::type_id::create("master_agent[0]", this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+master_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(`UART_MASTER_CFG)::set(null, "/.+master_agent[*0]*/", "cfg", master_cfg[0]);
    `uvm_info(get_type_name(), {"Printing master_cfg0:\n", master_cfg[0].sprint()}, UVM_MEDIUM)

    // rx0 cfg, agent
    slave_cfg0 = {$psprintf("slave_cfg[%0d]", 0)};
    slave_cfg[0] = `UART_SLAVE_CFG::type_id::create(slave_cfg0, this);
    slave_cfg[0].copy(master_cfg[0]);
    slave_agent[0] = `UART_SLAVE_AGENT::type_id::create("slave_agent[0]", this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+slave_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(`UART_SLAVE_CFG)::set(null, "/.+slave_agent[*0]*/", "cfg", slave_cfg[0]);
    `uvm_info(get_type_name(), {"Printing slave_cfg0:\n", slave_cfg[0].sprint()}, UVM_MEDIUM)

    // scoreboard num of masters cross all slaves ex: 3*all, 2*all socreboard
    master_scb[0] = `UART_BASE_SCOREBOARD::type_id::create({$psprintf("master_scb[%0d]", 0)}, this);
    uvm_config_db#(`UART_MASTER_AGENT)::set(null, "/.+master_scb[*0]*/", "initor_m[0]", master_agent[0]);
    uvm_config_db#(`UART_SLAVE_AGENT)::set(null, "/.+master_scb[*0]*/", "targets_s[0]", slave_agent[0]);

    // resetn
    uart_rst_model = smtdv_reset_model#(`UART_RST_VIF)::type_id::create("uart_rst_model");
    if(!uvm_config_db#(`UART_RST_VIF)::get(this, "", "uart_rst_vif", uart_rst_vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".uart_rst_vif"});
    uart_rst_model.create_rst_monitor(uart_rst_vif);

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    master_agent[0].mon.item_collected_port.connect(master_scb[0].initor[0]);
    slave_agent[0].mon.item_collected_port.connect(master_scb[0].targets[0]);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uart_rst_model.add_component(this);
    uart_rst_model.set_rst_type(ALL_RST);
    uart_rst_model.show_components(0);
  endfunction


endclass

`endif // __UART_TEST_SV__
