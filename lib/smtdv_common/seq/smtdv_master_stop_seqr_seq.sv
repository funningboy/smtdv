`ifndef __SMTDV_MASTER_STOP_SEQR_SEQ_SV__
`define __SMTDV_MASTER_STOP_SEQR_SEQ_SV__

class smtdv_master_stop_seqr_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_master_cfg,
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, T1)
  ) extends
  smtdv_master_base_seq#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .T1(T1),
    .VIF(VIF),
    .CFG(CFG),
    .SEQR(SEQR)
  );

  typedef smtdv_master_stop_seqr_seq#(ADDR_WIDTH, DATA_WIDTH, T1, VIF, CFG, SEQR) seq_t;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_master_stop_seqr_seq");
    super.new(name);
  endfunction : new

  extern virtual task body();
  extern virtual task stop_from_mon();
  extern virtual task callback();
  extern virtual task stop_to_seqr();

endclass : smtdv_master_stop_seqr_seq


task smtdv_master_stop_seqr_seq::stop_from_mon();
  wait(seqr.cfg.start_to_stop);
endtask : stop_from_mon

task smtdv_master_stop_seqr_seq::callback();
endtask : callback

task smtdv_master_stop_seqr_seq::stop_to_seqr();
  seqr.cfg.end_to_stop = TRUE;
endtask : stop_to_seqr

task smtdv_master_stop_seqr_seq::body();
  super.body();

  fork
    fork
      begin
        stop_from_mon();
        callback();
        stop_to_seqr();
      end
    join_any
    disable fork;
  join_none
endtask : body

`endif // __SMTDV_MASTER_STOP_SEQR_SEQ_SV__
