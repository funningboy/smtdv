
`ifndef __UART_TEST_SV__
`define __UART_TEST_SV__

// 1Mx1S
class uart_base_test
  extends
    smtdv_test;

  `UART_RST_VIF uart_rst_vif;

  `UART_RX_AGENT rx_agent[$];
  `UART_RX_CFG rx_cfg[$];

  `UART_TX_AGENT tx_agent[$];
  `UART_TX_CFG tx_cfg[$];

  smtdv_reset_model #(`UART_RST_VIF) uart_rst_model;

  `uvm_component_utils(`UART_BASE_TEST)

  function new(string name = "uart_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    string rx_cfg0, tx_cfg0;
    super.build_phase(phase);

    // rx0 cfg, agent
    rx_cfg0 = {$psprintf("rx_cfg[%0d]", 0)};
    rx_cfg[0] = `UART_RX_CFG::type_id::create(rx_cfg0, this);
    `SMTDV_RAND_WITH(rx_cfg[0], {
        has_force == 1;
        has_coverage == 1;
        has_export == 1;
        parity_en == 1;
      })
    rx_cfg[0].post_randomize();
    rx_cfg[0].is_tx_active = UVM_PASSIVE;
    rx_cfg[0].is_rx_active = UVM_ACTIVE;
    rx_agent[0] = `UART_RX_AGENT::type_id::create("rx_agent[0]", this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+rx_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(`UART_RX_CFG)::set(null, "/.+rx_agent[*0]*/", "cfg", rx_cfg[0]);
    `uvm_info(get_type_name(), {"Printing rx_cfg0:\n", rx_cfg[0].sprint()}, UVM_MEDIUM)

    // tx cfg, agent
    tx_cfg0 = {$psprintf("tx_cfg[%0d]", 0)};
    tx_cfg[0] = `UART_TX_CFG::type_id::create(tx_cfg0, this);
    tx_cfg[0].copy(rx_cfg[0]);
    tx_cfg[0].is_tx_active = UVM_ACTIVE;
    tx_cfg[0].is_rx_active = UVM_PASSIVE;
    tx_agent[0] = `UART_TX_AGENT::type_id::create("tx_agent[0]", this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+tx_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(`UART_TX_CFG)::set(null, "/.+tx_agent[*0]*/", "cfg", tx_cfg[0]);
    `uvm_info(get_type_name(), {"Printing tx_cfg0:\n", tx_cfg[0].sprint()}, UVM_MEDIUM)

    // resetn
    uart_rst_model = smtdv_reset_model#(`UART_RST_VIF)::type_id::create("uart_rst_model");
    if(!uvm_config_db#(`UART_RST_VIF)::get(this, "", "uart_rst_vif", uart_rst_vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".uart_rst_vif"});
    uart_rst_model.create_rst_monitor(uart_rst_vif);

    //sqlite3
    smtdv_sqlite3::delete_db("uart_db.db");
    smtdv_sqlite3::new_db("uart_db.db");
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uart_rst_model.add_component(this);
    uart_rst_model.set_rst_type(ALL_RST);
    uart_rst_model.show_components(0);
  endfunction


endclass

`endif // __UART_TEST_SV__
