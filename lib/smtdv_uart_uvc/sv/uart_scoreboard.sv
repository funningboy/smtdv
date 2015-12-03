
`ifndef __UART_SCOREBOARD_SV__
`define __UART_SCOREBOARD_SV__

`uvm_analysis_imp_decl(_initor)
`uvm_analysis_imp_decl(_target)

// one to one TX/RX
class uart_base_scoreboard #(
  NUM_OF_INITOR = 1,
  NUM_OF_TARGETS = 1
 ) extends
    smtdv_scoreboard#(
      0,
      32,
      NUM_OF_TARGETS,
      NUM_OF_TARGETS
    );

  `UART_ITEM atmic_item;

  `UART_TX_AGENT initor_m[NUM_OF_INITOR];
  `UART_RX_AGENT targets_s[NUM_OF_TARGETS];

  uvm_analysis_imp_initor #(`UART_ITEM, `UART_BASE_SCOREBOARD) initor[NUM_OF_INITOR];
  uvm_analysis_imp_target #(`UART_ITEM, `UART_BASE_SCOREBOARD) targets[NUM_OF_TARGETS];

  `uvm_component_param_utils_begin(`UART_BASE_SCOREBOARD)
  `uvm_component_utils_end

  function new (string name = "uart_scoreboard", uvm_component parent);
    super.new(name, parent);
    for(int i=0; i<NUM_OF_INITOR; i++) begin
      initor[i] = new({$psprintf("initor[%0d]", i)}, this);
    end
    for(int i=0; i<NUM_OF_TARGETS; i++) begin
      targets[i] = new({$psprintf("targets[%0d]", i)}, this);
    end
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    for(int i=0; i<NUM_OF_INITOR; i++) begin
      if(!uvm_config_db#(`UART_MASTER_AGENT)::get(this, "", {$psprintf("initor_m[%0d]", i)}, initor_m[i]))
        `uvm_fatal("NOINITOR",{"uart master agent must be set for: ",get_full_name(), {$psprintf(".initor_m[%0d]", i)}});
    end
    for(int i=0; i<NUM_OF_TARGETS; i++) begin
      if(!uvm_config_db#(`UART_SLAVE_AGENT)::get(this, "", {$psprintf("targets_s[%0d]", i)}, targets_s[i]))
        `uvm_fatal("NOINITOR",{"uart slave agent must be set for: ",get_full_name(), {$psprintf(".targets_s[%0d]", i)}});
    end
  endfunction

  //bind as backdoor memory RD after WR check
  virtual function _backdoor_check();
  endfunction

  // bind at master side
  virtual function void write_initor(`UART_ITEM item);
    super._write_initor(item);
  endfunction

  // bind at slave side
  virtual function void write_target(`UART_ITEM item);
    super._write_target(item);
  endfunction

endclass



`endif // __UART_SCOREBOARD_SV__
