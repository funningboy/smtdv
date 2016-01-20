
`ifndef __SMTDV_SLAVE_FIFO_SV__
`define __SMTDV_SLAVE_FIFO_SV__

//typedef class smtdv_sequence_item;
//typedef class smtdv_master_cfg;
//typedef class smtdv_sequencer;
//typedef class smtdv_slave_base_seq;
//typedef class smtdv_generic_fifo;

/**
* smtdv_slave_fifo_seq
* a base slave fifo access seq
*
* @class smtdv_slave_fifo_seq#(ADDR_WIDTH, DATA_WIDTH, FIFO_DEEP, T1, CFG, VIF, CFG, SEQR)
*
*/
class smtdv_slave_fifo_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  FIFO_DEEP = 100,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_slave_cfg,
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, virtual interface smtdv_if, smtdv_slave_cfg, smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH))
  ) extends
  smtdv_slave_base_seq#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .T1(T1),
    .VIF(VIF),
    .CFG(CFG),
    .SEQR(SEQR)
  );

  typedef smtdv_slave_fifo_seq#(ADDR_WIDTH, DATA_WIDTH, FIFO_DEEP, T1, VIF, CFG, SEQR) fifo_seq_t;
  typedef smtdv_generic_fifo#(FIFO_DEEP, DATA_WIDTH)  fifo_t;

  fifo_t gene_fifo;

  `uvm_object_param_utils_begin(fifo_seq_t)
  `uvm_object_utils_end

   function new(string name = "smtdv_slave_fifo_seq");
     super.new(name);
     gene_fifo = new();
   endfunction : new

   extern virtual task pre_do(bit is_item);

endclass : smtdv_slave_fifo_seq

// create fifo table map as ini
task smtdv_slave_fifo_seq::pre_do(bit is_item);
  string table_nm = $psprintf("\"%s\"", m_sequencer.get_full_name());
  super.pre_do(is_item);
  if (gene_fifo.fifo_cb.table_nm == "") begin
    gene_fifo.fifo_cb.table_nm = table_nm;
    void'(gene_fifo.fifo_cb.create_table());
  end
endtask : pre_do

`endif // end of __SMTDV_SLAVE_FIFO_SV__

