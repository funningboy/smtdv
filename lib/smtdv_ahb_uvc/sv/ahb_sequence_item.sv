`ifndef __AHB_SEQUENCE_ITEM_SV__
`define __AHB_SEQUENCE_ITEM_SV__

/**
* ahb item
* a basic ahb item
*
* @class ahb_sequence_item
*
*/
class ahb_sequence_item #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  smtdv_sequence_item #(
    ADDR_WIDTH,
    DATA_WIDTH
  );

  typedef ahb_sequence_item #(ADDR_WIDTH, DATA_WIDTH) item_t;

  rand bst_type_t               bst_type;
  rand bit [3:0]                trx_prt;
  rand bit [0:0]                hmastlock;

  // status field
  bit                           reqbus = FALSE;
  bit                           retry = FALSE;
  bit                           split = FALSE;
  bit                           error = FALSE;
  bit                           lock = FALSE;

  int                           busy_cnt = 0;

  rand int                      hbusreq_L2H;
  rand int                      hnonseq_L2H;
  rand int                      hready_L2H;

  rand bit [(DATA_WIDTH>>3)-1:0][7:0] rdata;

  constraint c_bst_type {
    bst_type inside {SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16};
  }

  // default: DATA_ACCESS
  // the master sets HPROT to b0011 to correspond to a non-cacheable,
  // non-bufferable, privileged, data access
  constraint c_trx_prt {
//    trx_prt inside {trx_prt_t[1]};
  }

  constraint c_bst_len  {
    solve bst_type before this.bst_len;
    (bst_type == SINGLE) -> this.bst_len == 0;
    (bst_type == INCR)   -> this.bst_len inside {1,2,4,5,6,8,9,10,11,12,13,14};
    (bst_type inside {WRAP4, INCR4}) -> this.bst_len == 3;
    (bst_type inside {WRAP8, INCR8}) -> this.bst_len == 7;
    (bst_type inside {WRAP16, INCR16}) -> this.bst_len == 15;
  }

// only work for dynamic array init, that's doesn't work for static queue
//  constraint c_addr_size {
//    solve bst_len before addrs;
//    (bst_len) -> addrs.size() == bst_len + 1;
//  }
//
//  constraint c_data_size {
//    solve bst_len before data_beat;
//    (bst_len) -> data_beat.size() == bst_len + 1;
//  }

  constraint c_wrap_burst {
    solve bst_type before this.bst_len, this.trx_size, this.addr;
    solve this.bst_len before this.trx_size, this.addr;
    solve this.trx_size before this.addr;

    if(bst_type inside {WRAP4, WRAP8, WRAP16}) {
      // Start address should be aligned to the size of each transfer
      (this.trx_size == B16)  -> this.addr[0]   == 0;
      (this.trx_size == B32)  -> this.addr[1:0] == 0;
      (this.trx_size == B64)  -> this.addr[2:0] == 0;
      (this.trx_size == B128) -> this.addr[3:0] == 0;
      (this.trx_size == B256) -> this.addr[4:0] == 0;
      (this.trx_size == B512) -> this.addr[5:0] == 0;
      (this.trx_size == B1024)-> this.addr[6:0] == 0;
    }
  }

  constraint c_trx_size {
    this.trx_size == B32;
  }

  // TODO
  constraint c_incr_burst {
  }

  // 1K boundary
  // An incremental burst can be of any length, but the upper limit is set by the
  // fact that address must not cross a 1KB boundary
  //constraint c_1k_bound {
  //  solve addr, bst_len, trx_size before addrs;
  //}

  constraint c_hbusreq_L2H {
    hbusreq_L2H inside {[1:16]};
  }

  constraint c_hnonseq_L2H {
    hnonseq_L2H inside {[1:16]};
  }

  constraint c_hready_L2H {
    hready_L2H inside {[1:16]};
  }

  `uvm_object_param_utils_begin(item_t)
    `uvm_field_enum(bst_type_t, bst_type, UVM_DEFAULT)
    `uvm_field_enum(trx_size_t, trx_size, UVM_DEFAULT)
    `uvm_field_int(hbusreq_L2H, UVM_DEFAULT)
    `uvm_field_int(hready_L2H, UVM_DEFAULT)
    `uvm_field_int(hnonseq_L2H, UVM_DEFAULT)
    `uvm_field_int(retry, UVM_DEFAULT)
    `uvm_field_int(split, UVM_DEFAULT)
    `uvm_field_int(error, UVM_DEFAULT)
  `uvm_object_utils_end

  function new (string name = "ahb_sequence_item");
    super.new(name);
  endfunction : new

  function void pre_randomize();
    super.pre_randomize();
  endfunction : pre_randomize

  function void post_data(
                          int bst_len,
                          ref bit [(DATA_WIDTH>>3)-1:0][7:0] data_beat[$]
    );

    for(int i=0; i<=bst_len; i++) begin
     `SMTDV_RAND_VAR(rdata);
      data_beat.push_back(rdata);
    end
  endfunction : post_data

  function void post_byten();
  endfunction : post_byten

  function void post_addr(
                          bit [ADDR_WIDTH-1:0] addr,
                          int trx_size,
                          int bst_len,
                          int bst_type,
                          ref bit [ADDR_WIDTH-1:0] addrs[$]
    );
    bit [ADDR_WIDTH-1:0]       aligned_addr,
                               lower_wrap_boundary,
                               upper_wrap_boundary;
    bit                        aligned;
    int                        dtsize;
    int                        lower_byte_lane, upper_byte_lane;
    int                        num_bytes, data_bus_bytes;

    // ref AXI4-specificaion.pdf
    num_bytes = (1<<trx_size);
    data_bus_bytes = (DATA_WIDTH>>3);

    aligned_addr = (addr/num_bytes) * num_bytes;
    aligned = (aligned_addr == addr);
    dtsize = num_bytes * (bst_len+1);

    if (bst_type inside {WRAP4, WRAP8, WRAP16}) begin
      lower_wrap_boundary= (addr/dtsize) * dtsize;
      upper_wrap_boundary= lower_wrap_boundary + dtsize;
    end

    for(int i=0; i<=bst_len; i++) begin
      addrs.push_back(addr);

      lower_byte_lane= addr - (addr/data_bus_bytes) * data_bus_bytes;
      if (aligned)
        upper_byte_lane = lower_byte_lane + num_bytes -1;
      else
        upper_byte_lane = aligned_addr + num_bytes -1 - (addr/data_bus_bytes) * data_bus_bytes;

      if(aligned) begin
        addr = addr + num_bytes;
        if(bst_type inside {WRAP4, WRAP8, WRAP16})
          if(addr >= upper_wrap_boundary)
            addr = lower_wrap_boundary;
      end
      else begin
        addr = addr + (upper_byte_lane - lower_byte_lane + 1);
      end
    end
  endfunction : post_addr

  function void post_randomize();
    bit [ADDR_WIDTH-1:0] addrs[$];
    bit [(DATA_WIDTH>>3)-1:0][7:0] data_beat[$];

    super.post_randomize();
    this.data_beat.delete();
    this.addrs.delete();
    this.byten_beat.delete();

    post_addr(this.addr, this.trx_size, this.bst_len, this.bst_type, addrs);
    for(int i=0; i<=this.bst_len; i++) begin
      this.addrs.push_back(addrs[i]);
    end

    post_data(this.bst_len, data_beat);
    for(int i=0; i<=this.bst_len; i++) begin
      this.data_beat.push_back(data_beat[i]);
    end

    post_byten();
  endfunction : post_randomize

  function int get_bst_len(int bst_type);
    int bst_len;
    bst_len = (bst_type == SINGLE)? 0:
              (bst_type == INCR)? this.addrs.size():
              (bst_type inside {WRAP4, INCR4})? 3:
              (bst_type inside {WRAP8, INCR8})? 7:
              (bst_type inside {WRAP16, INCR16})? 15: 0;
    return bst_len;
  endfunction : get_bst_len

endclass : ahb_sequence_item

`endif // end of __AHB_SEQUENCE_ITEM_SV__

