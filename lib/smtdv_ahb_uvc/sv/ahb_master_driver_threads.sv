`ifndef __AHB_MASTER_DRIVER_THREADS_SV__
`define __AHB_MASTER_DRIVER_THREADS_SV__

typedef class ahb_sequence_item;
typedef class ahb_master_driver;


class ahb_master_base_thread #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_run_thread#(
      ahb_master_driver#(ADDR_WIDTH, DATA_WIDTH)
  );

  typedef ahb_master_base_thread#(ADDR_WIDTH, DATA_WIDTH) th_t;
  typedef ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef ahb_master_driver#(ADDR_WIDTH, DATA_WIDTH) cmp_t;

  item_t item;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_base_thread", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void pre_do();
    if (!this.cmp) begin
      `uvm_fatal("NOCMP",
          {"cmp must be set for: ",get_full_name(),".cmp"});
    end
  endfunction : pre_do

endclass : ahb_master_base_thread


class ahb_master_drive_addr #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  ahb_master_base_thread#(
    ADDR_WIDTH,
    DATA_WIDTH
  );

  typedef ahb_master_drive_addr#(ADDR_WIDTH, DATA_WIDTH) th_t;
  typedef ahb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  item_t item;
  rand int opt;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_drive_addr", uvm_component parent=null);
    super.new(name);
  endfunction : new

  virtual task listen_RETRY(item_t item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == RETRY && !this.cmp.vif.hready));
    populate_retry_item(item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == RETRY && this.cmp.vif.hready));
    populate_complete_item(item);
  endtask : listen_RETRY

  virtual task listen_SPLIT(item_t item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == SPLIT && !this.cmp.vif.hready));
    populate_split_item(item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == SPLIT && this.cmp.vif.hready));
    populate_complete_item(item);
  endtask : listen_SPLIT

  virtual task listen_OKAY(item_t item);
    // nonseq rsp
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == OKAY && this.cmp.vif.hready));
    item.addr_idx++;

    // seq/bus rsp i f bst_len > 0
    while (1) begin
      if (item.addr_idx > item.bst_len) break;
      // BUSY/SEQ
      `SMTDV_RAND_VAR_WITH(opt, {opt dist {0:=40, 1:=60};})
      if (this.cmp.cfg.has_busy && opt==0) begin
        populate_busy_item(item);
        @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == OKAY && this.cmp.vif.hready));
      end else begin
        populate_seq_item(item);
        @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == OKAY && this.cmp.vif.hready));
        item.addr_idx++;
      end
    end
    populate_complete_item(item);
  endtask : listen_OKAY

  virtual task listen_ERROR(item_t item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == ERROR && !this.cmp.vif.hready));
    populate_error_item(item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == ERROR && this.cmp.vif.hready));
    populate_complete_item(item);
  endtask : listen_ERROR

  virtual task run();
    forever begin
      // after reset
      populate_default_item(item);
      this.cmp.addrbox.async_pop_front(0, item);

      while(!item.addr_complete) begin
        populate_nonseq_item(item);
        // join listen one of resp is back
        fork
          listen_OKAY(item);
          listen_ERROR(item);
          listen_RETRY(item);
          listen_SPLIT(item);
        join_any
        disable fork;
      end

      `uvm_info(this.cmp.get_full_name(),
          {$psprintf("try do addr item \n%s", item.sprint())}, UVM_LOW)

      if (this.cmp.cfg.has_debug)
        update_timestamp();

    end
  endtask : run

  virtual task populate_default_item(item_t item);
    this.cmp.vif.master.htrans <= IDLE;
  endtask : populate_default_item

  virtual task populate_nonseq_item(item_t item);
    this.cmp.vif.master.haddr <= item.addrs[item.addr_idx];
    this.cmp.vif.master.htrans <= NONSEQ;
    this.cmp.vif.master.hwrite <= item.trs_t;
    this.cmp.vif.master.hsize <= item.trx_size;
    this.cmp.vif.master.hburst <= item.bst_type;
    this.cmp.vif.master.hprot <= item.trx_prt;
    this.cmp.vif.master.hmastlock <= item.hmastlock;
  endtask : populate_nonseq_item

  virtual task populate_seq_item(item_t item);
    this.cmp.vif.master.haddr <= item.addrs[item.addr_idx];
    this.cmp.vif.master.htrans <= SEQ;
  endtask : populate_seq_item

  virtual task populate_busy_item(item_t item);
    this.cmp.vif.master.haddr <= item.addrs[item.addr_idx];
    this.cmp.vif.master.htrans <= BUSY;
    item.busy_cnt--;
  endtask : populate_busy_item

  virtual task populate_complete_item(item_t item);
    item.addr_complete = TRUE;
  endtask : populate_complete_item

  virtual task populate_error_item(item_t item);
    item.error = TRUE;
    this.cmp.vif.master.htrans <= IDLE;
  endtask : populate_error_item

  virtual task populate_retry_item(item_t item);
    item.retry = TRUE;
    this.cmp.vif.master.htrans <= IDLE;
    this.cmp.redrive_bus(item);
  endtask : populate_retry_item

  virtual task populate_split_item(item_t item);
    item.split = TRUE;
    this.cmp.vif.master.htrans <= IDLE;
    this.cmp.redrive_bus(item);
  endtask : populate_split_item

endclass : ahb_master_drive_addr


class ahb_master_drive_data #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  ahb_master_base_thread#(
    ADDR_WIDTH,
    DATA_WIDTH
  );

  typedef ahb_master_drive_data #(ADDR_WIDTH, DATA_WIDTH) th_t;
  typedef ahb_sequence_item #(ADDR_WIDTH, DATA_WIDTH) item_t;

  item_t item;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "ahb_master_drive_data", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual task listen_OKAY(item_t item);
    while (1) begin
      if (item.data_idx > item.bst_len) break;
      // data phase should be after addr phase for one cycle
      @(posedge this.cmp.vif.clk iff(this.cmp.vif.hready && this.cmp.vif.hresp == OKAY));
      if (item.addr_idx > item.data_idx) begin
        populate_data_item(item);
      end
    end
    populate_complete_item(item);
  endtask : listen_OKAY

  virtual task listen_RETRY(item_t item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == RETRY && !this.cmp.vif.hready));
    populate_retry_item(item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == RETRY && this.cmp.vif.hready));
    populate_complete_item(item);
  endtask : listen_RETRY

  virtual task listen_SPLIT(item_t item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == SPLIT && !this.cmp.vif.hready));
    populate_split_item(item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == SPLIT && this.cmp.vif.hready));
    populate_complete_item(item);
  endtask : listen_SPLIT

  virtual task listen_ERROR(item_t item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == ERROR && !this.cmp.vif.hready));
    populate_error_item(item);
    @(posedge this.cmp.vif.clk iff (this.cmp.vif.hgrant && this.cmp.vif.hresp == ERROR && this.cmp.vif.hready));
    populate_complete_item(item);
  endtask : listen_ERROR

  virtual task run();
    forever begin
      this.cmp.databox.async_pop_front(0, item);

      `SMTDV_SWAP(0) // data phase should be after addr phase

      while(!item.data_complete) begin
        // get retry/split from addr phase and abort it
        if (item.retry || item.split || item.error) break;

        // join listen resp back
        fork
          listen_OKAY(item);
          listen_ERROR(item);
          listen_RETRY(item);
          listen_SPLIT(item);
        join_any
        disable fork;
      end
      `uvm_info(this.cmp.get_full_name(),
          {$psprintf("try do data item \n%s", item.sprint())}, UVM_LOW)

      if (this.cmp.cfg.has_debug)
        update_timestamp();

    end
  endtask : run

  virtual task populate_data_item(item_t item);
    if (item.trs_t == WR) begin
      this.cmp.vif.master.hwdata <= item.unpack_data(item.data_idx);
    end
    item.data_idx++;
  endtask : populate_data_item

  virtual task populate_complete_item(item_t item);
    item.data_complete = TRUE;
  endtask : populate_complete_item

  virtual task populate_error_item(item_t item);
  endtask : populate_error_item

  virtual task populate_retry_item(item_t item);
    this.cmp.redrive_bus(item);
  endtask : populate_retry_item

  virtual task populate_split_item(item_t item);
    this.cmp.redrive_bus(item);
  endtask : populate_split_item

endclass : ahb_master_drive_data

`endif // end if __AHB_DRIVER_THREADS_SV__
