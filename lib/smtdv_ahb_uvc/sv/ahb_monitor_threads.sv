`ifndef __AHB_MONITOR_THREADS_SV__
`define __AHB_MONITOR_THREADS_SV__

typedef class ahb_monitor;

class ahb_collect_cover_group#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `AHB_ITEM item;
    `AHB_MONITOR cmp;

   `uvm_object_param_utils_begin(`AHB_COLLECT_COVER_GROUP)
   `uvm_object_utils_end

    covergroup ahb_coverage;
      ahb_addr : coverpoint item.addr {
        bins zero = {0};
        bins non_zero = {[1:32'hffff_ffff]};
      }
      ahb_rw : coverpoint item.trs_t {
        bins read = {RD};
        bins write = {WR};
      }
      ahb_data : coverpoint item.unpack_data(item.data_idx) {
        bins zero = {0};
        bins non_zero = {[1:32'hffff_ffff]};
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
      ahb_trx  : cross ahb_addr, ahb_rw, ahb_data, ahb_rsp, ahb_lock;
    endgroup

    function new(string name = "ahb_collect_cover_group");
      super.new(name);
      ahb_coverage = new();
    endfunction

    virtual task run();
      forever begin
        this.cmp.cbox.get(item);
        ahb_coverage.sample();
      end
    endtask

endclass


class ahb_export_collected_items#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `AHB_ITEM item;
    `AHB_MONITOR cmp;

    string attr_longint[$] = {
      "addr",
      "rw",
      "len",
      "burst",
      "size",
      "lock",
      "prot",
      "data_0",
      "data_1",
      "data_2",
      "data_3",
      "data_4",
      "data_5",
      "data_6",
      "data_7",
      "data_8",
      "data_9",
      "data_10",
      "data_11",
      "data_12",
      "data_13",
      "data_14",
      "data_15",
      "resp",
      "bg_cyc",
      "ed_cyc"
    };

    `uvm_object_param_utils_begin(`AHB_EXPORT_COLLECTED_ITEMS)
    `uvm_object_utils_end

    function new(string name = "ahb_export_collected_items");
      super.new(name);
    endfunction

    virtual task run();
      create_table();
      forever begin
        this.cmp.cbox.get(item);
        populate_item(item);
      end
    endtask

    virtual task create_table();
      string table_nm = $psprintf("\"%s\"", this.cmp.get_full_name());
      `uvm_info(this.cmp.get_full_name(), {table_nm}, UVM_LOW)

      smtdv_sqlite3::create_tb(table_nm);
      foreach (attr_longint[i])
        smtdv_sqlite3::register_longint_field(table_nm, attr_longint[i]);
      smtdv_sqlite3::exec_field(table_nm);
    endtask

    virtual task populate_item(ref `AHB_ITEM item);
      string table_nm = $psprintf("\"%s\"", this.cmp.get_full_name());
      smtdv_sqlite3::insert_value(table_nm, "addr",    $psprintf("%d", item.addr));
      smtdv_sqlite3::insert_value(table_nm, "rw",      $psprintf("%d", item.trs_t));
      smtdv_sqlite3::insert_value(table_nm, "len",      $psprintf("%d", item.addrs.size()));
      smtdv_sqlite3::insert_value(table_nm, "burst",    $psprintf("%d", item.bst_type));
      smtdv_sqlite3::insert_value(table_nm, "size",     $psprintf("%d", item.trx_size));
      smtdv_sqlite3::insert_value(table_nm, "lock",     $psprintf("%d", item.hmastlock));
      smtdv_sqlite3::insert_value(table_nm, "prot",     $psprintf("%d", item.trx_prt));
      for (int i=0; i<item.data_beat.size(); i++) begin
        smtdv_sqlite3::insert_value(table_nm, $psprintf("data_%0d", i),    $psprintf("%d", item.unpack_data(i)));
      end
      smtdv_sqlite3::insert_value(table_nm, "bg_cyc",  $psprintf("%d", item.bg_cyc));
      smtdv_sqlite3::insert_value(table_nm, "ed_cyc",  $psprintf("%d", item.ed_cyc));
      smtdv_sqlite3::exec_value(table_nm);
      smtdv_sqlite3::flush_value(table_nm);
    endtask

endclass


class ahb_collect_stop_signal#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `AHB_MONITOR cmp;
    int stop_cnt = 100;
    int cnt = 0;
    int pre_st = IDLE;

    //trx_type_t trx
   `uvm_object_param_utils_begin(`AHB_COLLECT_STOP_SIGNAL)
      `uvm_field_int(stop_cnt, UVM_DEFAULT)
   `uvm_object_utils_end

    function new(string name = "ahb_collect_stop_signal");
      super.new(name);
    endfunction

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
      end
    endtask

    virtual task run();
      do_stop();
      // notify sequencer to finish
      // like timeout watch dog ref: http://www.synapse-da.com/Uploads/PDFFiles/04_UVM-Heartbeat.pdf
      if (this.cmp.seqr) begin
        this.cmp.seqr.finish = 1;
        `uvm_info(this.cmp.get_full_name(), {$psprintf("try collect finish signal\n")}, UVM_LOW)
      end
      //else begin
      //  //`uvm_fatal(this.cmp.get_full_name(), {$psprintf("try collect finish signal\n")}, UVM_LOW)
      //end
    endtask

endclass

class ahb_collect_addr_items#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `AHB_ITEM item;
    `AHB_MONITOR cmp;

    `uvm_object_param_utils_begin(`AHB_COLLECT_ADDR_ITEMS)
    `uvm_object_utils_end

    function new(string name = "ahb_collect_addr_items");
      super.new(name);
    endfunction

    virtual task listen_nonseq(ref `AHB_ITEM item);
      @(negedge this.cmp.vif.clk iff (this.cmp.vif.hready && this.cmp.vif.hresp == OKAY && this.cmp.vif.htrans == NONSEQ));
      populate_nonseq_item(item);
      this.cmp.pbox.put(item);
    endtask

    virtual task listen_OKAY(ref `AHB_ITEM item);
      while (1) begin
        if (item.addr_idx > item.bst_len) begin break; end
        @(negedge this.cmp.vif.clk iff (this.cmp.vif.hready && this.cmp.vif.hresp == OKAY));

             if (this.cmp.vif.htrans == SEQ) begin populate_seq_item(item); end
        else if (this.cmp.vif.htrans == BUSY) begin populate_busy_item(item); end
        else if (this.cmp.vif.htrans == IDLE) begin popilate_idle_item(item); end
      end
      populate_complete_item(item);
    endtask

    virtual task listen_RETRY(ref `AHB_ITEM item);
      @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == RETRY));
      populate_retry_item(item);
      @(negedge this.cmp.vif.clk iff (this.cmp.vif.hready && this.cmp.vif.hresp == RETRY && this.cmp.vif.htrans == IDLE));
      populate_retry_item(item);
      populate_complete_item(item);
    endtask

    virtual task listen_SPLIT(ref `AHB_ITEM item);
      @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == SPLIT));
      populate_split_item(item);
      @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == SPLIT && this.cmp.vif.htrans == IDLE));
      populate_split_item(item);
      populate_complete_item(item);
    endtask

    virtual task listen_ERROR(ref `AHB_ITEM item);
      @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == ERROR));
      populate_error_item(item);
      @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == ERROR && this.cmp.vif.htrans == IDLE));
      populate_error_item(item);
      populate_complete_item(item);
    endtask

    virtual task run();
      forever begin
        listen_nonseq(item);
        fork
          listen_OKAY(item);
          listen_ERROR(item);
          listen_RETRY(item);
          listen_SPLIT(item);
        join_any
        disable fork;
        if (this.cmp.cfg.has_coverage) begin this.cmp.cbox.put(item); end
      `uvm_info(this.cmp.get_full_name(), {$psprintf("try collect addr item \n%s", item.sprint())}, UVM_LOW)
      end
    endtask

    virtual task popilate_idle_item(ref `AHB_ITEM item);
      // detect the idle is init or not,
      if (item==null) return;
    endtask

    virtual task populate_nonseq_item(ref `AHB_ITEM item);
        item = `AHB_ITEM::type_id::create("ahb_item");
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
        item.addr_idx++;
        item.addrs.push_back(this.cmp.vif.haddr);
        void'(this.cmp.begin_tr(item, this.cmp.get_full_name()));
        // notify to slave sequencer
        this.cmp.item_asserted_port.write(item);
      endtask

    virtual task populate_seq_item(ref `AHB_ITEM item);
      item.addr_idx++;
      item.addrs.push_back(this.cmp.vif.haddr);
    endtask

    virtual task populate_busy_item(ref `AHB_ITEM item);
    endtask

    virtual task populate_complete_item(ref `AHB_ITEM item);
        item.addr_complete = 1;
        item.complete = 1;
    endtask

    virtual task populate_retry_item(ref `AHB_ITEM item);
      if (!item.retry) begin
        item.retry = 1;
        item.complete = 1;
      end
    endtask

    virtual task populate_split_item(ref `AHB_ITEM item);
      if (!item.split) begin
        item.split = 1;
        item.complete = 1;
      end
    endtask

    virtual task populate_error_item(ref `AHB_ITEM item);
      if (!item.error) begin
        item.error = 1;
        item.complete = 1;
      end
    endtask

endclass


class ahb_collect_data_items#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
)  extends
    smtdv_run_thread;

    `AHB_ITEM item;
    `AHB_MONITOR cmp;

    `uvm_object_param_utils_begin(`AHB_COLLECT_DATA_ITEMS)
    `uvm_object_utils_end

    function new(string name = "ahb_collect_data_items");
      super.new(name);
    endfunction

    virtual task listen_RETRY(ref `AHB_ITEM item);
      @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == RETRY));
      populate_retry_item(item);
      @(negedge this.cmp.vif.clk iff (this.cmp.vif.hready && this.cmp.vif.hresp == RETRY && this.cmp.vif.htrans == IDLE));
      populate_retry_item(item);
      populate_complete_item(item);
    endtask

    virtual task listen_SPLIT(ref `AHB_ITEM item);
      @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == SPLIT));
      populate_split_item(item);
      @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == SPLIT && this.cmp.vif.htrans == IDLE));
      populate_split_item(item);
      populate_complete_item(item);
    endtask

    virtual task listen_ERROR(ref `AHB_ITEM item);
      @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == ERROR));
      populate_error_item(item);
      @(negedge this.cmp.vif.clk iff (!this.cmp.vif.hready && this.cmp.vif.hresp == ERROR && this.cmp.vif.htrans == IDLE));
      populate_error_item(item);
      populate_complete_item(item);
    endtask

    virtual task listen_OKAY(ref `AHB_ITEM item);
      while (item.data_idx <= item.bst_len) begin
        @(negedge this.cmp.vif.clk iff (this.cmp.vif.hready && this.cmp.vif.hresp == OKAY && this.cmp.vif.htrans inside {NONSEQ, SEQ}));
        if(item.addr_idx > item.data_idx) begin
          populate_data_item(item);
          if (this.cmp.cfg.has_coverage) begin this.cmp.cbox.put(item); end
        end
      end
      populate_complete_item(item);
    endtask


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
        if (this.cmp.cfg.has_export)   this.cmp.ebox.put(item);
      `uvm_info(this.cmp.get_full_name(), {$psprintf("try collect data item \n%s", item.sprint())}, UVM_LOW)
      end
    endtask

    virtual task populate_data_item(ref `AHB_ITEM item);
      bit[DATA_WIDTH-1:0] data;
      data = (item.trs_t == WR)? this.cmp.vif.hwdata : this.cmp.vif.hrdata;
      item.pack_data(item.data_idx, data);
      item.data_idx++;
    endtask

    virtual task populate_complete_item(ref `AHB_ITEM item);
      item.data_complete = 1;
      item.complete = 1;
      // notify to scoreboard
      this.cmp.item_collected_port.write(item);
    endtask

    virtual task populate_retry_item(ref `AHB_ITEM item);
    endtask

    virtual task populate_split_item(ref `AHB_ITEM item);
    endtask

    virtual task populate_error_item(ref `AHB_ITEM item);
    endtask

endclass

`endif // end of __AHB_MONITOR_THREADS_SV__
