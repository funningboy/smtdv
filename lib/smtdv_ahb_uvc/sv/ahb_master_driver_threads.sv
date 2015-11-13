`ifndef __AHB_MASTER_DRIVER_THREADS_SV__
`define __AHB_MASTER_DRIVER_THREADS_SV__

typedef class ahb_master_driver;

class ahb_master_drive_addr #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_run_thread;

    rand int opt = 0;
    `AHB_ITEM item, req;
    `AHB_MASTER_DRIVER cmp;

    `uvm_object_param_utils_begin(`AHB_MASTER_DRIVE_ADDR)
    `uvm_object_utils_end

    function new(string name = "ahb_master_drive_addr");
      super.new(name);
    endfunction

    virtual task listen_RETRY(ref `AHB_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == RETRY && !this.cmp.vif.hready));
      populate_retry_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == RETRY && this.cmp.vif.hready));
      populate_clear_item(item);
    endtask

    virtual task listen_SPLIT(ref `AHB_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == SPLIT && !this.cmp.vif.hready));
      populate_split_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == SPLIT && this.cmp.vif.hready));
      populate_complete_item(item);
    endtask

    virtual task listen_OKAY(ref `AHB_ITEM item);
      while (1) begin
        @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == OKAY && this.cmp.vif.hready));
        if (item.addr_idx > item.bst_len) begin break; end
        // BUSY/SEQ
        `SMTDV_RAND_VAR_WITH(opt, {opt dist {0:=40, 1:=60};})
        if (this.cmp.cfg.has_busy && opt==0) begin
          populate_busy_item(item);
        end
        else begin
          populate_seq_item(item);
        end
      end
      populate_complete_item(item);
    endtask

    virtual task listen_ERROR(ref `AHB_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == ERROR && !this.cmp.vif.hready));
      populate_error_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == ERROR && this.cmp.vif.hready));
      populate_complete_item(item);
    endtask

    virtual task drive_nonseq(ref `AHB_ITEM item);
       // start nonseq
      populate_nonseq_item(item);
    endtask

    virtual task run();
      forever begin
         // after reset
         populate_default_item(item);
         this.cmp.addrbox.get(item);

         while(!item.addr_complete) begin
            drive_nonseq(item);
            // join listen resp back
            fork
                listen_OKAY(item);
                listen_ERROR(item);
                listen_RETRY(item);
                listen_SPLIT(item);
              join_any
            disable fork;
          end
          `uvm_info(this.cmp.get_full_name(), {$psprintf("try do addr item \n%s", item.sprint())}, UVM_LOW)
      end
    endtask

    virtual task populate_default_item(ref `AHB_ITEM item);
      this.cmp.vif.master.htrans <= IDLE;
    endtask

    virtual task populate_clear_item(ref `AHB_ITEM item);
      item.retry = 0;
      item.split = 0;
      item.error = 0;
      item.addr_idx = 0;
      item.addr_complete = 0;
      item.complete = 0;
      this.cmp.vif.master.htrans <= IDLE;
    endtask

    virtual task populate_nonseq_item(ref `AHB_ITEM item);
      this.cmp.vif.master.haddr <= item.addrs[item.addr_idx];
      this.cmp.vif.master.htrans <= NONSEQ;
      this.cmp.vif.master.hwrite <= item.trs_t;
      this.cmp.vif.master.hsize <= item.trx_size;
      this.cmp.vif.master.hburst <= item.bst_type;
      this.cmp.vif.master.hprot <= item.trx_prt;
      this.cmp.vif.master.hmastlock <= item.hmastlock;
      item.addr_idx++;
    endtask

    virtual task populate_seq_item(ref `AHB_ITEM item);
      this.cmp.vif.master.haddr <= item.addrs[item.addr_idx];
      this.cmp.vif.master.htrans <= SEQ;
      item.addr_idx++;
    endtask

    virtual task populate_busy_item(ref `AHB_ITEM item);
      this.cmp.vif.master.haddr <= item.addrs[item.addr_idx];
      this.cmp.vif.master.htrans <= BUSY;
      item.busy_cnt--;
    endtask

    virtual task populate_complete_item(ref `AHB_ITEM item);
      item.addr_complete = 1;
      item.complete = 1;
    endtask

    virtual task populate_error_item(ref `AHB_ITEM item);
      item.error = 1;
      item.addr_complete = 1;
      item.complete = 1;
      this.cmp.vif.master.htrans <= IDLE;
    endtask

    virtual task populate_retry_item(ref `AHB_ITEM item);
      item.retry = 1;
      this.cmp.vif.master.htrans <= IDLE;
    endtask

    virtual task populate_split_item(ref `AHB_ITEM item);
      item.split = 1;
      this.cmp.vif.master.htrans <= IDLE;
    endtask

endclass


class ahb_master_drive_data #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_run_thread;

    `AHB_ITEM item;
    `AHB_MASTER_DRIVER cmp;

    `uvm_object_param_utils_begin(`AHB_MASTER_DRIVE_DATA)
    `uvm_object_utils_end

    function new(string name = "ahb_master_drive_data");
      super.new(name);
    endfunction

    virtual task listen_ERROR(ref `AHB_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == ERROR && !this.cmp.vif.hready));
      populate_error_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == ERROR && this.cmp.vif.hready));
      populate_complete_item(item);
    endtask

    virtual task listen_RETRY(ref `AHB_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == RETRY && !this.cmp.vif.hready));
      populate_retry_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == RETRY && this.cmp.vif.hready));
      populate_clear_item(item);
    endtask

    virtual task listen_SPLIT(ref `AHB_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == SPLIT && !this.cmp.vif.hready));
      populate_split_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == SPLIT && this.cmp.vif.hready));
      populate_complete_item(item);
    endtask

    virtual task listen_OKAY(ref `AHB_ITEM item);
      while (item.data_idx <= item.bst_len) begin
        @(posedge this.cmp.vif.clk iff(this.cmp.vif.hready && this.cmp.vif.hresp == OKAY && this.cmp.vif.htrans inside {NONSEQ, SEQ}));
        if(item.addr_idx > item.data_idx) begin
          populate_data_item(item);
        end
      end
      populate_complete_item(item);
    endtask

    virtual task run();
      forever begin
        this.cmp.databox.get(item);

         while(!item.data_complete) begin
            // join listen resp back
            fork
              listen_OKAY(item);
              listen_ERROR(item);
              listen_SPLIT(item);
              listen_RETRY(item);
            join_any
            disable fork;
          end
        `uvm_info(this.cmp.get_full_name(), {$psprintf("try do data item \n%s", item.sprint())}, UVM_LOW)
      end
    endtask

    virtual task populate_data_item(ref `AHB_ITEM item);
      if (item.trs_t == WR) begin
        this.cmp.vif.master.hwdata <= item.unpack_data(item.data_idx);
      end
      item.data_idx++;
    endtask

    virtual task populate_complete_item(ref `AHB_ITEM item);
      item.data_complete = 1;
      item.complete = 1;
    endtask

    virtual task populate_error_item(ref `AHB_ITEM item);
    endtask

    virtual task populate_retry_item(ref `AHB_ITEM item);
    endtask

    virtual task populate_split_item(ref `AHB_ITEM item);
    endtask

    virtual task populate_clear_item(ref `AHB_ITEM item);
      item.data_idx = 0;
      item.data_complete = 0;
      item.complete = 0;
    endtask

endclass

`endif // end if __AHB_DRIVER_THREADS_SV__
