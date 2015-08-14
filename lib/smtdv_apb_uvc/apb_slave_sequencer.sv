`ifndef __APB_SLAVE_SEQUENCER_SV__
`define __APB_SLAVE_SEQUENCER_SV__

class apb_slave_sequencer #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_sequencer #(`APB_ITEM);

    // get transfer from apb slave monitor
    uvm_blocking_get_port #(`APB_ITEM) mon_get_port;

  `uvm_component_param_utils_begin(`APB_SLAVE_SEQUENCER)
  `uvm_component_utils_end

    function new(string name = "apb_slave_sequencer", uvm_component parent);
      super.new(name, parent);
      mon_get_port= new("mon_get_port", this);
    endfunction

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

`endif //__APB_SLAVE_SEQUENCER_SV__

