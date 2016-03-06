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
  uvm_component;

  typedef smtdv_system_table sys_tb_t;

  typedef struct {
    string abbr_names[$];
  } header_t;

  typedef struct {
    time sitme;
    string abbr_name;
    string desc;
  } meta_t;

  headr_t header;

  `uvm_object_param_utils_begin(sys_tb_t)
  `uvm_object_utils_end

  extern static function string get_full_name();
  extern static task run();
  extern static task set(string abbr_name);
  extern static task create_table();
  extern static task populate_label(meta_t meta);

endclass : smtdv_system_table

function string get_full_name();
  return "top.system_table";
endfunction : get_full_name

task set()

task smtdv_system_table::create_table();
  string table_nm = $psprintf("\"%s\"", this.get_full_name());

  smtdv_sqlite3::create_tb(table_nm);
  foreach (header.abbr_names[i])
    smtdv_sqlite3::register_int_field(table_nm, header.abbr_names[i]);

  smtdv_sqlite3::register_longint_field(table_nm, "time");
  smtdv_sqlite3::register_str_field(table_nm, "desc");
  smtdv_sqlite3::exec_field(table_nm);
endtask : create_table


task smtdv_system_table::populate_label();
    string table_nm = $psprintf("\"%s\"", this.cmp.get_full_name());
    //smtdv_sqlite3::insert_value(table_nm, "dec_uuid",    $psprintf("%d", item.get_transaction_id()));
endtask : populate_label

`endif // __SMTDV_SYSTEM_TABLE_SVH__
