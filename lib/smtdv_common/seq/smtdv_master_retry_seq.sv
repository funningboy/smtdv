`ifndef __SMTDV_MASTER_RETRY_SES_SV__
`define __SMTDV_MASTER_RETRY_SES_SV__

typedef class smtdv_sequence_item;
typedef class smtdv_master_base_seq;
typedef class smtdv_master_cfg;

/**
* smtdv_master_retry_seq
* a basic master retry seq while err/retry side effect assert
*
* @class smtdv_master_retry_seq #(ADDR_WIDTH, DATA_WIDTH, T1, CFG)
*
*/
class smtdv_master_retry_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type CFG = smtdv_master_cfg,
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, CFG, T1)
  ) extends
  smtdv_master_base_seq #(
    ADDR_WIDTH,
    DATA_WIDTH,
    T1,
    CFG,
    SEQR
  );

  typedef smtdv_master_retry_seq#(ADDR_WIDTH, DATA_WIDTH, T1, CFG, SEQR) seq_t;

  // retry search table,
  // retry = (err asserted times < max_err cnt)
  typedef struct {
    bit [ADDR_WIDTH-1:0] addr;
    int visit;
  } retry;
  typedef bit [ADDR_WIDTH-1:0] tt;
  retry maps[tt];

  rand int max_err;
  constraint c_max_err { 2 <= max_err && max_err <= 4; }

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

   function new(string name = "smtdv_master_retry_seq");
     super.new(name);
   endfunction : new

  extern virtual task do_read_item(ref T1 item);
  extern virtual task do_write_item(ref T1 item);

endclass : smtdv_master_retry_seq

// wait addr and data completed and rsp not ok
task smtdv_master_retry_seq::do_read_item(ref T1 item);
  super.do_read_item(item);
  if (!item.success) begin
    foreach(item.addrs[i]) begin
      if(maps.exists(item.addrs[i])) begin
        maps[item.addrs[i]].visit++;
      end
      else begin
        maps[item.addrs[i]].addr = item.addrs[i];
        maps[item.addrs[i]].visit = 0;
      end
      item.retry = (maps[item.addrs[i]].visit >= max_err)? FALSE: TRUE;
      `uvm_info(get_type_name(), {$psprintf("get override read item\n%s", item.sprint())}, UVM_LOW)
    end
  end
endtask : do_read_item


// wait addr and data completed and rsp not ok
task smtdv_master_retry_seq::do_write_item(ref T1 item);
  super.do_write_item(item);
  if (!item.success) begin
    foreach(item.addrs[i]) begin
      if(maps.exists(item.addrs[i])) begin
        maps[item.addrs[i]].visit++;
      end
      else begin
        maps[item.addrs[i]].addr = item.addrs[i];
        maps[item.addrs[i]].visit = 0;
      end
      item.retry = (maps[item.addrs[i]].visit >= max_err)? FALSE: TRUE;
      `uvm_info(get_type_name(), {$psprintf("get override write item\n%s", item.sprint())}, UVM_LOW)
    end
  end
endtask : do_write_item

`endif // __SMTDV_MASTER_RETRY_SES_SV__
