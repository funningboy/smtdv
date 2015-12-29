`ifndef __SMTDV_MASTER_POLLING_SEQ_SV__
`define __SMTDV_MASTER_POLLING_SEQ_SV__

//typedef class smtdv_sequence_item;
//typedef class smtdv_master_base_seq;
//typedef class smtdv_master_cfg;
//typedef class smtdv_sequencer;

/**
* smtdv_master_retry_seq
* a basic master polling seq while some expected data assert
*
* @class smtdv_master_retry_seq #(ADDR_WIDTH, DATA_WIDTH, T1, CFG)
*
*/
class smtdv_master_polling_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_master_cfg,
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1)
  ) extends
 smtdv_master_base_seq #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .T1(T1),
    .VIF(VIF),
    .CFG(CFG),
    .SEQR(SEQR)
  );

  typedef smtdv_master_polling_seq#(ADDR_WIDTH, DATA_WIDTH, T1, VIF, CFG, SEQR) seq_t;
  bit done = 0;

  typedef struct {
    bit [ADDR_WIDTH-1:0] addr;
    bit [DATA_WIDTH-1:0] data;
    int visit;
  } polling;
  typedef bit [ADDR_WIDTH-1:0] tt;
  polling maps[tt];

  rand int max_polling;
  constraint c_max_polling { 10 <= max_polling && max_polling <= 100; }

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

   function new(string name = "smtdv_master_polling_seq");
     super.new(name);
   endfunction : new

   //extern virtual task mid_do_read_item(T1 item);

endclass : smtdv_master_polling_seq

/*
*
*/
//task smtdv_master_polling_seq::mid_do_read_item(T1 item);
//  super.do_read_item(item);
//  if(item.success) begin
//    foreach(item.addrs[i]) begin
//      if(maps.exists(item.addrs[i])) begin
//        if (maps[item.addrs[i]].data == item.unpack_data(i)) begin
//          item.retry = FALSE;
//          done = TRUE;
//        end
//        else begin
//          item.retry = (maps[item.addrs[i]].visit >= max_polling)? FALSE: TRUE;
//          if (item.retry == FALSE)
//            `uvm_error("SMTDV_MST_POLLTIMOUT_ERR", {$psprintf("POLLING OUT OF TIMEOUT DATA\n%s", item.sprint())})
//          else
//            `uvm_info(get_type_name(), {$psprintf("GET RETRY POLLING READ ITEM\n%s", item.sprint())}, UVM_LOW)
//        end
//      end
//    end
//  end
//
//endtask : mid_do_read_item

`endif // __SMTDV_MASTER_RETRY_SEQ_SV__


