`ifndef __SMTDV_MASTER_RETRY_SEQ_SV__
`define __SMTDV_MASTER_RETRY_SEQ_SV__

//typedef class smtdv_sequence_item;
//typedef class smtdv_master_retry_seq;
//typedef class smtdv_master_cfg;
//typedef class smtdv_sequencer;

/**
* smtdv_master_retry_seq
* a basic master retry seq while err/retry assert
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

  // retry search table,
  typedef struct {
    bit [ADDR_WIDTH-1:0] addr;
    int visit;
  } retry;
  typedef bit [ADDR_WIDTH-1:0] tt;
  retry maps[tt];

  rand int max_err;
  constraint c_max_err { max_err inside {[5:10]}; }

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

   function new(string name = "smtdv_master_retry_seq");
     super.new(name);
   endfunction : new

  extern virtual task body();
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
* find first err happened addr, and clone it to retyr queu
*/
task smtdv_master_retry_seq::mid_do_read_item(T1 item);
  if (!item.success) begin
    if(maps.exists(item.addrs[$])) begin
        maps[item.addrs[$]].visit++;
    end
    else begin
      maps[item.addrs[$]].addr = item.addrs[$];
      maps[item.addrs[$]].visit = 0;
    end
    item.retry = (maps[item.addrs[$]].visit >= max_err)? FALSE: TRUE;
    `uvm_info(get_type_name(), {$psprintf("GET OVERRIDE READ ITEM\n%s", item.sprint())}, UVM_LOW)
    if (!item.retry)
      `uvm_error("SMTDV_RTRY_TIMEOUT", {$psprintf("%h RUN OUT OF RETRY TIMEOUT %d", maps[item.addrs[$]].addr, max_err)})
    end
endtask : mid_do_read_item


/*
* find first err happened addr, and clone it to retry queue
*/
task smtdv_master_retry_seq::mid_do_write_item(T1 item);
  if (!item.success) begin
    if(maps.exists(item.addrs[$])) begin
        maps[item.addrs[$]].visit++;
    end
    else begin
        maps[item.addrs[$]].addr = item.addrs[$];
        maps[item.addrs[$]].visit = 0;
    end
    item.retry = (maps[item.addrs[$]].visit >= max_err)? FALSE: TRUE;
    `uvm_info(get_type_name(), {$psprintf("GET OVERRIDE WRITE ITEM\n%s", item.sprint())}, UVM_LOW)
    if (!item.retry)
      `uvm_error("SMTDV_RTRY_TIMEOUT", {$psprintf("%h RUN OUT OF RETRY TIMEOUT %d", maps[item.addrs[$]].addr, max_err)})
  end
endtask : mid_do_write_item


task smtdv_master_retry_seq::note_to_drv();
  forever begin
    mbox.get(bitem);

    // more familiar with `uvm_do(seq_or_item), only diff part is remvoed randomize
    // grab goes the front of the queue of processing waiting for exclusive
    // acces to sequencer, lock goes to the back of queue
    if (grabbing) grab();
    if (locking)  lock();

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


task smtdv_master_retry_seq::body();
  fork
    fork
      rcv_from_mon();
      note_to_drv();
      finish_from_mon();
    join_any
    disable fork;
  join
endtask : body


`endif // __SMTDV_MASTER_RETRY_SES_SV__
