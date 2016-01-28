`ifndef __SMTDV_SCOREBOARD_THREADDS_SV__
`define __SMTDV_SCOREBOARD_THREADDS_SV__

typedef class smtdv_scoreboard;
typedef class smtdv_sequence_item;
typedef class smtdv_master_agent;
typedef class smtdv_slave_agent;
typedef class smtdv_cfg;
typedef class smtdv_run_thread;
typedef class smtdv_component;

/**
* smtdv_scoreboard_base_thread
* parameterize universal scoreboard thread to check initiator to target trx is
* completed
*
* @class smtdv_scoreboard_base_thread
*
*/
class smtdv_scoreboard_base_thread #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type T2 = smtdv_master_agent#(ADDR_WIDTH, DATA_WIDTH),
  type T3 = smtdv_slave_agent#(ADDR_WIDTH, DATA_WIDTH),
  type CFG = smtdv_cfg
  ) extends
  smtdv_run_thread#(
    smtdv_scoreboard#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .NUM_OF_INITOR(NUM_OF_INITOR),
      .NUM_OF_TARGETS(NUM_OF_TARGETS),
      .T1(T1),
      .T2(T2),
      .T3(T3),
      .CFG(CFG)
  ));

  typedef smtdv_scoreboard#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) scb_t;
  typedef smtdv_scoreboard_base_thread#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) scb_th_t;
  typedef smtdv_queue#(T1) queue_t;
  typedef bit [ADDR_WIDTH-1:0] addr_t;

  T1 item, ritem;

  `uvm_object_param_utils_begin(scb_th_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_scoreboard_base_thread", scb_t parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void pre_do();
    if (cmp==null) begin
      `uvm_fatal("SMTDV_SB_NO_CMP",
          {"CMP MUST BE SET ",get_full_name(),".cmp"});
    end
  endfunction : pre_do

endclass : smtdv_scoreboard_base_thread

`endif // end of __SMTDV_SCOREBOARD_THREADDS_SV__
