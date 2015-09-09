//---------------------------------------------------------------------------
//File name   : tb_xbus.v
//Title       : Verilog testbench for XBus eVC demo
//Project     : XBus eVC
//Developers  : 
//Created     : 2001
//Description : 
//Notes       : 
//--------------------------------------------------------------------------- 
//----------------------------------------------------------------------
//   Copyright 2008-2010 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
//---------------------------------------------------------------------------

module xbus_evc_demo;
  // xbus signals by agent
  reg xbus_req_master_0;
  wire xbus_gnt_master_0;
    
  // xbus signals
  reg xbus_clock;
  reg xbus_reset;
  reg [15:0] xbus_addr;
  reg [1:0] xbus_size;
  reg xbus_read;
  reg xbus_write;
  wire xbus_start;
  reg xbus_bip;
  reg [7:0] xbus_data;
  reg xbus_wait;
  reg xbus_error;

initial    
   begin
      xbus_reset <= 1'b1;
      xbus_clock <= 1'b1;
      #51 xbus_reset = 1'b0;
   end // initial begin


   always
      #5 xbus_clock = ~xbus_clock;

   arbiter_dut #(1) AR1(.clk(xbus_clock),.rst(xbus_reset),.sig_start(xbus_start),.sig_bip(xbus_bip),
			.sig_wait(xbus_wait),.sig_error(xbus_error),.sig_request({xbus_req_master_0}),
			.sig_grant({xbus_gnt_master_0}));

   
endmodule // xbus_evc_demo
