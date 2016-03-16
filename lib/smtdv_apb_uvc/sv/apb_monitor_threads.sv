
`ifndef __APB_MONITOR_THREADS_SV__
`define __APB_MONITOR_THREADS_SV__

typedef class apb_monitor;
typedef class apb_slave_sequencer;
typedef class apb_master_sequencer;
typedef class apb_master_cfg;
typedef class apb_slave_cfg;
typedef class apb_sequence_item;

class apb_monitor_base_thread#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = apb_slave_cfg,
  type SEQR = apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    smtdv_run_thread#(
      apb_monitor#(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .CFG(CFG),
        .SEQR(SEQR))
  );

  typedef apb_monitor_base_thread#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) th_t;
  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef apb_monitor#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) mon_t;
  typedef apb_master_cfg m_cfg_t;
  typedef apb_slave_cfg s_cfg_t;

  item_t item;
  m_cfg_t m_cfg;
  s_cfg_t s_cfg;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "apb_monitor_base_thread", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void pre_do();
    if (!this.cmp) begin
      `uvm_fatal("APB_NO_CMP",
          {"CMP MUST BE SET ",get_full_name(),".cmp"});
    end
  endfunction : pre_do

endclass : apb_monitor_base_thread


class apb_collect_cover_group#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = apb_slave_cfg,
  type SEQR = apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    apb_monitor_base_thread#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .CFG(CFG),
      .SEQR(SEQR)
  );

  typedef apb_collect_cover_group#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) cov_grp_t;

  // should be override
  bit [ADDR_WIDTH-1:0] start_addr = 32'h0000_0000;
  bit [ADDR_WIDTH-1:0] end_addr = 32'hffff_ffff;
  bit [DATA_WIDTH-1:0] start_data = 32'h0000_0000;
  bit [DATA_WIDTH-1:0] end_data = 32'hffff_ffff;

 `uvm_object_param_utils_begin(cov_grp_t)
 `uvm_object_utils_end

  covergroup apb_coverage;
    apb_addr : coverpoint item.addr {
      bins zero = {0};
      bins non_zero = {[start_addr:end_addr]};
    }
    apb_rw : coverpoint item.trs_t {
      bins read = {RD};
      bins write = {WR};
    }
    apb_data : coverpoint item.unpack_data(0) {
      bins zero = {0};
      bins non_zero = {[start_data:end_data]};
    }
    apb_rsp : coverpoint item.rsp {
      bins ok = {OK};
      bins err = {ERR};
    }
    apb_trx  : cross apb_addr, apb_rw, apb_data, apb_rsp;
  endgroup : apb_coverage

  function new(string name = "apb_collect_cover_group", uvm_component parent=null);
    super.new(name, parent);
    apb_coverage = new();
  endfunction : new

  virtual task run();
    forever begin
      this.cmp.cbox.get(item);
      apb_coverage.sample();

      if (this.cmp.cfg.has_debug)
        update_timestamp();
    end
  endtask : run

endclass : apb_collect_cover_group


class apb_export_collected_items#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = apb_slave_cfg,
  type SEQR = apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    apb_monitor_base_thread#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .CFG(CFG),
      .SEQR(SEQR)
  );

  typedef apb_export_collected_items#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) exp_items_t;

  string attr_longint[$] = `SMTDV_BUS_VIF_ATTR_LONGINT;

  `uvm_object_param_utils_begin(exp_items_t)
  `uvm_object_utils_end

  function new(string name = "apb_export_collected_items", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual task run();
    create_table();
    forever begin
      this.cmp.ebox.get(item);
      populate_item(item);

      if (this.cmp.cfg.has_debug)
        update_timestamp();
    end
  endtask : run

  virtual task create_table();
    string table_nm = $psprintf("\"%s\"", this.cmp.get_full_name());
    `uvm_info(this.cmp.get_full_name(),
        {$psprintf("CREATE MON SQLITE3: %s\n", table_nm)}, UVM_LOW)

    smtdv_sqlite3::create_tb(table_nm);
    foreach (attr_longint[i])
      smtdv_sqlite3::register_longint_field(table_nm, attr_longint[i]);
    smtdv_sqlite3::exec_field(table_nm);
  endtask : create_table

  virtual task populate_item(item_t item);
    string table_nm = $psprintf("\"%s\"", this.cmp.get_full_name());
    smtdv_sqlite3::insert_value(table_nm, "dec_uuid",    $psprintf("%d", item.get_transaction_id()));
    smtdv_sqlite3::insert_value(table_nm, "dec_id",      $psprintf("%d", item.sel));
    smtdv_sqlite3::insert_value(table_nm, "dec_resp",    $psprintf("%d", item.rsp));
    smtdv_sqlite3::insert_value(table_nm, "dec_addr",    $psprintf("%d", item.addr));
    smtdv_sqlite3::insert_value(table_nm, "dec_rw",      $psprintf("%d", item.trs_t));
    smtdv_sqlite3::insert_value(table_nm, "dec_data_000",$psprintf("%d", item.unpack_data(0)));
    smtdv_sqlite3::insert_value(table_nm, "dec_bg_cyc",  $psprintf("%d", item.bg_cyc));
    smtdv_sqlite3::insert_value(table_nm, "dec_ed_cyc",  $psprintf("%d", item.ed_cyc));
    smtdv_sqlite3::insert_value(table_nm, "dec_bg_time", $psprintf("%d", item.bg_time));
    smtdv_sqlite3::insert_value(table_nm, "dec_ed_time", $psprintf("%d", item.ed_time));
    smtdv_sqlite3::exec_value(table_nm);
    smtdv_sqlite3::flush_value(table_nm);
  endtask : populate_item

endclass : apb_export_collected_items


class apb_update_notify_labels#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = apb_slave_cfg,
  type SEQR = apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    apb_monitor_base_thread#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .CFG(CFG),
      .SEQR(SEQR)
  );

  typedef apb_update_notify_labels#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) note_labs_t;
  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef smtdv_base_item bitem_t;

  item_t item;
  bitem_t bitem;

  `uvm_object_param_utils_begin(note_labs_t)
  `uvm_object_utils_end

  function new(string name = "apb_update_notify_labels", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual task run();
    forever begin
      this.cmp.bbox.get(item);
      populate_item(item);

      if (this.cmp.cfg.has_debug)
        update_timestamp();

    end
  endtask : run

  virtual task populate_item(item_t item);
    if (!$cast(bitem, item))
      `uvm_error("SMTDV_DCAST_SEQ_ITEM",
         {$psprintf("DOWN CAST TO SMTDV SEQ_ITEM FAIL")})

    bitem.cmp = this.cmp;
    smtdv_label_handler::push_item(bitem);

  endtask : populate_item

endclass : apb_update_notify_labels


class apb_collect_stop_signal#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = apb_slave_cfg,
  type SEQR = apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    apb_monitor_base_thread#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .CFG(CFG),
      .SEQR(SEQR)
  );

  typedef apb_collect_stop_signal#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) stop_t;

  rand int stop_cnt;
  int cnt = 0;

  constraint c_stop_cnt { stop_cnt inside {[100:200]}; }

  `uvm_object_param_utils_begin(stop_t)
    `uvm_field_int(stop_cnt, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "apb_collect_stop_signal", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual task do_stop();
    while (cnt < stop_cnt) begin
      @(negedge this.cmp.vif.clk);
      cnt = (this.cmp.vif.penable || this.cmp.vif.pready || !this.cmp.vif.resetn)? 0 : cnt+1;

      if (this.cmp.cfg.has_debug)
        update_timestamp();
    end
  endtask : do_stop

  virtual task run();
    do_stop();
    // notify sequencer to finish
    // like timeout watch dog ref: http://www.synapse-da.com/Uploads/PDFFiles/04_UVM-Heartbeat.pdf
    if (this.cmp.seqr) begin
      this.cmp.seqr.finish = TRUE;
      `uvm_info(this.cmp.get_full_name(),
          {$psprintf("TRY COLLECT FINISH SIGNAL\n")}, UVM_LOW)
    end
    else begin
      `uvm_fatal("APB_MON_STOP",
          {$psprintf("TRY COLLECT FINISH SIGNAL\n")})
    end
  endtask : run

endclass : apb_collect_stop_signal


class apb_collect_write_items#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = apb_slave_cfg,
  type SEQR = apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
   ) extends
    apb_monitor_base_thread#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .CFG(CFG),
      .SEQR(SEQR)
  );

  typedef apb_collect_write_items#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) coll_t;
  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  `uvm_object_param_utils_begin(coll_t)
  `uvm_object_utils_end

  function new(string name = "apb_collect_write_items", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual task run();
    forever begin
      @(negedge this.cmp.vif.clk iff (this.cmp.vif.psel && this.cmp.vif.penable && this.cmp.vif.prwd));
      populate_begin_item(item);

      // notify to sequencer
      if (!$cast(m_cfg, this.cmp.cfg) && item.trs_t == WR) `SMTDV_SWAP(0)
      this.cmp.item_asserted_port.write(item);
      @(negedge this.cmp.vif.clk iff (this.cmp.vif.pready));
      populate_end_item(item);

      // notify to scoreboard
      if (!$cast(m_cfg, this.cmp.cfg) && item.trs_t == WR) `SMTDV_SWAP(0)

      `uvm_info(this.cmp.get_full_name(),
            {$psprintf("TRY COLLECT WRITE ITEM\n%s", item.sprint())}, UVM_LOW)

      if (item.success) this.cmp.item_collected_port.write(item);

      if (this.cmp.cfg.has_coverage) this.cmp.cbox.put(item);
      if (this.cmp.cfg.has_export)   this.cmp.ebox.put(item);
      if (this.cmp.cfg.has_notify)   this.cmp.bbox.put(item);

      if (this.cmp.cfg.has_debug)
         update_timestamp();

    end
  endtask : run

  virtual function void populate_begin_item(ref item_t item);
    item = item_t::type_id::create("apb_write_item");
    item.mod_t = ($cast(m_cfg, this.cmp.cfg))? MASTER: SLAVE;
    item.run_t = (this.cmp.cfg.has_force)? FORCE: NORMAL;
    item.addr = this.cmp.vif.paddr;
    item.addrs[0] = item.addr;
    item.trs_t = WR;
    item.bg_cyc = this.cmp.vif.cyc;
    item.bg_time = $time;
    item.addr_complete = TRUE;
    void'(this.cmp.begin_tr(item, this.cmp.get_full_name()));
  endfunction : populate_begin_item

  virtual function void populate_end_item(item_t item);
    item.pack_data(0, this.cmp.vif.pwdata);
    item.ed_cyc = this.cmp.vif.cyc;
    item.ed_time = $time;
    item.rsp = (this.cmp.vif.pslverr == OK)? OK:ERR;
    item.success = (item.rsp == OK)? TRUE:FALSE;
    item.data_complete = TRUE;
     void'(this.cmp.end_tr(item));
  endfunction : populate_end_item

endclass : apb_collect_write_items


class apb_collect_read_items#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = apb_slave_cfg,
  type SEQR = apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  )  extends
    apb_monitor_base_thread#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .CFG(CFG),
      .SEQR(SEQR)
  );

  typedef apb_collect_read_items#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) coll_t;
  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  `uvm_object_param_utils_begin(coll_t)
  `uvm_object_utils_end

  function new(string name = "apb_collect_read_items", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual task run();
    forever begin
      @(negedge this.cmp.vif.clk iff (this.cmp.vif.psel && this.cmp.vif.penable && !this.cmp.vif.prwd));
      populate_begin_item(item);

      // notify to sequencer
      if ($cast(m_cfg, this.cmp.cfg) && item.trs_t == RD) `SMTDV_SWAP(0)
      this.cmp.item_asserted_port.write(item);
      @(negedge this.cmp.vif.clk iff (this.cmp.vif.pready));
      populate_end_item(item);

      // notify to scoreboard
      if ($cast(m_cfg, this.cmp.cfg) && item.trs_t == RD) `SMTDV_SWAP(0)

      `uvm_info(this.cmp.get_full_name(),
          {$psprintf("TRY COLLECT READ ITEM\n%s", item.sprint())}, UVM_LOW)

      if (item.success) this.cmp.item_collected_port.write(item);

      if (this.cmp.cfg.has_coverage) this.cmp.cbox.put(item);
      if (this.cmp.cfg.has_export)   this.cmp.ebox.put(item);
      if (this.cmp.cfg.has_notify)   this.cmp.bbox.put(item);

      if (this.cmp.cfg.has_debug)
         update_timestamp();

    end
  endtask : run

  virtual function void populate_begin_item(ref item_t item);
    item = item_t::type_id::create("apb_read_item");
    item.mod_t = ($cast(m_cfg, this.cmp.cfg))? MASTER: SLAVE;
    item.run_t = (this.cmp.cfg.has_force)? FORCE: NORMAL;
    item.addr = this.cmp.vif.paddr;
    item.addrs[0] = item.addr;
    item.trs_t = RD;
    item.bg_cyc = this.cmp.vif.cyc;
    item.bg_time = $time;
    item.addr_complete = TRUE;
    void'(this.cmp.begin_tr(item, this.cmp.get_full_name()));
  endfunction : populate_begin_item

  virtual function void populate_end_item(item_t item);
    item.pack_data(0, this.cmp.vif.prdata);
    item.ed_cyc = this.cmp.vif.cyc;
    item.ed_time = $time;
    item.rsp = (this.cmp.vif.pslverr == OK)? OK:ERR;
    item.success = (item.rsp == OK)? TRUE : FALSE;
    item.data_complete = TRUE;
    void'(this.cmp.end_tr(item));
  endfunction : populate_end_item

endclass : apb_collect_read_items

`endif // end of __APB_MONITOR_THREADS_SV__
