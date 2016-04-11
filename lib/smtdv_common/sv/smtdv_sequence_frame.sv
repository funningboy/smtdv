
// DATA_WIDTH
// [0:10]
// field name, row range(0, 0), column range(0, 10) MSB/LSB
// ex:
// frame.init(5, 32, SMTDV_MSB)
// frame.field("header", (0,0), (0,10))
// frame.finalize();
// frame.convert(); / frame.populate 2 low level sequence_item

`ifndef __SMTDV_SEQUENCE_FRAME_SV__
`define __SMTDV_SEQUENCE_FRAME_SV__

// bunch of sequence_items
// frame = '{
// };
//

class smtdv_sequence_frame#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
  smtdv_sequence_item#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  );

  typedef smtdv_sequence_frame#(ADDR_WIDTH, DATA_WIDTH) frame_t;
  typedef smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;

  item_t item;

  typedef struct {
    int ucid;
    int left;   // left Boundary
    int right;  // right Boundary
    int def;    // default value
    int val;    // value
    string desc;
  } col_t;

  typedef struct {
    int urid;
    col_t cols[$];
    bit [DATA_WIDTH-1:0] data; // unpackage data
    bit [ADDR_WIDTH-1:0] addr; // map addr
  } row_t;

  typedef struct {
    int ufid;
    row_t rows[$];
    string desc; // frame description
  } dframe_t;

  dframe_t frame;
  row_t row;
  col_t col;

  `uvm_object_param_utils_begin(frame_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_sequence_frame");
    super.new(name);
  endfunction : new

//  extern virtual function bit is_valid();  // it's valid sequence_frame
  extern virtual function void pack_item(); //  from sequence_item to sequence_frame
  extern virtual function void unpack_item(); // fraome sequence_frame to sequence_item
// extern virtual item_t iter();
//
endclass : smtdv_sequence_frame

function void smtdv_sequence_frame::pack_item();
endfunction : pack_item

function void smtdv_sequence_frame::unpack_item();
endfunction : unpack_item


`endif // end of __SMTDV_FRAME_SV__

