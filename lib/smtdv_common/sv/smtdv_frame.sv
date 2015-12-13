
// DATA_WIDTH
// [0:10]
// field name, row range(0, 0), column range(0, 10) MSB/LSB
// ex:
// frame.init(5, 32, SMTDV_MSB)
// frame.field("header", (0,0), (0,10))
// frame.finalize();
// frame.convert(); / frame.populate

`ifndef __SMTDV_FRAME_SV__
`define __SMTDV_FRAME_SV__

//// only for 2D arr,
//class smtdv_frame #(ROW_WIDTH = 1, COL_WIDTH = 32)
//  extends
//    uvm_object;
//
//    bit                 debug = TRUE;
//    bit [COL_WIDTH-1:0] frame[ROW_WIDTH];

`endif // end of __SMTDV_FRAME_SV__

//class smtdv_frame #()
