
`ifndef __SMTDV_SCOREBOARD_SV__
`define __SMTDV_SCOREBOARD_SV__

// macro should been imp at your scoreboard
//`uvm_analysis_imp_decl(_initor)
//`uvm_analysis_imp_decl(_target)

`define SMTDV_SCOREBOARD smtdv_scoreboard#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_TARGETS, NUM_OF_TARGETS, T1, T2)
`define SMTDV_SEQUENCE_ITEM smtdv_sequence_item

class smtdv_scoreboard #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = smtdv_sequence_item,
  type T2 = T1)
    extends
  smtdv_component#(uvm_scoreboard);

  smtdv_sequence_item wr_pool[ADDR_WIDTH-1:0][$];
  smtdv_sequence_item rd_pool[ADDR_WIDTH-1:0][$];

  smtdv_sequence_item atmic_item;
  int watch_per_ns = 1000;

//  smtdv_agent initor_ptr[NUM_OF_INITOR];
//  smtdv_agent targets_ptr[NUM_OF_TARGETS];

// macro should been imp at your scoreboard
//  uvm_analysis_imp_initor #(smtdv_sequence_item, `SMTDV_SCOREBOARD) initor[NUM_OF_INITOR];
//  uvm_analysis_imp_target #(smtdv_sequence_item, `SMTDV_SCOREBOARD) targets[NUM_OF_TARGETS];

  `uvm_component_param_utils(`SMTDV_SCOREBOARD)

  function new(string name = "smtdv_scoreboard", uvm_component parent);
    super.new(name, parent);
// macro should been imp at your scoreboard
//    for(int i=0; i<NUM_OF_INITOR; i++) begin
//      initor[i] = new({$psprintf("initor[%0d]", i)}, this);
//    end
//    for(int i=0; i<NUM_OF_TARGETS; i++) begin
//      targets[i] = new({$psprintf("targets[%0d]", i)}, this);
//    end
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

          begin
            watch_wr_life_time();
            end

          begin
            watch_rd_life_time();
         end

        join_any
      join
      disable fork;
    end
  endtask

  virtual task watch_wr_life_time();
    smtdv_sequence_item it;
    forever begin: check_wr_pool
      #watch_per_ns;
      foreach(wr_pool[i])begin
        foreach(wr_pool[i][j]) begin
          it = wr_pool[i][j];
          if (it.life_time<0) begin
            `uvm_error(get_type_name(), {$psprintf("RUN OUT OF LIFE TIMEOUT DATA \n%s", it.sprint())})
          end
          it.life_time--;
        end
      end
    end
   endtask

  virtual task watch_rd_life_time();
    smtdv_sequence_item it;
    forever begin: check_rd_pool
      #watch_per_ns;
      foreach(rd_pool[i])begin
        foreach(rd_pool[i][j]) begin
          it = rd_pool[i][j];
          if (it.life_time<0) begin
            `uvm_error(get_type_name(), {$psprintf("RUN OUT OF LIFE TIMEOUT DATA \n%s", it.sprint())})
          end
          it.life_time--;
        end
      end
    end
  endtask

  // bind at master side
  virtual function void _write_initor(smtdv_sequence_item item);
    smtdv_sequence_item it;

    foreach(item.addrs[i]) begin
      atmic_item = smtdv_sequence_item::type_id::create("smtdv_item");
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
      // RD: cmp RD at wait pool when target sent
      else if (item.trs_t == RD)begin
        if (rd_pool[item.addrs[i]].size() > 0) begin
          it = rd_pool[item.addrs[i]].pop_front();
          if (!it.compare(atmic_item)) begin
          `uvm_error(get_type_name(), {$psprintf("RECEIVED WRONG DATA \n%s", item.sprint())})
          end
        end
        else begin
          `uvm_error(get_type_name(), {$psprintf("RECEIVED NOTFOUND DATA \n%s", item.sprint())})
        end
      end
    end
  endfunction

  // bind at slave side
  virtual function void _write_target(smtdv_sequence_item item);
    smtdv_sequence_item it;

    foreach(item.addrs[i]) begin
      atmic_item = smtdv_sequence_item::type_id::create("smtdv_item");
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
      // WR: cmp WR at wait pool when initor sent
      else if (item.trs_t == WR)begin
        if (wr_pool[item.addrs[i]].size() > 0) begin
          it = wr_pool[item.addrs[i]].pop_front();
          if (!it.compare(atmic_item)) begin
          `uvm_error(get_type_name(), {$psprintf("RECEIVED WRONG DATA \n%s", item.sprint())})
          end
        end
        else begin
          `uvm_error(get_type_name(), {$psprintf("RECEIVED NOTFOUND DATA \n%s", item.sprint())})
        end
      end
    end
  endfunction

endclass : smtdv_scoreboard

`endif // end of __SMTDV_SCOREBOARD_SV__
