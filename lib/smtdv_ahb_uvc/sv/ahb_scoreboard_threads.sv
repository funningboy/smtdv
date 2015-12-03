`ifndef __AHB_SCOREBOARD_THREADS_SV__
`define __AHB_SCOREBOARD_THREADS_SV__

typedef  class  ahb_base_scoreboard;

// write through/back
class ahb_mem_bkdor_wr_comp #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4
) extends
  smtdv_run_thread;

  `AHB_ITEM item, ritem;
  `AHB_BASE_SCOREBOARD scb;
  `AHB_MEM_BACKDOOR bkdor;

   `uvm_object_param_utils_begin(`AHB_MEM_BKDOR_WR_COMP)
   `uvm_object_utils_end

    function new(string name = "ahb_mem_bkdor_wr_comp");
      super.new(name);
      bkdor = new("ahb_mem_bkdor_wr_comp");
    endfunction

    virtual task run();
      int sid;
      string table_nm;

      forever begin
        sid = -1;
        wait(scb.rbox.size()>0);
        item = scb.rbox.pop_front();
        sid = scb.initor_m[0].cfg.find_slave(item.addr);
        if (sid<0) begin
          `uvm_fatal("NOREGISTER",{"ahb slave addr must be register to master cfg: ", scb.initor_m[0].cfg.get_full_name()});
        end
        table_nm = $psprintf("\"%s\"", scb.targets_s[sid].seqr.get_full_name());

        while(bkdor.timeout>0) begin
          if (bkdor.match == FALSE) begin
            if (bkdor.compare(table_nm, item, ritem)) begin
              bkdor.match = TRUE;
            end
          end
          @(posedge scb.initor_m[0].vif.clk);
          bkdor.timeout--;
        end

        if (bkdor.match == FALSE) begin
          `uvm_error(scb.get_full_name(), {$psprintf("BACKDOOR COMPARE WRONG DATA \n%s, %s", item.sprint(), ritem.sprint())})
        end
        bkdor.match = FALSE;
      end
    endtask

endclass

class ahb_mem_bkdor_rd_comp #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4
) extends
  smtdv_run_thread;

  `AHB_ITEM item, ritem;
  `AHB_BASE_SCOREBOARD scb;
  `AHB_MEM_BACKDOOR bkdor;

   `uvm_object_param_utils_begin(`AHB_MEM_BKDOR_RD_COMP)
   `uvm_object_utils_end

    function new(string name = "ahb_mem_bkdor_rd_comp");
      super.new(name);
      bkdor = new("ahb_mem_bkdor_rd_comp");
    endfunction

    virtual task run();
      int sid;
      string table_nm;

      forever begin
        sid = -1;
        wait(scb.wbox.size()>0);
        item = scb.wbox.pop_front();
        sid = scb.initor_m[0].cfg.find_slave(item.addr);
        if (sid<0) begin
          `uvm_fatal("NOREGISTER",{"ahb slave addr must be register to master cfg: ", scb.initor_m[0].cfg.get_full_name()});
        end
        table_nm = $psprintf("\"%s\"", scb.targets_s[sid].seqr.get_full_name());

        while(bkdor.timeout>0) begin
          if (bkdor.match == FALSE) begin
            if (bkdor.compare(table_nm, item, ritem)) begin
              bkdor.match = TRUE;
            end
          end
          @(posedge scb.initor_m[0].vif.clk);
          bkdor.timeout--;
        end

        if (bkdor.match == FALSE) begin
          `uvm_error(scb.get_full_name(), {$psprintf("BACKDOOR COMPARE WRONG DATA \n%s, %s", item.sprint(), ritem.sprint())})
        end
        bkdor.match = FALSE;
      end
    endtask

endclass

`endif // end of __AHB_SCOREBOARD_THREADS_SV__

