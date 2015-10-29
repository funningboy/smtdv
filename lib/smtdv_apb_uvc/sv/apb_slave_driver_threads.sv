`ifndef __APB_SLAVE_DRIVER_THREADS_SV__
`define __APB_SLAVE_DRIVER_THREADS_SV__

typedef class apb_slave_driver;

class apb_slave_drive_items #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_run_thread;

    `APB_SLAVE_DRIVER cmp;
    `APB_ITEM item;

    `uvm_object_param_utils_begin(`APB_SLAVE_DRIVE_ITEMS)
    `uvm_object_utils_end

    function new(string name = "apb_slave_drive_items");//, callback, cb);
      super.new(name);
    endfunction

    virtual task run();
      forever begin
        this.cmp.mbox.get(item);
        case(item.trs_t)
          WR: do_write_item(item);
          RD: do_read_item(item);
          default:
            `uvm_fatal("UNXPCTDPKT",
              $sformatf("get an unexpected item \n%s", item.sprint()))
        endcase
      end
    endtask

    virtual task do_write_item(ref `APB_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.psel && this.cmp.vif.penable));
      if (this.cmp.cfg.block_pready) repeat(item.pready_L2H) @(posedge this.cmp.vif.clk);
      wait(this.cmp.vif.cyc >= item.bg_cyc);
      populate_begin_write_item(item);
      @(posedge this.cmp.vif.clk);
      populate_end_write_item(item);
      `uvm_info(this.cmp.get_full_name(), {$psprintf("try respone write item\n")}, UVM_LOW)
    endtask

    virtual task do_read_item(ref `APB_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.psel && this.cmp.vif.penable));
      if (this.cmp.cfg.block_pready) repeat(item.pready_L2H) @(posedge this.cmp.vif.clk);
      wait(this.cmp.vif.cyc >= item.bg_cyc);
      populate_begin_read_item(item);
      @(posedge this.cmp.vif.clk);
      populate_end_read_item(item);
      `uvm_info(this.cmp.get_full_name(), {$psprintf("try respone read item\n")}, UVM_LOW)
    endtask

    virtual task populate_begin_write_item(ref `APB_ITEM item);
      this.cmp.vif.slave.pready <= 1'b1;
      this.cmp.vif.slave.pslverr <= item.rsp;
    endtask

    virtual task populate_end_write_item(ref `APB_ITEM item);
      this.cmp.vif.slave.pready <= 1'b0;
    endtask

    virtual task populate_begin_read_item(ref `APB_ITEM item);
      this.cmp.vif.slave.pready <= 1'b1;
      this.cmp.vif.slave.prdata <= (item.rsp == OK)? item.unpack_data(): 'hx;
      this.cmp.vif.slave.pslverr <= item.rsp;
    endtask

    virtual task populate_end_read_item(ref `APB_ITEM item);
      this.cmp.vif.slave.pready <= 1'b0;
    endtask

endclass

`endif // __APB_SLAVE_DRIVER_THREADS_SV__
