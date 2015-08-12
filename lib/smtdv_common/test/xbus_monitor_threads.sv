
`ifndef __XBUS_MONITOR_THREADS_SV__
`define __XBUS_MONITOR_THREADS_SV__

typedef class xbus_monitor;

class xbus_collect_cover_group#(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 8,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `XBUS_ITEM item;
    `XBUS_MONITOR cmp;

   `uvm_object_param_utils_begin(`XBUS_COLLECT_COVER_GROUP)
   `uvm_object_utils_end

    covergroup xbus_coverage;
      xbus_addr : coverpoint item.addr {
        bins zero = {0};
        bins non_zero = {[1:32'hffff_ffff]};
      }
      xbus_rw : coverpoint item.trs_t {
        bins read = {RD};
        bins write = {WR};
      }
      xbus_data : coverpoint item.unpack_data() {
        bins zero = {0};
        bins non_zero = {[1:32'hffff_ffff]};
      }
      xbus_byten : coverpoint item.unpack_byten() {
        bins zero = {0};
        bins non_zero = {[1:4'b1111]};
      }

      xbus_write_trx  : cross xbus_addr, xbus_rw, xbus_data, xbus_byten;
      xbus_read_trx   : cross xbus_addr, xbus_rw;
    endgroup

    function new(string name = "xbus_collect_cover_group");
      super.new(name);
      xbus_coverage = new();
    endfunction

    virtual task run();
      forever begin
        this.cmp.cbox.get(item);
        xbus_coverage.sample();
      end
    endtask

endclass


class xbus_export_collected_items#(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 8,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `XBUS_ITEM item;
    `XBUS_MONITOR cmp;

    string attr_longint[$] = {
      "addr",
      "rw",
      "data",
      "byten",
      "bg_cyc",
      "ed_cyc"
    };

    `uvm_object_param_utils_begin(`XBUS_EXPORT_COLLECTED_ITEMS)
    `uvm_object_utils_end

    function new(string name = "xbus_collect_stop_signal");
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

    virtual task populate_item(ref `XBUS_ITEM item);
      string table_nm = $psprintf("\"%s\"", this.cmp.get_full_name());
      smtdv_sqlite3::insert_value(table_nm, "addr",    $psprintf("%d", item.addr));
      smtdv_sqlite3::insert_value(table_nm, "rw",      $psprintf("%d", item.trs_t));
      smtdv_sqlite3::insert_value(table_nm, "data",    $psprintf("%d", item.data));
      smtdv_sqlite3::insert_value(table_nm, "byten",   $psprintf("%d", item.byten));
      smtdv_sqlite3::insert_value(table_nm, "bg_cyc",  $psprintf("%d", item.bg_cyc));
      smtdv_sqlite3::insert_value(table_nm, "ed_cyc",  $psprintf("%d", item.ed_cyc));
      smtdv_sqlite3::exec_value(table_nm);
      smtdv_sqlite3::flush_value(table_nm);
    endtask

endclass


class xbus_collect_stop_signal#(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 8,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `XBUS_MONITOR cmp;
    int stop_cnt = 10;
    int cnt = 0;

   `uvm_object_param_utils_begin(`XBUS_COLLECT_STOP_SIGNAL)
      `uvm_field_int(stop_cnt, UVM_DEFAULT)
   `uvm_object_utils_end

    function new(string name = "xbus_collect_stop_signal");
      super.new(name);
    endfunction

    virtual task do_stop();
      while (cnt < stop_cnt) begin
        @(negedge this.cmp.vif.clk);
        cnt = (this.cmp.vif.req || this.cmp.vif.ack || ~this.cmp.vif.resetn)? cnt : cnt+1;
      end
    endtask

    virtual task run();
      do_stop();
      // notify sequencer to finish
      if (this.cmp.seqr) begin
        this.cmp.seqr.finish = 1;
        `uvm_info(this.cmp.get_full_name(), {$psprintf("try collect finish signal\n")}, UVM_LOW)
      end
    endtask

endclass

class xbus_collect_write_items#(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 8,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `XBUS_ITEM item;
    `XBUS_MONITOR cmp;

    `uvm_object_param_utils_begin(`XBUS_COLLECT_WRITE_ITEMS)
    `uvm_object_utils_end

    function new(string name = "xbus_collect_write_items");
      super.new(name);
    endfunction

    virtual task run();
      forever begin
        // heartbeat assert/deassert
        @(negedge this.cmp.vif.clk iff (this.cmp.vif.req && this.cmp.vif.rw));
        populate_begin_item(item);
        this.cmp.item_asserted_port.write(item);
        @(negedge this.cmp.vif.clk iff (this.cmp.vif.ack));
        populate_end_item(item);
        this.cmp.item_collected_port.write(item);
        @(negedge this.cmp.vif.clk);
       `uvm_info(this.cmp.get_full_name(), {$psprintf("try collect write item\n%s", item.sprint())}, UVM_LOW)

       if (this.cmp.cfg.has_coverage) this.cmp.cbox.put(item);
       if (this.cmp.cfg.has_export)   this.cmp.ebox.put(item);
      end
    endtask

    virtual function void populate_begin_item(ref `XBUS_ITEM item);
        item = `XBUS_ITEM::type_id::create("xbus_write_item");
        item.addr = this.cmp.vif.addr;
        item.trs_t = WR;
        item.pack_data(this.cmp.vif.wdata);
        item.pack_byten(this.cmp.vif.byten);
        item.bg_cyc = this.cmp.vif.cyc;
        void'(this.cmp.begin_tr(item, this.cmp.get_full_name()));
      endfunction

    virtual function void populate_end_item(ref `XBUS_ITEM item);
        item.ed_cyc = this.cmp.vif.cyc;
        void'(this.cmp.end_tr(item));
    endfunction

endclass


class xbus_collect_read_items#(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 8,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
)  extends
    smtdv_run_thread;

    `XBUS_ITEM item;
    `XBUS_MONITOR cmp;

    `uvm_object_param_utils_begin(`XBUS_COLLECT_READ_ITEMS)
    `uvm_object_utils_end

    function new(string name = "xbus_collect_read_items");
      super.new(name);
    endfunction

    virtual task run();
      forever begin
        @(negedge this.cmp.vif.clk iff (this.cmp.vif.req && ~this.cmp.vif.rw));
        populate_begin_item(item);
        this.cmp.item_asserted_port.write(item);
        @(negedge this.cmp.vif.clk iff (this.cmp.vif.ack));
        populate_end_item(item);
        this.cmp.item_collected_port.write(item);
        @(negedge this.cmp.vif.clk);
       `uvm_info(this.cmp.get_full_name(), {$psprintf("try collect read item\n%s", item.sprint())}, UVM_LOW)
       if (this.cmp.cfg.has_coverage) this.cmp.cbox.put(item);
       if (this.cmp.cfg.has_export)   this.cmp.ebox.put(item);
      end
    endtask

    virtual function void populate_begin_item(ref `XBUS_ITEM item);
        item = `XBUS_ITEM::type_id::create("xbus_read_item");
        item.addr = this.cmp.vif.addr;
        item.trs_t = RD;
        item.bg_cyc = this.cmp.vif.cyc;
        void'(this.cmp.begin_tr(item, this.cmp.get_full_name()));
    endfunction

    virtual function void populate_end_item(ref `XBUS_ITEM item);
        item.pack_data(this.cmp.vif.rdata);
        item.ed_cyc = this.cmp.vif.cyc;
        void'(this.cmp.end_tr(item));
    endfunction

endclass

`endif // end of __XBUS_MONITOR_THREADS_SV__
