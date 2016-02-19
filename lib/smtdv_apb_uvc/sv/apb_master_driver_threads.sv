`ifndef __APB_MASTER_DRIVER_THREADS_SV__
`define __APB_MASTER_DRIVER_THREADS_SV__

typedef class apb_item;
typedef class apb_master_driver;

class apb_master_base_thread#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_run_thread#(
      apb_master_driver#(ADDR_WIDTH, DATA_WIDTH)
  );

  typedef apb_master_base_thread#(ADDR_WIDTH, DATA_WIDTH) th_t;
  typedef apb_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef apb_master_driver#(ADDR_WIDTH, DATA_WIDTH) cmp_t;

  item_t item;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_base_thread", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void pre_do();
    if (!this.cmp) begin
      `uvm_fatal("APB_NO_CMP",{"CMP MUST BE SET ",get_full_name(),".cmp"});
    end
  endfunction : pre_do

endclass : apb_master_base_thread


class apb_master_drive_items#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    apb_master_base_thread#(
      ADDR_WIDTH,
      DATA_WIDTH
  );

  typedef apb_master_drive_items#(ADDR_WIDTH, DATA_WIDTH) th_t;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "apb_master_drive_items", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual task run();
  extern virtual task do_write_item(item_t item);
  extern virtual task do_read_item(item_t item);
  extern virtual task populate_setup_write_item(item_t item);
  extern virtual task populate_access_write_item(item_t item);
  extern virtual task populate_end_write_item(item_t item);
  extern virtual task populate_setup_read_item(item_t item);
  extern virtual task populate_access_read_item(item_t item);
  extern virtual task populate_end_read_item(item_t item);

endclass : apb_master_drive_items

// blocking for R/W trx
task apb_master_drive_items::run();
  item = null;
  forever begin
    if(item==null)
      this.cmp.mbox.async_pop_front(0, item);

    case(item.trs_t)
      RD: begin do_read_item(item); end
      WR: begin do_write_item(item); end
      default:
        `uvm_fatal("APB_UNXPCTDPKT",
        $sformatf("GET AN UNEXPECTED ITEM \n%s", item.sprint()))
    endcase

    if (!$cast(item, item.next))
     `uvm_error("SMTDV_UCAST_SEQ_ITEM",
         {$psprintf("UP CAST TO SMTDV SEQ_ITEM FAIL")})

  end
endtask : run


task apb_master_drive_items::do_write_item(item_t item);
  wait(this.cmp.vif.cyc >= item.bg_cyc);
  // SetUp
  if (this.cmp.cfg.block_psel) repeat(item.psel_L2H) @(posedge this.cmp.vif.clk);
  populate_setup_write_item(item);
  @(posedge this.cmp.vif.clk);
  // Access
  if (this.cmp.cfg.block_penable) repeat(item.penable_L2H) @(posedge this.cmp.vif.clk);
  populate_access_write_item(item);
  // wait until pready assert
  @(posedge this.cmp.vif.clk iff (this.cmp.vif.pready));
  populate_end_write_item(item);
  `uvm_info(this.cmp.get_full_name(), {$psprintf("TRY DO WRITE ITEM \n%s", item.sprint())}, UVM_LOW)
endtask : do_write_item


task apb_master_drive_items::do_read_item(item_t item);
  wait(this.cmp.vif.cyc >= item.bg_cyc);
  // SetUp
  if (this.cmp.cfg.block_psel) repeat(item.psel_L2H) @(posedge this.cmp.vif.clk);
  populate_setup_read_item(item);
  @(posedge this.cmp.vif.clk);
  // Access
  if (this.cmp.cfg.block_penable) repeat(item.penable_L2H) @(posedge this.cmp.vif.clk);
  populate_access_read_item(item);
  // wait until pready assert
  @(posedge this.cmp.vif.clk iff (this.cmp.vif.pready));
  populate_end_read_item(item);
  `uvm_info(this.cmp.get_full_name(), {$psprintf("TRY DO READ ITEM \n%s", item.sprint())}, UVM_LOW)
endtask : do_read_item


task apb_master_drive_items::populate_setup_write_item(item_t item);
  this.cmp.vif.master.paddr <= item.addr;
  this.cmp.vif.master.prwd <= WR;
  this.cmp.vif.master.psel <= 1<<this.cmp.cfg.find_slave(item.addr);
  this.cmp.vif.master.pwdata <= item.unpack_data(0);
endtask : populate_setup_write_item


task apb_master_drive_items::populate_access_write_item(item_t item);
  this.cmp.vif.master.penable <= 1'b1;
endtask : populate_access_write_item


task apb_master_drive_items::populate_end_write_item(item_t item);
  this.cmp.vif.master.psel <= 1'b0;
  this.cmp.vif.master.penable <= 1'b0;
endtask : populate_end_write_item


task apb_master_drive_items::populate_setup_read_item(item_t item);
  this.cmp.vif.master.paddr <= item.addr;
  this.cmp.vif.master.prwd <= RD;
  this.cmp.vif.master.psel <= 1<<this.cmp.cfg.find_slave(item.addr);
endtask : populate_setup_read_item


task apb_master_drive_items::populate_access_read_item(item_t item);
  this.cmp.vif.master.penable <= 1'b1;
endtask : populate_access_read_item


task apb_master_drive_items::populate_end_read_item(item_t item);
  this.cmp.vif.master.psel <= 1'b0;
  this.cmp.vif.master.penable <= 1'b0;
endtask : populate_end_read_item


`endif // end if __APB_DRIVER_THREADS_SV__
