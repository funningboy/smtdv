
`ifndef __SMTDV_MEM_BKDOR_RD_COMP_THREADS_SV__
`define __SMTDV_MEM_BKDOR_RD_COMP_THREADS_SV__

typedef class smtdv_sequence_item;
typedef class smtdv_master_agent;
typedef class smtdv_slave_agent;
typedef class smtdv_cfg;
typedef class smtdv_backdoor_base_thread;

/**
* smtdv_mem_backdoor_rd_thread
* check read through from mem is ok
*
* @class smtdv_mem_bkdor_rd_comp#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR,
* NUM_OF_TARGETS, T1, T2, T3, CFG)
*
*/
class smtdv_mem_bkdor_rd_comp#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH),
  type T2 = smtdv_master_agent,
  type T3 = smtdv_slave_agent,
  type CFG = smtdv_cfg
  ) extends
  smtdv_backdoor_base_thread#(
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
  typedef smtdv_mem_bkdor_rd_comp#(ADDR_WIDTH, DATA_WIDTH, NUM_OF_INITOR, NUM_OF_TARGETS, T1, T2, T3, CFG) bk_rd_t;
  T1 item, ritem;

  `uvm_object_param_utils_begin(bk_rd_t)
  `uvm_object_utils_end

  function new(string name = "mem_bkdor_rd_comp", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual task run();

endclass : smtdv_mem_bkdor_rd_comp


task smtdv_mem_bkdor_rd_comp::run();
  int sid;
  int timeout;
  string table_nm;
  bit match;

  if (this.cmp.bkdor_rd.timeout<0)
  `uvm_fatal("SMTDV_BKDOR_NO_TIMEOUT",
      {$psprintf("TIMEOUT MUST BE SET %d >0", this.cmp.bkdor_rd.timeout)});

  forever begin
    sid = -1;
    match = FALSE;
    timeout = this.cmp.bkdor_rd.timeout;

    wait(this.cmp.rbox.size()>0);
    item = this.cmp.rbox.pop_front();
    sid = this.cmp.initor_m[0].cfg.find_slave(item.addr);

    if (sid<0)
      `uvm_fatal("SMTDV_BKDOR_NO_CFG",
          {$psprintf("SLAVE ADDR %h MUST BE SET FOR MASTER CFG %s", item.addr, this.cmp.initor_m[0].cfg.get_full_name())});

    table_nm = $psprintf("\"%s\"", this.cmp.targets_s[sid].seqr.get_full_name());

    while(timeout>0) begin
      if (match == FALSE) begin
        if (this.cmp.bkdor_rd.compare(table_nm, item, ritem)) begin
          match = TRUE;
          break;
        end
      end
      @(posedge this.cmp.initor_m[0].vif.clk);
      timeout--;
    end

    if (match == FALSE) begin
      if (item && ritem)
        `uvm_error("SMTDV_BKDOR_CMP",
            {$psprintf("BACKDOOR COMPARE WRDONG DATA \n%s, %s", item.sprint(), ritem.sprint())})
      else
        `uvm_error("SMTDV_BKDOR_CMP",
            {$psprintf("BACKDOOR COMPARE WRDONG DATA \n%s, null", item.sprint())})
    end

    if (this.cmp.initor_m[0].cfg.has_debug)
      update_timestamp();

  end
endtask : run


`endif // end of __SMTDV_MEM_BKDOR_RD_COMP_THREADS_SV__
