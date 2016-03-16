`ifndef __SPI_MASTER_DRIVER_SV__
`define __SPI_MASTER_DRIVER_SV__

typedef class spi_master_cfg;
typedef class spi_sequence_item;

class spi_master_driver #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_driver#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface spi_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(spi_master_cfg),
      .REQ(spi_sequence_item#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef spi_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef spi_master_driver#(ADDR_WIDTH, DATA_WIDTH) drv_t;
  typedef spi_master_drive_data#(ADDR_WIDTH, DATA_WIDTH) drv_data_t;
  typedef smtdv_queue#(item_t) queue_t;
  typedef smtdv_thread_handler#(drv_t) hdler_t;

  // as frontend threader/handler
  hdler_t th_handler;

  queue_t databox;
  drv_data_t th0;

  `uvm_component_param_utils_begin(drv_t)
  `uvm_component_utils_end

  function new(string name = "spi_master_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    databox = queue_t::type_id::create("spi_master_databox");
    th0 = drv_data_t::type_id::create("spi_master_drive_data", this);
    th_handler = hdler_t::type_id::create("spi_master_handler", this);

    `SMTDV_RAND(th_handler)
    `SMTDV_RAND(th0)
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    th0.register(this); th_handler.add(th0);
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    th_handler.register(this);
    th_handler.finalize();
  endfunction : end_of_elaboration_phase

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();
  extern virtual task redrive_bus(item_t item);
  extern virtual task run_threads();

endclass : spi_master_driver


task ahb_master_driver::run_threads();
  super.run_threads();
  th_handler.run();
endtask : run_threads


task spi_master_driver::reset_driver();
  databox = new();
  reset_inf();
endtask : reset_driver

task spi_master_driver::reset_inf();
//  this.vif.master.hbusreq <= 0;

endtask : reset_inf

task spi_master_driver::drive_bus();
  case(req.trs_t)
    WR: begin databox.put(req); end
    default:
      `uvm_fatal("UNXPCTDPKT",
      $sformatf("receives an unexpected item: %s", req.sprint()))
  endcase
endtask : drive_bus

task spi_master_driver::redrive_bus(item_t item);
endtask : redrive_bus

`endif // end of __SPI_MASTER_DRIVER_SV__

