`ifndef __SPI_MASTER_AGENT_SV__
`define __SPI_MASTER_AGENT_SV__

class spi_master_agent #(
  DATA_WIDTH = 32
  ) extends
    smtdv_agent#(
      `SPI_VIF,
      `SPI_MASTER_CFG,
      `SPI_MASTER_SEQUENCER,
      `SPI_MASTER_DRIVER,
      `SPI_MONITOR);

  `uvm_component_param_utils_begin(`SPI_MASTER_AGENT)
  `uvm_component_utils_end

  function new(string name = "spi_master_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

endclass

`endif // end of __SPI_MASTER_AGENT_SV__

