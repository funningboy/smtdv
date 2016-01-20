
`ifndef __UART_TEST_SV__
`define __UART_TEST_SV__

//typedef class uart_tx_cfg;
//typedef class uart_rx_cfg;
//typedef class uart_tx_agent;
//typedef class uart_rx_agent;
//typedef class uart_base_scoreboard;
//typedef class uart_item;
//
// 1Mx1S
class uart_base_test
  extends
    smtdv_test;

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;
  parameter NUM_OF_INITOR = 1;
  parameter NUM_OF_TARGETS = 1;

  typedef uart_base_test test_t;

  typedef virtual interface uart_if#(ADDR_WIDTH, DATA_WIDTH) vif_t;
  typedef virtual interface smtdv_gen_rst_if#("", 100, 0) rst_t;

  typedef smtdv_reset_model#(ADDR_WIDTH, DATA_WIDTH, rst_t) rst_mode_t;

  typedef uart_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  typedef uart_tx_cfg tx_cfg_t;
  typedef uart_rx_cfg rx_cfg_t;

  typedef uart_tx_agent#(ADDR_WIDTH, DATA_WIDTH) tx_agt_t;
  typedef uart_rx_agent#(ADDR_WIDTH, DATA_WIDTH) rx_agt_t;

  typedef uart_tx_scoreboard#(
    ADDR_WIDTH,
    DATA_WIDTH,
    NUM_OF_INITOR,
    NUM_OF_TARGETS
  ) tx_scb_t;

  typedef uart_rx_scoreboard#(
    ADDR_WIDTH,
    DATA_WIDTH,
    NUM_OF_INITOR,
    NUM_OF_TARGETS
  ) rx_scb_t;

  tx_cfg_t master_cfg[$];
  tx_agt_t master_agent[$];

  rx_cfg_t slave_cfg[$];
  rx_agt_t slave_agt_t[$];

  tx_scb_t master_scb[$];
  rx_scb_t slave_scb[$];

  rst_t rst_Vif;
  rst_mod_t rst_model;

  `uvm_component_utils(test_t)

  function new(string name = "uart_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //sqlite3
    smtdv_sqlite3::delete_db("uart_db.db");
    smtdv_sqlite3::new_db("uart_db.db");

    // tx0 cfg, agent
    master_cfg[0] = tx_cfg_t::type_id::create({$psprintf("master_cfg[%0d]", 0)}, this);
    `SMTDV_RAND_WITH(master_cfg[0], {
        has_force == TRUE;
        has_coverage == TRUE;
        has_export == TRUE;
        parity_en == TRUE;
        char_length == 3; // as char_len = 8
      })
    master_agent[0] = tx_agt_t::type_id::create({$psprintf("master_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+master_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(tx_cfg_t)::set(null, "/.+master_agent[*0]*/", "cfg", master_cfg[0]);

    // rx0 cfg, agent
    slave_cfg[0] = rx_cfg_t::type_id::create({$psprintf("slave_cfg[%0d]", 0)}, this);
    slave_cfg[0].copy(master_cfg[0]);
    slave_agent[0] = rx_agt_t::type_id::create({$psprintf("slave_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+slave_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(rx_cfg_t)::set(null, "/.+slave_agent[*0]*/", "cfg", slave_cfg[0]);

    // tx -> rx scoreboard
    master_scb[0] = tx_scb_t::type_id::create({$psprintf("master_scb[%0d]", 0)}, this);
    uvm_config_db#(tx_agt_t)::set(null, "/.+master_scb[*0]*/", "initor_m[0]", master_agent[0]);
    uvm_config_db#(rx_agt_t)::set(null, "/.+master_scb[*0]*/", "targets_s[0]", slave_agent[0]);

    // rx -> tx scoreboard
    slave_scb[0] = rx_scb_t::type_id::create({$psprintf("slave_scb[%0d]", 0)}, this);
    uvm_config_db#(rx_agt_t)::set(null, "/.+slave_scb[*0]*/", "initor_m[0]", slave_agent[0]);
    uvm_config_db#(tx_agt_t)::set(null, "/.+slave_scb[*0]*/", "targets_s[0]", master_agent[0]);

    // resetn
    rst_model = rst_mod_t::type_id::create("rst_model");
    if(!uvm_config_db#(rst_t)::get(this, "", "rst_vif", rst_vif))
      `uvm_fatal("UART_NO_VIF",{"VIRTUAL INTERFACE MUST BE SET ",get_full_name(),".rst_vif"});
    rst_model.create_rst_monitor(rst_vif);

  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    master_agent[0].mon.item_collected_port.connect(master_scb[0].initor[0]);
    slave_agent[0].mon.item_collected_port.connect(master_scb[0].targets[0]);

    master_agent[0].mon.item
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uart_rst_model.add_component(this);
    uart_rst_model.set_rst_type(ALL_RST);
    uart_rst_model.show_components(0);
  endfunction


endclass

`endif // __UART_TEST_SV__
