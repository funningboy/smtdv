`ifndef __AHB_SLAVE_BASE_SEQ_SV__
`define __AHB_SLAVE_BASE_SEQ_SV__

//typedef class ahb_item;
//typedef class ahb_slave_cfg;
//typedef class ahb_slave_sequencer;

class ahb_slave_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_slave_mem_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .T1(ahb_item#(ADDR_WIDTH, DATA_WIDTH)),
      .VIF(virtual interface ahb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(ahb_slave_cfg),
      .SEQR(ahb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef ahb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef ahb_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "ahb_slave_base_seq");
    super.new(name);
  endfunction : new

  /*
  * create a new rd trx by accessing the normal unlock mem
  */
  virtual task mid_do_read_item(item_t item);
    byte data[];
    bit [ADDR_WIDTH-1:0] addrs[$];
    data= new[DATA_WIDTH>>3];
    super.mid_do_read_item(item);

    wait(!gene_mem.is_lock());
    gene_mem.lock();
    item.post_addr(item.addr, item.trx_size, item.bst_len, item.bst_type, addrs);
    foreach(addrs[i]) begin
      gene_mem.mem_load_byte(addrs[i], DATA_WIDTH>>3, data, item.bg_cyc);
      foreach(data[j]) begin
        item.data_beat[i][j] = data[j];
      end
    end
    item.mem_complete = TRUE;
    gene_mem.unlock();
    `uvm_info(get_type_name(), {$psprintf("GET AHB READ ITEM\n%s", item.sprint())}, UVM_LOW)

  endtask : mid_do_read_item

  /*
  * store to normal mem while trx is completed and mem is free to access
  */
  virtual task mid_do_write_item(item_t item);
    byte data[];
    data= new[DATA_WIDTH>>3];
    super.mid_do_write_item(item);

    if (item.success) begin
      wait(!gene_mem.is_lock());
      gene_mem.lock();
      foreach(item.addrs[i]) begin
        foreach(item.data_beat[i][j]) begin
          data[j] = item.data_beat[i][j];
        end
        gene_mem.mem_store_byte(item.addrs[i], data, item.bg_cyc);
      end
      item.mem_complete = TRUE;
      gene_mem.unlock();
    end
  endtask : mid_do_write_item

endclass : ahb_slave_base_seq

`endif // __AHB_SLAVE_BASE_SEQ_SV__
