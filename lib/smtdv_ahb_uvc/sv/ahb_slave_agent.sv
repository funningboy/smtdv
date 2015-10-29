`ifndef __AHB_SLAVE_AGENT_SV__
`define __AHB_SLAVE_AGENT_SV__

class ahb_slave_agent #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_agent#(
      `AHB_VIF,
      `AHB_SLAVE_CFG,
      `AHB_SLAVE_SEQUENCER,
      `AHB_SLAVE_DRIVER,
      `AHB_MONITOR);

   uvm_tlm_analysis_fifo #(`AHB_ITEM) fifo_mon_sqr;

  `uvm_component_param_utils_begin(`AHB_SLAVE_AGENT)
  `uvm_component_utils_end

  function new(string name = "ahb_slave_agent", uvm_component parent);
    super.new(name, parent);
    fifo_mon_sqr = new("fifo_mon_sqr", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // put seq to sequencer
    uvm_config_db#(uvm_object_wrapper)::set(this,
      "seqr.run_phase",
      "default_sequence",
      `AHB_SLAVE_BASE_SEQ::type_id::get());

    if(this.get_is_active())
      mon.seqr = seqr;
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // connect monitor to sequencer via tlm analysis port
    mon.item_asserted_port.connect(fifo_mon_sqr.analysis_export);

    if(get_is_active()) begin
      seqr.mon_get_port.connect(fifo_mon_sqr.get_export);
    end
  endfunction

endclass

`endif // enf of __AHB_SLAVE_AGENT_SV__

