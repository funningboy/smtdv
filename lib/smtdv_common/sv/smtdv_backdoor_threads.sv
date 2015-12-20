
`ifndef __SMTDV_BACKDOOR_THREADS_SV__
`define __SMTDV_BACKDOOR_THREADS_SV__

typedef class smtdv_scoreboard;
typedef class smtdv_sequence_item;
typedef class smtdv_master_agent;
typedef class smtdv_slave_agent;
typedef class smtdv_cfg;
typedef class smtdv_run_thread;
typedef class smtdv_component;

/**
* smtdv_backdoor_base_thread
* a base backdoor access thread
*
* @class smtdv_backdoor_base_thread#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR,
* NUM_OF_TARGETS, T1, T2, T3, CFG)
*
*/
class smtdv_backdoor_base_thread #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type T2 = smtdv_master_agent,
  type T3 = smtdv_slave_agent,
  type CFG = smtdv_cfg
  ) extends
  smtdv_run_thread#(
    smtdv_scoreboard#(
      ADDR_WIDTH,
      DATA_WIDTH,
      NUM_OF_INITOR,
      NUM_OF_TARGETS,
      T1,
      T2,
      T3,
      CFG
    ));

  typedef smtdv_scoreboard#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) scb_t;
  typedef smtdv_backdoor_base_thread#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) bk_th_t;
  T1 item;
  T1 ritem;

  `uvm_object_param_utils_begin(bk_th_t)
  `uvm_object_utils_end

   function new(string name = "smtdv_backdoor_base_thread", scb_t parent=null);
     super.new(name, parent);
   endfunction : new

    virtual function void pre_do();
      if (cmp==null) begin
        `uvm_fatal("NOCMP",{"cmp must be set for: ",get_full_name(),".cmp"});
     end
    endfunction : pre_do

endclass : smtdv_backdoor_base_thread


`endif // end of __SMTDV_BACKDOOR_THREADS_SV__
