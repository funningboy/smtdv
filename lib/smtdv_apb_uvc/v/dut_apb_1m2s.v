
`timescale 1ns/10ps

`include "apb_master.v"
`include "apb_slave.v"

module dut_1m2s #(
  parameter integer ADDR_WIDTH  = 14,
  parameter integer DATA_WIDTH = 32
  ) (
    clk,
    resetn
);

  input [0:0]             clk;
  input [0:0]             resetn;

  wire [ADDR_WIDTH-1:0]  w_paddr;
  wire [0:0]             w_prwd;
  wire [DATA_WIDTH-1:0]  w_pwdata;
  wire [15:0]            w_psel; // master [15:0], slave[0:0]
  wire [0:0]             w_penable;

  wire [DATA_WIDTH-1:0]  w_prdata[3];
  wire [0:0]             w_pslverr[3];
  wire [0:0]             w_pready[3];

  assign w_pready[2] =  (w_psel==16'h1)? w_pready[0]:
                        (w_psel==16'h2)? w_pready[1]: w_pready[0];
  assign w_pslverr[2] = (w_psel==16'h1)? w_pslverr[0]:
                        (w_psel==16'h2)? w_pslverr[1]: w_pslverr[0];
  assign w_prdata[2] =  (w_psel==16'h1)? w_prdata[0]:
                        (w_psel==16'h2)? w_prdata[1]: w_prdata[0];

  genvar i;
  generate
  for (i=0; i < 1; i++) begin: M
    // instances: top.u_dut_1m2s.M[0].u_apb_master,
    apb_master #(
      .ADDR_WIDTH   (ADDR_WIDTH),
      .DATA_WIDTH   (DATA_WIDTH)
    ) u_apb_master (
      .clk(clk),
      .resetn(resetn),

      .paddr(w_paddr),
      .prwd(w_prwd),
      .pwdata(w_pwdata),
      .psel(w_psel),
      .penable(w_penable),

      .prdata(w_prdata[2]),
      .pready(w_pready[2]),
      .pslverr(w_pslverr[2])
    );
  end
  endgenerate

  generate
  for (i=0; i < 2; i++)  begin: S
    // instances: top.u_dut_1m2s.S[0].u_apb_slave,..
    apb_slave #(
      .ADDR_WIDTH   (ADDR_WIDTH),
      .DATA_WIDTH   (DATA_WIDTH)
    ) u_apb_slave (
      .clk(clk),
      .resetn(resetn),

      .paddr(w_paddr),
      .prwd(w_prwd),
      .pwdata(w_pwdata),
      .psel(w_psel[i]),
      .penable(w_penable),

      .prdata(w_prdata[i]),
      .pready(w_pready[i]),
      .pslverr(w_pslverr[i])
    );
  end
  endgenerate

  // implement your code here ...
endmodule
