
`ifndef __SMTDV_BACKDOOR_THREADS_SV__
`define __SMTDV_BACKDOOR_THREADS_SV__

typedef class smtdv_scoreboard;

class smtdv_backdoor_base_thread #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type T2 = smtdv_master_agent,
  type T3 = smtdv_slave_agent,
  CFG = smtdv_cfg)
    extends
  smtdv_run_thread;

  `SMTDV_SCOREBOARD cmp;
  T1 item;
  T1 ritem;

  `uvm_object_param_utils_begin(`SMTDV_BACKDOOR_BASE_THREAD)
  `uvm_object_utils_end

   function new(string name = "smtdv_backdoor_base_thread", smtdv_component parent=null);
     super.new(name, parent);
   endfunction

    virtual function void pre_do();
      if ($cast(cmp, this.cmp)) begin
        `uvm_fatal("NOCMP",{"cmp must be set for: ",get_full_name(),".cmp"});
     end
    endfunction

endclass


// write through/back
class smtdv_mem_bkdor_wr_comp #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type T2 = smtdv_master_agent,
  type T3 = smtdv_slave_agent,
  CFG = smtdv_cfg)
    extends
  `SMTDV_BACKDOOR_BASE_THREAD;

   `uvm_object_param_utils_begin(`SMTDV_MEM_BKDOR_WR_COMP)
   `uvm_object_utils_end

    function new(string name = "smtdv_mem_bkdor_wr_comp", smtdv_component parent=null);
      super.new(name, parent);
    endfunction

    virtual task run();
      int sid;
      string table_nm;

      forever begin
        sid = -1;
        wait(this.cmp.rbox.size()>0);
        item = this.cmp.rbox.pop_front();
        sid = this.cmp.initor_m[0].cfg.find_slave(item.addr);
        if (sid<0) begin
          `uvm_fatal("NOREGISTER",{"slave addr must be register to master cfg: ", this.cmp.initor_m[0].cfg.get_full_name()});
        end
        table_nm = $psprintf("\"%s\"", this.cmp.targets_s[sid].seqr.get_full_name());

        // check mem backdoor data is match expected until timeout
        while(this.cmp.bkdor_wr.timeout>0) begin
          if (this.cmp.bkdor_wr.match == FALSE) begin
            if (this.cmp.bkdor_wr.compare(table_nm, item, ritem)) begin
              this.cmp.bkdor_wr.match = TRUE;
              break;
            end
          end
          @(posedge cmp.initor_m[0].vif.clk);
          this.cmp.bkdor_wr.timeout--;
        end

        if (this.cmp.bkdor_wr.match == FALSE) begin
          `uvm_error(cmp.get_full_name(), {$psprintf("BACKDOOR COMPARE WRONG DATA \n%s, %s", item.sprint(), ritem.sprint())})
        end
        this.cmp.bkdor_wr.match = FALSE;
      end
    endtask

endclass


class smtdv_mem_bkdor_rd_comp #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type T2 = smtdv_master_agent,
  type T3 = smtdv_slave_agent,
  CFG = smtdv_cfg)
    extends
  `SMTDV_BACKDOOR_BASE_THREAD;

   `uvm_object_param_utils_begin(`SMTDV_MEM_BKDOR_RD_COMP)
   `uvm_object_utils_end

    function new(string name = "mem_bkdor_rd_comp", smtdv_component parent=null);
      super.new(name, parent);
    endfunction

    virtual task run();
      int sid;
      string table_nm;

      forever begin
        sid = -1;
        wait(this.cmp.wbox.size()>0);
        item = this.cmp.wbox.pop_front();
        sid = this.cmp.initor_m[0].cfg.find_slave(item.addr);
        if (sid<0) begin
          `uvm_fatal("NOREGISTER",{"slave addr must be register to master cfg: ", this.cmp.initor_m[0].cfg.get_full_name()});
        end
        table_nm = $psprintf("\"%s\"", this.cmp.targets_s[sid].seqr.get_full_name());

        while(this.cmp.bkdor_rd.timeout>0) begin
          if (this.cmp.bkdor_rd.match == FALSE) begin
            if (this.cmp.bkdor_rd.compare(table_nm, item, ritem)) begin
              this.cmp.bkdor_rd.match = TRUE;
              break;
            end
          end
          @(posedge this.cmp.initor_m[0].vif.clk);
          this.cmp.bkdor_rd.timeout--;
        end

        if (this.cmp.bkdor_rd.match == FALSE) begin
          `uvm_error(this.cmp.get_full_name(), {$psprintf("BACKDOOR COMPARE WRONG DATA \n%s, %s", item.sprint(), ritem.sprint())})
        end
        this.cmp.bkdor_rd.match = FALSE;
      end
    endtask

endclass


`endif // end of __SMTDV_BACKDOOR_THREADS_SV__
