
`ifndef __APB_MONITOR_THREADS_SV__
`define __APB_MONITOR_THREADS_SV__

typedef class apb_monitor;

class apb_collect_cover_group#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `APB_ITEM item;
    `APB_MONITOR cmp;

   `uvm_object_param_utils_begin(`APB_COLLECT_COVER_GROUP)
   `uvm_object_utils_end

    covergroup apb_coverage;
      apb_addr : coverpoint item.addr {
        bins zero = {0};
        bins non_zero = {[1:32'hffff_ffff]};
      }
      apb_rw : coverpoint item.trs_t {
        bins read = {RD};
        bins write = {WR};
      }
      apb_data : coverpoint item.unpack_data() {
        bins zero = {0};
        bins non_zero = {[1:32'hffff_ffff]};
      }

      apb_trx  : cross apb_addr, apb_rw, apb_data;
    endgroup

    function new(string name = "apb_collect_cover_group");
      super.new(name);
      apb_coverage = new();
    endfunction

    virtual task run();
      forever begin
        this.cmp.cbox.get(item);
        apb_coverage.sample();
      end
    endtask

endclass


class apb_export_collected_items#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `APB_ITEM item;
    `APB_MONITOR cmp;

    string attr_longint[$] = {
      "addr",
      "rw",
      "data",
      "bg_cyc",
      "ed_cyc"
    };

    `uvm_object_param_utils_begin(`APB_EXPORT_COLLECTED_ITEMS)
    `uvm_object_utils_end

    function new(string name = "apb_export_collected_items");
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

    virtual task populate_item(ref `APB_ITEM item);
      string table_nm = $psprintf("\"%s\"", this.cmp.get_full_name());
      smtdv_sqlite3::insert_value(table_nm, "addr",    $psprintf("%d", item.addr));
      smtdv_sqlite3::insert_value(table_nm, "rw",      $psprintf("%d", item.trs_t));
      smtdv_sqlite3::insert_value(table_nm, "data",    $psprintf("%d", item.unpack_data()));
      smtdv_sqlite3::insert_value(table_nm, "bg_cyc",  $psprintf("%d", item.bg_cyc));
      smtdv_sqlite3::insert_value(table_nm, "ed_cyc",  $psprintf("%d", item.ed_cyc));
      smtdv_sqlite3::exec_value(table_nm);
      smtdv_sqlite3::flush_value(table_nm);
    endtask

endclass


class apb_collect_stop_signal#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `APB_MONITOR cmp;
    int stop_cnt = 100;
    int cnt = 0;

   `uvm_object_param_utils_begin(`APB_COLLECT_STOP_SIGNAL)
      `uvm_field_int(stop_cnt, UVM_DEFAULT)
   `uvm_object_utils_end

    function new(string name = "apb_collect_stop_signal");
      super.new(name);
    endfunction

    virtual task do_stop();
      while (cnt < stop_cnt) begin
        @(negedge this.cmp.vif.clk);
        cnt = (this.cmp.vif.psel || this.cmp.vif.pready || ~this.cmp.vif.resetn)? cnt : cnt+1;
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
    endtask

endclass

class apb_collect_write_items#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `APB_ITEM item;
    `APB_MONITOR cmp;

    `uvm_object_param_utils_begin(`APB_COLLECT_WRITE_ITEMS)
    `uvm_object_utils_end

    function new(string name = "apb_collect_write_items");
      super.new(name);
    endfunction

    virtual task run();
      forever begin
        @(negedge this.cmp.vif.clk iff (this.cmp.vif.psel !=0 && this.cmp.vif.penable && this.cmp.vif.prwd));
        populate_begin_item(item);
        this.cmp.item_asserted_port.write(item);
        @(negedge this.cmp.vif.clk iff (this.cmp.vif.pready));
        populate_end_item(item);
        this.cmp.item_collected_port.write(item);
       `uvm_info(this.cmp.get_full_name(), {$psprintf("try collect write item\n%s", item.sprint())}, UVM_LOW)

       if (this.cmp.cfg.has_coverage) this.cmp.cbox.put(item);
       if (this.cmp.cfg.has_export)   this.cmp.ebox.put(item);
      end
    endtask

    virtual function void populate_begin_item(ref `APB_ITEM item);
        item = `APB_ITEM::type_id::create("apb_write_item");
        item.addr = this.cmp.vif.paddr;
        item.trs_t = WR;
        item.pack_data(this.cmp.vif.pwdata);
        item.bg_cyc = this.cmp.vif.cyc;
        void'(this.cmp.begin_tr(item, this.cmp.get_full_name()));
      endfunction

    virtual function void populate_end_item(ref `APB_ITEM item);
        item.ed_cyc = this.cmp.vif.cyc;
        void'(this.cmp.end_tr(item));
    endfunction

endclass


class apb_collect_read_items#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
)  extends
    smtdv_run_thread;

    `APB_ITEM item;
    `APB_MONITOR cmp;

    `uvm_object_param_utils_begin(`APB_COLLECT_READ_ITEMS)
    `uvm_object_utils_end

    function new(string name = "apb_collect_read_items");
      super.new(name);
    endfunction

    virtual task run();
      forever begin
        @(negedge this.cmp.vif.clk iff (this.cmp.vif.psel != 0 && this.cmp.vif.penable && ~this.cmp.vif.prwd));
        populate_begin_item(item);
        this.cmp.item_asserted_port.write(item);
        @(negedge this.cmp.vif.clk iff (this.cmp.vif.pready));
        populate_end_item(item);
        this.cmp.item_collected_port.write(item);
        @(negedge this.cmp.vif.clk);
       `uvm_info(this.cmp.get_full_name(), {$psprintf("try collect read item\n%s", item.sprint())}, UVM_LOW)
       if (this.cmp.cfg.has_coverage) this.cmp.cbox.put(item);
       if (this.cmp.cfg.has_export)   this.cmp.ebox.put(item);
      end
    endtask

    virtual function void populate_begin_item(ref `APB_ITEM item);
        item = `APB_ITEM::type_id::create("apb_read_item");
        item.addr = this.cmp.vif.paddr;
        item.trs_t = RD;
        item.bg_cyc = this.cmp.vif.cyc;
        void'(this.cmp.begin_tr(item, this.cmp.get_full_name()));
    endfunction

    virtual function void populate_end_item(ref `APB_ITEM item);
        item.pack_data(this.cmp.vif.prdata);
        item.ed_cyc = this.cmp.vif.cyc;
        void'(this.cmp.end_tr(item));
    endfunction

endclass

`endif // end of __APB_MONITOR_THREADS_SV__
