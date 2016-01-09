
`timescale 1ns/10ps

`include "ahb_typedefs.svh"
`include "ahb_master.v"
`include "ahb_slave.v"

module dut_1m1s #(
  parameter integer ADDR_WIDTH  = 14,
  parameter integer DATA_WIDTH = 32
  ) (
    clk,
    resetn
);

  input [0:0]             clk;
  input [0:0]             resetn;

  wire [ADDR_WIDTH-1:0]   w_haddr;
  wire [1:0]              w_htrans;
  wire [0:0]              w_hwrite;
  wire [2:0]              w_hsize;
  wire [2:0]              w_hburst;
  wire [3:0]              w_hprot;
  wire [DATA_WIDTH-1:0]   w_hwdata;
  wire [0:0]              w_hmastlock;

  wire [15:0]              w_hsel; // master [15:0], slave[0:0]

  wire [DATA_WIDTH-1:0]   w_hrdata;
  wire [0:0]              w_hreadyout;
  wire [1:0]              w_hresp;

  wire [0:0]              w_hbusreq;
  wire [0:0]              w_hgrant;

  assign w_hgrant = 1'b1;
  assign w_hsel[0] = 1'b1;

  genvar i;
  generate
  for (i=0; i < 1; i++) begin: M
    // instances: top.u_dut_1m2s.M[0].u_anb_master,
    ahb_master #(
      .ADDR_WIDTH   (ADDR_WIDTH),
      .DATA_WIDTH   (DATA_WIDTH)
    ) u_ahb_master (
      .clk(clk),
      .resetn(resetn),
      // to arbiter
      .hbusreq(w_hbusreq),
      .hmastlock(w_hmastlock),
      .hgrant(w_hgrant),
      // to ahb slave
      .haddr(w_haddr),
      .htrans(w_htrans),
      .hwrite(w_hwrite),
      .hsize(w_hsize),
      .hburst(w_hburst),
      .hprot(w_hprot),
      .hwdata(w_hwdata),
      .hrdata(w_hrdata),
      .hready(w_hreadyout),
      .hresp(w_hresp)
    );
  end
  endgenerate

  generate
  for (i=0; i < 1; i++)  begin: S
    // instances: top.u_dut_1m2s.S[0].u_ahb_slave,..
    ahb_slave #(
      .ADDR_WIDTH   (ADDR_WIDTH),
      .DATA_WIDTH   (DATA_WIDTH)
    ) u_ahb_slave (
      .clk(clk),
      .resetn(resetn),
      // DECODER
      .hsel(w_hsel[i]),

      .haddr(w_haddr),
      .htrans(w_htrans),
      .hwrite(w_hwrite),
      .hsize(w_hsize),
      .hburst(w_hburst),
      .hprot(w_hprot),
      .hwdata(w_hwdata),
      .hmastlock(w_hmastlock),
      .hready(w_hreadyout),
      .hrdata(w_hrdata),
      .hreadyout(w_hreadyout),
      .hresp(w_hresp)
    );
  end
  endgenerate

  // implement your code here ...
endmodule

