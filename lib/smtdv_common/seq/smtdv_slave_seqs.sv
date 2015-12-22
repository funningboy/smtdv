
`ifndef __SMTDV_SLAVE_SEQS_SV__
`define __SMTDV_SLAVE_SEQS_SV__

typedef class smtdv_sequence_item;
typedef class smtdv_slave_cfg;
typedef class smtdv_sequencer;
typedef class smtdv_sequence;

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

    T1 item;
    mailbox #(T1) mbox;
    SEQR seqr;

    `uvm_object_param_utils_begin(seq_t)
    `uvm_object_utils_end

    function new(string name = "smtdv_slave_base_seq");
      super.new(name);
      mbox = new();
    endfunction : new

    virtual task pre_body();
      super.pre_body();
      $cast(seqr, m_sequencer);
    endtask : pre_body

    extern virtual task body();
    extern virtual task do_read_item(ref T1 item);
    extern virtual task do_write_item(ref T1 item);
    extern virtual task rcv_from_mon();
    extern virtual task note_to_drv();
    extern virtual task finish_from_mon();

endclass : smtdv_slave_base_seq


// preload read item, no wait addr anda data completed
task smtdv_slave_base_seq::do_read_item(ref T1 item);
endtask : do_read_item


// need to wait addr and data completed
task smtdv_slave_base_seq::do_write_item(ref T1 item);
  wait(item.addr_complete && item.data_complete);
endtask : do_write_item


task smtdv_slave_base_seq::rcv_from_mon();
  forever begin
    seqr.mon_get_port.get(item);
    `uvm_info(get_type_name(), {$psprintf("get monitor collected item\n%s", item.sprint())}, UVM_LOW)
    case(item.trs_t)
      RD: begin
        do_read_item(item);
        mbox.put(item);
        end
      WR: begin
        mbox.put(item);
        do_write_item(item);
        end
      default:
        `uvm_fatal("UNXPCTDPKT",
        $sformatf("collected an unexpected item: \n%s", req.sprint()))
    endcase
  end
endtask : rcv_from_mon


task smtdv_slave_base_seq::note_to_drv();
  forever begin
    mbox.get(item);
    `uvm_create(req);
    req.copy(item);
    start_item(req);
    finish_item(req);
  end
endtask : note_to_drv

task smtdv_slave_base_seq::finish_from_mon();
  wait(seqr.finish);
  `uvm_info(seqr.get_full_name(), {$psprintf("try collected finish signal\n")}, UVM_LOW)
endtask : finish_from_mon

task smtdv_slave_base_seq::body();
  fork
    fork
      rcv_from_mon();
      note_to_drv();
      finish_from_mon();
    join_any
  join
endtask : body


`endif // end of __SMTDV_SLAVE_SEQS_SV__
