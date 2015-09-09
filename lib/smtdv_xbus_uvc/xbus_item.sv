
`ifndef __XBUS_ITEM_SV__
`define __XBUS_ITEM_SV__

class xbus_item #(
  ADDR_WIDTH = 14,
  BYTEN_WIDTH = 4,
  DATA_WIDTH = 32
) extends
    smtdv_sequence_item;

  rand bit [ADDR_WIDTH-1:0] addr;
  rand bit [7:0]            data[$];
  rand bit [0:0]            byten[$];
  bit [0:0]                 done = 0;

  rand int req_L2H;
  rand int ack_L2H;

  constraint c_data_size { data.size() ==  DATA_WIDTH>>3; }
  constraint c_byten_size { byten.size() == DATA_WIDTH>>3; }
  constraint c_req_L2H { req_L2H inside {[0:10]}; }
  constraint c_ack_L2H { ack_L2H inside {[0:10]}; }

  `uvm_object_param_utils_begin(`XBUS_ITEM)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_queue_int(data, UVM_DEFAULT)
    `uvm_field_queue_int(byten, UVM_DEFAULT)
    `ifdef DEBUG
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
      data[i] = idata[i*8+:8];
    end
  endfunction

  function bit[DATA_WIDTH-1:0] unpack_data();
    bit [DATA_WIDTH-1:0] odata;
    int n = (DATA_WIDTH % 8 == 0)? DATA_WIDTH>>3 : DATA_WIDTH>>3+1;
    for (int i=0; i<n; i+=1) begin
      odata[i*8+:8] = data[i];
    end
    return odata;
  endfunction

  function void pack_byten(bit [BYTEN_WIDTH-1:0] idata);
    int n = (DATA_WIDTH % 8 == 0)? DATA_WIDTH>>3 : DATA_WIDTH>>3+1;
    for (int i=0; i<n; i+=1) begin
      byten[i] = idata[i];
    end
  endfunction

  function bit[BYTEN_WIDTH-1:0] unpack_byten();
    bit [BYTEN_WIDTH-1:0] odata;
    int n = (DATA_WIDTH % 8 == 0)? DATA_WIDTH>>3 : DATA_WIDTH>>3+1;
    for (int i=0; i<n; i+=1) begin
      odata[i] = byten[i];
    end
    return odata;
  endfunction

//  extern function void pre_randomize();
//  extern function void post_randomize();
endclass

`endif // end of __XBUS_ITEM_SV__

