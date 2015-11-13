
`ifndef __AHB_SCOREBOARD_SV__
`define __AHB_SCOREBOARD_SV__

class ahb_base_scoreboard #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 4
 ) extends
    smtdv_scoreboard#(
      ADDR_WIDTH,
      DATA_WIDTH,
      NUM_OF_TARGETS,
      NUM_OF_TARGETS
    );

  `uvm_analysis_imp_decl(_initor)
  `uvm_analysis_imp_decl(_target)

  `AHB_ITEM rbox[$]; // rd mem channel backdoor
  `AHB_ITEM wbox[$]; // wr mem channel backdoor

  `AHB_MEM_BKDOR_WR_COMP thc0;
  `AHB_MEM_BKDOR_RD_COMP thc1;

  `AHB_ITEM wr_pool[ADDR_WIDTH-1:0][$];
  `AHB_ITEM rd_pool[ADDR_WIDTH-1:0][$];

  `AHB_ITEM atmic_item;

  `AHB_MASTER_AGENT initor_m[NUM_OF_INITOR];
  `AHB_SLAVE_AGENT targets_s[NUM_OF_TARGETS];

  uvm_analysis_imp_initor #(`AHB_ITEM, `AHB_BASE_SCOREBOARD) initor[NUM_OF_INITOR];
  uvm_analysis_imp_target #(`AHB_ITEM, `AHB_BASE_SCOREBOARD) targets[NUM_OF_TARGETS];

  `uvm_component_param_utils_begin(`AHB_BASE_SCOREBOARD)
  `uvm_component_utils_end

  function new (string name = "ahb_scoreboard", uvm_component parent);
    super.new(name, parent);
    if (NUM_OF_INITOR>1) begin
      `uvm_fatal("VOIINITOR",{"initor size must be set for 1: ",get_full_name()});
    end
    for(int i=0; i<NUM_OF_INITOR; i++) begin
      initor[i] = new({$psprintf("initor[%0d]", i)}, this);
    end
    for(int i=0; i<NUM_OF_TARGETS; i++) begin
      targets[i] = new({$psprintf("targets[%0d]", i)}, this);
    end
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    thc0 = `AHB_MEM_BKDOR_WR_COMP::type_id::create("ahb_mem_bkdor_wr_comp"); thc0.scb = this; this.th_handler.add(thc0);
    thc1 = `AHB_MEM_BKDOR_RD_COMP::type_id::create("ahb_mem_bkdor_rd_comp"); thc1.scb = this; this.th_handler.add(thc1);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    for(int i=0; i<NUM_OF_INITOR; i++) begin
      if(!uvm_config_db#(`AHB_MASTER_AGENT)::get(this, "", {$psprintf("initor_m[%0d]", i)}, initor_m[i]))
        `uvm_fatal("NOINITOR",{"ahb master agent must be set for: ",get_full_name(), {$psprintf(".initor_m[%0d]", i)}});
    end
    for(int i=0; i<NUM_OF_TARGETS; i++) begin
      if(!uvm_config_db#(`AHB_SLAVE_AGENT)::get(this, "", {$psprintf("targets_s[%0d]", i)}, targets_s[i]))
        `uvm_fatal("NOINITOR",{"ahb slave agent must be set for: ",get_full_name(), {$psprintf(".targets_s[%0d]", i)}});
    end
  endfunction

  // bind at master side
  virtual function void write_initor(`AHB_ITEM item);
    super._write_initor(item);

    // make sure master RD trx is completed after slave deasserted
    if (item.trs_t == RD) begin
      rbox.push_back(item);
    end
  endfunction

  // bind at slave side
  virtual function void write_target(`AHB_ITEM item);
    super._write_target(item);

  // make sure master WR trx is completed before slave asserted
    if (item.trs_t == WR) begin
      wbox.push_back(item);
    end
  endfunction

endclass

`endif // __AHB_SCOREBOARD_SV__
