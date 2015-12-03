`ifndef __UART_MONITOR_THREADS_SV__
`define __UART_MONITOR_THREADS_SV__

typedef class uart_monitor;
typedef class uart_tx_cfg;
typedef class uart_rx_cfg;

class uart_collect_cover_group#(
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `UART_ITEM item;
    `UART_MONITOR cmp;

   `uvm_object_param_utils_begin(`UART_COLLECT_COVER_GROUP)
   `uvm_object_utils_end

    covergroup uart_coverage;
    NUM_STOP_BITS : coverpoint this.cmp.cfg.nbstop {
      bins ONE = {0};
      bins TWO = {1};
    }
    DATA_LENGTH : coverpoint this.cmp.cfg.char_length {
      bins EIGHT = {0,1};
      bins SEVEN = {2};
      bins SIX = {3};
    }
    PARITY_MODE : coverpoint this.cmp.cfg.parity_mode {
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


class uart_gen_sample_rate#(
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `UART_ITEM item;
    `UART_MONITOR cmp;

   `uvm_object_param_utils_begin(`UART_GEN_SAMPLE_RATE)
   `uvm_object_utils_end

    function new(string name = "uart_collect_trx_items");
      super.new(name);
    endfunction

    virtual task run();
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

endclass


class uart_start_synchronizer#(
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `UART_ITEM item;
    `UART_MONITOR cmp;
    `UART_TX_CFG tx_cfg;
    `UART_RX_CFG rx_cfg;

   `uvm_object_param_utils_begin(`UART_START_SYNCHRONIZER)
   `uvm_object_utils_end

    function new(string name = "uart_start_synchronizer");
      super.new(name);
    endfunction

    virtual task run();
      if ($cast(tx_cfg, this.cmp.cfg)) begin
        forever begin
          // collect tx channel
          @(posedge this.cmp.vif.clk);
          if (!this.cmp.vif.resetn) begin
            this.cmp.serial_d1 = 1;
            this.cmp.serial_b = 1;
          end else begin
            this.cmp.serial_d1 = this.cmp.serial_b;
            this.cmp.serial_b = this.cmp.vif.txd;
          end
        end
      end
      // collect rx channel
      if ($cast(rx_cfg, this.cmp.cfg) && this.cmp.has_rx) begin
        forever begin
          @(posedge this.cmp.vif.clk);
          if (!this.cmp.vif.resetn) begin
            this.cmp.serial_d1 = 1;
            this.cmp.serial_b = 1;
          end else begin
            this.cmp.serial_d1 = this.cmp.serial_b;
            this.cmp.serial_b = this.cmp.vif.rxd;
          end
        end
      end

      // collect tx channel to tx with loopback condition
      if ($cast(rx_cfg, this.cmp.cfg) && this.cmp.has_tx) begin
        forever begin
          @(posedge this.cmp.vif.clk);
          if (!this.cmp.vif.resetn) begin
            this.cmp.serial_d1 = 1;
            this.cmp.serial_b = 1;
          end else begin
            this.cmp.serial_d1 = this.cmp.serial_b;
            this.cmp.serial_b = this.cmp.vif.txd;
          end
        end
      end

      `uvm_fatal("UART ERROR", "need to set start synchornizer")
    endtask

endclass


class uart_sample_and_store#(
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `UART_ITEM item;
    `UART_MONITOR cmp;

   `uvm_object_param_utils_begin(`UART_SAMPLE_AND_STORE)
   `uvm_object_utils_end

    function new(string name = "uart_start_synchronizer");
      super.new(name);
    endfunction

    virtual task run();
      `uvm_info(this.cmp.get_full_name(),"Start Running", UVM_LOW)
      @(negedge this.cmp.vif.resetn);
      wait (this.cmp.vif.resetn);
      `uvm_info(this.cmp.get_full_name(), "Detected Reset Done", UVM_LOW)
       this.cmp.num_items = 0;

      forever begin
        wait_for_sop();
        collect_item();
      end
    endtask

    virtual task wait_for_sop();
       this.cmp.transmit_delay = 0;
       this.cmp.sop_detected = 0;
       while (!this.cmp.sop_detected) begin
         `uvm_info(this.cmp.get_full_name(), "trying to detect SOP", UVM_MEDIUM)
         while (!(this.cmp.serial_d1 == 1 && this.cmp.serial_b == 0)) begin
           @(negedge this.cmp.vif.clk);
           this.cmp.transmit_delay++;
         end
         if (this.cmp.serial_b != 0)
           `uvm_info(this.cmp.get_full_name(), "Encountered a glitch in serial during SOP, shall continue", UVM_LOW)
         else
         begin
           this.cmp.sop_detected = 1;
           `uvm_info(this.cmp.get_full_name(), "SOP detected", UVM_MEDIUM)
         end
       end
    endtask

    virtual task collect_item();
        bit bb;
        `uvm_info(this.cmp.get_full_name(), $psprintf("Collecting a item: %0d", this.cmp.num_items+1), UVM_HIGH)
        item = `UART_ITEM::type_id::create("uart_item");
        item.transmit_delay = this.cmp.transmit_delay;
        item.start_bit = 1'b0;
        item.parity_type = GOOD_PARITY;
        item.bg_cyc = this.cmp.vif.cyc;
        item.bg_time = $time;
        this.cmp.item_asserted_port.write(item);
        this.cmp.num_of_bits_rcvd = 0;
        void'(this.cmp.begin_tr(item, this.cmp.get_full_name()));

        while (this.cmp.num_of_bits_rcvd < (1 + this.cmp.cfg.char_len_val + this.cmp.cfg.parity_en + this.cmp.cfg.nbstop))
          begin
            @(posedge this.cmp.vif.clk);
            #1;
            if (this.cmp.sample_clk) begin
              this.cmp.num_of_bits_rcvd++;
              if ((this.cmp.num_of_bits_rcvd > 0) && (this.cmp.num_of_bits_rcvd <= this.cmp.cfg.char_len_val)) begin // sending "data bits"
                item.pack_data(this.cmp.num_of_bits_rcvd-1, this.cmp.serial_b);
                bb = item.unpack_data(this.cmp.num_of_bits_rcvd-1);
                `uvm_info(this.cmp.get_full_name(), $psprintf("Received a item data bit:'b%0b", bb), UVM_HIGH)
              end
              this.cmp.msb_lsb_data[0] =  item.unpack_data(0) ;
              this.cmp.msb_lsb_data[1] =  item.unpack_data(this.cmp.cfg.char_len_val-1);
              if ((this.cmp.num_of_bits_rcvd == (1 + this.cmp.cfg.char_len_val)) && (this.cmp.cfg.parity_en)) begin // sending "parity bit" if parity is enabled
                item.parity = this.cmp.serial_b;
                `uvm_info(this.cmp.get_full_name(), $psprintf("Received Parity bit:'b%0b", item.parity), UVM_HIGH)
                if (this.cmp.serial_b == item.calc_parity(this.cmp.cfg.char_len_val, this.cmp.cfg.parity_mode))
                  `uvm_info(this.cmp.get_full_name(), "Received Parity is same as calculated Parity", UVM_MEDIUM)
                else
                  `uvm_error(this.cmp.get_full_name(), "####### FAIL :Received Parity doesn't match the calculated Parity  ")
              end
              if (this.cmp.num_of_bits_rcvd == (1 + this.cmp.cfg.char_len_val + this.cmp.cfg.parity_en)) begin // sending "stop/error bits"
                for (int i = 0; i < this.cmp.cfg.nbstop; i++) begin
                  wait (this.cmp.sample_clk);
                  item.stop_bits[i] = this.cmp.serial_b;
                  `uvm_info(this.cmp.get_full_name(), $psprintf("Received a Stop bit: 'b%0b", item.stop_bits[i]), UVM_HIGH)
                  this.cmp.num_of_bits_rcvd++;
                  wait (!this.cmp.sample_clk);
                end
              end
              wait (!this.cmp.sample_clk);
            end
          end
       item.ed_cyc = this.cmp.vif.cyc;
       item.ed_time = $time;
       item.complete = 1;
       item.addr_complete = 1;
       item.data_complete = 1;
       void'(this.cmp.end_tr(item));
       this.cmp.item_collected_port.write(item);

       this.cmp.num_items++;
       `uvm_info(this.cmp.get_full_name(), $psprintf("Collected the following Item No:%0d\n%s", this.cmp.num_items, item.sprint()), UVM_MEDIUM)

       if (this.cmp.cfg.has_coverage) this.cmp.cbox.put(item);
       if (this.cmp.cfg.has_export)   this.cmp.ebox.put(item);
      endtask

endclass


class uart_export_collected_items#(
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `UART_ITEM item;
    `UART_MONITOR cmp;

    string attr_longint[$] = `SMTDV_BUS_VIF_ATTR_LONGINT;

    `uvm_object_param_utils_begin(`UART_EXPORT_COLLECTED_ITEMS)
    `uvm_object_utils_end

    function new(string name = "uart_export_collected_items");
      super.new(name);
    endfunction

    virtual task run();
      create_table();
      forever begin
        this.cmp.ebox.get(item);
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
      smtdv_sqlite3::insert_value(table_nm, "dec_uuid",    $psprintf("%d", item.get_sequence_id()));
      smtdv_sqlite3::insert_value(table_nm, "dec_addr",    $psprintf("%d", 0));
      smtdv_sqlite3::insert_value(table_nm, "dec_rw",      $psprintf("%d", WR));
      smtdv_sqlite3::insert_value(table_nm, "dec_data_000", $psprintf("%d", item.data_beat[0]));
      smtdv_sqlite3::insert_value(table_nm, "dec_bg_cyc",  $psprintf("%d", item.bg_cyc));
      smtdv_sqlite3::insert_value(table_nm, "dec_ed_cyc",  $psprintf("%d", item.ed_cyc));
      smtdv_sqlite3::insert_value(table_nm, "dec_bg_time", $psprintf("%d", item.bg_time));
      smtdv_sqlite3::insert_value(table_nm, "dec_ed_time", $psprintf("%d", item.ed_time));
      smtdv_sqlite3::exec_value(table_nm);
      smtdv_sqlite3::flush_value(table_nm);
    endtask

endclass


class uart_collect_stop_signal#(
  type CFG = smtdv_cfg
) extends
    smtdv_run_thread;

    `UART_MONITOR cmp;
    int stop_cnt = 1000;
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

`endif // end of __UART_MONITOR_THREADS_SV__
