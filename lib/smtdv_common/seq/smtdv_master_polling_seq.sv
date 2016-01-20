`ifndef __SMTDV_MASTER_POLLING_SEQ_SV__
`define __SMTDV_MASTER_POLLING_SEQ_SV__

//typedef class smtdv_sequence_item;
//typedef class smtdv_master_base_seq;
//typedef class smtdv_master_cfg;
//typedef class smtdv_sequencer;

/**
* smtdv_master_retry_seq
* a basic master polling seq while some expected data assert
* steps to run seq:
* pre_body() {
*   `uvm_create_on(seq_pol, seqr)
*   `SMTDV_RAND(seq_pol)
*   seq_pol.register_watch_table(start_addr, end_addr);
*   seq_pol.register_polling_table(start_addr, expect_data);
*   seq_pol.start(seqr, this, -1);
* }
*
* body() {
*   seq_pol.set_polling_start();
*   assert(seq.pol.is_ready_to_polling());
*   wait(seq_pol.is_finish_to_polling());
* }
*
* @class smtdv_master_retry_seq#(ADDR_WIDTH, DATA_WIDTH, T1, CFG)
*
*/
class smtdv_master_polling_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_master_cfg,
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1)
  ) extends
 smtdv_master_retry_seq#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .T1(T1),
    .VIF(VIF),
    .CFG(CFG),
    .SEQR(SEQR)
  );

  typedef smtdv_master_polling_seq#(ADDR_WIDTH, DATA_WIDTH, T1, VIF, CFG, SEQR) seq_t;

  bit poll_done = FALSE;

  typedef struct {
    bit [ADDR_WIDTH-1:0] addr;
    bit [DATA_WIDTH-1:0] data;
    int visit;
  } polling_t;
  typedef bit [ADDR_WIDTH-1:0] tt;
  polling_t polling[tt];

  rand int max_polling;
  constraint c_max_polling { 10 <= max_polling && max_polling <= 100; }

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_master_polling_seq");
    super.new(name);
  endfunction : new

  virtual task pre_do(bit is_item);
    super.pre_do(is_item);
    grabbing = FALSE;
    locking = TRUE;
  endtask : pre_do

  extern virtual function bit is_ready_to_polling();
  extern virtual function bit is_finish_to_polling();
  extern virtual function void register_polling_table(bit [ADDR_WIDTH-1:0] addr, bit [DATA_WIDTH-1:0] data);
  extern virtual function void flush_polling_table();
  extern virtual function void set_polling_start();

  extern virtual task mid_do_read_item(T1 item);

endclass : smtdv_master_polling_seq


function bit smtdv_master_polling_seq::is_ready_to_polling();
  return poll_done == FALSE;
endfunction : is_ready_to_polling


function bit smtdv_master_polling_seq::is_finish_to_polling();
  return poll_done == TRUE;
endfunction : is_finish_to_polling


function void smtdv_master_polling_seq::register_polling_table(bit [ADDR_WIDTH-1:0] addr, bit [DATA_WIDTH-1:0] data);
  polling[addr].addr = addr;
  polling[addr].data = data;
  polling[addr].visit = 0;
endfunction : register_polling_table

function void smtdv_master_polling_seq::set_polling_start();
  poll_done = FALSE;
endfunction : set_polling_start


function void smtdv_master_polling_seq::flush_polling_table();
  polling.delete();
endfunction : flush_polling_table

/*
* polling expected value until timeout break
*/
task smtdv_master_polling_seq::mid_do_read_item(T1 item);
  super.mid_do_read_item(item);
  if(item.success) begin
    foreach(item.addrs[i]) begin
      if(is_addr_to_watch(item.addrs[i])) begin
        if(polling.exists(item.addrs[i])) begin
          if (polling[item.addrs[i]].data == item.unpack_data(i)) begin
            item.retry = FALSE;
            poll_done = TRUE;
          end
          else begin
            item.retry = (polling[item.addrs[i]].visit >= max_polling)? FALSE: TRUE;
            if (item.retry == FALSE)
              `uvm_error("SMTDV_MST_POLLTIMOUT_ERR",
                 {$psprintf("POLLING OUT OF TIMEOUT DATA\n%s", item.sprint())})
          end
        end
      end
    end
  end

endtask : mid_do_read_item

`endif // __SMTDV_MASTER_RETRY_SEQ_SV__


