
`ifndef __XBUS_ITEM_SV__
`define __XBUS_ITEM_SV__

class xbus_item #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
    smtdv_sequence_item;

  rand bit [ADDR_WIDTH-1:0] addr;
  rand bit [ADDR_WIDTH-1:0] addrs[$];
  rand bit [(DATA_WIDTH>>3)-1:0][7:0] data_beat[$];
  rand bit [(DATA_WIDTH>>3)-1:0][0:0] byten_beat[$];

  rand int req_L2H;
  rand int ack_L2H;

  constraint c_data_size { data_beat.size() == 1; }
  constraint c_byten_size { byten_beat.size() == 1; }
  constraint c_req_L2H { req_L2H inside {[0:10]}; }
  constraint c_ack_L2H { ack_L2H inside {[0:10]}; }

  `uvm_object_param_utils_begin(`XBUS_ITEM)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_queue_int(addrs, UVM_DEFAULT)
    `uvm_field_queue_int(data_beat, UVM_DEFAULT)
    `uvm_field_queue_int(byten_beat, UVM_DEFAULT)
    `ifdef XBUS_DEBUG
      `uvm_field_int(req_L2H, UVM_DEFAULT)
      `uvm_field_int(ack_L2H, UVM_DEFAULT)
    `endif
  `uvm_object_utils_end

  function new (string name = "xbus_item");
    super.new(name);
  endfunction

  function void pack_data(bit [DATA_WIDTH-1:0] idata);
    int n = (DATA_WIDTH % 8 == 0)? DATA_WIDTH>>3 : DATA_WIDTH>>3+1;
    for (int i=0; i<n; i+=1) begin
      data_beat[0][i] = idata[i*8+:8];
    end
  endfunction

  function bit[DATA_WIDTH-1:0] unpack_data();
    bit [DATA_WIDTH-1:0] odata;
    int n = (DATA_WIDTH % 8 == 0)? DATA_WIDTH>>3 : DATA_WIDTH>>3+1;
    for (int i=0; i<n; i+=1) begin
      odata[i*8+:8] = data_beat[0][i];
    end
    return odata;
  endfunction

  function void pack_byten(bit [(DATA_WIDTH>>3)-1:0] idata);
    int n = (DATA_WIDTH % 8 == 0)? DATA_WIDTH>>3 : DATA_WIDTH>>3+1;
    for (int i=0; i<n; i+=1) begin
      byten_beat[0][i] = idata[i];
    end
  endfunction

  function bit[(DATA_WIDTH>>3)-1:0] unpack_byten();
    bit [(DATA_WIDTH>>3)-1:0] odata;
    int n = (DATA_WIDTH % 8 == 0)? DATA_WIDTH>>3 : DATA_WIDTH>>3+1;
    for (int i=0; i<n; i+=1) begin
      odata[i] = byten_beat[0][i];
    end
    return odata;
  endfunction

//  extern function void pre_randomize();
//  extern function void post_randomize();
endclass

`endif // end of __XBUS_ITEM_SV__

