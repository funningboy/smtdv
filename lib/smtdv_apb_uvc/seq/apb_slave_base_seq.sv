
`ifndef __APB_SLAVE_BASE_SEQ_SV__
`define __APB_SLAVE_BASE_SEQ_SV__

//typedef class apb_sequence_item;
//typedef class apb_slave_cfg;
//typedef class apb_slave_sequencer;
//typedef class smtdv_slave_base_seq

/*
* normal mem no bank, set, channel...
*/
class apb_slave_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_slave_mem_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .MEM_WIDTH(128),
      .T1(apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH)),
      .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(apb_slave_cfg),
      .SEQR(apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef apb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  item_t item;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "apb_slave_base_seq");
    super.new(name);
  endfunction : new

  virtual task mid_do_read_item(item_t item);
    byte data[];
    super.mid_do_read_item(item);
    data= new[DATA_WIDTH>>3];

    wait(!gene_mem.is_lock());
    gene_mem.lock();
    gene_mem.mem_load_byte(item.addrs[0], DATA_WIDTH>>3, data, item.bg_cyc);
    foreach(data[i]) begin
      item.data_beat[0][i] = data[i];
    end
    item.mem_complete = TRUE;
    gene_mem.unlock();
  endtask : mid_do_read_item

  virtual task mid_do_write_item(item_t item);
    byte data[];
    super.mid_do_write_item(item);
    data= new[DATA_WIDTH>>3];

    wait(!gene_mem.is_lock());
    gene_mem.lock();
    if (item.success) begin
      foreach(item.data_beat[0][i]) begin
        data[i] = item.data_beat[0][i];
      end
      gene_mem.mem_store_byte(item.addrs[0], data, item.bg_cyc);
      item.mem_complete = TRUE;
    end
    gene_mem.unlock();
  endtask : mid_do_write_item

endclass : apb_slave_base_seq

`endif // __APB_SLAVE_BASE_SEQ_SV__
