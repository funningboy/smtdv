`ifndef __AHB_MONITOR_THREADS_SV__
`define __AHB_MONITOR_THREADS_SV__

typedef class ahb_monitor;
typedef class ahb_slave_sequencer;
typedef class ahb_master_sequencer;
typedef class ahb_master_cfg;
typedef class ahb_slave_cfg;

class ahb_monitor_base_thread #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = ahb_slave_cfg,
  type SEQR = ahb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
  smtdv_run_thread#(
    ahb_monitor#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .CFG(CFG),
      .SEQR(SEQR))
  );

  typedef ahb_monitor_base_thread#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) th_t;
  typedef ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef ahb_monitor#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) mon_t;
  typedef ahb_master_cfg m_cfg_t;
  typedef ahb_slave_cfg s_cfg_t;

  item_t item;

  m_cfg_t m_cfg;
  s_cfg_t s_cfg;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "ahb_monitor_base_thread", mon_t parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void pre_do();
    if (!this.cmp) begin
      `uvm_fatal("NOCMP",{"CMP MUST BE SET FOR: ",get_full_name(),".cmp"});
    end
  endfunction : pre_do

endclass : ahb_monitor_base_thread


class ahb_collect_cover_group#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = ahb_slave_cfg,
  type SEQR = ahb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    ahb_monitor_base_thread #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .CFG(CFG),
      .SEQR(SEQR)
  );

  typedef ahb_collect_cover_group#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) cov_grp_t;

  bit [ADDR_WIDTH-1:0] start_addr = 32'h0000_0000;
  bit [ADDR_WIDTH-1:0] end_addr = 32'hffff_ffff;
  bit [DATA_WIDTH-1:0] start_data = 32'h0000_0000;
  bit [DATA_WIDTH-1:0] end_data = 32'hffff_ffff;

  `uvm_object_param_utils_begin(cov_grp_t)
  `uvm_object_utils_end

  covergroup ahb_coverage;
      ahb_addr : coverpoint item.addr {
        bins zero = {0};
        bins non_zero = {[start_addr:end_addr]};
      }
      ahb_rw : coverpoint item.trs_t {
        bins read = {RD};
        bins write = {WR};
      }
      ahb_bst_type : coverpoint item.bst_type {
        bins INCR = {INCR, INCR4, INCR8, INCR16};
        bins WRAP = {WRAP4, WRAP8, WRAP16};
      }
      ahb_trx_size : coverpoint item.trx_size {
        bins B8 = {B8};
        bins B16 = {B16};
        bins B32 = {B32};
        bins B64 = {B64};
        bins B128 = {B128};
        bins B256 = {B256};
        bins B512 = {B512};
        bins B1024 = {B1024};
      }
      ahb_data : coverpoint item.unpack_data(item.data_idx) {
        bins zero = {0};
        bins non_zero = {[start_data:end_data]};
      }
      ahb_rsp : coverpoint item.rsp {
        bins ok = {OKAY};
        bins err = {ERROR};
        bins retry = {RETRY};
        bins split = {SPLIT};
      }
      ahb_lock : coverpoint item.hmastlock {
        bins lock = {1};
        bins unlock = {0};
      }
      ahb_trx  : cross ahb_addr, ahb_rw, ahb_bst_type, ahb_trx_size, ahb_data, ahb_rsp, ahb_lock;
    endgroup : ahb_coverage

    function new(string name = "ahb_collect_cover_group", mon_t parent=null);
      super.new(name, parent);
      ahb_coverage = new();
    endfunction : new

    virtual task run();
      forever begin
        this.cmp.cbox.get(item);
        ahb_coverage.sample();

        if (this.cmp.cfg.has_debug)
          update_timestamp();
      end
    endtask : run

endclass : ahb_collect_cover_group


class ahb_export_collected_items#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = ahb_slave_cfg,
  type SEQR = ahb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    ahb_monitor_base_thread #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .CFG(CFG),
      .SEQR(SEQR)
  );

  typedef ahb_export_collected_items#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) exp_item_t;

  static string attr_longint[$] = `SMTDV_BUS_VIF_ATTR_LONGINT;

  `uvm_object_param_utils_begin(exp_item_t)
  `uvm_object_utils_end

  function new(string name = "ahb_export_collected_items", mon_t parent=null);
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
    string table_nm = {$psprintf("\"%s\"", this.cmp.get_full_name())};
    `uvm_info(this.cmp.get_full_name(), {$psprintf("create mon sqlite3: %s", table_nm)}, UVM_LOW)

    smtdv_sqlite3::create_tb(table_nm);
    foreach (attr_longint[i])
      smtdv_sqlite3::register_longint_field(table_nm, attr_longint[i]);
    smtdv_sqlite3::exec_field(table_nm);
  endtask : create_table

  virtual task populate_item(item_t item);
    string table_nm = {$psprintf("\"%s\"", this.cmp.get_full_name())};
    smtdv_sqlite3::insert_value(table_nm, "dec_uuid",    $psprintf("%d", item.get_transaction_id()));
    smtdv_sqlite3::insert_value(table_nm, "dec_addr",    $psprintf("%d", item.addr));
    smtdv_sqlite3::insert_value(table_nm, "dec_rw",      $psprintf("%d", item.trs_t));
    smtdv_sqlite3::insert_value(table_nm, "dec_len",      $psprintf("%d", item.bst_len));
    smtdv_sqlite3::insert_value(table_nm, "dec_burst",    $psprintf("%d", item.bst_type));
    smtdv_sqlite3::insert_value(table_nm, "dec_size",     $psprintf("%d", item.trx_size));
    smtdv_sqlite3::insert_value(table_nm, "dec_lock",     $psprintf("%d", item.hmastlock));
    smtdv_sqlite3::insert_value(table_nm, "dec_prot",     $psprintf("%d", item.trx_prt));
    smtdv_sqlite3::insert_value(table_nm, "dec_resp",     $psprintf("%d", item.rsp));
    for (int i=0; i<item.data_beat.size(); i++) begin
      if (i<item.data_idx) begin
        smtdv_sqlite3::insert_value(table_nm, $psprintf("dec_data_%03d", i),    $psprintf("%d", item.unpack_data(i)));
      end
    end
    smtdv_sqlite3::insert_value(table_nm, "dec_bg_cyc",  $psprintf("%d", item.bg_cyc));
    smtdv_sqlite3::insert_value(table_nm, "dec_ed_cyc",  $psprintf("%d", item.ed_cyc));
    smtdv_sqlite3::insert_value(table_nm, "dec_bg_time", $psprintf("%d", item.bg_time));
    smtdv_sqlite3::insert_value(table_nm, "dec_ed_time", $psprintf("%d", item.ed_time));
    smtdv_sqlite3::exec_value(table_nm);
    smtdv_sqlite3::flush_value(table_nm);
  endtask : populate_item

endclass : ahb_export_collected_items


class ahb_update_notify_cfgs#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = ahb_slave_cfg,
  type SEQR = ahb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    ahb_monitor_base_thread #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .CFG(CFG),
      .SEQR(SEQR)
  );

  typedef ahb_update_notify_cfgs#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) note_cfgs_t;
  typedef smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH) bitem_t;
  typedef ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  // cover to basic item
  bitem_t bitem;

  `uvm_object_param_utils_begin(note_cfgs_t)
  `uvm_object_utils_end

  function new(string name = "ahb_update_notify_cfgs", mon_t parent=null);
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

  //
  virtual task populate_item(item_t item);
    $cast(bitem, item);
  // smtdv_label_handler::update_item(item);
  // smtdv_label_handler::run();
  endtask : populate_item

endclass : ahb_update_notify_cfgs


class ahb_collect_stop_signal#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = ahb_slave_cfg,
  type SEQR = ahb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    ahb_monitor_base_thread #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .CFG(CFG),
      .SEQR(SEQR)
  );

  typedef ahb_collect_stop_signal#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) stop_t;

  int stop_cnt = 100;
  int cnt = 0;
  int pre_st = IDLE;

  //trx_type_t trx
  `uvm_object_param_utils_begin(stop_t)
  `uvm_field_int(stop_cnt, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "ahb_collect_stop_signal", mon_t parent=null);
    super.new(name, parent);
  endfunction : new

  virtual task do_stop();
    while (cnt < stop_cnt) begin
      @(negedge this.cmp.vif.clk);
      if (pre_st == this.cmp.vif.htrans) begin
        cnt++;
      end
      else begin
        pre_st = this.cmp.vif.htrans;
        cnt = 0;
      end

      if (this.cmp.cfg.has_debug)
        update_timestamp();
    end
  endtask : do_stop

  virtual task run();
    do_stop();
    // notify sequencer to finish
    // like timeout watch dog ref: http://www.synapse-da.com/Uploads/PDFFiles/04_UVM-Heartbeat.pdf
    if (this.cmp.seqr) begin
      this.cmp.seqr.finish = 1;
      `uvm_info(this.cmp.get_full_name(), {$psprintf("try collect finish signal\n")}, UVM_LOW)
    end
    else begin
      `uvm_fatal(this.cmp.get_full_name(), {$psprintf("try collect finish signal\n")})
    end
  endtask : run

endclass : ahb_collect_stop_signal


class ahb_collect_addr_items#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = ahb_slave_cfg,
  type SEQR = ahb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    ahb_monitor_base_thread #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .CFG(CFG),
      .SEQR(SEQR)
  );

  typedef ahb_collect_addr_items#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) coll_t;
  typedef ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  `uvm_object_param_utils_begin(coll_t)
  `uvm_object_utils_end

  function new(string name = "ahb_collect_addr_items", mon_t parent=null);
    super.new(name, parent);
  endfunction : new

  virtual task listen_nonseq(ref item_t item);
    @(negedge this.cmp.vif.clk iff (this.cmp.vif.hready && this.cmp.vif.hresp == OKAY && this.cmp.vif.htrans == NONSEQ));
    populate_nonseq_item(item);
    this.cmp.pbox.put(item);
  endtask : listen_nonseq

  virtual task listen_OKAY(item_t item);
    while (item.addr_idx <= item.bst_len) begin
      @(negedge this.cmp.vif.clk iff (this.cmp.vif.hready && this.cmp.vif.hresp == OKAY));

      if (this.cmp.vif.htrans == SEQ) begin populate_seq_item(item); end
      else if (this.cmp.vif.htrans == BUSY) begin populate_busy_item(item); end
      else if (this.cmp.vif.htrans == IDLE) begin popilate_idle_item(item); end
    end
    populate_okay_item(item);
    populate_complete_item(item);
  endtask : listen_OKAY

  virtual task listen_RETRY(item_t item);
    @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == RETRY));
    populate_retry_item(item);
    @(negedge this.cmp.vif.clk iff (this.cmp.vif.hready && this.cmp.vif.hresp == RETRY && this.cmp.vif.htrans == IDLE));
    populate_retry_item(item);
    populate_complete_item(item);
  endtask : listen_RETRY

  virtual task listen_SPLIT(item_t item);
    @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == SPLIT));
    populate_split_item(item);
    @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == SPLIT && this.cmp.vif.htrans == IDLE));
    populate_split_item(item);
    populate_complete_item(item);
  endtask : listen_SPLIT

  virtual task listen_ERROR(item_t item);
    @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == ERROR));
    populate_error_item(item);
    @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == ERROR && this.cmp.vif.htrans == IDLE));
    populate_error_item(item);
    populate_complete_item(item);
  endtask : listen_ERROR

  virtual task run();
    forever begin
      listen_nonseq(item);
      // notify to slave sequencer
      if (!$cast(m_cfg, this.cmp.cfg) && item.trs_t == WR) `SMTDV_SWAP(0)
      if ($cast(m_cfg, this.cmp.cfg) && item.trs_t == RD) `SMTDV_SWAP(0)
      this.cmp.item_asserted_port.write(item);
      fork
        listen_OKAY(item);
        listen_ERROR(item);
        listen_RETRY(item);
        listen_SPLIT(item);
      join_any
      disable fork;

      `uvm_info(this.cmp.get_full_name(),
          {$psprintf("try collect addr item \n%s", item.sprint())}, UVM_LOW)

       if (this.cmp.cfg.has_debug)
        update_timestamp();

    end
  endtask : run

  virtual task popilate_idle_item(item_t item);
    // detect the idle is init or not,
    if (item==null) return;
  endtask

  virtual task populate_nonseq_item(ref item_t item);
    item = item_t::type_id::create("ahb_sequence_item");
    item.mod_t = ($cast(m_cfg, this.cmp.cfg))? MASTER: SLAVE;
    item.run_t = (this.cmp.cfg.has_force)? FORCE: NORMAL;
    item.addr = this.cmp.vif.haddr;
    item.trs_t = (this.cmp.vif.hwrite)? WR: RD;
    item.trx_size = (this.cmp.vif.hsize == B8) ? B8:
      (this.cmp.vif.hsize == B16)? B16:
      (this.cmp.vif.hsize == B32)? B32:
      (this.cmp.vif.hsize == B64)? B64:
      (this.cmp.vif.hsize == B128)? B128:
      (this.cmp.vif.hsize == B256)? B256:
      (this.cmp.vif.hsize == B512)? B512:
      (this.cmp.vif.hsize == B1024)? B1024: B128;
    item.bst_type = (this.cmp.vif.hburst == SINGLE)? SINGLE:
      (this.cmp.vif.hburst == INCR)? INCR:
      (this.cmp.vif.hburst == WRAP4)? WRAP4:
      (this.cmp.vif.hburst == INCR4)? INCR4:
      (this.cmp.vif.hburst == WRAP8)? WRAP8:
      (this.cmp.vif.hburst == INCR8)? INCR8:
      (this.cmp.vif.hburst == WRAP16)? WRAP16:
      (this.cmp.vif.hburst == INCR16)? INCR16: INCR;
    item.trx_prt = this.cmp.vif.hprot;
    item.bst_len = item.get_bst_len(this.cmp.vif.hburst);
    item.hmastlock = this.cmp.vif.hmastlock;
    item.bg_cyc = this.cmp.vif.cyc;
    item.bg_time = $time;
    item.addr_idx++;
    item.addrs.push_back(this.cmp.vif.haddr);
    void'(this.cmp.begin_tr(item, this.cmp.get_full_name()));
  endtask : populate_nonseq_item

  virtual task populate_seq_item(item_t item);
    item.addr_idx++;
    item.addrs.push_back(this.cmp.vif.haddr);
  endtask : populate_seq_item

  virtual task populate_busy_item(item_t item);
  endtask : populate_busy_item

  virtual task populate_okay_item(item_t item);
    item.rsp = OKAY;
  endtask : populate_okay_item

  virtual task populate_complete_item(item_t item);
    item.addr_complete = TRUE;
  endtask : populate_complete_item

  virtual task populate_retry_item(item_t item);
    if (!item.retry) begin
      item.retry = TRUE;
      item.rsp = RETRY;
    end
  endtask : populate_retry_item

  virtual task populate_split_item(item_t item);
    if (!item.split) begin
      item.split = TRUE;
      item.rsp = SPLIT;
    end
  endtask : populate_split_item

  virtual task populate_error_item(item_t item);
    if (!item.error) begin
      item.error = TRUE;
      item.rsp = ERROR;
    end
  endtask : populate_error_item

endclass : ahb_collect_addr_items


class ahb_collect_data_items#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = ahb_slave_cfg,
  type SEQR = ahb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH)
  )  extends
    ahb_monitor_base_thread #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .CFG(CFG),
      .SEQR(SEQR)
  );

  typedef ahb_collect_data_items#(ADDR_WIDTH, DATA_WIDTH, CFG, SEQR) coll_t;
  typedef ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  `uvm_object_param_utils_begin(coll_t)
  `uvm_object_utils_end

  function new(string name = "ahb_collect_data_items", mon_t parent=null);
    super.new(name, parent);
  endfunction : new

  virtual task listen_RETRY(item_t item);
    @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == RETRY));
    populate_retry_item(item);
    @(negedge this.cmp.vif.clk iff (this.cmp.vif.hready && this.cmp.vif.hresp == RETRY && this.cmp.vif.htrans == IDLE));
    populate_retry_item(item);
    populate_complete_item(item);
  endtask : listen_RETRY

  virtual task listen_SPLIT(item_t item);
    @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == SPLIT));
    populate_split_item(item);
    @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == SPLIT && this.cmp.vif.htrans == IDLE));
    populate_split_item(item);
    populate_complete_item(item);
  endtask : listen_SPLIT

  virtual task listen_ERROR(item_t item);
    @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == ERROR));
    populate_error_item(item);
    @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == ERROR && this.cmp.vif.htrans == IDLE));
    populate_error_item(item);
    populate_complete_item(item);
  endtask : listen_ERROR

  virtual task listen_OKAY(item_t item);
    while (item.data_idx <= item.bst_len) begin
      @(negedge this.cmp.vif.clk iff (this.cmp.vif.hready && this.cmp.vif.hresp == OKAY && this.cmp.vif.htrans inside {NONSEQ, SEQ, IDLE}));
      if(item.addr_idx > item.data_idx) begin
        populate_data_item(item);
      end
    end
    populate_okay_item(item);
    populate_complete_item(item);
  endtask : listen_OKAY

  virtual task run();
    forever begin
      this.cmp.pbox.get(item);

      while(!item.data_complete) begin
        fork
          listen_ERROR(item);
          listen_SPLIT(item);
          listen_RETRY(item);
          listen_OKAY(item);
        join_any
        disable fork;
      end
      // notify to scoreboard
      if (!$cast(m_cfg, this.cmp.cfg) && item.trs_t == WR) `SMTDV_SWAP(0)
      if ($cast(m_cfg, this.cmp.cfg) && item.trs_t == RD) `SMTDV_SWAP(0)

      `uvm_info(this.cmp.get_full_name(),
          {$psprintf("try collect data item \n%s", item.sprint())}, UVM_LOW)

      if (item.success) this.cmp.item_collected_port.write(item);

      if (this.cmp.cfg.has_coverage) this.cmp.cbox.put(item);
      if (this.cmp.cfg.has_export)   this.cmp.ebox.put(item);
      if (this.cmp.cfg.has_notify)   this.cmp.bbox.put(item);

      if (this.cmp.cfg.has_debug)
        update_timestamp();

    end
  endtask : run

  virtual task populate_data_item(item_t item);
    bit[DATA_WIDTH-1:0] data;
    data = (item.trs_t == WR)? this.cmp.vif.hwdata : this.cmp.vif.hrdata;
    item.pack_data(item.data_idx, data);
    item.data_idx++;
  endtask : populate_data_item

  virtual task populate_complete_item(item_t item);
    item.data_complete = TRUE;
    item.ed_cyc = this.cmp.vif.cyc;
    item.ed_time = $time;
  endtask : populate_complete_item

  virtual task populate_okay_item(item_t item);
    item.rsp = OKAY;
    item.success = TRUE;
  endtask : populate_okay_item

  virtual task populate_retry_item(item_t item);
  endtask : populate_retry_item

  virtual task populate_split_item(item_t item);
  endtask : populate_split_item

  virtual task populate_error_item(item_t item);
  endtask : populate_error_item

endclass : ahb_collect_data_items

`endif // end of __AHB_MONITOR_THREADS_SV__
