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
  //
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
  typedef smtdv_scoreboard_base_thread#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) scb_th_t;

  T1 item, ritem;

  `uvm_object_param_utils_begin(scb_th_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_scoreboard_base_thread", scb_t parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void pre_do();
    if (cmp==null) begin
      `uvm_fatal("NOCMP",{"cmp must be set for: ",get_full_name(),".cmp"});
    end
  endfunction : pre_do

endclass


/**
* smtdv_watch_wr_lifetime
* make sure the wr trx from initiator to target is completed at time
*
* @class smtdv_watch_wr_lifetime
*
*/
class smtdv_watch_wr_lifetime #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type T2 = smtdv_master_agent#(ADDR_WIDTH, DATA_WIDTH),
  type T3 = smtdv_slave_agent#(ADDR_WIDTH, DATA_WIDTH),
  type CFG = smtdv_cfg
  )extends
    smtdv_scoreboard_base_thread #(
      ADDR_WIDTH,
      DATA_WIDTH,
      NUM_OF_INITOR,
      NUM_OF_TARGETS,
      T1,
      T2,
      T3,
      CFG
    );

  typedef smtdv_scoreboard#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) scb_t;
  typedef smtdv_watch_wr_lifetime #(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) wr_lf_t;
  int watch_per_ns = 100; // period check time

  `uvm_object_param_utils_begin(wr_lf_t)
  `uvm_object_utils_end

   function new(string name = "smtdv_watch_wr_lifetime", scb_t parent=null);
     super.new(name, parent);
   endfunction : new

   extern virtual task run();

endclass : smtdv_watch_wr_lifetime

/**
 *  do check
 */
task smtdv_watch_wr_lifetime::run();
  forever begin
    #watch_per_ns;
    foreach(this.cmp.wr_pool[i])begin
      foreach(this.cmp.wr_pool[i][j]) begin
        item = this.cmp.wr_pool[i][j];
        if (item.life_time<0) begin
          `uvm_error(get_type_name(), {$psprintf("RUN OUT OF LIFE TIMEOUT DATA \n%s", item.sprint())})
        end
        item.life_time--;
      end
    end
  end
endtask : run


/**
* smtdv_watch_rd_lifetime
* make sure the rd trx from initiator to target is completed at time
*
* @class smtdv_watch_rd_lifetime
*
*/
class smtdv_watch_rd_lifetime #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type T2 = smtdv_master_agent#(ADDR_WIDTH, DATA_WIDTH),
  type T3 = smtdv_slave_agent#(ADDR_WIDTH, DATA_WIDTH),
  type CFG = smtdv_cfg)
    extends
    smtdv_scoreboard_base_thread #(
      ADDR_WIDTH,
      DATA_WIDTH,
      NUM_OF_INITOR,
      NUM_OF_TARGETS,
      T1,
      T2,
      T3,
      CFG
    );

  typedef smtdv_scoreboard#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) scb_t;
  typedef smtdv_watch_rd_lifetime #(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) rd_lf_t;
  int watch_per_ns = 100;

  `uvm_object_param_utils_begin(rd_lf_t)
  `uvm_object_utils_end

   function new(string name = "smtdv_watch_rd_lifetime", scb_t parent=null);
     super.new(name, parent);
   endfunction : new

   extern virtual task run();

endclass : smtdv_watch_rd_lifetime

/**
 *  do check
 */
task smtdv_watch_rd_lifetime::run();
  forever begin
    #watch_per_ns;
    foreach(this.cmp.rd_pool[i])begin
      foreach(this.cmp.rd_pool[i][j]) begin
        item = this.cmp.rd_pool[i][j];
        if (item.life_time<0) begin
          `uvm_error(get_type_name(), {$psprintf("RUN OUT OF LIFE TIMEOUT DATA \n%s", item.sprint())})
        end
        item.life_time--;
      end
    end
  end
endtask : run


`endif // end of __SMTDV_SCOREBOARD_THREADDS_SV__
