`ifndef __APB_CONFIG_REG_SEQ_SV__
`define __APB_CONFIG_REG_SEQ_SV__

// use apb to config UART init reg config
class apb_config_reg_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  )extends
    `APB_MASTER_BASE_SEQ;

   `uvm_object_utils(`APB_CONFIG_REG_SEQ)

   rand bit [DATA_WIDTH-1:0] temp_data;
   constraint c1 {temp_data[7] == 1'b1; }

   function new(string name="apb_config_reg_seq");
      super.new(name);
   endfunction

   virtual task body();
      `uvm_info(get_type_name(),
        "UART Controller Register configuration sequence starting...\n",
        UVM_LOW)

      // Address 3: Line Control Register: bit 7, Divisor Latch Access = 1
      item = `APB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
          mod_t == MASTER;
          trs_t == WR;
          run_t == NORMAL;
          addr == 3;
      })
      item.packet(temp_data);
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);

      // Address 0: Divisor Latch Byte 1 = 1
      item = `APB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
          mod_t == MASTER;
          trs_t == WR;
          run_t == NORMAL;
          addr == 0;
        })
      item.packet('h01);
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);

      // Address 1: Divisor Latch Byte 2 = 0
      item = `APB_ITEM::type_id::create("item");
      `SMTDV_RAND_WITH(item, {
          mod_t == MASTER;
          trs_t == WR;
          run_t == NORMAL;
          addr == 1;
        })
      item.packet('h00);
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);

      // Address 3: Line Control Register: bit 7, Divisor Latch Access = 0
      temp_data[7] = 1'b0;
      item = `APB_ITEM::type_id::create("item");
      item.packet(temp_data);
      `uvm_create(req);
      req.copy(item);
      start_item(req);
      finish_item(req);

      `uvm_info(get_type_name(),
        "UART Controller Register configuration sequence completed\n",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq

`endif // end of __APB_CONFIG_REG_SEQ_SV__
