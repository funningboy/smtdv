`ifndef __AHB_SLAVE_DRIVER_THREADS_SV__
`define __AHB_SLAVE_DRIVER_THREADS_SV__

typedef class ahb_slave_driver;

class ahb_slave_drive_addr #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_run_thread;

    `AHB_SLAVE_DRIVER cmp;
    `AHB_ITEM item;
    rand int opt = 0;

    `uvm_object_param_utils_begin(`AHB_SLAVE_DRIVE_ADDR)
    `uvm_object_utils_end

    function new(string name = "ahb_slave_drive_addr");//, callback, cb);
      super.new(name);
    endfunction

    virtual task drive_RETRY(ref `AHB_ITEM item);
      populate_retry_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && !this.cmp.vif.hready));
      populate_retry_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && this.cmp.vif.hready));
      populate_complete_item(item);
    endtask

    virtual task drive_SPLIT(ref `AHB_ITEM item);
      populate_split_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && !this.cmp.vif.hready));
      populate_split_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && this.cmp.vif.hready));
      populate_complete_item(item);
    endtask

    virtual task drive_ERROR(ref `AHB_ITEM item);
      populate_error_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && !this.cmp.vif.hready));
      populate_error_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && this.cmp.vif.hready));
      populate_complete_item(item);
    endtask

    virtual task drive_OKAY(ref `AHB_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && this.cmp.vif.hready && this.cmp.vif.htrans inside {NONSEQ, SEQ}));
      populate_okay_item(item);
      if(item.addr_idx == item.bst_len+1) begin
        populate_complete_item(item);
      end
    endtask

    virtual task drive(ref `AHB_ITEM item);
      `SMTDV_RAND_VAR_WITH(opt, {opt dist {[0:2]:=50, 3:=50};})
           if (this.cmp.cfg.has_split && opt==0) begin drive_SPLIT(item); end
      else if (this.cmp.cfg.has_error && opt==1) begin drive_ERROR(item); end
      else if (this.cmp.cfg.has_retry && opt==2) begin drive_RETRY(item); end
      else begin drive_OKAY(item); end
    endtask

    virtual task run();
      forever begin
        // after reset
        populate_default_item(item);
        this.cmp.addrbox.get(item);

        while(!item.addr_complete) begin
            fork
              drive(item);
            join_any
            disable fork;
          end
        `uvm_info(this.cmp.get_full_name(), {$psprintf("try do addr item \n%s", item.sprint())}, UVM_LOW)
      end
    endtask

    virtual task populate_complete_item(ref `AHB_ITEM item);
      item.addr_complete = 1;
      item.complete = 1;
    endtask

    virtual task populate_default_item(ref `AHB_ITEM item);
      this.cmp.vif.slave.hreadyout <= 1'b1;
      this.cmp.vif.slave.hresp <= OKAY;
    endtask

    virtual task populate_okay_item(ref `AHB_ITEM item);
      if (this.cmp.cfg.block_hready) begin
        this.cmp.vif.slave.hreadyout <= 1'b0;
        this.cmp.vif.slave.hresp <= OKAY;
        repeat(item.hready_L2H) @(posedge this.cmp.vif.clk);
      end
      this.cmp.vif.slave.hreadyout <= 1'b1;
      this.cmp.vif.slave.hresp <= OKAY;
      item.addr_idx++;
    endtask

    virtual task populate_error_item(ref `AHB_ITEM item);
      if (!item.error) begin
        this.cmp.vif.slave.hreadyout <= 1'b0;
        this.cmp.vif.slave.hresp <= ERROR;
        item.error = 1;
      end
      else begin
        this.cmp.vif.slave.hreadyout <= 1'b1;
        this.cmp.vif.slave.hresp <= ERROR;
      end
    endtask

    virtual task populate_retry_item(ref `AHB_ITEM item);
      if (!item.retry) begin
        this.cmp.vif.slave.hreadyout <= 1'b0;
        this.cmp.vif.slave.hresp <= RETRY;
        item.retry = 1;
      end
      else begin
        this.cmp.vif.slave.hreadyout <= 1'b1;
        this.cmp.vif.slave.hresp <= RETRY;
      end
    endtask

    virtual task populate_split_item(ref `AHB_ITEM item);
      if (!item.split) begin
        this.cmp.vif.slave.hreadyout <= 1'b0;
        this.cmp.vif.slave.hresp <= SPLIT;
        item.split = 1;
      end
      else begin
        this.cmp.vif.slave.hreadyout <= 1'b1;
        this.cmp.vif.slave.hresp <= SPLIT;
      end
    endtask

endclass

class ahb_slave_drive_data #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_run_thread;

    `AHB_SLAVE_DRIVER cmp;
    `AHB_ITEM item;
    rand int opt = 0;

    `uvm_object_param_utils_begin(`AHB_SLAVE_DRIVE_DATA)
    `uvm_object_utils_end

    function new(string name = "ahb_slave_drive_data");//, callback, cb);
      super.new(name);
    endfunction

    virtual task drive_RETRY(ref `AHB_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && !this.cmp.vif.hready));
      populate_retry_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && this.cmp.vif.hready));
      populate_complete_item(item);
    endtask

    virtual task drive_SPLIT(ref `AHB_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && !this.cmp.vif.hready));
      populate_split_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && this.cmp.vif.hready));
      populate_complete_item(item);
    endtask

    virtual task drive_ERROR(ref `AHB_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && !this.cmp.vif.hready));
      populate_error_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && this.cmp.vif.hready));
      populate_complete_item(item);
    endtask

    virtual task drive_OKAY(ref `AHB_ITEM item);
      while (item.data_idx <= item.bst_len) begin
        @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && this.cmp.vif.hready && this.cmp.vif.htrans inside {NONSEQ, SEQ}));
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
          // join
          fork
            drive_OKAY(item);
            drive_ERROR(item);
            drive_SPLIT(item);
            drive_RETRY(item);
          join_any
          disable fork;
        end
        `uvm_info(this.cmp.get_full_name(), {$psprintf("try do data item \n%s", item.sprint())}, UVM_LOW)
      end
    endtask

    virtual task populate_data_item(ref `AHB_ITEM item);
      if (item.trs_t == RD) begin
        this.cmp.vif.slave.hrdata <= item.unpack_data(item.data_idx);
      end
      item.data_idx++;
    endtask

    virtual task populate_error_item(ref `AHB_ITEM item);
    endtask

    virtual task populate_retry_item(ref `AHB_ITEM item);
    endtask

    virtual task populate_split_item(ref `AHB_ITEM item);
    endtask


    virtual task populate_complete_item(ref `AHB_ITEM item);
      item.data_complete = 1;
      item.complete = 1;
    endtask

endclass

`endif // __AHB_SLAVE_DRIVER_THREADS_SV__
