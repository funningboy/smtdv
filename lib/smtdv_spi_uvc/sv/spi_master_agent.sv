`ifndef __SPI_MASTER_AGENT_SV__
`define __SPI_MASTER_AGENT_SV__

typedef class spi_master_cfg;
typedef class spi_sequence_item;
typedef class spi_master_sequencer;
typedef class spi_master_driver;
typedef class spi_monitor;

class spi_master_agent #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_master_agent#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface spi_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(spi_master_cfg),
      .SEQR(spi_master_sequencer#(ADDR_WIDTH, DATA_WIDTH)),
      .DRV(spi_master_driver#(ADDR_WIDTH, DATA_WIDTH)),
      .MON(spi_monitor#(ADDR_WIDTH, DATA_WIDTH, spi_master_cfg, spi_master_sequencer#(ADDR_WIDTH, DATA_WIDTH)))
  );

  typedef spi_master_agent#(ADDR_WIDTH, DATA_WIDTH) agent_t;

  `uvm_component_param_utils_begin(agent_t)
  `uvm_component_utils_end

  function new(string name = "spi_master_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

endclass : spi_master_agent

`endif // end of __SPI_MASTER_AGENT_SV__

