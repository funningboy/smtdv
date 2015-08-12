
`ifndef __XBUS_SLAVE_DRIVER_THREADS_SV__
`define __XBUS_SLAVE_DRIVER_THREADS_SV__

typedef class xbus_slave_driver;

class xbus_slave_drive_items #(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 8,
  DATA_WIDTH = 32
) extends
    smtdv_run_thread;

    `XBUS_SLAVE_DRIVER cmp;
    `XBUS_ITEM item;

    `uvm_object_param_utils_begin(`XBUS_SLAVE_DRIVE_ITEMS)
    `uvm_object_utils_end

    function new(string name = "xbus_slave_drive_items");//, callback, cb);
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

    virtual task do_write_item(ref `XBUS_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.req));
      wait(!this.cmp.cfg.block_ack);
      repeat(item.ack_L2H) @(posedge this.cmp.vif.clk);
      wait(this.cmp.vif.cyc >= item.bg_cyc);
      populate_begin_write_item(item);
      @(posedge this.cmp.vif.clk);
      populate_end_write_item(item);
      @(posedge this.cmp.vif.clk);
      `uvm_info(this.cmp.get_full_name(), {$psprintf("try respone write item\n")}, UVM_LOW)
    endtask

    virtual task do_read_item(ref `XBUS_ITEM item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.req));
      wait(!this.cmp.cfg.block_ack);
      repeat(item.ack_L2H) @(posedge this.cmp.vif.clk);
      wait(this.cmp.vif.cyc >= item.bg_cyc);
      populate_begin_read_item(item);
      @(posedge this.cmp.vif.clk);
      populate_end_read_item(item);
      @(posedge this.cmp.vif.clk);
      `uvm_info(this.cmp.get_full_name(), {$psprintf("try respone read item\n")}, UVM_LOW)
    endtask

    virtual task populate_begin_write_item(ref `XBUS_ITEM item);
      this.cmp.vif.ack <= 1'b1;
    endtask

    virtual task populate_end_write_item(ref `XBUS_ITEM item);
      this.cmp.vif.ack <= 1'b0;
    endtask

    virtual task populate_begin_read_item(ref `XBUS_ITEM item);
      this.cmp.vif.ack <= 1'b1;
      this.cmp.vif.rdata <= item.unpack_data();
    endtask

    virtual task populate_end_read_item(ref `XBUS_ITEM item);
      this.cmp.vif.ack <= 1'b0;
    endtask

endclass

`endif // __XBUS_SLAVE_DRIVER_THREADS_SV__
