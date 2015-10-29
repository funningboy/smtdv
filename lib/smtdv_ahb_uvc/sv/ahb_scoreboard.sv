
`ifndef __AHB_SCOREBOARD_SV__
`define __AHB_SCOREBOARD_SV__

`uvm_analysis_imp_decl(_initor)
`uvm_analysis_imp_decl(_target)

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

  `AHB_ITEM wr_pool[ADDR_WIDTH-1:0][$];
  `AHB_ITEM rd_pool[ADDR_WIDTH-1:0][$];

  `AHB_ITEM atmic_item;

  uvm_analysis_imp_initor #(`AHB_ITEM, `AHB_BASE_SCOREBOARD) initor[NUM_OF_INITOR];
  uvm_analysis_imp_target #(`AHB_ITEM, `AHB_BASE_SCOREBOARD) targets[NUM_OF_TARGETS];

  `uvm_component_param_utils_begin(`AHB_BASE_SCOREBOARD)
  `uvm_component_utils_end

  function new (string name = "ahb_scoreboard", uvm_component parent);
    super.new(name, parent);
    for(int i=0; i<NUM_OF_INITOR; i++) begin
      initor[i] = new({$psprintf("initor[%0d]", i)}, this);
    end
    for(int i=0; i<NUM_OF_TARGETS; i++) begin
      targets[i] = new({$psprintf("targets[%0d]", i)}, this);
    end
  endfunction

  // bind at master side
  virtual function void write_initor(`AHB_ITEM item);
    super._write_initor(item);
  endfunction

  // bind at slave side
  virtual function void write_target(`AHB_ITEM item);
    super._write_target(item);
  endfunction

endclass

`endif // __AHB_SCOREBOARD_SV__
