`ifndef __SMTDV_SCOREBOARD_THREADDS_SV__
`define __SMTDV_SCOREBOARD_THREADDS_SV__

typedef class smtdv_scoreboard;

class smtdv_watch_wr_lifetime #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = `SMTDV_SEQUENCE_ITEM,
  type T2 = T1,
  CFG = uvm_object)
    extends
  smtdv_run_thread;

  int watch_per_ns = 100;
  `SMTDV_SCOREBOARD cmp;
  `SMTDV_SEQUENCE_ITEM item;

  `uvm_object_param_utils_begin(`SMTDV_WATCH_WR_LIFETIME)
  `uvm_object_utils_end

   function new(string name = "smtdv_watch_wr_lifetime");
     super.new(name);
   endfunction

   virtual task run();
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
  endtask

endclass


class smtdv_watch_rd_lifetime #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = `SMTDV_SEQUENCE_ITEM,
  type T2 = T1,
  CFG = uvm_object)
    extends
  smtdv_run_thread;

  int watch_per_ns = 100;
  `SMTDV_SCOREBOARD cmp;
  `SMTDV_SEQUENCE_ITEM item;

  `uvm_object_param_utils_begin(`SMTDV_WATCH_RD_LIFETIME)
  `uvm_object_utils_end

   function new(string name = "smtdv_watch_rd_lifetime");
     super.new(name);
   endfunction

   virtual task run();
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
  endtask

endclass

`endif // end of __SMTDV_SCOREBOARD_THREADDS_SV__
