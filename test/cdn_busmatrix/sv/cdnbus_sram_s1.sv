
`ifndef __CDNBUS_SLAVE_0_SV__
`define __CDNBUS_SLAVE_0_SV__

class cdn_slave_0 #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    ahb_slave_agent(
      ADDR_WIDTH,
      DATA_WIDTH
  );

  function new(string name = "cdn_slave_0", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // set type override
    uvm_config_db#(uvm_object_wrapper)::set(this,
      "seqr.run_phase",
      "default_sequence",
      `AHB_SLAVE_BASE_SEQ::type_id::get());

  endfunction


