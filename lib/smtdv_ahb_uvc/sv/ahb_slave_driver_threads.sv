`ifndef __AHB_SLAVE_DRIVER_THREADS_SV__
`define __AHB_SLAVE_DRIVER_THREADS_SV__

typedef class ahb_sequence_item;
typedef class ahb_slave_driver;

class ahb_slave_base_thread #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  smtdv_run_thread#(
    ahb_slave_driver#(ADDR_WIDTH, DATA_WIDTH)
  );

  typedef ahb_slave_base_thread#(ADDR_WIDTH, DATA_WIDTH) th_t;
  typedef ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef ahb_slave_driver#(ADDR_WIDTH, DATA_WIDTH) cmp_t;

  item_t item;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "ahb_slave_base_thread", uvm_component parent=null);//, callback, cb);
    super.new(name, parent);
  endfunction : new

  virtual function void pre_do();
    if (!this.cmp) begin
      `uvm_fatal("NOCMP",{"cmp must be set for: ",get_full_name(),".cmp"});
    end
endfunction : pre_do

endclass : ahb_slave_base_thread


class ahb_slave_drive_addr #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  ahb_slave_base_thread #(
    ADDR_WIDTH,
    DATA_WIDTH
  );

  typedef ahb_slave_drive_addr#(ADDR_WIDTH, DATA_WIDTH) th_t;
  typedef ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  item_t item;
  rand int opt;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "ahb_slave_drive_addr", uvm_component parent=null);//, callback, cb);
    super.new(name);
  endfunction : new

  virtual task drive_RETRY(item_t item);
    populate_retry_item(item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && !this.cmp.vif.hready));
    populate_retry_item(item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && this.cmp.vif.hready));
    populate_complete_item(item);
  endtask : drive_RETRY

  virtual task drive_SPLIT(item_t item);
    populate_split_item(item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && !this.cmp.vif.hready));
    populate_split_item(item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && this.cmp.vif.hready));
    populate_complete_item(item);
  endtask : drive_SPLIT

  virtual task drive_ERROR(item_t item);
    populate_error_item(item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && !this.cmp.vif.hready));
    populate_error_item(item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && this.cmp.vif.hready));
    populate_complete_item(item);
  endtask : drive_ERROR

  virtual task drive_OKAY(item_t item);
    while (item.addr_idx <= item.bst_len) begin
      populate_okay_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && this.cmp.vif.hready));
    end
    populate_complete_item(item);
  endtask : drive_OKAY

  virtual task drive(item_t item);
    `SMTDV_RAND_VAR_WITH(opt, {opt dist {[0:2]:=50, 3:=50};})
    if (this.cmp.cfg.has_split && opt==0) begin drive_SPLIT(item); end
    else if (this.cmp.cfg.has_error && opt==1) begin drive_ERROR(item); end
    else if (this.cmp.cfg.has_retry && opt==2) begin drive_RETRY(item); end
    else begin drive_OKAY(item); end
  endtask : drive

  virtual task run();
    forever begin
      // after reset
      populate_default_item(item);
      this.cmp.addrbox.async_pop_front(0, item);

      while(!item.addr_complete) begin
        fork
          drive(item);
        join_any
        disable fork;
      end

      `uvm_info(this.cmp.get_full_name(),
          {$psprintf("try do addr item \n%s", item.sprint())}, UVM_LOW)

      if (this.cmp.cfg.has_debug)
        update_timestamp();

    end
  endtask : run

  virtual task populate_complete_item(item_t item);
    item.addr_complete = TRUE;
  endtask : populate_complete_item

  virtual task populate_default_item(item_t item);
    this.cmp.vif.slave.hreadyout <= 1'b1;
    this.cmp.vif.slave.hresp <= OKAY;
  endtask : populate_default_item

  virtual task populate_okay_item(item_t item);
    if (this.cmp.cfg.block_hready) begin
      this.cmp.vif.slave.hreadyout <= 1'b0;
      this.cmp.vif.slave.hresp <= OKAY;
      repeat(item.hready_L2H) @(posedge this.cmp.vif.clk);
    end
    this.cmp.vif.slave.hreadyout <= 1'b1;
    this.cmp.vif.slave.hresp <= OKAY;
    item.addr_idx++;

  endtask : populate_okay_item

  virtual task populate_error_item(item_t item);
    if (!item.error) begin
      this.cmp.vif.slave.hreadyout <= 1'b0;
      this.cmp.vif.slave.hresp <= ERROR;
      item.error = TRUE;
    end
    else begin
      this.cmp.vif.slave.hreadyout <= 1'b1;
      this.cmp.vif.slave.hresp <= ERROR;
    end
  endtask : populate_error_item

  virtual task populate_retry_item(item_t item);
    if (!item.retry) begin
      this.cmp.vif.slave.hreadyout <= 1'b0;
      this.cmp.vif.slave.hresp <= RETRY;
      item.retry = TRUE;
    end
    else begin
      this.cmp.vif.slave.hreadyout <= 1'b1;
      this.cmp.vif.slave.hresp <= RETRY;
    end
  endtask : populate_retry_item

  virtual task populate_split_item(item_t item);
    if (!item.split) begin
      this.cmp.vif.slave.hreadyout <= 1'b0;
      this.cmp.vif.slave.hresp <= SPLIT;
      item.split = TRUE;
    end
    else begin
      this.cmp.vif.slave.hreadyout <= 1'b1;
      this.cmp.vif.slave.hresp <= SPLIT;
    end
  endtask : populate_split_item

endclass : ahb_slave_drive_addr


class ahb_slave_drive_data #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    ahb_slave_base_thread #(
      ADDR_WIDTH,
      DATA_WIDTH
  );

  typedef ahb_slave_drive_data#(ADDR_WIDTH, DATA_WIDTH) th_t;
  typedef ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  rand int opt;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "ahb_slave_drive_data", uvm_component parent=null);//, callback);
    super.new(name, parent);
  endfunction

  virtual task drive_OKAY(item_t item);
    while (1) begin
      if (item.data_idx > item.bst_len) break;
      if (item.split || item.retry || item.error) break;
      if (item.addr_idx > item.data_idx) populate_data_item(item);
      @(posedge this.cmp.vif.clk iff (this.cmp.vif.hsel && this.cmp.vif.hready && this.cmp.vif.htrans inside {NONSEQ, SEQ, IDLE}));
    end
    populate_complete_item(item);
  endtask : drive_OKAY

  virtual task run();
    item = null;
    forever begin
      if (item==null)
        this.cmp.databox.async_pop_front(0, item);

      `SMTDV_SWAP(0) // data phase should be after addr phase

      while(!item.data_complete) begin
        if (item.retry || item.split || item.error) break;

        // join
        fork
          drive_OKAY(item);
        join_any
        disable fork;
      end
      `uvm_info(this.cmp.get_full_name(), {$psprintf("try do data item \n%s", item.sprint())}, UVM_LOW)

      $cast(item, item.next);
    end
  endtask : run

  virtual task populate_data_item(item_t item);
    if (item.trs_t == RD) begin
      this.cmp.vif.slave.hrdata <= item.unpack_data(item.data_idx);
    end
    item.data_idx++;
  endtask : populate_data_item

  virtual task populate_complete_item(item_t item);
    item.data_complete = TRUE;
  endtask : populate_complete_item

endclass : ahb_slave_drive_data

`endif // __AHB_SLAVE_DRIVER_THREADS_SV__
