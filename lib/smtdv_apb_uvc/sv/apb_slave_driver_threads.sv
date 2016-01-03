`ifndef __APB_SLAVE_DRIVER_THREADS_SV__
`define __APB_SLAVE_DRIVER_THREADS_SV__

typedef class apb_item;
typedef class apb_slave_driver;

class apb_slave_base_thread #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_run_thread#(
      apb_slave_driver#(ADDR_WIDTH, DATA_WIDTH)
  );

  typedef apb_slave_base_thread#(ADDR_WIDTH, DATA_WIDTH) th_t;
  typedef apb_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef apb_slave_driver#(ADDR_WIDTH, DATA_WIDTH) cmp_t;

  item_t item;
  cmp_t cmp;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "apb_slave_base_thread", cmp_t parent=null);//, callback, cb);
    super.new(name, parent);
  endfunction : new

  virtual function void pre_do();
    if ($cast(cmp, this.cmp)) begin
      `uvm_fatal("APB_NO_CMP",{"CMP MUST BE SET ",get_full_name(),".cmp"});
    end
endfunction : pre_do

endclass : apb_slave_base_thread


class apb_slave_drive_items #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    apb_slave_base_thread #(
      ADDR_WIDTH,
      DATA_WIDTH
  );

  typedef apb_slave_drive_items#(ADDR_WIDTH, DATA_WIDTH) th_t;

  rand int opt = 0;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "apb_slave_drive_items", cmp_t parent=null);//, callback, cb);
    super.new(name, parent);
  endfunction : new

  // blocking for R/W trx
  virtual task run();
    forever begin
      populate_default_item(item);
      this.cmp.mbox.get(item);
      wait(this.cmp.vif.has_force);
      case(item.trs_t)
        WR: begin do_write_item(item); end
        RD: begin do_read_item(item);  end
        default:
          `uvm_fatal("APB_UNXPCTDPKT",
          $sformatf("GET AN UNEXPECTED ITEM \n%s", item.sprint()))
        endcase
      end
    endtask : run

    virtual task populate_default_item(item_t item);
      this.cmp.vif.slave.pready <= 1'b0;
    endtask : populate_default_item

    virtual task do_write_item(item_t item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.psel && this.cmp.vif.penable));
      if (this.cmp.cfg.block_pready) repeat(item.pready_L2H) @(posedge this.cmp.vif.clk);
      wait(this.cmp.vif.cyc >= item.bg_cyc);
      populate_begin_write_item(item);
      @(posedge this.cmp.vif.clk);
      populate_end_write_item(item);
    endtask : do_write_item

    virtual task do_read_item(item_t item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.psel && this.cmp.vif.penable));
      if (this.cmp.cfg.block_pready) repeat(item.pready_L2H) @(posedge this.cmp.vif.clk);
      wait(this.cmp.vif.cyc >= item.bg_cyc);
      populate_begin_read_item(item);
      @(posedge this.cmp.vif.clk);
      populate_end_read_item(item);
    endtask : do_read_item

    virtual task populate_begin_write_item(item_t item);
      `SMTDV_RAND_VAR_WITH(opt, {opt dist {0:=50, 1:=50};})
      this.cmp.vif.slave.pready <= 1'b1;
      this.cmp.vif.slave.pslverr <= (this.cmp.cfg.has_error && opt ==1)? ERR: OK;
    endtask : populate_begin_write_item

    virtual task populate_end_write_item(item_t item);
      this.cmp.vif.slave.pready <= 1'b0;
    endtask : populate_end_write_item

    virtual task populate_begin_read_item(item_t item);
      `SMTDV_RAND_VAR_WITH(opt, {opt dist {0:=50, 1:=50};})
      this.cmp.vif.slave.pready <= 1'b1;
      this.cmp.vif.slave.prdata <= item.unpack_data(0);
      this.cmp.vif.slave.pslverr <= (this.cmp.cfg.has_error && opt == 1)? ERR: OK;
    endtask : populate_begin_read_item

    virtual task populate_end_read_item(item_t item);
      this.cmp.vif.slave.pready <= 1'b0;
    endtask : populate_end_read_item

endclass : apb_slave_drive_items

`endif // __APB_SLAVE_DRIVER_THREADS_SV__
