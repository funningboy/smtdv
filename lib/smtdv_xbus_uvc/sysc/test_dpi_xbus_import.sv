
`include "dpi_xbus_import.sv"

module test();

chandle xbus_e;

initial begin

  xbus_e = dpi_xbus_create_event();
  dpi_xbus_assign_event(xbus_e, 10, 100);
  dpi_xbus_emit_event(xbus_e);
  dpi_xbus_return_event(xbus_e, addr, data);
  dpi_xbus_free_event(xbus_e);

  $finish;
end

endmodule
