`ifndef __SMTDV_SYSTEM_TABLE_SVH__
`define __SMTDV_SYSTEM_TABLE_SVH__

// define global/local lookup table(router table) as trace recoreder
//
// ex:
//  | s time | CPU |  DMA |  RAM | DDR | description
// =====================================================
//  |        |   0 |    1  |  x   |  x  | => CPU cfg DMA to set blocks of mem to mv
//  |        |   x |    x  |  0   |  1  | => mv Data from RAM to DDR
//  |        |   1 |    0  |  x   |  x  | => interrupt CPU while DMA is completed
//static lookup table
//header
//'{
// puid:
// time:
// desc:
//}
//body
//`{
//}

class smtdv_system_table
  extends
  uvm_object;

  typedef smtdv_system_table sys_tb_t;

  typedef struct {
    string abbr_names[$];
  } header_t;

  typedef struct {
    time stime;
    string abbr_name;
    string desc;
  } meta_t;

  static header_t header;

  `uvm_object_param_utils_begin(sys_tb_t)
  `uvm_object_utils_end

  extern static function string get_top_name();
  extern static function void set_header(string abbr_name);
  extern static function void create_table();
  extern static function void populate_label(meta_t meta);

endclass : smtdv_system_table

function string smtdv_system_table::get_top_name();
  return "top.system_table";
endfunction : get_top_name

function void smtdv_system_table::set_header(string abbr_name);
  header.abbr_names.push_back(abbr_name);
endfunction : set_header

function void smtdv_system_table::create_table();
  string table_nm = $psprintf("\"%s\"", get_top_name());

  smtdv_sqlite3::create_tb(table_nm);
  foreach (header.abbr_names[i])
    smtdv_sqlite3::register_longint_field(table_nm, {$psprintf("\"%s\"", header.abbr_names[i])});

  smtdv_sqlite3::register_longint_field(table_nm, "time");
  smtdv_sqlite3::register_string_field(table_nm, "desc");
  smtdv_sqlite3::exec_field(table_nm);
endfunction : create_table


function void smtdv_system_table::populate_label(meta_t meta);
  string table_nm = $psprintf("\"%s\"", get_top_name());
  smtdv_sqlite3::insert_value(table_nm, "time", {$psprintf("%d", meta.stime)});
  smtdv_sqlite3::insert_value(table_nm, {$psprintf("\"%s\"", meta.abbr_name)}, "1");
  smtdv_sqlite3::insert_value(table_nm, "desc", {$psprintf("%s", meta.desc)});
  smtdv_sqlite3::exec_value(table_nm);
  smtdv_sqlite3::flush_value(table_nm);
endfunction : populate_label

`endif // __SMTDV_SYSTEM_TABLE_SVH__
