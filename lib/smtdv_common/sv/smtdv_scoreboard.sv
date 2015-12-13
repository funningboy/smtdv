
`ifndef __SMTDV_SCOREBOARD_SV__
`define __SMTDV_SCOREBOARD_SV__

class smtdv_scoreboard #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = smtdv_sequence_item #(ADDR_WIDTH, DATA_WIDTH),
  type T2 = smtdv_master_agent,
  type T3 = smtdv_slave_agent,
  CFG = smtdv_cfg)
    extends
  smtdv_component#(uvm_scoreboard);

  `uvm_analysis_imp_decl(_initor)
  `uvm_analysis_imp_decl(_target)

  smtdv_thread_handler #(CFG) th_handler;

  T1 rbox[$];  // rd mem channel backdoor
  T1 wbox[$];  // wr mem channel backdoor

  // queue of associative arry
  typedef bit [ADDR_WIDTH-1:0] addr_t;
  T1 wr_pool[addr_t][$];
  T1 rd_pool[addr_t][$];

  `SMTDV_BACKDOOR bkdor_wr;
  `SMTDV_BACKDOOR bkdor_rd;

  `SMTDV_WATCH_WR_LIFETIME th0;
  `SMTDV_WATCH_RD_LIFETIME th1;
  `SMTDV_MEM_BKDOR_WR_COMP th2;
  `SMTDV_MEM_BKDOR_RD_COMP th3;

  T1 atmic_item;
  T2 initor_m[NUM_OF_INITOR];
  T3 targets_s[NUM_OF_TARGETS];

  uvm_analysis_imp_initor #(T1, `SMTDV_SCOREBOARD) initor[NUM_OF_INITOR];
  uvm_analysis_imp_target #(T1, `SMTDV_SCOREBOARD) targets[NUM_OF_TARGETS];

  `uvm_component_param_utils(`SMTDV_SCOREBOARD)

  function new(string name = "smtdv_scoreboard", uvm_component parent);
    super.new(name, parent);
    for(int i=0; i<NUM_OF_INITOR; i++) begin
      initor[i] = new({$psprintf("initor[%0d]", i)}, this);
    end
    for(int i=0; i<NUM_OF_TARGETS; i++) begin
      targets[i] = new({$psprintf("targets[%0d]", i)}, this);
    end
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    bkdor_wr = `SMTDV_BACKDOOR::type_id::create("smtdv_mem_bkdor_wr_comp", this);
    bkdor_rd = `SMTDV_BACKDOOR::type_id::create("smtdv_mem_bkdor_rd_comp", this);

    th_handler = smtdv_thread_handler#(CFG)::type_id::create("smtdv_driver_threads", this);

    th0 = `SMTDV_WATCH_WR_LIFETIME::type_id::create("smtdv_watch_wr_lifetime", this);
    th1 = `SMTDV_WATCH_RD_LIFETIME::type_id::create("smtdv_watch_rd_lifetime", this);
    th2 = `SMTDV_MEM_BKDOR_WR_COMP::type_id::create("smtdv_mem_bkdor_wr_comp", this);
    th3 = `SMTDV_MEM_BKDOR_RD_COMP::type_id::create("smtdv_mem_bkdor_rd_comp", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    th0.cmp = this; this.th_handler.add(th0);
    th1.cmp = this; this.th_handler.add(th1);
    th2.cmp = this; this.th_handler.add(th2);
    th3.cmp = this; this.th_handler.add(th3);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    for(int i=0; i<NUM_OF_INITOR; i++) begin
      if(!uvm_config_db#(T2)::get(this, "", {$psprintf("initor_m[%0d]", i)}, initor_m[i]))
        `uvm_fatal("NOINITOR",{"master agent must be set for: ",get_full_name(), {$psprintf(".initor_m[%0d]", i)}});
    end
    for(int i=0; i<NUM_OF_TARGETS; i++) begin
      if(!uvm_config_db#(T3)::get(this, "", {$psprintf("targets_s[%0d]", i)}, targets_s[i]))
        `uvm_fatal("NOINITOR",{"slave agent must be set for: ",get_full_name(), {$psprintf(".targets_s[%0d]", i)}});
    end
  endfunction

  virtual function void reset_scoreboard();
    bit [ADDR_WIDTH-1:0] addr;
    while(wr_pool.next(addr)) begin
      wr_pool.delete(addr);
    end
    while(rd_pool.next(addr)) begin
      rd_pool.delete(addr);
    end
  endfunction

  // as timeout watch dog
  virtual task run_phase(uvm_phase phase);
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
  endtask


  // bind at master side uvm_analysis_imp_initor
  virtual function void write_initor(T1 item);
    if (!item.success)
      return;
    this._write_initor(item);
    // make sure master RD trx is success after slave deasserted
    if (item.success && item.trs_t == RD) begin
      rbox.push_back(item);
    end
  endfunction

  // bind at slave side uvm_analysis_imp_target
  virtual function void write_target(T1 item);
    this._write_target(item);
    // make sure master WR trx is success before slave asserted
    if (item.success && item.trs_t == WR) begin
      wbox.push_back(item);
    end
  endfunction

  // bind at master side
  virtual function void _write_initor(T1 item);
    T1 it;
    bit [ADDR_WIDTH-1:0] addr;

   // slice to atomic seq
    foreach(item.addrs[i]) begin
      atmic_item = T1::type_id::create("smtdv_item");
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
        `uvm_info(get_full_name(), {$psprintf("put wr_pool write atmic item %h\n%s", item.addrs[i], atmic_item.sprint())}, UVM_LOW)
      end
      // RD: compare RD at wait pool when target sent
      else if (item.trs_t == RD)begin
        if (rd_pool[item.addrs[i]].size() > 0) begin
          it = rd_pool[item.addrs[i]].pop_front();
          if (!it.compare(atmic_item)) begin
          `uvm_error(get_full_name(), {$psprintf("RECEIVED WRONG DATA %h\n%s", item.addrs[i], item.sprint())})
          end
        `uvm_info(get_full_name(), {$psprintf("pop rd_pool read atmic item %h\n%s", item.addrs[i], it.sprint())}, UVM_LOW)
        end
        else begin
          while (rd_pool.next(addr)) begin
            foreach(rd_pool[addr][i]) begin
              it = rd_pool[addr][i];
              `uvm_warning(get_full_name(), {$psprintf("at rd_pool: %h \n%s", addr, it.sprint())})
            end
          end

          `uvm_error(get_full_name(), {$psprintf("RECEIVED NOTFOUND DATA %h\n%s", item.addrs[i], item.sprint())})
        end
      end
    end
  endfunction

  // bind at slave side
  virtual function void _write_target(T1 item);
    T1 it;
    bit [ADDR_WIDTH-1:0] addr;

    // slice to atomic seq
    foreach(item.addrs[i]) begin
      atmic_item = T1::type_id::create("smtdv_item");
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
        `uvm_info(get_full_name(), {$psprintf("put rd_pool read atmic item %h\n%s", item.addrs[i], atmic_item.sprint())}, UVM_LOW)
      end
      // WR: compare WR at wait pool when initor sent
      else if (item.trs_t == WR)begin
        if (wr_pool[item.addrs[i]].size() > 0) begin
          it = wr_pool[item.addrs[i]].pop_front();
          if (!it.compare(atmic_item)) begin
          `uvm_error(get_full_name(), {$psprintf("RECEIVED WRONG DATA %h\n%s", item.addrs[i], item.sprint())})
          end
          `uvm_info(get_full_name(), {$psprintf("pop wr_pool write atmic item %h\n%s", item.addrs[i], it.sprint())}, UVM_LOW)
        end
        else begin
          while (wr_pool.next(addr)) begin
            foreach(wr_pool[addr][i]) begin
              it = wr_pool[addr][i];
              `uvm_warning(get_full_name(), {$psprintf("at wr_pool: %h \n%s", addr, it.sprint())})
            end
          end

          `uvm_error(get_full_name(), {$psprintf("RECEIVED NOTFOUND DATA %h\n%s", item.addrs[i], item.sprint())})
        end
      end
    end
  endfunction

endclass : smtdv_scoreboard

`endif // end of __SMTDV_SCOREBOARD_SV__
