
`ifndef __UART_RX_DRIVER_THREADS_SV__
`define __UART_RX_DRIVER_THREADS_SV__

typedef class uart_rx_driver;

class uart_rx_sample_rate #(
) extends
  smtdv_run_thread;

  `UART_ITEM item;
  `UART_RX_DRIVER cmp;

   `uvm_object_param_utils_begin(`UART_RX_SAMPLE_RATE)
   `uvm_object_utils_end

   function new(string name = "uart_rx_sample_rate");
     super.new(name);
   endfunction

    virtual task run();
      forever begin
        @(posedge this.cmp.vif.clk);
        if (!this.cmp.vif.resetn) begin
          this.cmp.ua_brgr = 0;
          this.cmp.sample_clk = 0;
        end else begin
          if (this.cmp.ua_brgr == ({this.cmp.cfg.baud_rate_div, this.cmp.cfg.baud_rate_gen})) begin
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


class uart_rx_drive_items#(
) extends
  smtdv_run_thread;

  `UART_ITEM item;
  `UART_RX_DRIVER cmp;

   `uvm_object_param_utils_begin(`UART_RX_DRIVE_ITEMS)
   `uvm_object_utils_end

   function new(string name = "uart_rx_drive_items");
     super.new(name);
   endfunction

  virtual task run();
    bit [7:0] payload_byte;

    forever begin
      this.cmp.mbox.get(item);
      this.cmp.num_items_sent++;

      `uvm_info(this.cmp.get_full_name(),
            $psprintf("Driver Sending RX Item No:%0d...\n%s", this.cmp.num_items_sent, item.sprint()),
            UVM_HIGH)

      this.cmp.num_of_bits_sent = 0;

      if(this.cmp.cfg.block_req) begin repeat (item.transmit_delay) @(posedge this.cmp.vif.clk); end

      wait((!this.cmp.cfg.rts_en)||(!this.cmp.vif.cts_n));
      `uvm_info(this.cmp.get_full_name(), "Driver - Modem RTS or CTS asserted", UVM_HIGH)

      while (this.cmp.num_of_bits_sent <= (1 + this.cmp.cfg.char_len_val + this.cmp.cfg.parity_en + this.cmp.cfg.nbstop)) begin
        @(posedge this.cmp.vif.clk);
        #1;
        if (this.cmp.sample_clk) begin
          if (this.cmp.num_of_bits_sent == 0) begin
            // Start sending rx_item with "start bit"
            this.cmp.vif.rx.rxd <= item.start_bit;
            `uvm_info(this.cmp.get_full_name(),
                      $psprintf("Driver Sending item SOP: %b", item.start_bit),
                      UVM_HIGH)
          end
          if ((this.cmp.num_of_bits_sent > 0) && (this.cmp.num_of_bits_sent < (1 + this.cmp.cfg.char_len_val))) begin
            // sending "data bits"
            payload_byte = item.payload[this.cmp.num_of_bits_sent-1] ;
            this.cmp.vif.rx.rxd <= item.payload[this.cmp.num_of_bits_sent-1];
            `uvm_info(this.cmp.get_full_name(),
                 $psprintf("Driver Sending item data bit number:%0d value:'b%b",
                 (this.cmp.num_of_bits_sent-1), payload_byte), UVM_HIGH)
          end
          if ((this.cmp.num_of_bits_sent == (1 + this.cmp.cfg.char_len_val)) && (this.cmp.cfg.parity_en)) begin
            // sending "parity bit" if parity is enabled
            this.cmp.vif.rx.rxd <= item.calc_parity(this.cmp.cfg.char_len_val, this.cmp.cfg.parity_mode);
            `uvm_info(this.cmp.get_full_name(),
                 $psprintf("Driver Sending item Parity bit:'b%b",
                 item.calc_parity(this.cmp.cfg.char_len_val, this.cmp.cfg.parity_mode)), UVM_HIGH)
          end
          if (this.cmp.num_of_bits_sent == (1 + this.cmp.cfg.char_len_val + this.cmp.cfg.parity_en)) begin
            // sending "stop/error bits"
            for (int i = 0; i < this.cmp.cfg.nbstop; i++) begin
              `uvm_info(this.cmp.get_full_name(),
                   $psprintf("Driver Sending item Stop bit:'b%b",
                   item.stop_bits[i]), UVM_HIGH)
              wait (this.cmp.sample_clk);
              if (item.error_bits[i]) begin
                this.cmp.vif.rx.rxd <= 0;
                `uvm_info(this.cmp.get_full_name(),
                     $psprintf("Driver intensionally corrupting Stop bit since error_bits['b%b] is 'b%b", i, item.error_bits[i]),
                     UVM_HIGH)
              end else
              this.cmp.vif.rx.rxd <= item.stop_bits[i];

              this.cmp.num_of_bits_sent++;
              wait (!this.cmp.sample_clk);
            end
          end
        this.cmp.num_of_bits_sent++;
        wait (!this.cmp.sample_clk);
        end
      end

      `uvm_info(this.cmp.get_full_name(),
           $psprintf("item **%0d** Sent...", this.cmp.num_items_sent), UVM_MEDIUM)
      wait (this.cmp.sample_clk);
      this.cmp.vif.rx.rxd <= 1;

      `uvm_info(this.cmp.get_full_name(), "item complete...", UVM_MEDIUM)
    end
  endtask

endclass

`endif // __UART_RX_DRIVER_THREADS_SV__
