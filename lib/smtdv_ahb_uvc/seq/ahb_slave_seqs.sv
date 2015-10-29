
`ifndef __AHB_SLAVE_SEQS_SV__
`define __AHB_SLAVE_SEQS_SV__

class ahb_slave_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_sequence#(`AHB_ITEM);

    smtdv_generic_memory#(ADDR_WIDTH)  gene_mem;

    `AHB_ITEM item;
    mailbox #(`AHB_ITEM) mbox;

    `uvm_object_utils_begin(`AHB_SLAVE_BASE_SEQ)
    `uvm_object_utils_end

    `uvm_declare_p_sequencer(`AHB_SLAVE_SEQUENCER)

    function new(string name = "ahb_slave_base_seq");
      super.new(name);
      mbox = new();
      gene_mem = new();
    endfunction

    virtual task do_read_item(ref `AHB_ITEM item);
      // override this func
      bit [ADDR_WIDTH-1:0] addrs[$];
      byte data[];
      data= new[DATA_WIDTH>>3];
      item.post_addr(item.addr, item.trx_size, item.bst_len, item.bst_type, addrs);
      // preload data as max space
      for(int i=0; i<=item.bst_len; i++) begin
        gene_mem.mem_load_byte(addrs[i], DATA_WIDTH>>3, data);
        for(int j=0; j<DATA_WIDTH>>3; j++) begin
          item.data_beat[i][j] = data[j];
        end
      end
      item.mod_t = SLAVE;
    endtask

    virtual task do_write_item(ref `AHB_ITEM item);
      // overide this func
      byte data[];
      data = new[DATA_WIDTH>>3];
      wait(item.complete);
      if (!(item.retry | item.split | item.error)) begin
        wait(item.addr_complete && item.data_complete);
        foreach(item.data_beat[i]) begin
          foreach(item.data_beat[i][j]) begin
              data[j] = item.data_beat[i][j];
          end
          gene_mem.mem_store_byte(item.addrs[i], data);
        end
      end
      item.mod_t = SLAVE;
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

`endif // end of __AHB_SLAVE_SEQS_SV__
