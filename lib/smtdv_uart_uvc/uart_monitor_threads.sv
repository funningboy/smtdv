`ifndef __UART_MONITOR_THREADS_SV__
`define __UART_MONITOR_THREADS_SV__

typedef class uart_monitor;

class uart_collect_cover_group#(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 8,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `UART_ITEM item;
    `UART_MONITOR cmp;

   `uvm_object_param_utils_begin(`UART_COLLECT_COVER_GROUP)
   `uvm_object_utils_end

    covergroup uart_coverage;
    NUM_STOP_BITS : coverpoint cfg.nbstop {
      bins ONE = {0};
      bins TWO = {1};
    }
    DATA_LENGTH : coverpoint cfg.char_length {
      bins EIGHT = {0,1};
      bins SEVEN = {2};
      bins SIX = {3};
    }
    PARITY_MODE : coverpoint cfg.parity_mode {
      bins EVEN  = {0};
      bins ODD   = {1};
      bins SPACE = {2};
      bins MARK  = {3};
    }
    PARITY_ERROR: coverpoint item.error_bits[1]
      {
        bins good = { 0 };
        bins bad = { 1 };
      }

    DATA_LENGTH_x_PARITY_MODE: cross DATA_LENGTH, PARITY_MODE;
    PARITY_ERROR_x_PARITY_MODE: cross PARITY_ERROR, PARITY_MODE;

  endgroup

    function new(string name = "uart_collect_cover_group");
      super.new(name);
      uart_coverage = new();
    endfunction

    virtual task run();
      forever begin
        this.cmp.cbox.get(item);
        uart_coverage.sample();
      end
    endtask

endclass

task uart_monitor::gen_sample_rate(ref bit [15:0] ua_brgr, ref bit sample_clk, ref bit sop_detected);
    forever begin
      @(posedge this.cmp.vif.clk);
      if ((!this.cmp.vif.resetn) || (this.cmp.sop_detected)) begin
        `uvm_info(this.cmp.get_full_name(), "sample_clk- resetting ua_brgr", UVM_HIGH)
        this.cmp.ua_brgr = 0;
        this.cmp.sample_clk = 0;
        this.cmp.sop_detected = 0;
      end else begin
        if ( this.cmp.ua_brgr == ({this.cmp.cfg.baud_rate_div, this.cmp.cfg.baud_rate_gen})) begin
          this.cmp.ua_brgr = 0;
          this.cmp.sample_clk = 1;
        end else begin
          this.cmp.sample_clk = 0;
          this.cmp.ua_brgr++;
        end
      end
    end
endtask

task uart_monitor::start_synchronizer(ref bit serial_d1, ref bit serial_b);
endtask

task uart_monitor::sample_and_store();
  forever begin
    wait_for_sop(sop_detected);
    collect_frame();
  end
endtask : sample_and_store

task uart_monitor::wait_for_sop(ref bit sop_detected);
    transmit_delay = 0;
    this.cmp.sop_detected = 0;
    while (!this.cmp.sop_detected) begin
      `uvm_info(this.cmp.get_full_name(), "trying to detect SOP", UVM_MEDIUM)
      while (!(this.cmp.serial_d1 == 1 && this.cmp.serial_b == 0)) begin
        @(negedge vif.clk);
        transmit_delay++;
      end
      if (serial_b != 0)
        `uvm_info(this.cmp.get_full_name(), "Encountered a glitch in serial during SOP, shall continue", UVM_LOW)
      else
      begin
        sop_detected = 1;
        `uvm_info(this.cmp.get_full_name(), "SOP detected", UVM_MEDIUM)
      end
    end
endtask : wait_for_sop


task uart_monitor::collect_frame();
  bit [7:0] payload_byte;
  item = new;
 `uvm_info(this.cmp.get_full_name(), $psprintf("Collecting a frame: %0d", num_frames+1), UVM_HIGH)
   // Begin Transaction Recording
  void'(this.begin_tr(item, "UART Monitor", , get_full_name()));
  item.transmit_delay = transmit_delay;
  item.start_bit = 1'b0;
  item.parity_type = GOOD_PARITY;
  num_of_bits_rcvd = 0;

    while (num_of_bits_rcvd < (1 + cfg.char_len_val + cfg.parity_en + cfg.nbstop))
    begin
      @(posedge vif.clk);
      #1;
      if (sample_clk) begin
        num_of_bits_rcvd++;
        if ((num_of_bits_rcvd > 0) && (num_of_bits_rcvd <= cfg.char_len_val)) begin // sending "data bits"
          item.payload[num_of_bits_rcvd-1] = serial_b;
          payload_byte = item.payload[num_of_bits_rcvd-1];
          `uvm_info(this.cmp.get_full_name(), $psprintf("Received a Frame data bit:'b%0b", payload_byte), UVM_HIGH)
        end
        msb_lsb_data[0] =  item.payload[0] ;
        msb_lsb_data[1] =  item.payload[cfg.char_len_val-1] ;
        if ((num_of_bits_rcvd == (1 + cfg.char_len_val)) && (cfg.parity_en)) begin // sending "parity bit" if parity is enabled
          item.parity = serial_b;
          `uvm_info(this.cmp.get_full_name(), $psprintf("Received Parity bit:'b%0b", item.parity), UVM_HIGH)
          if (serial_b == item.calc_parity(cfg.char_len_val, cfg.parity_mode))
            `uvm_info(this.cmp.get_full_name(), "Received Parity is same as calculated Parity", UVM_MEDIUM)
          else if (checks_enable)
            `uvm_error(this.cmp.get_full_name(), "####### FAIL :Received Parity doesn't match the calculated Parity  ")
        end
        if (num_of_bits_rcvd == (1 + cfg.char_len_val + cfg.parity_en)) begin // sending "stop/error bits"
          for (int i = 0; i < cfg.nbstop; i++) begin
            wait (sample_clk);
            item.stop_bits[i] = serial_b;
            `uvm_info(this.cmp.get_full_name(), $psprintf("Received a Stop bit: 'b%0b", item.stop_bits[i]), UVM_HIGH)
            num_of_bits_rcvd++;
            wait (!sample_clk);
          end
        end
        wait (!sample_clk);
      end
    end
 num_frames++;
 `uvm_info(this.cmp.get_full_name(), $psprintf("Collected the following Frame No:%0d\n%s", num_frames, item.sprint()), UVM_MEDIUM)

  if(coverage_enable) perform_coverage();
  frame_collected_port.write(item);
  this.end_tr(item);
endtask : collect_frame

function void uart_monitor::perform_coverage();
  uart_trans_frame_cg.sample();
endfunction : perform_coverage

`endif


class uart_export_collected_items#(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 8,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `UART_ITEM item;
    `UART_MONITOR cmp;

    string attr_longint[$] = {
      "addr",
      "rw",
      "data",
      "byten",
      "bg_cyc",
      "ed_cyc"
    };

    `uvm_object_param_utils_begin(`UART_EXPORT_COLLECTED_ITEMS)
    `uvm_object_utils_end

    function new(string name = "uart_export_collected_items");
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

    virtual task populate_item(ref `UART_ITEM item);
      string table_nm = $psprintf("\"%s\"", this.cmp.get_full_name());
      smtdv_sqlite3::insert_value(table_nm, "addr",    $psprintf("%d", item.addr));
      smtdv_sqlite3::insert_value(table_nm, "rw",      $psprintf("%d", item.trs_t));
      smtdv_sqlite3::insert_value(table_nm, "data",    $psprintf("%d", item.unpack_data()));
      smtdv_sqlite3::insert_value(table_nm, "byten",   $psprintf("%d", item.unpack_byten()));
      smtdv_sqlite3::insert_value(table_nm, "bg_cyc",  $psprintf("%d", item.bg_cyc));
      smtdv_sqlite3::insert_value(table_nm, "ed_cyc",  $psprintf("%d", item.ed_cyc));
      smtdv_sqlite3::exec_value(table_nm);
      smtdv_sqlite3::flush_value(table_nm);
    endtask

endclass


class uart_collect_stop_signal#(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 8,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `UART_MONITOR cmp;
    int stop_cnt = 100;
    int cnt = 0;

   `uvm_object_param_utils_begin(`UART_COLLECT_STOP_SIGNAL)
      `uvm_field_int(stop_cnt, UVM_DEFAULT)
   `uvm_object_utils_end

    function new(string name = "uart_collect_stop_signal");
      super.new(name);
    endfunction

    virtual task do_stop();
      while (cnt < stop_cnt) begin
        @(negedge this.cmp.vif.clk);
        cnt = (this.cmp.vif.req || this.cmp.vif.ack || ~this.cmp.vif.resetn)? 0 : cnt+1;
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
      //  #1000;
      //  $display("no traffic found at vif after time:%t", $time);
      //  $finish;
      //end
    endtask

endclass

class uart_collect_write_items#(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 8,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `UART_ITEM item;
    `UART_MONITOR cmp;

    `uvm_object_param_utils_begin(`UART_COLLECT_WRITE_ITEMS)
    `uvm_object_utils_end

    function new(string name = "uart_collect_write_items");
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

    virtual function void populate_begin_item(ref `UART_ITEM item);
        item = `UART_ITEM::type_id::create("uart_write_item");
        item.addr = this.cmp.vif.addr;
        item.trs_t = WR;
        item.pack_data(this.cmp.vif.wdata);
        item.pack_byten(this.cmp.vif.byten);
        item.bg_cyc = this.cmp.vif.cyc;
        void'(this.cmp.begin_tr(item, this.cmp.get_full_name()));
      endfunction

    virtual function void populate_end_item(ref `UART_ITEM item);
        item.ed_cyc = this.cmp.vif.cyc;
        void'(this.cmp.end_tr(item));
    endfunction

endclass


class uart_collect_read_items#(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 8,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg
)  extends
    smtdv_run_thread;

    `UART_ITEM item;
    `UART_MONITOR cmp;

    `uvm_object_param_utils_begin(`UART_COLLECT_READ_ITEMS)
    `uvm_object_utils_end

    function new(string name = "uart_collect_read_items");
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

    virtual function void populate_begin_item(ref `UART_ITEM item);
        item = `UART_ITEM::type_id::create("uart_read_item");
        item.addr = this.cmp.vif.addr;
        item.trs_t = RD;
        item.bg_cyc = this.cmp.vif.cyc;
        void'(this.cmp.begin_tr(item, this.cmp.get_full_name()));
    endfunction

    virtual function void populate_end_item(ref `UART_ITEM item);
        item.pack_data(this.cmp.vif.rdata);
        item.ed_cyc = this.cmp.vif.cyc;
        void'(this.cmp.end_tr(item));
    endfunction

endclass

`endif // end of __UART_MONITOR_THREADS_SV__
