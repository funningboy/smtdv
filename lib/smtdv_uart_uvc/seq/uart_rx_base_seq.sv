
`ifndef __UART_BASE_SEQS_LIB_SV__
`define __UART_BASE_SEQS_LIB_SV__

//-------------------------------------------------
// SEQUENCE: uart_rx_base_seq
//-------------------------------------------------
class uart_rx_base_seq#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  )extends
    smtdv_sequence#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .T1(uart_item#(ADDR_WIDTH, DATA_WIDTH)),
      .VIF(virtual interface uart_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(uart_rx_cfg),
      .SEQR(uart_rx_sequencer#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef uart_rx_base_seq#(ADDR_WIDTH, DATA_WIDTH) seq_t;
  typedef uart_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  item_t item;

  `uvm_object_param_utils_begin(seq_t)
  `uvm_object_utils_end

  function new(string name="uart_rx_base_seq");
    super.new(name);
  endfunction : new

endclass :


//-------------------------------------------------
// SEQUENCE: uart_incr_payload_seq
//-------------------------------------------------
class uart_incr_payload_seq#(
)extends
  `UART_BASE_SEQ;

    rand int unsigned cnt;
    rand bit [7:0] start_payload;

    constraint count_ct { cnt > 0; cnt <= 10;}

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`UART_INCR_PAYLOAD_SEQ)
   `uvm_object_utils_end

    function new(string name="uart_incr_payload_seq");
      super.new(name);
    endfunction

    virtual task body();
      `uvm_info(get_type_name(), "UART sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++) begin
        start_payload = (start_payload +i*3)%256;

        `uvm_info(get_type_name(), $psprintf("UART sequencer try to send: %d\n", start_payload), UVM_HIGH)

        `uvm_do_with(req, {req.data_beat[0] == start_payload; })
      end
    endtask
endclass

//-------------------------------------------------
// SEQUENCE: uart_bad_parity_seq
//-------------------------------------------------
class uart_bad_parity_seq#(
)extends
  `UART_BASE_SEQ;

    rand int unsigned cnt;
    rand bit [7:0] start_payload;

    constraint count_ct {cnt <= 10;}

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`UART_BAD_PARITY_SEQ)
   `uvm_object_utils_end

    function new(string name="uart_bad_parity_seq");
      super.new(name);
    endfunction

    virtual task body();
      `uvm_info(get_type_name(),  "UART sequencer executing sequence...", UVM_LOW)
      for (int i = 0; i < cnt; i++)
      begin
         // Create the frame
        `uvm_create(req)
         // Nullify the constrain on the parity
         req.default_parity_type.constraint_mode(0);

         // Now send the packed with parity constrained to BAD_PARITY
        `uvm_rand_send_with(req, { req.parity_type == BAD_PARITY;})
      end
    endtask
endclass

//-------------------------------------------------
// SEQUENCE: uart_transmit_seq
//-------------------------------------------------
class uart_transmit_seq#(
  )extends
  `UART_BASE_SEQ;

   rand int unsigned num_of_tx;
   // register sequence with a sequencer

   constraint num_of_tx_ct { num_of_tx <= 250; }

   `uvm_object_param_utils_begin(`UART_TRANSMIT_SEQ)
   `uvm_object_utils_end

   function new(string name="uart_transmit_seq");
      super.new(name);
   endfunction

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART sequencer: Executing %0d Frames", num_of_tx), UVM_LOW)
     for (int i = 0; i < num_of_tx; i++) begin
        `uvm_do(req)
     end
   endtask
endclass

////-------------------------------------------------
//// SEQUENCE: uart_no_activity_seq
////-------------------------------------------------
//class no_activity_seq#(
//  )extends
//  `UART_BASE_SEQ;
//
//   // register sequence with a sequencer
//  `uvm_object_param_utils_begin(`NO_ACTIVITY_SEQ)
//  `uvm_object_utils_end
//
//  function new(string name="no_activity_seq");
//    super.new(name);
//  endfunction
//
//  virtual task body();
//    `uvm_info(get_type_name(), "UART sequencer executing sequence...", UVM_LOW)
//  endtask
//endclass

//-------------------------------------------------
// SEQUENCE: uart_short_transmit_seq
//-------------------------------------------------
class uart_short_transmit_seq#(
  )extends
  `UART_BASE_SEQ;

   rand int unsigned num_of_tx;

   constraint num_of_tx_ct { num_of_tx inside {[2:10]}; }

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`UART_SHORT_TRANSMIT_SEQ)
   `uvm_object_utils_end

   function new(string name="uart_short_transmit_seq");
      super.new(name);
   endfunction

   virtual task body();
     `uvm_info(get_type_name(), $psprintf("UART sequencer: Executing %0d Frames", num_of_tx), UVM_LOW)
     for (int i = 0; i < num_of_tx; i++) begin
        `uvm_do(req)
     end
   endtask
endclass

`endif // __UART_BASE_SEQS_LIB_SV__
