
`ifndef __DPI_XBUS_IMPORT_SV__
`define __DPI_XBUS_IMPORT_SV__

  import "DPI-C" function chandle dpi_xbus_create_event();
  import "DPI-C" function chandle dpi_xbus_assign_event(chandle e, longint addr, longint data);

`endif // end of __DPI_XBUS_IMPORT_SV__
