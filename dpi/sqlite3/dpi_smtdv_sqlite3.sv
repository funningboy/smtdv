
`ifndef __SMTDV_SQLITE3__
`define __SMTDV_SQLITE3__

  import "DPI-C" function void dpi_smtdv_new_db(string i_db_nm);
  import "DPI-C" function void dpi_smtdv_close_db();
  import "DPI-C" function void dpi_smtdv_delete_db(string i_db_nm);
  import "DPI-C" function void dpi_smtdv_create_tb(string i_tb_nm);
  import "DPI-C" function void dpi_smtdv_delete_tb(string i_tb_nm);
  import "DPI-C" function void dpi_smtdv_create_pl(string i_tb_nm);
  import "DPI-C" function void dpi_smtdv_delete_pl(string i_tb_nm);
  import "DPI-C" function void dpi_smtdv_register_string_field(string i_tb_nm, string i_fd_nm);
  import "DPI-C" function void dpi_smtdv_register_longint_field(string i_tb_nm, string i_fd_nm);
  import "DPI-C" function void dpi_smtdv_register_longlong_field(string i_tb_nm, string i_fd_nm);
  import "DPI-C" function void dpi_smtdv_exec_field(string i_tb_nm);
  import "DPI-C" function void dpi_smtdv_insert_value(string i_tb_nm, string i_fd_nm, string i_val);
  import "DPI-C" function void dpi_smtdv_exec_value(string i_tb_nm);
  import "DPI-C" function void dpi_smtdv_flush_value(string i_tb_nm);
  import "DPI-C" function chandle dpi_smtdv_exec_query(string i_tb_nm, string i_query);
  import "DPI-C" function int  dpi_smtdv_exec_row_size(chandle i_pl);
  import "DPI-C" function chandle dpi_smtdv_exec_row_step(chandle i_pl, int i_indx);
  import "DPI-C" function int  dpi_smtdv_exec_column_size(chandle i_row);
  import "DPI-C" function chandle dpi_smtdv_exec_column_step(chandle i_row, int i_indx);
  import "DPI-C" function string dpi_smtdv_exec_string_data(chandle i_dt);
  import "DPI-C" function string dpi_smtdv_exec_header_data(chandle i_dt);
  import "DPI-C" function bit  dpi_smtdv_is_string_data(chandle i_dt);
  import "DPI-C" function bit  dpi_smtdv_is_longint_data(chandle i_dt);
  import "DPI-C" function bit  dpi_smtdv_is_longlong_data(chandle i_dt);

class smtdv_sqlite3;

  static int map_db[string];
  static int map_tb[string];
  static int indx_db = 0;
  static int indx_tb = 0;

  static function void close_db();
    dpi_smtdv_close_db();
  endfunction : close_db

  static function bit has_db(string i_db_nm);
    return map_db.exists(i_db_nm);
  endfunction : has_db

  static function void new_db(string i_db_nm);
    dpi_smtdv_new_db(i_db_nm);
    map_db[i_db_nm] = indx_db++;
  endfunction : new_db

  static function void delete_db(string i_db_nm);
    dpi_smtdv_delete_db(i_db_nm);
    map_db.delete(i_db_nm);
  endfunction : delete_db

  static function bit has_tb(string i_tb_nm);
    return map_tb.exists(i_tb_nm);
  endfunction : has_tb

  static function void create_tb(string i_tb_nm);
    dpi_smtdv_create_tb(i_tb_nm);
    map_tb[i_tb_nm] = indx_tb++;
  endfunction : create_tb

  static function void delete_tb(string i_tb_nm);
    dpi_smtdv_delete_tb(i_tb_nm);
    map_tb.delete(i_tb_nm);
  endfunction : delete_tb

  static function void create_pl(string i_tb_nm);
    dpi_smtdv_create_pl(i_tb_nm);
  endfunction : create_pl

  static function void delete_pl(string i_tb_nm);
    dpi_smtdv_delete_pl(i_tb_nm);
  endfunction : delete_pl

  static function void register_string_field(string i_tb_nm, i_fd_nm);
    dpi_smtdv_register_string_field(i_tb_nm, i_fd_nm);
  endfunction : register_string_field

  static function void register_longlong_field(string i_tb_nm, i_fd_nm);
    dpi_smtdv_register_longlong_field(i_tb_nm, i_fd_nm);
  endfunction : register_longlong_field

  static function void register_longint_field(string i_tb_nm, i_fd_nm);
    dpi_smtdv_register_longint_field(i_tb_nm, i_fd_nm);
  endfunction : register_longint_field

  static function void exec_field(string i_tb_nm);
    dpi_smtdv_exec_field(i_tb_nm);
  endfunction : exec_field

  static function void insert_value(string i_tb_nm, string i_fd_nm, string i_val);
    dpi_smtdv_insert_value(i_tb_nm, i_fd_nm, i_val);
  endfunction : insert_value

  static function void exec_value(string i_tb_nm);
    dpi_smtdv_exec_value(i_tb_nm);
  endfunction : exec_value

  static function void flush_value(string i_tb_nm);
    dpi_smtdv_flush_value(i_tb_nm);
  endfunction : flush_value

  static function chandle exec_query(string i_tb_nm, string i_query);
    return dpi_smtdv_exec_query(i_tb_nm, i_query);
  endfunction : exec_query

  static function int exec_row_size(chandle i_pl);
    return dpi_smtdv_exec_row_size(i_pl);
  endfunction : exec_row_size

  static function chandle exec_row_step(chandle i_pl, int i_indx);
    return dpi_smtdv_exec_row_step(i_pl, i_indx);
  endfunction : exec_row_step

  static function int exec_column_size(chandle i_row);
    return dpi_smtdv_exec_column_size(i_row);
  endfunction : exec_column_size

  static function chandle exec_column_step(chandle i_row, int i_indx);
    return dpi_smtdv_exec_column_step(i_row, i_indx);
  endfunction : exec_column_step

  static function string exec_header_data(chandle i_dt);
    return dpi_smtdv_exec_header_data(i_dt);
  endfunction : exec_header_data

  static function string exec_string_data(chandle i_dt);
    return dpi_smtdv_exec_string_data(i_dt);
  endfunction : exec_string_data

  static function bit is_string_data(chandle i_dt);
    return dpi_smtdv_is_string_data(i_dt);
  endfunction : is_string_data

  static function bit is_longint_data(chandle i_dt);
    return dpi_smtdv_is_longint_data(i_dt);
  endfunction : is_longint_data

  static function bit is_longlong_data(chandle i_dt);
    return dpi_smtdv_is_longlong_data(i_dt);
  endfunction : is_longlong_data

endclass : smtdv_sqlite3

`endif // __SMTDV_SQLITE3__
