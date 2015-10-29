/*-------------------------------------------------------------------------
File name   : uart_ctrl_reg_seq_lib.sv
Title       : UVM_REG Sequence Library
Project     :
Created     :
Description : Register Sequence Library for the UART Controller DUT
Notes       :
----------------------------------------------------------------------
Copyright 2007 (c) Cadence Design Systems, Inc. All Rights Reserved.
----------------------------------------------------------------------*/
//--------------------------------------------------------------------
// apb_config_reg_seq: Direct APB transactions to configure the DUT
//--------------------------------------------------------------------
class apb_config_reg_seq extends uvm_sequence;

   `uvm_object_utils(apb_config_reg_seq)

   apb_pkg::write_byte_seq write_seq;
   rand bit [7:0] temp_data;
   constraint c1 {temp_data[7] == 1'b1; }

   function new(string name="apb_config_reg_seq");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info(get_type_name(),
        "UART Controller Register configuration sequence starting...",
        UVM_LOW)
      // Address 3: Line Control Register: bit 7, Divisor Latch Access = 1
      `uvm_do_with(write_seq, { start_addr == 3; write_data == temp_data; } )
      // Address 0: Divisor Latch Byte 1 = 1
      `uvm_do_with(write_seq, { start_addr == 0; write_data == 'h01; } )
      // Address 1: Divisor Latch Byte 2 = 0
      `uvm_do_with(write_seq, { start_addr == 1; write_data == 'h00; } )
      // Address 3: Line Control Register: bit 7, Divisor Latch Access = 0
      temp_data[7] = 1'b0;
      `uvm_do_with(write_seq, { start_addr == 3; write_data == temp_data; } )
      `uvm_info(get_type_name(),
        "UART Controller Register configuration sequence completed",
        UVM_LOW)
   endtask

endclass : apb_config_reg_seq

//--------------------------------------------------------------------
// Base Sequence for Register sequences
//--------------------------------------------------------------------
class base_reg_seq extends uvm_sequence;
  function new(string name="base_reg_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(base_reg_seq)
  `uvm_declare_p_sequencer(uart_ctrl_reg_sequencer)

// Use a base sequence to raise/drop objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running sequence '",
                                              get_full_name(), "'"});
  endtask

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
endclass : base_reg_seq

//--------------------------------------------------------------------
// uart_ctrl_config_reg_seq: UVM_REG transactions to configure the DUT
//--------------------------------------------------------------------
class uart_ctrl_config_reg_seq extends base_reg_seq;

   // Pointer to the register model
   uart_ctrl_reg_model_c reg_model;
   uvm_object rm_object;

   `uvm_object_utils(uart_ctrl_config_reg_seq)

   function new(string name="uart_ctrl_config_reg_seq");
      super.new(name);
   endfunction : new

   virtual task body();
     uvm_status_e status;
     if (uvm_config_object::get(uvm_root::get(), get_full_name(), "reg_model", rm_object))
      $cast(reg_model, rm_object);
      `uvm_info(get_type_name(),
        "UART Controller Register configuration sequence starting...",
        UVM_LOW)
      // Line Control Register, set Divisor Latch Access = 1
      reg_model.uart_ctrl_rf.ua_lcr.write(status, 'h8f);
      // Divisor Latch Byte 1 = 1
      reg_model.uart_ctrl_rf.ua_div_latch0.write(status, 'h01);
      // Divisor Latch Byte 2 = 0
      reg_model.uart_ctrl_rf.ua_div_latch1.write(status, 'h00);
      // Line Control Register, set Divisor Latch Access = 0
      reg_model.uart_ctrl_rf.ua_lcr.write(status, 'h0f);
      //ToDo: FIX: DISABLE CHECKS AFTER CONFIG IS DONE
      reg_model.uart_ctrl_rf.ua_div_latch0.div_val.set_compare(UVM_NO_CHECK);
      `uvm_info(get_type_name(),
        "UART Controller Register configuration sequence completed",
        UVM_LOW)
   endtask
endclass : uart_ctrl_config_reg_seq

class uart_ctrl_1stopbit_reg_seq extends base_reg_seq;

   `uvm_object_utils(uart_ctrl_1stopbit_reg_seq)

   function new(string name="uart_ctrl_1stopbit_reg_seq");
      super.new(name);
   endfunction // new
 
   // Pointer to the register model
   uart_ctrl_rf_c reg_model;
//   uart_ctrl_reg_model_c reg_model;

   //ua_lcr_c ulcr;
   //ua_div_latch0_c div_lsb;
   //ua_div_latch1_c div_msb;

   virtual task body();
     uvm_status_e status;
     reg_model = p_sequencer.reg_model.uart_ctrl_rf;
     `uvm_info(get_type_name(),
        "UART config register sequence with num_stop_bits == STOP1 starting...",
        UVM_LOW)

      #200;
      //`rgm_write_by_name_with(ulcr, "ua_lcr", {value.num_stop_bits == 1'b0;})
      #50;
      //`rgm_write_by_name(div_msb, "ua_div_latch1")
      #50;
      //`rgm_write_by_name(div_lsb, "ua_div_latch0")
      #50;
      //ulcr.value.div_latch_access = 1'b0;
      //`rgm_write_send(ulcr)
      #50;
   endtask
endclass : uart_ctrl_1stopbit_reg_seq

class uart_cfg_rxtx_fifo_cov_reg_seq extends uart_ctrl_config_reg_seq;

   `uvm_object_utils(uart_cfg_rxtx_fifo_cov_reg_seq)

   function new(string name="uart_cfg_rxtx_fifo_cov_reg_seq");
      super.new(name);
   endfunction : new
 
//   ua_ier_c uier;
//   ua_idr_c uidr;

   virtual task body();
      super.body();
      `uvm_info(get_type_name(),
        "enabling tx/rx full/empty interrupts...", UVM_LOW)
//     `rgm_write_by_name_with(uier, {uart_rf, ".ua_ier"}, {value == 32'h01e;})
//     #50;
//     `rgm_write_by_name_with(uidr, {uart_rf, ".ua_idr"}, {value == 32'h3e1;})
//     #50;
   endtask
endclass : uart_cfg_rxtx_fifo_cov_reg_seq
