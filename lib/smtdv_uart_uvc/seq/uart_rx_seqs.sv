`ifndef __UART_RX_SEQS_REF_SV__
`define __UART_RX_SEQS_REF_SV__

// received tx seq to rx loopback
class rx_loopback_base_seq #(
) extends
  smtdv_sequence#(`UART_ITEM);

  smtdv_generic_fifo#(10, 8) gene_fifo;
  `UART_ITEM item;
  mailbox #(`UART_ITEM) mbox;

  `uvm_object_param_utils_begin(`RX_LOOPBACK_BASE_SEQ)
  `uvm_object_utils_end

  `uvm_declare_p_sequencer(`UART_RX_SEQUENCER)

  function new(string name = "rx_loopback_base_seq");
    super.new(name);
    mbox = new();
    gene_fifo = new();
  endfunction

  virtual task do_read_item(ref `UART_ITEM item);
    bit[7:0] data;
    gene_fifo.pop_front(data, item.bg_cyc);
    item.data_beat[0] = data;
  endtask

  virtual task do_write_item(ref `UART_ITEM item);
    bit[7:0] data;
    wait(item.complete && item.addr_complete && item.data_complete);
    data = item.data_beat[0];
    gene_fifo.push_back(data, item.bg_cyc);
  endtask

  virtual task rcv_from_mon();
    forever begin
      p_sequencer.mon_get_port.get(item);
      `uvm_info(get_type_name(), {$psprintf("get monitor collected item\n%s", item.sprint())}, UVM_LOW)
      // no block wait
      do_write_item(item);
      do_read_item(item);
      mbox.put(item);
    end
    endtask

    virtual task note_to_drv();
      forever begin
        mbox.get(item);
        `uvm_create(req);
        req.copy(item);
        start_item(req);
        finish_item(req);
      end
    endtask

    virtual task finish_from_mon();
      wait(p_sequencer.finish);
     `uvm_info(p_sequencer.get_full_name(), {$psprintf("try collected finish signal\n")}, UVM_LOW)
    endtask

    virtual task body();
      fork
        fork
          rcv_from_mon();
          note_to_drv();
          finish_from_mon();
        join_any
      join
    endtask

endclass


class rx_incr_payload_seq #(
)extends
  `UART_INCR_PAYLOAD_SEQ;

  `uvm_declare_p_sequencer(`UART_RX_SEQUENCER)

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`RX_INCR_PAYLOAD_SEQ)
   `uvm_object_utils_end

    function new(string name="rx_incr_payload_seq");
      super.new(name);
    endfunction
endclass

class rx_bad_parity_seq #(
) extends
  `UART_BAD_PARITY_SEQ;

   `uvm_declare_p_sequencer(`UART_RX_SEQUENCER)

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`RX_BAD_PARITY_SEQ)
   `uvm_object_utils_end

    function new(string name="rx_bad_parity_seq");
      super.new(name);
    endfunction
endclass


class rx_transmit_seq #(
) extends
  `UART_TRANSMIT_SEQ;

   `uvm_declare_p_sequencer(`UART_RX_SEQUENCER)

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`RX_TRANSMIT_SEQ)
   `uvm_object_utils_end

    function new(string name="rx_transmit_seq");
      super.new(name);
    endfunction
endclass


class rx_short_transmit_seq #(
) extends
  `UART_SHORT_TRANSMIT_SEQ;

  `uvm_declare_p_sequencer(`UART_RX_SEQUENCER)

   // register sequence with a sequencer
   `uvm_object_param_utils_begin(`RX_SHORT_TRANSMIT_SEQ)
   `uvm_object_utils_end

    function new(string name="rx_short_transmit_seq");
      super.new(name);
    endfunction
endclass


`endif // __UART_RX_SEQS_REF_SV__
