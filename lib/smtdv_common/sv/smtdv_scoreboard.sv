
`ifndef __SMTDV_SCOREBOARD_SV__
`define __SMTDV_SCOREBOARD_SV__

typedef class smtdv_sequence_item;
typedef class smtdv_master_agent;
typedef class smtdv_slave_agent;
typedef class smtdv_cfg;
typedef class smtdv_run_thread;
typedef class smtdv_component;
typedef class smtdv_thread_handler;
typedef class smtdv_watch_wr_lifetime;
typedef class smtdv_watch_rd_lifetime;
typedef class smtdv_mem_bkdor_wr_comp;
typedef class smtdv_mem_bkdor_rd_comp;

/**
* smtdv_scoreboard
* parameterize universal scoreboard
*
* @class smtdv_component#(uvm_scoreboard)
*
*/
class smtdv_scoreboard #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = smtdv_sequence_item #(ADDR_WIDTH, DATA_WIDTH),
  type T2 = smtdv_master_agent,
  type T3 = smtdv_slave_agent,
  type CFG = smtdv_cfg
  ) extends
  smtdv_component#(uvm_scoreboard);

  `uvm_analysis_imp_decl(_initor) // uvm_analysis_port from initor
  `uvm_analysis_imp_decl(_target) // uvm_analysis_port from target

  typedef bit [ADDR_WIDTH-1:0] addr_t;
  typedef smtdv_scoreboard        #(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) scb_t;
  typedef smtdv_backdoor#(ADDR_WIDTH, DATA_WIDTH, scb_t, T1) bak_t;
  typedef smtdv_watch_wr_lifetime #(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) wr_lf_t;
  typedef smtdv_watch_rd_lifetime #(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) rd_lf_t;
  typedef smtdv_mem_bkdor_wr_comp #(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) bk_wr_t;
  typedef smtdv_mem_bkdor_rd_comp #(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) bk_rd_t;
  typedef smtdv_thread_handler #(scb_t) hdler_t;

  hdler_t th_handler; // scb thread handler

  T1 rbox[$];  // rd mem channel backdoor
  T1 wbox[$];  // wr mem channel backdoor

  // queue of associative arry
  T1 wr_pool[addr_t][$];
  T1 rd_pool[addr_t][$];

  bak_t bkdor_wr;   // wr mem backdoor handler
  bak_t bkdor_rd;   // rd mem backdoor handler

  wr_lf_t th0; // watch wr trx is completed thread
  rd_lf_t th1; // watch rd trx is completed thread
  bk_wr_t th2; // backdoor wr trx at mem access thread
  bk_rd_t th3; // backdoor rd trx at mem access thread

  T1 atmic_item;
  T2 initor_m[NUM_OF_INITOR];   // map to initiator as master
  T3 targets_s[NUM_OF_TARGETS]; // map to all targets as slaves

  uvm_analysis_imp_initor #(T1, scb_t) initor[NUM_OF_INITOR];
  uvm_analysis_imp_target #(T1, scb_t) targets[NUM_OF_TARGETS];

  `uvm_component_param_utils_begin(scb_t)
  `uvm_component_utils_end

  function new(string name = "smtdv_scoreboard", uvm_component parent);
    super.new(name, parent);
    for(int i=0; i<NUM_OF_INITOR; i++) begin
      initor[i] = new({$psprintf("initor[%0d]", i)}, this);
    end
    for(int i=0; i<NUM_OF_TARGETS; i++) begin
      targets[i] = new({$psprintf("targets[%0d]", i)}, this);
    end
  endfunction : new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void write_initor(T1 item);
  extern virtual function void write_target(T1 item);
  extern virtual function void reset_scoreboard();

  extern protected function void _write_initor(T1 item);
  extern protected function void _write_target(T1 item);

endclass : smtdv_scoreboard

/**
 *  construct all threads and register them to handler
 */
function void smtdv_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);
  bkdor_wr = bak_t::type_id::create("smtdv_mem_bkdor_wr", this); assert(bkdor_wr);
  bkdor_rd = bak_t::type_id::create("smtdv_mem_bkdor_rd", this); assert(bkdor_rd);

  th_handler = hdler_t::type_id::create("smtdv_backend_handler", this);

  th0 = wr_lf_t::type_id::create("smtdv_watch_wr_lifetime", this);
  th1 = rd_lf_t::type_id::create("smtdv_watch_rd_lifetime", this);
  th2 = bk_wr_t::type_id::create("smtdv_mem_bkdor_wr_comp", this);
  th3 = bk_rd_t::type_id::create("smtdv_mem_bkdor_rd_comp", this);
endfunction : build_phase

/**
 * connect(link) cmp to backend threads
 */
function void smtdv_scoreboard::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  th0.register(this); th_handler.add(th0);
  th1.register(this); th_handler.add(th1);
  th2.register(this); th_handler.add(th2);
  th3.register(this); th_handler.add(th3);
endfunction : connect_phase

/**
 * check initiator and targets are constructed
 */
function void smtdv_scoreboard::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  for(int i=0; i<NUM_OF_INITOR; i++) begin
    if(!uvm_config_db#(T2)::get(this, "", {$psprintf("initor_m[%0d]", i)}, initor_m[i]))
      `uvm_fatal("SMTDV_SCB_NO_INITOR", {"MASTER AGENT MUST BE SET ", get_full_name(), {$psprintf(".initor_m[%0d]", i)}});
  end
  for(int i=0; i<NUM_OF_TARGETS; i++) begin
    if(!uvm_config_db#(T3)::get(this, "", {$psprintf("targets_s[%0d]", i)}, targets_s[i]))
      `uvm_fatal("SMTDV_SCB_NO_INITOR", {"SLAVE AGENT MUST BE SET ", get_full_name(), {$psprintf(".targets_s[%0d]", i)}});
  end
  th_handler.finalize();
endfunction : end_of_elaboration_phase

/**
 *  reset_scoreboard while resetn assert
 */
function void smtdv_scoreboard::reset_scoreboard();
  bit [ADDR_WIDTH-1:0] addr;
  while(wr_pool.next(addr)) begin
    wr_pool.delete(addr);
  end
  while(rd_pool.next(addr)) begin
    rd_pool.delete(addr);
  end
endfunction : reset_scoreboard

/**
 *  do as watchdog to detect any violations
 */
task smtdv_scoreboard::run_phase(uvm_phase phase);
  fork
    super.run_phase(phase);
  join_none

  forever begin
    reset_scoreboard();
    wait(resetn);

    fork
      fork
      begin
        @(negedge resetn);
      end

    join_any

    th_handler.run();
  join
  disable fork;
  end
endtask : run_phase


/**
 *  bind at master side uvm_analysis_imp_initor
 */
function void smtdv_scoreboard::write_initor(T1 item);
  this._write_initor(item);
  // make sure master RD trx is success trx without err after slave deasserted
  if (item.success && item.trs_t == RD) begin
    rbox.push_back(item);
  end
endfunction : write_initor


/**
 * bind at slave side uvm_analysis_imp_target
 */
function void smtdv_scoreboard::write_target(T1 item);
  this._write_target(item);
  // make sure master WR trx is success trx without err before slave asserted
  if (item.success && item.trs_t == WR) begin
    wbox.push_back(item);
  end
endfunction : write_target

/**
 * make sure trx at initor side is ok
 * wr seq, initor will put wr seq into wr_pool, target will check it later
 * rd seq, initor will check rd seq back is ok after target is already put rd seq into rd fifo
 */
function void smtdv_scoreboard::_write_initor(T1 item);
  T1 it;
  bit [ADDR_WIDTH-1:0] addr;

  // slice to atomic seq
  foreach(item.addrs[i]) begin
    atmic_item = T1::type_id::create("atomic_item");
    atmic_item.addrs[0] = item.addrs[i];
    atmic_item.data_beat[0] = item.data_beat[i];
    atmic_item.trs_t = item.trs_t;
    if (item.byten_beat.size() > 0) begin
      atmic_item.byten_beat[0] = item.byten_beat[i];
    end
    atmic_item.parent = item;

    // WR: put WR to wait pool when initor sent
    if (item.trs_t == WR) begin
      wr_pool[item.addrs[i]].push_back(atmic_item);
      `uvm_info(get_full_name(), {$psprintf("PUT wr_pool WRITE ATMIC ITEM %h\n%s", item.addrs[i], atmic_item.sprint())}, UVM_LOW)
    end
    // RD: compare RD at wait pool when target sent
    else if (item.trs_t == RD)begin
      if (rd_pool[item.addrs[i]].size() > 0) begin
        it = rd_pool[item.addrs[i]].pop_front();
        if (!it.compare(atmic_item)) begin
          `uvm_error("SMTDV_SCB_RD_COMP", {$psprintf("RECEIVED WRONG DATA %h\n%s", item.addrs[i], item.sprint())})
        end
        `uvm_info(get_full_name(), {$psprintf("POP rd_pool READ ATMIC ITEM %h\n%s", item.addrs[i], it.sprint())}, UVM_LOW)
      end
      else begin
        while (rd_pool.next(addr)) begin
          foreach(rd_pool[addr][i]) begin
            it = rd_pool[addr][i];
            `uvm_warning(get_full_name(), {$psprintf("AT rd_pool: %h \n%s", addr, it.sprint())})
          end
        end

        `uvm_error("SMTDV_SCB_RD_COMP", {$psprintf("RECEIVED NOTFOUND DATA %h\n%s", item.addrs[i], item.sprint())})
      end
    end
  end
endfunction : _write_initor

/*
 * make sure trx at target side is ok
 * wr seq, target will check wr seq is ok after initor is already put wr seq into wr fifo
 * rd seq, target will put rd seq into rd_pool, initor will check it later
 */
function void smtdv_scoreboard::_write_target(T1 item);
  T1 it;
  bit [ADDR_WIDTH-1:0] addr;

  // slice to atomic seq
  foreach(item.addrs[i]) begin
    atmic_item = T1::type_id::create("atomic_item");
    atmic_item.addrs[0] = item.addrs[i];
    atmic_item.data_beat[0] = item.data_beat[i];
    atmic_item.trs_t = item.trs_t;
    if (item.byten_beat.size() > 0) begin
      atmic_item.byten_beat[0] = item.byten_beat[i];
    end
    atmic_item.parent = item;

    // RD: put RD to wait pool when target sent
    if (item.trs_t == RD) begin
      rd_pool[item.addrs[i]].push_back(atmic_item);
      `uvm_info(get_full_name(), {$psprintf("PUT rd_pool READ ATMIC ITEM %h\n%s", item.addrs[i], atmic_item.sprint())}, UVM_LOW)
    end
    // WR: compare WR at wait pool when initor sent
    else if (item.trs_t == WR)begin
      if (wr_pool[item.addrs[i]].size() > 0) begin
        it = wr_pool[item.addrs[i]].pop_front();
        if (!it.compare(atmic_item)) begin
          `uvm_error("SMTDV_SCB_WR_COMP", {$psprintf("RECEIVED WRONG DATA %h\n%s", item.addrs[i], item.sprint())})
        end
        `uvm_info(get_full_name(), {$psprintf("POP wr_pool WRITE ATMIC ITEM %h\n%s", item.addrs[i], it.sprint())}, UVM_LOW)
      end
      else begin
        while (wr_pool.next(addr)) begin
          foreach(wr_pool[addr][i]) begin
            it = wr_pool[addr][i];
            `uvm_warning(get_full_name(), {$psprintf("AT wr_pool: %h \n%s", addr, it.sprint())})
          end
        end

        `uvm_error("SMTDV_SCB_WR_COMP", {$psprintf("RECEIVED NOTFOUND DATA %h\n%s", item.addrs[i], item.sprint())})
      end
    end
  end
endfunction : _write_target


`endif // end of __SMTDV_SCOREBOARD_SV__
