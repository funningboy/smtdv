`ifndef __AHB_MASTER_DRIVER_THREADS_SV__
`define __AHB_MASTER_DRIVER_THREADS_SV__

typedef class ahb_master_driver;

class ahb_master_drive_addr #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_run_thread;

    `AHB_ITEM item, req;
    `AHB_MASTER_DRIVER cmp;

    `uvm_object_param_utils_begin(`AHB_MASTER_DRIVE_ADDR)
    `uvm_object_utils_end

    function new(string name = "ahb_master_drive_addr");
      super.new(name);
    endfunction

    virtual task run();
      forever begin
         this.cmp.addrbox.get(item);
          // start to request bus if item is nonstart
          if (item.pre == null) begin
            if (this.cmp.cfg.block_hbusreq) repeat(item.hbusreq_L2H) @(posedge this.cmp.vif.clk);
            populate_reqbus_item(item);
            @(posedge this.cmp.vif.clk iff(this.cmp.vif.hgrant && this.cmp.vif.hready && this.cmp.vif.hresp == OKAY));
          end

          // start to noseq
          if (this.cmp.cfg.block_hnonseq) repeat(item.hnonseq_L2H) @(posedge this.cmp.vif.clk);
          populate_nonseq_item(item);
          while(!item.complete) begin
            @(posedge this.cmp.vif.clk);
            // OKAY
            if (this.cmp.vif.hgrant && this.cmp.vif.hready && this.cmp.vif.hresp == OKAY) begin
                if (item.addr_idx > item.bst_len) begin
                  // complete at lock
                  if (item.next == null) begin
                    if (item.hmastlock) begin
                      populate_idle_item(item);
                      @(posedge this.cmp.vif.clk);
                    end
                  end
                  populate_complete_item(item);
                end
                // BUSY && SEQ
                else begin
                  if (item.busy_cnt > 0) begin populate_busy_item(item); end
                  else                   begin populate_seq_item(item); end
                end
            end
            // RETRY
            else if(this.cmp.vif.hgrant && this.cmp.vif.hresp == RETRY) begin
              if (!this.cmp.vif.hready && !item.retry) begin  populate_retry_item(item); end
              else if (this.cmp.vif.hready && this.cmp.vif.htrans == IDLE && item.retry) begin  populate_nonseq_item(item); end
              else begin `uvm_error(this.cmp.get_full_name(), "RETRY protocol fail") end
            end
            // SPLIT
            else if (this.cmp.vif.hgrant && this.cmp.vif.hresp == SPLIT) begin
              if (!this.cmp.vif.hready && !item.retry)begin  populate_split_item(item); end
              else if (this.cmp.vif.hready && this.cmp.vif.htrans == IDLE && item.split) begin populate_split_item(item); end
              else begin `uvm_error(this.cmp.get_full_name(), "SPLIT protocol fail") end
            end
            // ERROR
            else if (this.cmp.vif.hgrant && this.cmp.vif.hresp == ERROR) begin
              if (!this.cmp.vif.hready && !item.retry)begin  populate_split_item(item); end
              else if (this.cmp.vif.hready && this.cmp.vif.htrans == IDLE && item.split) begin populate_error_item(item); end
              else begin `uvm_error(this.cmp.get_full_name(), "SPLIT protocol fail") end
            end
        end
        `uvm_info(this.cmp.get_full_name(), {$psprintf("try do addr item \n%s", item.sprint())}, UVM_LOW)
      end
    endtask

    virtual task populate_reqbus_item(ref `AHB_ITEM item);
      this.cmp.vif.master.hbusreq <= 1'b1;
    endtask

    virtual task populate_nonseq_item(ref `AHB_ITEM item);
      this.cmp.vif.master.haddr <= item.addrs[item.addr_idx++];
      this.cmp.vif.master.htrans <= NONSEQ;
      this.cmp.vif.master.hwrite <= item.trs_t;
      this.cmp.vif.master.hsize <= item.trx_size;
      this.cmp.vif.master.hburst <= item.bst_type;
      this.cmp.vif.master.hprot <= item.trx_prt;
      this.cmp.vif.master.hmastlock <= item.hmastlock;
      //if
      //`SMTDV
    endtask

    virtual task populate_seq_item(ref `AHB_ITEM item);
      this.cmp.vif.master.haddr <= item.addrs[item.addr_idx++];
      this.cmp.vif.master.htrans <= SEQ;
      //if
      //`SMTDV_
    endtask

    virtual task populate_busy_item(ref `AHB_ITEM item);
      this.cmp.vif.master.haddr <= item.addrs[item.addr_idx];
      this.cmp.vif.master.htrans <= BUSY;
      item.busy_cnt--;
    endtask

    virtual task populate_complete_item(ref `AHB_ITEM item);
      item.complete = 1;
      this.cmp.vif.master.htrans <= IDLE;
    endtask

    virtual task populate_error_item(ref `AHB_ITEM item);
      if (!item.error) begin
        item.error = 1;
        this.cmp.vif.master.htrans <= IDLE;
      end
      else begin
        // override your func when error happened
        item.complete = 1;
      end
    endtask

    virtual task populate_retry_item(ref `AHB_ITEM item);
      if (!item.retry) begin
        item.retry = 1;
        this.cmp.vif.master.htrans <= IDLE;
      end
      else begin
        item.addr_idx = 0;
        item.data_idx = 0;
      end
    endtask

    virtual task populate_split_item(ref `AHB_ITEM item);
      if (!item.split) begin
        item.split = 1;
        this.cmp.vif.master.htrans <= IDLE;
      end
      else begin
        item.addr_idx = 0;
        item.data_idx = 0;
        $cast(req, item.clone());
        this.cmp.addrbox.put(req);
        item.complete = 1;
      end
    endtask

    virtual task populate_idle_item(ref `AHB_ITEM item);
      this.cmp.vif.master.htrans <= IDLE;
    endtask

endclass


class ahb_master_drive_data #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_run_thread;

    `AHB_ITEM item;
    `AHB_MASTER_DRIVER cmp;

    `uvm_object_param_utils_begin(`AHB_MASTER_DRIVE_DATA)
    `uvm_object_utils_end

    function new(string name = "ahb_master_drive_data");
      super.new(name);
    endfunction

    virtual task run();
      forever begin
        this.cmp.databox.get(item);
        while(!item.complete) begin
          if(item.addr_idx > item.data_idx) begin
            populate_data_item(item);
          end
          @(posedge this.cmp.vif.clk);
        end
        `uvm_info(this.cmp.get_full_name(), {$psprintf("try do data item \n%s", item.sprint())}, UVM_LOW)
      end
    endtask

    virtual task populate_data_item(ref `AHB_ITEM item);
      this.cmp.vif.master.hwdata <= item.unpack_data(item.data_idx++);
    endtask

endclass

`endif // end if __AHB_DRIVER_THREADS_SV__
