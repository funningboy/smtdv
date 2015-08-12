`ifndef __XBUS_IF_HARNESS_SV__
`define __XBUS_IF_HARNESS_SV__

// ref xbus master.v port type
// map table
// type : interface type
// reg out: ref logic
// input: inout logic
// assign out(wire): inout logic
//
interface xbus_slave_if_harness #(
  parameter int ADDR_WIDTH  = 14,
  parameter int BYTEN_WIDTH = 4,
  parameter int DATA_WIDTH = 32
  ) (
    input clk,
    input resetn,

    inout logic [0:0]   req, // input
    inout logic [0:0]    rw, // input
    inout logic [ADDR_WIDTH-1:0]  addr, //input
    inout logic [0:0]   ack, // assign wire out
    inout logic [BYTEN_WIDTH-1:0] byten, // input
    inout logic [DATA_WIDTH-1:0] rdata,  // reg out
    // ref logic [DATA_WIDTH-1:0] rdata,  // reg out
    inout logic [DATA_WIDTH-1:0] wdata // input
  );

    bit has_force = 1;

    virtual interface xbus_if #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .BYTEN_WIDTH(BYTEN_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
    ) xbus_if_harness;

    // as eq assign
    always @(req) begin
      if (has_force)
        xbus_if_harness.req = req;
    end

    always @(rw) begin
      if (has_force)
        xbus_if_harness.rw = rw;
    end

    always @(addr) begin
      if (has_force)
        xbus_if_harness.addr = addr;
    end

    always @(byten) begin
      if (has_force)
        xbus_if_harness.byten = byten;
    end

    always @(wdata) begin
      if (has_force)
        xbus_if_harness.wdata = wdata;
    end

    always @(xbus_if_harness.ack) begin
      if (has_force)
        force ack = xbus_if_harness.ack;
      else release ack;
    end

    always @(xbus_if_harness.rdata) begin
      if (has_force)
        force rdata = xbus_if_harness.rdata;
      else release rdata;
    end

endinterface



`endif // end of  __XBUS_IF_HARNESS_SV__
