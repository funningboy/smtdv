
`ifndef __SMTDV_MONITOR_SV__
`define __SMTDV_MONITOR_SV__

/**
* smtdv_monitor
* a basic monitor
*
* @class smtdv_monitor
*
*/
class smtdv_monitor#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type VIF = virtual interface smtdv_if,
  type CFG = smtdv_cfg,
  type SEQR = smtdv_sequencer#(ADDR_WIDTH, DATA_WIDTH, VIF, smtdv_cfg, smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH)),
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    smtdv_component#(uvm_monitor);

  typedef smtdv_monitor#(ADDR_WIDTH, DATA_WIDTH, VIF, CFG, SEQR, T1) mon_t;
  typedef smtdv_thread_handler#(mon_t) hdler_t;

  VIF vif;
  CFG cfg;
  SEQR seqr;

  uvm_analysis_port#(T1) item_collected_port; // collect to scoreboard
  uvm_analysis_port#(T1) item_asserted_port;  // pre assert note to sequence item
  uvm_analysis_port#(T1) item_callback_port;  // notify rsp back to master sequence

  // as backend threads/handler
  hdler_t bk_handler;

  `uvm_component_param_utils_begin(mon_t)
  `uvm_component_utils_end

  function new(string name = "smtdv_monitor", uvm_component parent=null);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
    item_asserted_port = new("item_asserted_port", this);
    item_callback_port = new("item_callback_port", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    bk_handler = hdler_t::type_id::create("smtdv_monitor_handler", this);

    `SMTDV_RAND(bk_handler)
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    bk_handler.register(this);
    bk_handler.finalize();
  endfunction : end_of_elaboration_phase

  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset_monitor();
  extern virtual task run_threads();

endclass : smtdv_monitor

/**
 *  extend this when start of run,
 *  start to spawn all threads and wait for join all by thread_handler
 */
task smtdv_monitor::run_phase(uvm_phase phase);
  begin
  fork
    super.run_phase(phase);
    join_none

  while(1) begin
    reset_monitor();
    wait(resetn);
    fork
      fork
        begin
          @(negedge resetn);
        end
      join_any

      run_threads();
    join
    disable fork;
    end
  end
endtask : run_phase


task smtdv_monitor::run_threads();
  bk_handler.run();
  bk_handler.watch();
endtask : run_threads


task smtdv_monitor::reset_monitor();
endtask : reset_monitor


`endif // end of __SMTDV_MONITOR_SV__
