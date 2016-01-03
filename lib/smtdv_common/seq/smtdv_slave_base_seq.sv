
`ifndef __SMTDV_SLAVE_BASE_SEQ_SV__
`define __SMTDV_SLAVE_BASE_SEQ_SV__

//typedef class smtdv_sequence_item;
//typedef class smtdv_slave_cfg;
//typedef class smtdv_sequencer;
//typedef class smtdv_sequence;

/**
* smtdv_save_base_seq
* a base slave seq
*
* @class smtdv_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH, T1, VIF, CFG, SEQR)
*
*/
class smtdv_slave_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_slave_cfg,
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1)
  ) extends
    smtdv_sequence#(T1);

    typedef smtdv_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH, T1, VIF, CFG, SEQR) seq_t;

    rand int trx_delay;
    constraint c_trx_delay { trx_delay inside {[0:10]}; }

    bit grabbing = FALSE;
    bit locking = FALSE;

    T1 item;  // default item
    T1 mitem; // item from mon
    T1 bitem; // item from mbox
    mailbox #(T1) mbox;
    SEQR seqr;

    `uvm_object_param_utils_begin(seq_t)
    `uvm_object_utils_end

    function new(string name = "smtdv_slave_base_seq");
      super.new(name);
      mbox = new();
    endfunction : new

// work for parant sequence
//    virtual task pre_do(bit is_item);
//      super.pre_do(is_item);
//      $cast(seqr, m_sequencer);
//    endtask : pre_do

    // work for this sequence
    virtual task pre_body();
      super.pre_body();
      $cast(seqr, m_sequencer);
    endtask : pre_body

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

endclass : smtdv_slave_base_seq

task smtdv_slave_base_seq::pre_do_read_item(T1 item);
endtask : pre_do_read_item

/*
* override
*/
task smtdv_slave_base_seq::mid_do_read_item(T1 item);
endtask : mid_do_read_item

/*
* put back after mid_do_read_item is completed
*/
task smtdv_slave_base_seq::post_do_read_item(T1 item);
  mbox.put(item);
endtask : post_do_read_item


task smtdv_slave_base_seq::do_read_item(T1 item);
  pre_do_read_item(item);
  mid_do_read_item(item);
  post_do_read_item(item);
endtask : do_read_item

/*
* nonblocking write
*/
task smtdv_slave_base_seq::pre_do_write_item(T1 item);
  mbox.put(item);
endtask : pre_do_write_item

/*
* override
*/
task smtdv_slave_base_seq::mid_do_write_item(T1 item);
  wait(item.addr_complete && item.data_complete);
endtask : mid_do_write_item


task smtdv_slave_base_seq::post_do_write_item(T1 item);
endtask : post_do_write_item


task smtdv_slave_base_seq::do_write_item(T1 item);
  pre_do_write_item(item);
  mid_do_write_item(item);
  post_do_write_item(item);
endtask : do_write_item


task smtdv_slave_base_seq::rcv_from_mon();
  forever begin
    seqr.mon_get_port.get(mitem);
    `uvm_info(get_type_name(), {$psprintf("GET MONITOR COLLECTED ITEM\n%s", mitem.sprint())}, UVM_LOW)
    case(mitem.trs_t)
      RD: begin do_read_item(mitem);  end
      WR: begin
            fork
              do_write_item(mitem);
            join_none
          end
      default:
        `uvm_fatal("SMTDV_UNXPCTDPKT",
        $sformatf("COLLECTED AN UNEXPECTED ITEM: \n%s", mitem.sprint()))
    endcase
  end
endtask : rcv_from_mon


task smtdv_slave_base_seq::note_to_drv();
  forever begin
    mbox.get(bitem);

    if (grabbing) grab();
    if (locking) lock();

    repeat(trx_delay) @(posedge seqr.vif.clk);
    `uvm_create(req);
    req.copy(bitem);
    start_item(req);
    finish_item(req);

    if (grabbing) ungrab();
    if (locking) unlock();

   `uvm_info(get_type_name(), {$psprintf("GET AFTER RETURN ITEM\n%s", bitem.sprint())}, UVM_LOW)
  end
endtask : note_to_drv

task smtdv_slave_base_seq::finish_from_mon();
  wait(seqr.finish);
  `uvm_info(seqr.get_full_name(), {$psprintf("TRY COLLECTED FINISH SIGNAL\n")}, UVM_LOW)
endtask : finish_from_mon

/*
* slave is a passive listener which means all trxs are driven start from master and
* wait for slave rsp back. it needs used finish signal assert to drop object phase,
* that can't run as background thread
*/
task smtdv_slave_base_seq::body();
  fork
    fork
      rcv_from_mon();
      note_to_drv();
      finish_from_mon();
    join_any
    disable fork;
  join
endtask : body


`endif // end of __SMTDV_SLAVE_BASE_SEQ_SV__
