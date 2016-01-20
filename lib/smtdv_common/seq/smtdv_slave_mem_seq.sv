
`ifndef __SMTDV_SLAVE_MEM_SEQ_SV__
`define __SMTDV_SLAVE_MEM_SEQ_SV__

//typedef class smtdv_sequence_item;
//typedef class smtdv_slave_cfg;
//typedef class smtdv_sequencer;
//typedef class smtdv_slave_base_seq;
//typedef class smtdv_generic_memory;

/**
* smtdv_slave_mem_seq
* a base slave mem access seq
*
* @class smtdv_slave_mem_seq#(ADDR_WIDTH, DATA_WIDTH, MEM_WIDTH, T1, VIF, CFG,
* SEQR)
*
*/
class smtdv_slave_mem_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  MEM_WIDTH = 128,
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

  typedef smtdv_slave_mem_seq#(ADDR_WIDTH, DATA_WIDTH, MEM_WIDTH, T1, VIF, CFG, SEQR) mem_seq_t;
  typedef smtdv_generic_memory#(ADDR_WIDTH, MEM_WIDTH) mem_t;

  mem_t gene_mem;

  `uvm_object_param_utils_begin(mem_seq_t)
  `uvm_object_utils_end

   function new(string name = "smtdv_slave_mem_seq");
     super.new(name);
     gene_mem = new();
   endfunction : new

   extern virtual task pre_do(bit is_item);

endclass : smtdv_slave_mem_seq


// create mem table map as ini
task smtdv_slave_mem_seq::pre_do(bit is_item);
  string table_nm = $psprintf("\"%s\"", seqr.get_full_name());
  super.pre_do(is_item);
  if (gene_mem.mem_cb.table_nm == "") begin
    gene_mem.mem_cb.table_nm = table_nm;
    void'(gene_mem.mem_cb.create_table());
  end
endtask : pre_do

`endif // end of __SMTDV_SLAVE_MEM_SEQ_SV__
