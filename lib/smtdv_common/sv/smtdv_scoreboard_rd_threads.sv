`ifndef __SMTDV_SCOREBOARD_RD_THREADDS_SV__
`define __SMTDV_SCOREBOARD_RD_THREADDS_SV__

typedef class smtdv_scoreboard;
typedef class smtdv_sequence_item;
typedef class smtdv_master_agent;
typedef class smtdv_slave_agent;
typedef class smtdv_cfg;
typedef class smtdv_run_thread;
typedef class smtdv_component;
typedef class smtdv_scoreboard_base_thread;

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
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .NUM_OF_INITOR(NUM_OF_INITOR),
      .NUM_OF_TARGETS(NUM_OF_TARGETS),
      .T1(T1),
      .T2(T2),
      .T3(T3),
      .CFG(CFG)
    );

  typedef smtdv_scoreboard#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) scb_t;
  typedef smtdv_watch_rd_lifetime #(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) rd_lf_t;
  typedef smtdv_queue#(T1) queue_t;
  typedef bit [ADDR_WIDTH-1:0] addr_t;

  rand int watch_per_ns;

  constraint c_watch_per_ns { watch_per_ns inside {[100:200]}; }

  `uvm_object_param_utils_begin(rd_lf_t)
  `uvm_object_utils_end

   function new(string name = "smtdv_watch_rd_lifetime", uvm_component parent=null);
     super.new(name, parent);
   endfunction : new

   extern virtual task run();

endclass : smtdv_watch_rd_lifetime

/**
 *  do check
 */
task smtdv_watch_rd_lifetime::run();
  addr_t taddr[$];
  queue_t tque;
  T1 item;

  forever begin
    #watch_per_ns;
    this.cmp.rd_pool.keys(taddr);

    foreach(taddr[i])begin
      tque = this.cmp.rd_pool.get(taddr[i]);

      for(int j=0; j<tque.size(); j++) begin
        tque.async_get(j, 0, item);

        if (item.life_time<0)
          `uvm_error("SMTDV_SB_LIFE_TIMEOUT",
              {$psprintf("RUN OUT OF LIFE TIMEOUT DATA \n%s", item.sprint())})

        item.life_time--;
      end
    end

    if (this.cmp.has_debug)
      update_timestamp();

  end
endtask : run


`endif // end of __SMTDV_SCOREBOARD_THREADDS_SV__
