`ifndef __SMTDV_GENERIC_FIFO_CB_SV__
`define __SNTDV_GENERIC_FIFO_CB_SV__

class smtdv_generic_fifo_cb #(DEEP = 100, DATA_WIDTH = 128)
  extends
  uvm_object;

  string attr_longint[$] = `SMTDV_FIFO_VIF_ATTR_LONGINT;
  string table_nm = "";

  `uvm_object_param_utils_begin(smtdv_generic_fifo_cb#(DEEP, DATA_WIDTH))
  `uvm_object_utils_end

  function new(string name="smtdv_generic_fifo_cb");
    super.new(name);
  endfunction

  virtual function void create_table();
    if (table_nm == "") begin
      `uvm_fatal("NOTBNM", {$psprintf("set table name at generic_fifo cb")})
    end
    table_nm = $psprintf("\"%s\"", table_nm);
    smtdv_sqlite3::create_tb(table_nm);
    foreach (attr_longint[i])
      smtdv_sqlite3::register_longint_field(table_nm, attr_longint[i]);
    smtdv_sqlite3::exec_field(table_nm);
  endfunction

  virtual function void pop_cb(bit[DATA_WIDTH-1:0] data, longint cyc);
    smtdv_sqlite3::insert_value(table_nm, "dec_data_000", $psprintf("%d", data));
    smtdv_sqlite3::insert_value(table_nm, "dec_rw",       $psprintf("%d", RD));
    smtdv_sqlite3::insert_value(table_nm, "dec_bg_cyc",   $psprintf("%d", cyc));
    smtdv_sqlite3::insert_value(table_nm, "dec_ed_cyc",   $psprintf("%d", cyc));
    smtdv_sqlite3::exec_value(table_nm);
    smtdv_sqlite3::flush_value(table_nm);
  endfunction

  virtual function void push_cb(bit[DATA_WIDTH-1:0] data, longint cyc);
    smtdv_sqlite3::insert_value(table_nm, "dec_data_000", $psprintf("%d", data));
    smtdv_sqlite3::insert_value(table_nm, "dec_rw",       $psprintf("%d", WR));
    smtdv_sqlite3::insert_value(table_nm, "dec_bg_cyc",   $psprintf("%d", cyc));
    smtdv_sqlite3::insert_value(table_nm, "dec_ed_cyc",   $psprintf("%d", cyc));
    smtdv_sqlite3::exec_value(table_nm);
    smtdv_sqlite3::flush_value(table_nm);
  endfunction

endclass

`endif // end of __SMTDV_GENERIC_FIFO_CB_SV__
