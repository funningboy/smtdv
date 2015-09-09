
`ifndef __XBUS_MASTER_DRIVER_THREADS_SV__
`define __XBUS_MASTER_DRIVER_THREADS_SV__

typedef class xbus_master_driver;

class xbus_master_drive_items #(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 8,
  DATA_WIDTH = 32
) extends
    smtdv_run_thread;

    `XBUS_ITEM item;
    `XBUS_MASTER_DRIVER cmp;

    `uvm_object_param_utils_begin(`XBUS_MASTER_DRIVE_ITEMS)
    `uvm_object_utils_end

    function new(string name = "xbus_master_drive_items");
      super.new(name);
    endfunction

    virtual task run();
      forever begin
        this.cmp.mbox.get(item);
        case(item.trs_t)
          RD: do_read_item(item);
          WR: do_write_item(item);
          default:
            `uvm_fatal("UNXPCTDPKT",
              $sformatf("get an unexpected item \n%s", item.sprint()))
        endcase
      end
    endtask

    virtual task do_write_item(ref `XBUS_ITEM item);
        if(this.cmp.cfg.block_req)begin repeat(item.req_L2H) @(posedge this.cmp.vif.clk); end
        wait(this.cmp.vif.cyc >= item.bg_cyc);
        populate_begin_write_item(item);
        @(posedge this.cmp.vif.clk iff (this.cmp.vif.ack));
        populate_end_write_item(item);
        @(posedge this.cmp.vif.clk);
        `uvm_info(this.cmp.get_full_name(), {$psprintf("try do write item \n%s", item.sprint())}, UVM_LOW)
    endtask

    virtual task do_read_item(ref `XBUS_ITEM item);
      if(this.cmp.cfg.block_req)begin repeat(item.req_L2H) @(posedge this.cmp.vif.clk); end
      wait(this.cmp.vif.cyc >= item.bg_cyc);
      populate_begin_read_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.ack));
      populate_end_read_item(item);
      @(posedge this.cmp.vif.clk);
      `uvm_info(this.cmp.get_full_name(), {$psprintf("try do read item \n%s", item.sprint())}, UVM_LOW)
    endtask

    virtual task populate_begin_write_item(ref `XBUS_ITEM item);
        this.cmp.vif.master.addr <= item.addr;
        this.cmp.vif.master.req <= 1'b1;
        this.cmp.vif.master.rw <= WR;
        this.cmp.vif.master.byten <= item.unpack_byten();
        this.cmp.vif.master.wdata <= item.unpack_data();
    endtask

    virtual task populate_end_write_item(ref `XBUS_ITEM item);
        this.cmp.vif.master.req <= 1'b0;
    endtask

    virtual task populate_begin_read_item(ref `XBUS_ITEM item);
      this.cmp.vif.master.addr <= item.addr;
      this.cmp.vif.master.req <= 1'b1;
      this.cmp.vif.master.rw <= RD;
    endtask

    virtual task populate_end_read_item(ref `XBUS_ITEM item);
      this.cmp.vif.master.req <= 1'b0;
    endtask

endclass

`endif // end if __XBUS_DRIVER_THREADS_SV__
