
`ifndef __XBUS_SLAVE_SEQS_SV__
`define __XBUS_SLAVE_SEQS_SV__

class xbus_slave_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_sequence#(`XBUS_ITEM);

    smtdv_generic_memory#(ADDR_WIDTH)  gene_mem;

    `XBUS_ITEM item;
    mailbox #(`XBUS_ITEM) mbox;

    `uvm_object_param_utils_begin(`XBUS_SLAVE_BASE_SEQ)
    `uvm_object_utils_end

    `uvm_declare_p_sequencer(`XBUS_SLAVE_SEQUENCER)

    function new(string name = "xbus_slave_base_seq");
      super.new(name);
      mbox = new();
      gene_mem = new();
    endfunction

    virtual task do_read_item(ref `XBUS_ITEM item);
      // override this func
      byte data[];
      data= new[DATA_WIDTH>>3];
      gene_mem.mem_load_byte(item.addr, DATA_WIDTH>>3, data, item.bg_cyc);
      foreach(data[i]) begin
        item.data_beat[i] = data[i];
      end
    endtask

    virtual task do_write_item(ref `XBUS_ITEM item);
      // overide this func write after read for update
      byte data[];
      data = new[DATA_WIDTH>>3];
      gene_mem.mem_load_byte(item.addr, DATA_WIDTH>>3, data, item.bg_cyc);
      foreach(item.data_beat[i]) begin
        if (item.byten_beat[i]) begin
          data[i] = item.data_beat[i];
        end
      end
      gene_mem.mem_store_byte(item.addr, data, item.bg_cyc);
    endtask

    virtual task rcv_from_mon();
      forever begin
        p_sequencer.mon_get_port.get(item);
        `uvm_info(get_type_name(), {$psprintf("get monitor collected item\n%s", item.sprint())}, UVM_LOW)
        case(item.trs_t)
          smtdv_common_pkg::RD: begin do_read_item(item); mbox.put(item); end
          smtdv_common_pkg::WR: begin do_write_item(item); mbox.put(item); end
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

`endif // end of __XBUS_SLAVE_SEQS_SV__
