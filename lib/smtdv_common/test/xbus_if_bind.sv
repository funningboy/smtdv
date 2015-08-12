
`ifndef __XBUS_VIF_BIND_SV__
`define __XBUS_VIF_BIND_SV__

  // bind to xbus_slave module
  bind xbus_slave xbus_if_harness#(
     .ADDR_WIDTH(ADDR_WIDTH),
     .BYTEN_WIDTH(BYTEN_WIDTH),
     .DATA_WIDTH(DATA_WIDTH)
  ) xbus_if_harness_0 (
    .clk(xbus_slave.clk),
    .resetn(xbus_slave.resetn),
    .req(xbus.req),
    .rw(xbus.rw),
    .addr(xbus.addr),
    .ack(xbus.ack),
    .byten(xbus.byten),
    .rdata(xbus.rdata),
    .wdata(xbus.wdata)
  );

`endif __XBUS_VIF_BIND_SV__
