
`ifndef __UART_ITEM_SV__
`define __UART_ITEM_SV__

class uart_item #(
) extends
  smtdv_sequence_item;

  rand bit start_bit;
  rand bit [7:0] data_beat[$];
  bit parity;
  rand bit [1:0] stop_bits;
  rand bit [3:0] error_bits;

  // Control Knobs
  rand parity_e parity_type;
  rand int transmit_delay;

  // as default value
  constraint default_txmit_delay {transmit_delay >= 0; transmit_delay < 20;}
  constraint default_start_bit { start_bit == 1'b0;}
  constraint default_stop_bits { stop_bits == 2'b11;}
  constraint default_parity_type { parity_type==GOOD_PARITY;}
  constraint default_error_bits { error_bits == 4'b0000;}

  constraint c_data_size { data_beat.size() == 1; }

  `uvm_object_param_utils_begin(`UART_ITEM)
    `uvm_field_int(start_bit, UVM_DEFAULT)
    `uvm_field_queue_int(data_beat, UVM_DEFAULT)
    `uvm_field_int(parity, UVM_DEFAULT)
    `uvm_field_int(stop_bits, UVM_DEFAULT)
    `uvm_field_int(error_bits, UVM_DEFAULT)
    `uvm_field_enum(parity_e,parity_type, UVM_DEFAULT)
    `uvm_field_int(transmit_delay, UVM_DEFAULT + UVM_DEC + UVM_NOCOMPARE + UVM_NOCOPY)
  `uvm_object_utils_end

  // Constructor - required UVM syntax  //lab1_note4
  function new(string name = "uart_item");
    super.new(name);
  endfunction

  // This method calculates the parity
  function bit calc_parity(int unsigned num_of_data_bits=8,
                           bit[1:0] ParityMode=0);
    bit temp_parity;

    if (num_of_data_bits == 6)
      temp_parity = ^data_beat[0][5:0];
    else if (num_of_data_bits == 7)
      temp_parity = ^data_beat[0][6:0];
    else
      temp_parity = ^data_beat[0];

    case(ParityMode[0])
      0: temp_parity = ~temp_parity;
      1: temp_parity = temp_parity;
    endcase
    case(ParityMode[1])
      0: temp_parity = temp_parity;
      1: temp_parity = ~ParityMode[0];
    endcase
    if (parity_type == BAD_PARITY)
      calc_parity = ~temp_parity;
    else
      calc_parity = temp_parity;
  endfunction

  // Parity is calculated in the post_randomize() method   //lab1_note5
  function void post_randomize();
    super.post_randomize();
    parity = calc_parity();
  endfunction : post_randomize

  function bit unpack_data(int idx);
    return data_beat[0][idx];
  endfunction

  function void pack_data(int idx, bit b);
    data_beat[0][idx] = b;
  endfunction

endclass

`endif // __UART_ITEM_SV__
