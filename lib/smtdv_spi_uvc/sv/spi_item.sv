`ifndef __SPI_ITEM_SV__
`define __SPI_ITEM_SV__

class spi_item #(
  DATA_WIDTH = 32
) extends
  smtdv_sequence_item

  rand bit [(DATA_WIDTH>>3)-1:0][7:0] data_beat[$];
  rand int htx_L2H;
  rand int hrx_L2H;

  constraint c_htrx_L2H {
    htx_L2H inside {[0:16]};
  }

  constraint c_hrx_L2H {
    hrx_L2H inside {[0:16]}
  }

  `uvm_object_param_utils_begin(`SPI_ITEM)
    `uvm_field_queue_int(data_beat, UVM_DEFAULT)
    `ifdef SPI_DEBUG
      `uvm_field_int(htx_L2H, UVM_DEFAULT)
      `uvm_field_int(hrx_L2H, UVM_DEFAULT)
    `endif
  `uvm_object_utils_end

  function new (string name = "spi_item");
    super.new(name);
  endfunction

endclass

`endif // end of __SPI_ITEM_SV__
