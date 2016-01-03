
`ifndef __APB_SLAVE_BASE_SEQ_SV__
`define __APB_SLAVE_BASE_SEQ_SV__

//typedef class apb_item;
//typedef class apb_slave_cfg;
//typedef class apb_slave_sequencer;

class apb_slave_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_slave_mem_seq#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .T1(apb_item#(ADDR_WIDTH, DATA_WIDTH)),
      .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(apb_slave_cfg),
      .SEQR(apb_slave_sequencer#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef apb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef apb_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

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
    gene_mem.mem_load_byte(item.addr, DATA_WIDTH>>3, data, item.bg_cyc);
    foreach(data[i]) begin
      item.data_beat[0][i] = data[i];
    end
    item.mem_complete = TRUE;
  endtask : mid_do_read_item

  virtual task mid_do_write_item(item_t item);
    byte data[];
    super.mid_do_write_item(item);
    data= new[DATA_WIDTH>>3];
    if (item.success) begin
      foreach(item.data_beat[0][i]) begin
        data[i] = item.data_beat[0][i];
      end
      gene_mem.mem_store_byte(item.addr, data, item.bg_cyc);
      item.mem_complete = TRUE;
    end
  endtask : mid_do_write_item

endclass : apb_slave_base_seq

`endif // __APB_SLAVE_BASE_SEQ_SV__
