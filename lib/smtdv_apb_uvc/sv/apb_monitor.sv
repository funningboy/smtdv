`ifndef __APB_MONITOR_SV__
`define __APB_MONITOR_SV__

typedef class apb_sequence_item;
typedef class apb_slave_sequencer;
typedef class apb_master_sequencer;
typedef class apb_slave_cfg;
typedef class apb_master_cfg;

class apb_monitor#(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32,
  type CFG = apb_slave_cfg,
  type SEQR = apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    smtdv_monitor#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(CFG),
      .SEQR(SEQR),
      .T1(apb_sequence_item#(ADDR_WIDTH,DATA_WIDTH))
      );

  typedef apb_monitor#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) mon_t;
  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef apb_collect_write_items#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) coll_wr_item_t;
  typedef apb_collect_read_items#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) coll_rd_item_t;
  typedef apb_collect_stop_signal#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) coll_stop_sin_t;
  typedef apb_collect_cover_group#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) coll_cov_grp_t;
  typedef apb_export_collected_items#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) exp_coll_items_t;
  typedef apb_update_notify_labels#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) updt_note_lab_t;
  typedef apb_snoop_backdoor_labels#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) snop_bkdor_lab_t;
  typedef smtdv_thread_handler#(mon_t) hdler_t;

  // as frontend threads/handler
  hdler_t th_handler;

  mailbox#(item_t) cbox; // collect coverage channel
  mailbox#(item_t) ebox; // export to db channel
  mailbox#(item_t) bbox; // update cfg channel
  mailbox#(item_t) sbox; // snoop to deubg channel

  // as backend system services, don't override these.
  coll_wr_item_t th0;
  coll_rd_item_t th1;
  coll_stop_sin_t th2;
  updt_note_lab_t th5;
  snop_bkdor_lab_t th6;

  // as frontend system services, user can override these at top level.
  coll_cov_grp_t th3;
  exp_coll_items_t th4;

  `uvm_component_param_utils_begin(mon_t)
  `uvm_component_utils_end

  function new (string name = "apb_monitor", uvm_component parent=null);
    super.new(name, parent);
    cbox = new();
    ebox = new();
    bbox = new();
    sbox = new();
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th_handler = hdler_t::type_id::create("apb_monitor_handler", this);

    th0 = coll_wr_item_t::type_id::create("apb_collect_write_items", this);
    th1 = coll_rd_item_t::type_id::create("apb_collect_read_items", this);
    th2 = coll_stop_sin_t::type_id::create("apb_collect_stop_signal", this);

    th3 = coll_cov_grp_t::type_id::create("apb_collect_cover_group", this);
    th4 = exp_coll_items_t::type_id::create("apb_export_collected_items", this);
    th5 = updt_note_lab_t::type_id::create("apb_update_notify_labels", this);
    th6 = snop_bkdor_lab_t::type_id::create("apb_snoop_backdoor_labels", this);

    `SMTDV_RAND(th_handler)
    `SMTDV_RAND(th0)
    `SMTDV_RAND(th1)
    `SMTDV_RAND(th2)
    `SMTDV_RAND(th3)
    `SMTDV_RAND(th4)
    `SMTDV_RAND(th5)
    `SMTDV_RAND(th6)
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    th0.register(this); th_handler.add(th0);
    th1.register(this); th_handler.add(th1);
    th2.register(this); th_handler.add(th2);
    th3.register(this); th_handler.add(th3);
    th4.register(this); th_handler.add(th4);
    th5.register(this); th_handler.add(th5);
    th6.register(this); th_handler.add(th6);
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    th_handler.register(this);
    th_handler.finalize();
  endfunction : end_of_elaboration_phase

  virtual task run_threads();
    super.run_threads();
    th_handler.run();
    th_handler.watch();
  endtask : run_threads

endclass : apb_monitor

`endif // end of __APB_MONITOR_SV__

