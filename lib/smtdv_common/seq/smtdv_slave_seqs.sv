
`ifndef __SMTDV_SLAVE_SEQS_SV__
`define __SMTDV_SLAVE_SEQS_SV__

typedef class smtdv_sequence_item;

class smtdv_slave_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
    smtdv_sequence#(T1);

    T1 item;
    mailbox #(T1) mbox;

    `uvm_object_param_utils_begin(smtdv_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH, T1))
    `uvm_object_utils_end

    `uvm_declare_p_sequencer(smtdv_slave_sequencer#(T1))

    function new(string name = "smtdv_slave_base_seq");
      super.new(name);
      mbox = new();
    endfunction

    virtual task do_read_item(ref T1 item);
    endtask

    virtual task do_write_item(ref T1 item);
    endtask

    virtual task rcv_from_mon();
      forever begin
        p_sequencer.mon_get_port.get(item);
        `uvm_info(get_type_name(), {$psprintf("get monitor collected item\n%s", item.sprint())}, UVM_LOW)
        case(item.trs_t)
          RD: begin
                do_read_item(item);
                mbox.put(item);
              end
          WR: begin
                mbox.put(item);
                do_write_item(item);
              end
        default:
        `uvm_fatal("UNXPCTDPKT",
            $sformatf("collected an unexpected item: \n%s", req.sprint()))
        endcase
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

    // create mem table map as ini
    virtual task pre_do(bit is_item);
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


class smtdv_slave_mem_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
  smtdv_slave_base_seq #(
    ADDR_WIDTH,
    DATA_WIDTH,
    T1
  );

  smtdv_generic_memory#(ADDR_WIDTH, 128)  gene_mem;

  `uvm_object_param_utils_begin(smtdv_slave_mem_seq#(ADDR_WIDTH, DATA_WIDTH, T1))
  `uvm_object_utils_end

   function new(string name = "smtdv_slave_mem_seq");
     super.new(name);
     gene_mem = new();
   endfunction

    // create mem table map as ini
    virtual task pre_do(bit is_item);
      string table_nm = $psprintf("\"%s\"", p_sequencer.get_full_name());

      if (gene_mem.mem_cb.table_nm == "") begin
        gene_mem.mem_cb.table_nm = table_nm;
        void'(gene_mem.mem_cb.create_table());
      end
    endtask

endclass


class smtdv_slave_fifo_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
  smtdv_slave_base_seq #(
    ADDR_WIDTH,
    DATA_WIDTH,
    T1
  );

  smtdv_generic_fifo#(100, DATA_WIDTH)  gene_fifo;

  `uvm_object_param_utils_begin(smtdv_slave_fifo_seq#(ADDR_WIDTH, DATA_WIDTH, T1))
  `uvm_object_utils_end

   function new(string name = "smtdv_slave_fifo_seq");
     super.new(name);
     gene_fifo = new();
   endfunction

    // create fifo table map as ini
    virtual task pre_do(bit is_item);
      string table_nm = $psprintf("\"%s\"", p_sequencer.get_full_name());

      if (gene_fifo.fifo_cb.table_nm == "") begin
        gene_fifo.fifo_cb.table_nm = table_nm;
        void'(gene_fifo.fifo_cb.create_table());
      end
    endtask

endclass


`endif // end of __SMTDV_SLAVE_SEQS_SV__
