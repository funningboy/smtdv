
`ifndef __UART_TX_DRIVER_THREADS_SV__
`define __UART_TX_DRIVER_THREADS_SV__

class uart_tx_drive_items

class uart_tx_sample_rate #(
) extends
  smtdv_run_thread;

  `UART_ITEM item;
  `UART_MASTER_DRIVER cmp;

   `uvm_object_param_utils_begin(`UART_TX_DRIVE_ITEMS)
   `uvm_object_utils_end

   function new(string name = "uart_tx_drive_items");
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


class uart_tx_drive_items#(
) extends
  smtdv_run_thread;

  `UART_ITEM item;
  `UART_MASTER_DRIVER cmp;

    `uvm_object_param_utils_begin(`UART_TX_DRIVE_ITEMS)
    `uvm_object_utils_end

    function new(string name = "uart_tx_drive_items");
      super.new(name);
    endfunction

    virtual task run();
      bit [7:0] payload_byte;

      forever begin
        this.cmp.mbox.get(item);
  num_of_bits_sent = 0;


  if(this.cmp.block_req)begin repeat (item.req_L2H)@(posedge this.cmp.vif.clk); end

  wait((!this.cmp.cfg.rts_en)||(!this.cmp.vif.cts_n));
  `uvm_info(this.cmp.get_full_name(), {$psprintf("Driver - Modem RTS or CTS asserted")}, UVM_HIGH)

  while (num_of_bits_sent <= (1 + this.cmp.cfg.char_len_val + this.cmp.cfg.parity_en + this.cmp.cfg.nbstop)) begin
    @(posedge this.cm.vif.clk);
    #1;
    if (this.cmp.sample_clk) begin
      send_start_bit();
      send_data_bits();
      send_parity_bit();
      send_stop_bit();

      if (num_of_bits_sent == 0) begin
        // Start sending tx_item with "start bit"
        this.cmp.tx.vif.txd <= item.start_bit;
        `uvm_info(get_type_name(),
                  {$psprintf("Driver Sending item SOP: %b", item.start_bit)},
                  UVM_HIGH)
      end
      if ((num_of_bits_sent > 0) && (num_of_bits_sent < (1 + this.cmp.cfg.char_len_val))) begin
        // sending "data bits"
        payload_byte = item.payload[num_of_bits_sent-1];
        this.cmp.tx.vif.txd <= item.payload[num_of_bits_sent-1];
        `uvm_info(get_type_name(),
             $psprintf("Driver Sending item data bit number:%0d value:'b%b",
             (num_of_bits_sent-1), payload_byte), UVM_HIGH)
      end
      if ((num_of_bits_sent == (1 + this.cmp.cfg.char_len_val)) && (this.cmp.cfg.parity_en)) begin
        // sending "parity bit" if parity is enabled
        this.cmp.tx.vif.txd <= item.calc_parity(this.cmp.cfg.char_len_val, this.cmp.cfg.parity_mode);
        `uvm_info(get_type_name(),
             $psprintf("Driver Sending item Parity bit:'b%b",
             item.calc_parity(this.cmp.cfg.char_len_val, this.cmp.cfg.parity_mode)), UVM_HIGH)
      end
      if (num_of_bits_sent == (1 + this.cmp.cfg.char_len_val + this.cmp.cfg.parity_en)) begin
        // sending "stop/error bits"
        for (int i = 0; i < this.cmp.cfg.nbstop; i++) begin
          `uvm_info(get_type_name(),
               $psprintf("Driver Sending item Stop bit:'b%b",
               item.stop_bits[i]), UVM_HIGH)
          wait (this.cmp.sample_clk);
          if (item.error_bits[i]) begin
            this.cmp.vif.tx.txd <= 0;
            `uvm_info(get_type_name(),
                 $psprintf("Driver intensionally corrupting Stop bit since error_bits['b%b] is 'b%b", i, item.error_bits[i]),
                 UVM_HIGH)
          end else
          this.cmp.vif.tx.txd <= item.stop_bits[i];
          num_of_bits_sent++;
          wait (!this.cmp.sample_clk);
        end
      end
    num_of_bits_sent++;
    wait (!this.cmp.sample_clk);
    end
  end

  num_items_sent++;
  `uvm_info(get_type_name(),
       $psprintf("item **%0d** Sent...", num_items_sent), UVM_MEDIUM)
  wait (this.cmp.sample_clk);
  this.cmp.vif.tx.txd <= 1;

  `uvm_info(get_type_name(), "item complete...", UVM_MEDIUM)
  this.end_tr(item);

endtask


