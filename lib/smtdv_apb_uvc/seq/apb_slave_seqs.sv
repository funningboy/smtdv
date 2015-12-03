
`ifndef __APB_SLAVE_SEQS_SV__
`define __APB_SLAVE_SEQS_SV__

typedef class apb_slave_agent;

class apb_slave_base_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_sequence#(`APB_ITEM);

    smtdv_generic_memory#(ADDR_WIDTH)  gene_mem;

    `APB_ITEM item;
    mailbox #(`APB_ITEM) mbox;

    `uvm_object_param_utils_begin(`APB_SLAVE_BASE_SEQ)
    `uvm_object_utils_end

    `uvm_declare_p_sequencer(`APB_SLAVE_SEQUENCER)

    function new(string name = "apb_slave_base_seq");
      super.new(name);
      mbox = new();
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

    virtual task do_read_item(ref `APB_ITEM item);
      // override this func
      byte data[];
      data= new[DATA_WIDTH>>3];
      gene_mem.mem_load_byte(item.addr, DATA_WIDTH>>3, data, item.bg_cyc);
      foreach(data[i]) begin
        item.data_beat[0][i] = data[i];
      end
    endtask

    virtual task do_write_item(ref `APB_ITEM item);
      // overide this func like err inject or seq random resp
      byte data[];
      data= new[DATA_WIDTH>>3];
      wait(item.complete && item.addr_complete && item.data_complete);
      foreach(item.data_beat[0][i]) begin
        data[i] = item.data_beat[0][i];
      end
      gene_mem.mem_store_byte(item.addr, data, item.bg_cyc);
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


class apb_slave_err_inject_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  `APB_SLAVE_BASE_SEQ;

    `uvm_object_param_utils_begin(`APB_SLAVE_ERR_INJECT_SEQ)
    `uvm_object_utils_end

    function new(string name = "apb_slave_err_inject_seq");
      super.new(name);
    endfunction

    virtual task do_read_item(ref `APB_ITEM item);
      super.do_read_item(item);
     `uvm_info(get_type_name(), {$psprintf("get before err_inject item\n%s", item.sprint())}, UVM_LOW)
      foreach(item.data_beat[0][i]) begin
        item.data_beat[0][i] = ~item.data_beat[0][i];
      end
     `uvm_info(get_type_name(), {$psprintf("get after err_inject item\n%s", item.sprint())}, UVM_LOW)
    endtask

endclass


class apb_slave_hijack_seq #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  `APB_SLAVE_BASE_SEQ;

    int rd_idx = 0;
    int rd_max = 1;
    `APB_SLAVE_AGENT agent;

    `uvm_object_param_utils_begin(`APB_SLAVE_HIJACK_SEQ)
    `uvm_object_utils_end

    function new(string name = "apb_slave_hijack_seq");
      super.new(name);
    endfunction

    virtual task pre_do(bit is_item);
      super.pre_do(is_item);
      $cast(agent, p_sequencer.get_parent());
    endtask

    // release force while slave is running into normal behavior
    virtual task do_read_item(ref `APB_ITEM item);
      super.do_read_item(item);
      if (rd_idx >= rd_max) begin
        agent.cfg.has_force = 0;
        `uvm_info(get_type_name(), {$psprintf("get after release force\n")}, UVM_LOW)
      end
      rd_idx++;
    endtask

endclass




`endif // end of __APB_SLAVE_SEQS_SV__
