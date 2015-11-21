`ifndef __SPI_MASTER_DRIVER_THREADS_SV__
`define __SPI_MASTER_DRIVER_THREADS_SV__

typedef class spi_master_driver;

class spi_master_drive_data #(
  DATA_WIDTH = 32
) extends
    smtdv_run_thread;

    rand int opt = 0;
    `SPI_ITEM item, req;
    `SPI_MASTER_DRIVER cmp;

    `uvm_object_param_utils_begin(`SPI_MASTER_DRIVE_DATA)
    `uvm_object_utils_end

    function new(string name = "spi_master_drive_data");
      super.new(name);
    endfunction

    // CPOL(clock polarity)=0, CPHA(clock phase)=0
    virtual task listen_mode0(ref `SPI_ITEM);
      this.vif.master.mosi <=
      this.vif.master.ss <= 0;
      @(negedge this.vif.master.sclk);
      //      this.vif.master.ssn <= id
    endtask

    virtual task listen_mode1
      this.vif.master.mosi <=
      this.vif.master.ss <= 0;
      @(posedge this.vif.master.sclk);
    endtask

    virtual task listem_mode2()
      this.vif.master.mosi <=
      @(posedge this.vif.master.sclk);

    virtual task run();
      forever begin
         // after reset
         populate_default_item(item);
         this.cmp.databox.get(item);

         while(!item.data_complete) begin
           // block trx
           case({this.cmp.cfg.CPOL, this.cmp.cfg.CPHA})
             0: begin listen_mode0(item); end
             1: begin listen_mode1(item); end
             2:
             3:
          end
          `uvm_info(this.cmp.get_full_name(), {$psprintf("try do data item \n%s", item.sprint())}, UVM_LOW)
      end
    endtask



