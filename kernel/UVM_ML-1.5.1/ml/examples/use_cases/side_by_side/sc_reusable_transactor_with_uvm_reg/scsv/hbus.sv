//----------------------------------------------------------------------
//   Copyright 2012 Cadence Design Systems, Inc.
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

 import uvm_pkg::*;  
`include "uvm_macros.svh"
 import uvm_ml::*;

module hbus(clk, resetn, haddr, hen, hwr_rd, hdata);
output clk;
output resetn;
input [7:0] haddr;
input hen;
input hwr_rd;
inout [7:0] hdata;

reg clk;
reg resetn;
wire error;
always
  begin
    clk = 1; #5;
    clk = 0; #5;
  end

initial
  begin
    resetn = 0;
    #99; resetn = 1;
  end 

`ifdef USE_UVM_ML_RUN_TEST
initial
  begin
    string tops[1];
    tops[0]   = "";
    uvm_ml_run_test(tops, "SV:reg_test");
  end
`endif

initial
  begin    
    #150000;
    #200 $finish;
  end 

  router dut(
    .reset(!resetn),
    .clock(clk),
    .error(error),
    .haddr(haddr),
    .hdata(hdata),
    .hen(hen),
    .hwr_rd(hwr_rd));

endmodule


  module host_ctl (input clock,
              input reset,
              input wr_rd,
              input en,
              input [7:0] addr,
              inout [7:0] data,
              output en_out,
              output [7:0] max_pkt_size_out);

   parameter   DEF_MAX_PKT = 8'h3F;
   parameter   DEF_EN = 1'b1;
   //parameter   DEF_EN = 1'b0;   //KAM - For Training
   
   //internal registers
   reg [7:0]   max_pkt_reg; // 0
   reg [7:0]   enable_reg;  // 0x20
	
   reg [7:0]   autoclear_reg;  // 0x28
	
   reg [7:0]   bank_number;  // 0x30
	
	
   reg [7:0]   bank1_1;      // 0x40 when bank_number is even
   reg [7:0]   bank1_2; 	 // 0x44 when bank_number is even
   reg [7:0]   bank2_1; 	 // 0x40 when bank_number is odd
   reg [7:0]   bank2_2; 	 // 0x44 when bank_number is odd

   reg [7:0]   protect_write_data;  // 0x50
   reg [7:0]   write_data;  // 0x54
	
   //internal data bus
   reg [7:0]   int_data;

   //continuous assignments
   assign max_pkt_size_out = max_pkt_reg;
   assign en_out = 1;
   assign data = int_data;

   always @(negedge clock or posedge reset) begin
     if (reset) begin
       max_pkt_reg = DEF_MAX_PKT;
       protect_write_data =  8'hff;
       write_data =  8'h00;
		 bank_number = 0;
		 bank1_1 =  8'h00;
		 bank1_2 =  8'h00;
		 bank2_1 =  8'h00;
		 bank2_2 =  8'h00;
       enable_reg =  DEF_EN;
       int_data = 8'h00;
     end
     else if (!en)   
         int_data = 8'hZZ;
     else if (en ) begin
       case (wr_rd) 
         0 : begin //read
             case (addr) 
               8'h00: int_data = max_pkt_reg;
               8'h20: int_data = enable_reg;
               8'h28: begin int_data = autoclear_reg; autoclear_reg = 0; end
               8'h30: int_data = bank_number;
               8'h40: if (bank_number[0] == 1'b0) int_data = bank1_1; else  int_data = bank2_1 ;
               8'h44: if (bank_number[0] == 1'b0) int_data = bank1_2; else  int_data = bank2_2 ;
               8'h50: int_data = protect_write_data;
               8'h54: int_data = write_data;
               default: int_data = 8'hZZ;
             endcase // case(addr)
             end
         1 : begin //write
             case (addr) 
               8'h00: max_pkt_reg = data;
               8'h20: enable_reg = data;
               8'h28: autoclear_reg = data;
               8'h30: bank_number = data;
               8'h40: if (bank_number[0] == 1'b0) bank1_1 = data ; else  bank2_1 = data ;
               8'h44: if (bank_number[0] == 1'b0) bank1_2 = data ; else  bank2_2 = data ;
               8'h50: protect_write_data = data;
               8'h54: if (protect_write_data == 0) write_data = data;
             endcase // case(addr)
             end
       endcase // case(wr_rd)
      end // if (en)
   end // always @ (posedge clock)
endmodule // host_ctl

module router (input clock,                              
                    input reset,                            
                    output error,
                    // Host Interface Signals
                    input [7:0] haddr,
                    inout [7:0] hdata,
                    input hen,
                    input hwr_rd);                            

wire   [2:0] write_enb;
wire   [1:0] addr;
wire      router_enable;
wire [7:0] max_pkt_size;
wire [7:0] chan_data;

//Host Interface Instance
  host_ctl hif_0 (.clock (clock),
                  .reset (reset),
                  .addr  (haddr),
                  .data  (hdata),
                  .en    (hen),
                  .wr_rd (hwr_rd),
                  .en_out (router_enable),
                  .max_pkt_size_out (max_pkt_size));
   

endmodule //router
