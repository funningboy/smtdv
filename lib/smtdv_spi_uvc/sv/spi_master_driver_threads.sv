`ifndef __SPI_MASTER_DRIVER_THREADS_SV__
`define __SPI_MASTER_DRIVER_THREADS_SV__

typedef class spi_sequence_item;
typedef class spi_master_driver;


class spi_master_base_thread #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_run_thread#(
      spi_master_driver#(ADDR_WIDTH, DATA_WIDTH)
  );

  typedef spi_master_base#(ADDR_WIDTH, DATA_WIDTH) th_t;
  typedef spi_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef spi_master_driver#(ADDR_WIDTH, DATA_WIDTH) cmp_t;

  tiem_t item;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "spi_master_base_thread", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void pre_do();
    if (!this.cmp) begin
      `uvm_fatal("NOCMP",
          {"cmp must be set for: ",get_full_name(),".cmp"});
    end
  endfunction : pre_do

endclass : spi_master_base_thread



class spi_master_drive_data #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  spi_master_base_thread#(
    ADDR_WIDTH,
    DATA_WIDTH
  );

  item_t, item;
  rand int opt ;

  `uvm_object_param_utils_begin(th_t)
  `uvm_object_utils_end

  function new(string name = "spi_master_drive_data", uvm_component parent=null);
      super.new(name);
  endfunction : new

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
         this.cmp.databox.async_prio_get(0, item);

         while(!item.data_complete) begin
           // block trx
           case({this.cmp.cfg.CPOL, this.cmp.cfg.CPHA})
             0: begin listen_mode0(item); end
             1: begin listen_mode1(item); end
             2: begin listen_mode2
             3: listen_mode3
          end
          `uvm_info(this.cmp.get_full_name(),
              {$psprintf("try do data item \n%s", item.sprint())}, UVM_LOW)
      end
    endtask



