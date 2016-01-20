//----------------------------------------------------------------------
//   Copyright 2007-2009 Mentor Graphics Corporation
//   Copyright 2007-2009 Cadence Design Systems, Inc.
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

// DUT is an XBus Arbiter. 
// Arbiter supports up to 15 masters
// Priority is given in order from master[0] to master[15]

module arbiter_dut #(parameter NUM_MASTERS = 1) (
  input  wire        clk,
  input  wire        rst,
  output reg         sig_start,
  input  wire        sig_bip,
  input  wire        sig_wait,
  input  wire        sig_error,
  input  wire [(NUM_MASTERS-1):0] sig_request,
  output reg  [(NUM_MASTERS-1):0] sig_grant
);

  // States
  localparam RST   = 0;
  localparam ADDR  = 1;
  localparam DATA  = 2;
  localparam START = 3;
  localparam NOP   = 4;

  // State variable
  reg [2:0] state;

  // State machine to drive start
  always @(posedge clk or posedge rst)
  begin
    if (rst)
    begin
      sig_start <= 1'b0;
      state <= RST;
    end
    else
    begin 
      case (state)
        RST   : begin
                  sig_start <= 1'b0;
                  state <= START;
                end
        START : begin
                  sig_start <= 1'b0;
                 
                  if (sig_grant == 'd0)
		    begin
                      state <= NOP;
	             
		    end
                  else
                    state <= ADDR;
                end
    
        NOP   : begin
                  sig_start <= 1'b1;
	          state <= START;
                end
        ADDR  : begin
                  sig_start <= 1'b0;
                  state <= DATA;
                end
        DATA  : begin
                  if ((sig_error == 1'b1) || 
                      ((sig_bip == 1'b0) && (sig_wait == 1'b0)))
                  begin
                    sig_start <= 1'b1;
                     state <= START;
                  end
                  else
                  begin
                    sig_start <= 1'b0;
                    state <= DATA;
                  end
                end
      endcase
    end
  end

  integer i;
  // Drive grant, priority given to lowest request bit set
  always @(negedge clk or posedge rst)
  begin
    if (rst == 1'b1)
    begin
      sig_grant <= 'd0;
    end
    else
    begin
      for (i=0; i<= NUM_MASTERS; i=i+1)
      if (sig_start && sig_request[i])
	begin
           sig_grant[i] <= 1'b1;
	   i=NUM_MASTERS; // break the loop once we picked the first grant
	end
      else
        sig_grant[i] <= 1'b0;
    end
  end

endmodule // dut_dummy

