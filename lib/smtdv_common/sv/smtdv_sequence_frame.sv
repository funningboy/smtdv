
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
// ex:
// frame0 = sequence_frame("frame0");
// while (frame0.item) begin
//   frame0.item = frame0.item.next;
// end
class smtdv_sequence_frame #(
  ADDR_WIDTH =14,
  DATA_WIDTH = 32
  ) extends
  smtdv_sequence_item#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  );

  typedef smtdv_sequence_frame#(ADDR_WIDTH, DATA_WIDTH) frame_t;

  typedef struct {
    int left;   // left Boundary
    int right;  // right Boundary
    int def;    // default value
    int val;    // value
    // MSB/LSB
    string desc;
  } col_t;

  typedef struct {
    col_t cols[$];
    bit [DATA_WIDTH-1:0] data; // unpackage data
    bit [ADDR_WIDTH-1:0] addr; // map addr
  } row_t;

  typedef struct {
    row_t rows[$];
    string desc; // frame description
  } dframe_t;

  dframe_t frame;

  `uvm_object_param_utils_begin(frame_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_sequence_frame");
    super.new(name);
  endfunction : new


//  extern virtual function bit is_valid();  // it's valid sequence_frame
//  extern virtual function void pack(); //  from sequence_item to sequence_frame
//  extern virtual function void unpack(); // fraome sequence_frame to sequence_item

endclass : smtdv_sequence_frame

`endif // end of __SMTDV_FRAME_SV__

//class smtdv_frame #()
