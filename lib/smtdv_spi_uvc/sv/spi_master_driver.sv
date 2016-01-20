`ifndef __SPI_MASTER_DRIVER_SV__
`define __SPI_MASTER_DRIVER_SV__

class spi_master_driver #(
  DATA_WIDTH = 32
  ) extends
    smtdv_driver#(
      `SPI_VIF,
      `SPI_MASTER_CFG,
      `SPI_ITEM
      );

  mailbox #(`SPI_ITEM) databox;

  `SPI_MASTER_DRIVE_DATA th0;

  `uvm_component_param_utils_begin(`SPI_MASTER_DRIVER)
  `uvm_component_utils_end

  function new(string name = "spi_master_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = `SPI_MASTER_DRIVE_DATA::type_id::create("spi_master_drive_data"); th0.cmp = this; this.th_handler.add(th0);
  endfunction

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();

endclass

task spi_master_driver::reset_driver();
  databox = new();
  reset_inf();
endtask

task spi_master_driver::reset_inf();
//  this.vif.master.hbusreq <= 0;

endtask

task spi_master_driver::drive_bus();
  case(req.trs_t)
    WR: begin databox.put(req); end
    default:
      `uvm_fatal("UNXPCTDPKT",
      $sformatf("receives an unexpected item: %s", req.sprint()))
  endcase
endtask

`endif // end of __SPI_MASTER_DRIVER_SV__

