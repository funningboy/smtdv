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

    virtual task run();
      forever begin
        populate_okay_item(item);
        this.cmp.addrbox.get(item);
        @(posedge this.cmp.vif.clk);
        if (this.cmp.vif.hsel && this.cmp.vif.hready && this.cmp.vif.htrans inside {NONSEQ, SEQ, BUSY}) begin
          // ERROR/SPLIT/RETRY at least two cycles
          `SMTDV_RAND_VAR_WITH(opt, {opt dist {[0:2]:=40, 3:=60};})
          if (this.cmp.cfg.has_split && opt==0) begin for(int i=0; i<2; i++) begin populate_split_item(item); @(posedge this.cmp.vif.clk); end end
          if (this.cmp.cfg.has_error && opt==1) begin for(int i=0; i<2; i++) begin populate_error_item(item); @(posedge this.cmp.vif.clk); end end
          if (this.cmp.cfg.has_retry && opt==2) begin for(int i=0; i<2; i++) begin populate_retry_item(item); @(posedge this.cmp.vif.clk); end end
        end
      end
    endtask

    virtual task populate_okay_item(ref `AHB_ITEM item);
      this.cmp.vif.slave.hready <= 1'b1;
      this.cmp.vif.slave.hresp <= OKAY;
    endtask

    virtual task populate_error_item(ref `AHB_ITEM item);
      if (!item.error) begin
        this.cmp.vif.slave.hready <= 1'b0;
        this.cmp.vif.slave.hresp <= ERROR;
        item.error = 1;
      end
      else begin
        this.cmp.vif.slave.hready <= 1'b1;
        this.cmp.vif.slave.hresp <= ERROR;
      end
    endtask

    virtual task populate_retry_item(ref `AHB_ITEM item);
      if (!item.retry) begin
        this.cmp.vif.slave.hready <= 1'b0;
        this.cmp.vif.slave.hresp <= RETRY;
        item.retry = 1;
      end
      else begin
        this.cmp.vif.slave.hready <= 1'b1;
        this.cmp.vif.slave.hresp <= RETRY;
      end
    endtask

    virtual task populate_split_item(ref `AHB_ITEM item);
      if (!item.split) begin
        this.cmp.vif.slave.hready <= 1'b0;
        this.cmp.vif.slave.hresp <= SPLIT;
        item.split = 1;
      end
      else begin
        this.cmp.vif.slave.hready <= 1'b1;
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

    virtual task run();
      forever begin
        this.cmp.databox.get(item);
        `uvm_info(this.cmp.get_full_name(), {$psprintf("try 1111 \n%s", item.sprint())}, UVM_LOW)

        while(!item.complete) begin
        `uvm_info(this.cmp.get_full_name(), {$psprintf("try 2222 \n%s", item.sprint())}, UVM_LOW)

          if(item.addr_idx > item.data_idx) begin
            populate_data_item(item);
          end
          @(posedge this.cmp.vif.clk);
        end
        `uvm_info(this.cmp.get_full_name(), {$psprintf("try 2222 \n%s", item.sprint())}, UVM_LOW)
      end
    endtask

    virtual task populate_data_item(ref `AHB_ITEM item);
      this.cmp.vif.slave.hrdata <= item.unpack_data(item.data_idx++);
    endtask

endclass

`endif // __AHB_SLAVE_DRIVER_THREADS_SV__
