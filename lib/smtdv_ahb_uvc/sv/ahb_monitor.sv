`ifndef __AHB_MONITOR_SV__
`define __AHB_MONITOR_SV__

typedef class ahb_sequence_item;
typedef class ahb_slave_sequencer;
typedef class ahb_master_sequencer;
typedef class ahb_slave_cfg;
typedef class ahb_master_cfg;

class ahb_monitor #(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32,
  type CFG = ahb_slave_cfg,
  type SEQR = ahb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    smtdv_monitor#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface ahb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(CFG),
      .SEQR(SEQR),
      .T1(ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH))
      );

  typedef ahb_monitor#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) mon_t;
  typedef ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef ahb_collect_addr_items#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) coll_addr_item_t;
  typedef ahb_collect_data_items#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) coll_data_item_t;
  typedef ahb_collect_stop_signal#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) coll_stop_sin_t;
  typedef ahb_collect_cover_group#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) coll_cov_grp_t;
  typedef ahb_export_collected_items#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) exp_coll_items_t;
  typedef ahb_update_notify_labels#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) updt_note_lab_t;
  typedef smtdv_thread_handler#(mon_t) hdler_t;

  // as frontend threads/handler
  hdler_t th_handler;

  mailbox #(item_t) cbox; // collect coverage channel
  mailbox #(item_t) ebox; // export to db channel
  mailbox #(item_t) pbox; // port to data channel
  mailbox #(item_t) bbox; // update cfg channel

  // as backend system services, don't override these.
  coll_addr_item_t th0;
  coll_data_item_t th1;
  coll_stop_sin_t th2;
  updt_note_lab_t th5;

  // as frontend system services, user can override these at top level.
  coll_cov_grp_t th3;
  exp_coll_items_t th4;

  `uvm_component_param_utils_begin(mon_t)
  `uvm_component_utils_end

  function new (string name = "ahb_monitor", uvm_component parent);
    super.new(name, parent);
    cbox = new();
    ebox = new();
    pbox = new();
    bbox = new();
  endfunction : new

  // register thread to thread handler
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th_handler = hdler_t::type_id::create("ahb_monitor_handler", this);

    th0 = coll_addr_item_t::type_id::create("ahb_collect_addr_items", this);
    th1 = coll_data_item_t::type_id::create("ahb_collect_data_items", this);
    th2 = coll_stop_sin_t::type_id::create("ahb_collect_stop_signal", this);

    th3 = coll_cov_grp_t::type_id::create("ahb_collect_cover_group", this);
    th4 = exp_coll_items_t::type_id::create("ahb_export_collected_items", this);
    th5 = updt_note_lab_t::type_id::create("ahb_update_notify_labels", this);

    `SMTDV_RAND(th_handler)
    `SMTDV_RAND(th0)
    `SMTDV_RAND(th1)
    `SMTDV_RAND(th2)
    `SMTDV_RAND(th3)
    `SMTDV_RAND(th4)
    `SMTDV_RAND(th5)
  endfunction : build_phase


  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    th0.register(this); th_handler.add(th0);
    th1.register(this); th_handler.add(th1);
    th2.register(this); th_handler.add(th2);
    th3.register(this); th_handler.add(th3);
    th4.register(this); th_handler.add(th4);
    th5.register(this); th_handler.add(th5);
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    th_handler.register(this);
    th_handler.finalize();
  endfunction : end_of_elaboration_phase

  virtual task run_threads();
    super.run_threads();
    th_handler.run();
  endtask : run_threads

endclass : ahb_monitor

`endif // end of __AHB_MONITOR_SV__

