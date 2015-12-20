`ifndef __SMTDV_MASTER_SEQS_SV__
`define __SMTDV_MASTER_SEQS_SV__

typedef class smtdv_sequence_item;
typedef class smtdv_master_cfg;

/**
* smtdv_master_base_seq
* a basic master seq
*
* @class smtdv_master_base_seq #(ADDR_WIDTH, DATA_WIDTH, T1, CFG)
*
*/
class smtdv_master_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type CFG = smtdv_master_cfg,
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, CFG, T1)
  ) extends
    smtdv_sequence#(T1);

    typedef smtdv_master_base_seq#(ADDR_WIDTH, DATA_WIDTH, T1, CFG, SEQR) seq_t;

    T1 item;
    mailbox #(T1) mbox;
    CFG cfg;

    `uvm_object_param_utils_begin(seq_t)
    `uvm_object_utils_end

    `uvm_declare_p_sequencer(SEQR)

    function new(string name = "smtdv_master_base_seq");
      super.new(name);
      mbox = new();
    endfunction

    extern virtual task body();
    extern virtual task do_read_item(ref T1 item);
    extern virtual task do_write_item(ref T1 item);
    extern virtual task rcv_from_mon();
    extern virtual task note_to_drv();
    extern virtual task finish_from_mon();

endclass : smtdv_master_base_seq


task smtdv_master_base_seq::do_read_item(ref T1 item);
  wait(item.addr_complete && item.data_complete);
endtask : do_read_item


task smtdv_master_base_seq::do_write_item(ref T1 item);
  wait(item.addr_complete && item.data_complete);
endtask : do_write_item


task smtdv_master_base_seq::rcv_from_mon();
  forever begin
    $cast(cfg, p_sequencer.cfg);
    p_sequencer.mon_get_port.get(item);
    `uvm_info(get_type_name(), {$psprintf("get monitor collected item\n%s", item.sprint())}, UVM_LOW)
    case(item.trs_t)
      RD: begin
        do_read_item(item);
        if (item.retry)
          mbox.put(item);
      end
      WR: begin
        do_write_item(item);
        if (item.retry)
          mbox.put(item);
      end
      default:
        `uvm_fatal("UNXPCTDPKT",
        $sformatf("collected an unexpected item: \n%s", req.sprint()))
      endcase
    end
endtask : rcv_from_mon


task smtdv_master_base_seq::note_to_drv();
  forever begin
    mbox.get(item);
    `uvm_info(get_type_name(), {$psprintf("get after retried item\n%s", item.sprint())}, UVM_LOW)
    `uvm_create(req);
    req.copy(item);
    start_item(req);
    finish_item(req);
  end
endtask : note_to_drv


task smtdv_master_base_seq::finish_from_mon();
  wait(p_sequencer.finish);
  `uvm_info(p_sequencer.get_full_name(), {$psprintf("try collected finish signal\n")}, UVM_LOW)
endtask : finish_from_mon


task smtdv_master_base_seq::body();
  fork
    fork
      rcv_from_mon();
      note_to_drv();
      finish_from_mon();
    join_any
  join_none
endtask : body


`endif // end of __SMTDV_MASTER_SEQS_SV__
