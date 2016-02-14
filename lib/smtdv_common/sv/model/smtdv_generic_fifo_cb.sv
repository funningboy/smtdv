`ifndef __SMTDV_GENERIC_FIFO_CB_SV__
`define __SNTDV_GENERIC_FIFO_CB_SV__

/**
* smtdv_generic_fifo_cb
* as basic fifo recorder to global db
*
* @class smtdv_generic_fifo_cb#(DEEP, DATA_WIDTH)
*
*/
class smtdv_generic_fifo_cb#(
  DEEP = 100,
  DATA_WIDTH = 128
  )extends
    uvm_object;

  typedef smtdv_generic_fifo_cb#(DEEP, DATA_WIDTH) fifo_cb_t;

  string attr_longint[$] = `SMTDV_FIFO_VIF_ATTR_LONGINT;
  string table_nm = "";

  `uvm_object_param_utils_begin(fifo_cb_t)
  `uvm_object_utils_end

  function new(string name="smtdv_generic_fifo_cb");
    super.new(name);
  endfunction

  extern virtual function void create_table();
  extern virtual function void pop_cb(bit[DATA_WIDTH-1:0] data, longint cyc);
  extern virtual function void push_cb(bit[DATA_WIDTH-1:0] data, longint cyc);

endclass : smtdv_generic_fifo_cb

function void smtdv_generic_fifo_cb::create_table();
  if (table_nm == "") begin
    `uvm_fatal("SMTDV_FIFO_NO_TBNM", {"SET TABLE NAME AT generic_fifo_cb"})
  end
  table_nm = $psprintf("\"%s\"", table_nm);
  smtdv_sqlite3::create_tb(table_nm);
  foreach (attr_longint[i])
    smtdv_sqlite3::register_longint_field(table_nm, attr_longint[i]);
  smtdv_sqlite3::exec_field(table_nm);
endfunction : create_table

function void smtdv_generic_fifo_cb::pop_cb(bit[DATA_WIDTH-1:0] data, longint cyc);
  smtdv_sqlite3::insert_value(table_nm, "dec_data_000", $psprintf("%d", data));
  smtdv_sqlite3::insert_value(table_nm, "dec_rw",       $psprintf("%d", RD));
  smtdv_sqlite3::insert_value(table_nm, "dec_bg_cyc",   $psprintf("%d", cyc));
  smtdv_sqlite3::insert_value(table_nm, "dec_ed_cyc",   $psprintf("%d", cyc));
  smtdv_sqlite3::exec_value(table_nm);
  smtdv_sqlite3::flush_value(table_nm);
endfunction : pop_cb

function void smtdv_generic_fifo_cb::push_cb(bit[DATA_WIDTH-1:0] data, longint cyc);
  smtdv_sqlite3::insert_value(table_nm, "dec_data_000", $psprintf("%d", data));
  smtdv_sqlite3::insert_value(table_nm, "dec_rw",       $psprintf("%d", WR));
  smtdv_sqlite3::insert_value(table_nm, "dec_bg_cyc",   $psprintf("%d", cyc));
  smtdv_sqlite3::insert_value(table_nm, "dec_ed_cyc",   $psprintf("%d", cyc));
  smtdv_sqlite3::exec_value(table_nm);
  smtdv_sqlite3::flush_value(table_nm);
endfunction : push_cb


`endif // end of __SMTDV_GENERIC_FIFO_CB_SV__
