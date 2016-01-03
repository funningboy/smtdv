`ifndef __SMTDV_MASTER_RETRY_SEQ_SV__
`define __SMTDV_MASTER_RETRY_SEQ_SV__

//typedef class smtdv_sequence_item;
//typedef class smtdv_master_retry_seq;
//typedef class smtdv_master_cfg;
//typedef class smtdv_sequencer;

/**
* smtdv_master_retry_seq
* a basic master retry seq while err/retry assert
* steps to run seq:
* pre_body() {
*   `uvm_create_on(seq_rty, seqr)
*   `SMTDV_RAND(seq_rty)
*   seq_rty.register_watch_table(start_addr, end_adrr);
*   seq_rty.start(seqr, this ,-1);
* }
*
* body() {
*   seq_rty.set_watch_window(WR, outstanding);
*   assert(seq_rty.is_ready_to_watch(WR))
*   wait(seq_rty.is_finish_to_watch(WR))
* }
*
* @class smtdv_master_retry_seq #(ADDR_WIDTH, DATA_WIDTH, T1, CFG)
*
*/
class smtdv_master_retry_seq #(
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

  typedef smtdv_master_retry_seq#(ADDR_WIDTH, DATA_WIDTH, T1, VIF, CFG, SEQR) seq_t;

  bit grabbing = TRUE;
  bit locking = FALSE;

  int rd_win;  // read watch window
  int wr_win;  // write watch window
  rand int retry_delay; // retry sample delay
  rand int watch_delay; // watch sample delay
  rand int max_err;     // max err
  trs_type_t trs_t;

  // watch table, declare useful addr range table
  typedef struct {
    bit [ADDR_WIDTH-1:0] start_addr;
    bit [ADDR_WIDTH-1:0] end_addr;
  } watch_t;
  watch_t watch[$];

  // retry visit table,
  typedef struct {
    bit [ADDR_WIDTH-1:0] addr;
    int visit;
  } retry_t;
  typedef bit [ADDR_WIDTH-1:0] tt;
  retry_t retry[tt];

  constraint c_max_err { max_err inside {[5:10]}; }
  constraint c_retry_delay { retry_delay inside {[0:10]}; }
  constraint c_watch_delay { watch_delay inside {[1:5]};  }

  `uvm_object_param_utils_begin(seq_t)
    `uvm_field_int(retry_delay, UVM_ALL_ON)
    `uvm_field_int(watch_delay, UVM_ALL_ON)
    `uvm_field_int(max_err, UVM_ALL_ON)
    `uvm_field_int(wr_win, UVM_ALL_ON)
    `uvm_field_int(rd_win, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "smtdv_master_retry_seq");
    super.new(name);
  endfunction : new

  extern virtual task body();
  extern virtual function bit is_addr_to_watch(bit [ADDR_WIDTH-1:0] addr);
  extern virtual function bit is_ready_to_watch(trs_type_t trs_t);
  extern virtual function bit is_finish_to_watch(trs_type_t trs_t);
  extern virtual function void register_watch_table(bit [ADDR_WIDTH-1:0] start_addr, bit [ADDR_WIDTH-1:0] end_addr);
  extern virtual function void flush_watch_table();
  extern virtual function void set_watch_window(trs_type_t trs_t, int win);

  extern virtual task pre_do_read_item(T1 item);
  extern virtual task pre_do_write_item(T1 item);
  extern virtual task mid_do_read_item(T1 item);
  extern virtual task mid_do_write_item(T1 item);
  extern virtual task post_do_read_item(T1 item);
  extern virtual task post_do_write_item(T1 item);
  extern virtual task do_read_item(T1 item);
  extern virtual task do_write_item(T1 item);
  extern virtual task rcv_from_mon();
  extern virtual task note_to_drv();
  extern virtual task finish_from_mon();

endclass : smtdv_master_retry_seq

function bit smtdv_master_retry_seq::is_addr_to_watch(bit [ADDR_WIDTH-1:0] addr);
  watch_t found[$];
  found = watch.find(x) with ({ x.start_addr <= addr && addr <= x.end_addr });
  return found.size() > 0;
endfunction : is_addr_to_watch

/*
* make sure watch window is clear to start
*/
function bit smtdv_master_retry_seq::is_ready_to_watch(trs_type_t trs_t);
  if (trs_t == WR) return wr_win > 0;
  if (trs_t == RD) return rd_win > 0;
  return FALSE;
endfunction : is_ready_to_watch

function bit smtdv_master_retry_seq::is_finish_to_watch(trs_type_t trs_t);
  if (trs_t == WR) return wr_win == 0;
  if (trs_t == RD) return rd_win == 0;
  return FALSE;
endfunction : is_finish_to_watch

/*
* register watch table
*/
function void smtdv_master_retry_seq::register_watch_table(bit [ADDR_WIDTH-1:0] start_addr, bit [ADDR_WIDTH-1:0] end_addr);
  watch.push_back('{start_addr, end_addr});
endfunction : register_watch_table

function void smtdv_master_retry_seq::flush_watch_table();
  watch.delete();
  retry.delete();
endfunction : flush_watch_table

function void smtdv_master_retry_seq::set_watch_window(trs_type_t trs_t, int win);
  if (trs_t == WR) wr_win = win;
  if (trs_t == RD) rd_win = win;
endfunction : set_watch_window


/*
* make sure add and data are completed
*/
task smtdv_master_retry_seq::pre_do_read_item(T1 item);
  wait(item.addr_complete && item.data_complete);
endtask : pre_do_read_item

/*
* make sure add and data are completed
*/
task smtdv_master_retry_seq::pre_do_write_item(T1 item);
  wait(item.addr_complete && item.data_complete);
endtask : pre_do_write_item

/*
* retry while item.retry is TRUE
*/
task smtdv_master_retry_seq::post_do_write_item(T1 item);
  if (item.retry)
    mbox.put(item);
endtask : post_do_write_item

/*
* retry while item.retry is TRUE
*/
task smtdv_master_retry_seq::post_do_read_item(T1 item);
  if (item.retry)
    mbox.put(item);
endtask : post_do_read_item


task smtdv_master_retry_seq::do_write_item(T1 item);
  pre_do_write_item(item);
  mid_do_write_item(item);
  post_do_write_item(item);
endtask : do_write_item


task smtdv_master_retry_seq::do_read_item(T1 item);
  pre_do_read_item(item);
  mid_do_read_item(item);
  post_do_read_item(item);
endtask : do_read_item


task smtdv_master_retry_seq::rcv_from_mon();
  forever begin
    seqr.mon_get_port.get(mitem);
    `uvm_info(get_type_name(), {$psprintf("GET MONITOR COLLECTED ITEM\n%s", mitem.sprint())}, UVM_LOW)
    case(mitem.trs_t)
      RD: begin do_read_item(mitem);  end
      WR: begin do_write_item(mitem); end
      default:
        `uvm_fatal("SMTDV_UNXPCTDPKT",
        $sformatf("collected an unexpected item: \n%s", mitem.sprint()))
      endcase
    end
endtask : rcv_from_mon


/*
* find first err happened addr at burst trx and clone it to retry queu,
* purge retry queue while next ok assert
*/
task smtdv_master_retry_seq::mid_do_read_item(T1 item);
  if (!item.success) begin
   if (is_addr_to_watch(item.addrs[$])) begin
      if(retry.exists(item.addrs[$])) begin
        retry[item.addrs[$]].visit++;
      end
      else begin
        retry[item.addrs[$]].addr = item.addrs[$];
        retry[item.addrs[$]].visit = 0;
      end
      item.retry = (retry[item.addrs[$]].visit >= max_err)? FALSE: TRUE;
      if (!item.retry)
        `uvm_error("SMTDV_RTRY_TIMEOUT", {$psprintf("%h RUN OUT OF RETRY TIMEOUT %d", retry[item.addrs[$]].addr, max_err)})
    end
  end
  else begin
    if(retry.exists(item.addrs[$])) retry.delete(item.addrs[$]);
    rd_win--;
  end
endtask : mid_do_read_item


/*
* find first err happened addr at burst trx and clone it to retry queue,
* purge retry queue while next ok assert
*/
task smtdv_master_retry_seq::mid_do_write_item(T1 item);
  if (!item.success) begin
    if (is_addr_to_watch(item.addrs[$])) begin
      if(retry.exists(item.addrs[$])) begin
          retry[item.addrs[$]].visit++;
      end
      else begin
          retry[item.addrs[$]].addr = item.addrs[$];
          retry[item.addrs[$]].visit = 0;
      end
      item.retry = (retry[item.addrs[$]].visit >= max_err)? FALSE: TRUE;
      if (!item.retry)
        `uvm_error("SMTDV_RTRY_TIMEOUT", {$psprintf("%h RUN OUT OF RETRY TIMEOUT %d", retry[item.addrs[$]].addr, max_err)})
    end
  end
  else begin
    if (retry.exists(item.addrs[$])) retry.delete(item.addrs[$]);
    wr_win--;
  end
endtask : mid_do_write_item


task smtdv_master_retry_seq::note_to_drv();
  forever begin
    mbox.get(bitem);

    // grab goes the front of the queue of processing waiting for exclusive
    // acces to sequencer, lock goes to the back of queue
    if (grabbing) grab();
    if (locking)  lock();

    repeat(retry_delay) @(posedge seqr.vif.clk);
    `uvm_create(req);
    req.copy(bitem);
    start_item(req);
    finish_item(req);

    if (grabbing) ungrab();
    if (locking) unlock();

    `uvm_info(get_type_name(), {$psprintf("GET AFTER RETRIED ITEM\n%s", bitem.sprint())}, UVM_LOW)
  end
endtask : note_to_drv


task smtdv_master_retry_seq::finish_from_mon();
  wait(seqr.finish);
  `uvm_info(seqr.get_full_name(), {$psprintf("TRY COLLECTED FINISH SIGNAL\n")}, UVM_LOW)
endtask : finish_from_mon

/*
* master is an active trigger, it needs a background thread to handler the
* retry methdology while uncompleted trx is asseted
*/
task smtdv_master_retry_seq::body();
  super.body();

  fork
    fork
      rcv_from_mon();
      note_to_drv();
      finish_from_mon();
    join_any
    disable fork;
  join_none
endtask : body


`endif // __SMTDV_MASTER_RETRY_SES_SV__
