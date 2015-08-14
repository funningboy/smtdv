`ifndef __APB_MASTER_DRIVER_THREADS_SV__
`define __APB_MASTER_DRIVER_THREADS_SV__

typedef class apb_master_driver;

class apb_master_drive_items #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_run_thread;

    `APB_ITEM item;
    `APB_MASTER_DRIVER cmp;

    `uvm_object_param_utils_begin(`APB_MASTER_DRIVE_ITEMS)
    `uvm_object_utils_end

    function new(string name = "apb_master_drive_items");
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

    virtual task do_write_item(ref `APB_ITEM item);
        wait(this.cmp.vif.cyc >= item.bg_cyc);
        // SetUp
        wait(!this.cmp.cfg.block_psel);
        repeat(item.psel_L2H) @(posedge this.cmp.vif.clk);
        populate_setup_write_item(item);
        @(posedge this.cmp.vif.clk);
        // Access
        wait(!this.cmp.cfg.block_penable);
        repeat(item.penable_L2H) @(posedge this.cmp.vif.clk);
        populate_access_write_item(item);
        // wait until pready assert
        @(posedge this.cmp.vif.clk iff (this.cmp.vif.pready));
        populate_end_write_item(item);
        `uvm_info(this.cmp.get_full_name(), {$psprintf("try do write item \n%s", item.sprint())}, UVM_LOW)
    endtask

    virtual task do_read_item(ref `APB_ITEM item);
      wait(this.cmp.vif.cyc >= item.bg_cyc);
      // SetUp
      wait(!this.cmp.cfg.block_psel);
      repeat(item.psel_L2H) @(posedge this.cmp.vif.clk);
      populate_setup_read_item(item);
      @(posedge this.cmp.vif.clk);
      // Access
      wait(!this.cmp.cfg.block_penable);
      repeat(item.penable_L2H) @(posedge this.cmp.vif.clk);
      populate_access_read_item(item);
      // wait until pready assert
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.pready));
      populate_end_read_item(item);
      `uvm_info(this.cmp.get_full_name(), {$psprintf("try do read item \n%s", item.sprint())}, UVM_LOW)
    endtask

    virtual task populate_setup_write_item(ref `APB_ITEM item);
        this.cmp.vif.master.paddr <= item.addr;
        this.cmp.vif.master.prwd <= WR;
        this.cmp.vif.master.psel <= 1<<this.cmp.cfg.find_slave(item.addr);
        this.cmp.vif.master.pwdata <= item.unpack_data();
    endtask

    virtual task populate_access_write_item(ref `APB_ITEM item);
        this.cmp.vif.master.penable <= 1'b1;
    endtask

    virtual task populate_end_write_item(ref `APB_ITEM item);
        this.cmp.vif.master.psel <= 1'b0;
        this.cmp.vif.master.penable <= 1'b0;
    endtask

    virtual task populate_setup_read_item(ref `APB_ITEM item);
      this.cmp.vif.master.paddr <= item.addr;
      this.cmp.vif.master.prwd <= RD;
      this.cmp.vif.master.psel <= 1<<this.cmp.cfg.find_slave(item.addr);
    endtask

    virtual task populate_access_read_item(ref `APB_ITEM item);
      this.cmp.vif.master.penable <= 1'b1;
    endtask

    virtual task populate_end_read_item(ref `APB_ITEM item);
      this.cmp.vif.master.psel <= 1'b0;
      this.cmp.vif.master.penable <= 1'b0;
    endtask

endclass

`endif // end if __APB_DRIVER_THREADS_SV__
