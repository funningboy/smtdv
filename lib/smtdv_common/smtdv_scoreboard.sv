
`ifndef __SMTDV_SCOREBOARD_SV__
`define __SMTDV_SCOREBOARD_SV__

// virtual macro should been imp at your scoreboard
//`uvm_analysis_imp_decl(_initor)
//`uvm_analysis_imp_decl(_target)

class smtdv_scoreboard #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = `SMTDV_SEQUENCE_ITEM,
  type T2 = T1,
  CFG = uvm_object)
    extends
  smtdv_component#(uvm_scoreboard);

  smtdv_thread_handler #(CFG) th_handler;

  `SMTDV_SEQUENCE_ITEM wr_pool[ADDR_WIDTH-1:0][$];
  `SMTDV_SEQUENCE_ITEM rd_pool[ADDR_WIDTH-1:0][$];

  `SMTDV_WATCH_WR_LIFETIME th0;
  `SMTDV_WATCH_RD_LIFETIME th1;

  `SMTDV_SEQUENCE_ITEM atmic_item;

// virtual macro should been imp at your scoreboard
//  uvm_analysis_imp_initor #(`SMTDV_SEQUENCE_ITEM, `SMTDV_SCOREBOARD) initor[NUM_OF_INITOR];
//  uvm_analysis_imp_target #(`SMTDV_SEQUENCE_ITEM, `SMTDV_SCOREBOARD) targets[NUM_OF_TARGETS];

  `uvm_component_param_utils(`SMTDV_SCOREBOARD)

  function new(string name = "smtdv_scoreboard", uvm_component parent);
    super.new(name, parent);
    th_handler = smtdv_thread_handler#(CFG)::type_id::create("smtdv_driver_threads", this);

// virtual macro should been imp at your scoreboard
//    for(int i=0; i<NUM_OF_INITOR; i++) begin
//      initor[i] = new({$psprintf("initor[%0d]", i)}, this);
//    end
//    for(int i=0; i<NUM_OF_TARGETS; i++) begin
//      targets[i] = new({$psprintf("targets[%0d]", i)}, this);
//    end
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = `SMTDV_WATCH_WR_LIFETIME::type_id::create("smtdv_watch_wr_lifetime"); th0.cmp = this; this.th_handler.add(th0);
    th1 = `SMTDV_WATCH_RD_LIFETIME::type_id::create("smtdv_watch_rd_lifetime"); th1.cmp = this; this.th_handler.add(th1);
  endfunction

  virtual function void reset_scoreboard();
    foreach(wr_pool[i]) begin
      wr_pool[i] = {};
    end
    foreach(rd_pool[i]) begin
      rd_pool[i] = {};
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


  // bind at master side
  virtual function void _write_initor(`SMTDV_SEQUENCE_ITEM item);
    `SMTDV_SEQUENCE_ITEM it;
    foreach(item.addrs[i]) begin
      atmic_item = `SMTDV_SEQUENCE_ITEM::type_id::create("smtdv_item");
      atmic_item.addrs[i] = item.addrs[i];
      atmic_item.data_beat[i] = item.data_beat[i];
      if (item.byten_beat.size() > 0) begin
        atmic_item.byten_beat[i] = item.byten_beat[i];
      end
      atmic_item.parent = item;

      // WR: put WR to wait pool when initor sent
      if (item.trs_t == WR) begin
        wr_pool[item.addrs[i]].push_back(atmic_item);
      end
      // RD: compare RD at wait pool when target sent
      else if (item.trs_t == RD)begin
        if (rd_pool[item.addrs[i]].size() > 0) begin
          it = rd_pool[item.addrs[i]].pop_front();
          if (!it.compare(atmic_item)) begin
          `uvm_error(get_full_name(), {$psprintf("RECEIVED WRONG DATA \n%s", item.sprint())})
          end
        end
        else begin
          `uvm_error(get_full_name(), {$psprintf("RECEIVED NOTFOUND DATA \n%s", item.sprint())})
        end
      end
    end
  endfunction

  // bind at slave side
  virtual function void _write_target(`SMTDV_SEQUENCE_ITEM item);
    `SMTDV_SEQUENCE_ITEM it;

    foreach(item.addrs[i]) begin
      atmic_item = `SMTDV_SEQUENCE_ITEM::type_id::create("smtdv_item");
      atmic_item.addrs[i] = item.addrs[i];
      atmic_item.data_beat[i] = item.data_beat[i];
      if (item.byten_beat.size() > 0) begin
        atmic_item.byten_beat[i] = item.byten_beat[i];
      end
      atmic_item.parent = item;

      // RD: put RD to wait pool when target sent
      if (item.trs_t == RD) begin
        rd_pool[item.addrs[i]].push_back(atmic_item);
      end
      // WR: compare WR at wait pool when initor sent
      else if (item.trs_t == WR)begin
        if (wr_pool[item.addrs[i]].size() > 0) begin
          it = wr_pool[item.addrs[i]].pop_front();
          if (!it.compare(atmic_item)) begin
          `uvm_error(get_full_name(), {$psprintf("RECEIVED WRONG DATA \n%s", item.sprint())})
          end
        end
        else begin
          `uvm_error(get_full_name(), {$psprintf("RECEIVED NOTFOUND DATA \n%s", item.sprint())})
        end
      end
    end
  endfunction

endclass : smtdv_scoreboard

`endif // end of __SMTDV_SCOREBOARD_SV__
