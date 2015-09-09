`ifndef __AHB_MASTER_SEQUENCER_SV__
`define __AHB_MASTER_SEQUENCER_SV__

class ahb_master_sequencer #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  smtdv_sequencer #(`AHB_ITEM);

  `uvm_component_param_utils_begin(`AHB_MASTER_SEQUENCER)
  `uvm_component_utils_end

  function new (string name = "ahb_master_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction

    virtual task run_phase(uvm_phase phase);
      fork
        super.run_phase(phase);
        join_none

      reset_restart_sqr(phase);
    endtask


    virtual task reset_restart_sqr(uvm_phase phase);
      while(1) begin
        @(negedge resetn);
        m_req_fifo.flush();

        stop_sequences();
        wait(resetn == 1);
        start_phase_sequence(phase);
        end
    endtask

endclass

`endif // end of __AHB_MASTER_SEQUENCER_SV__
