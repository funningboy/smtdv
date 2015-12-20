
`ifndef __SMTDV_GENERIC_MEMORY_CB_SV__
`define __SNTDV_GENERIC_MEMORY_CB_SV__

/**
* smtdv_generic_memory_cb
* as basic memory recorder to global db
* // TODO: future tasks ....
*  // find first best match trx
*  // find last best match trx
*  //static function void find_last_best_match_trx(string table_nm, ref smtdv_sequence_item src, ref smtdv_sequence_item ret);
*  //endfunction
*  // find chunk best match trxs
*  // find max continuous addr hit
*  // find throughput
*  // find best visited trace path
*  //
*
* @class smtdv_generic_memory_cb#(DEEP, DATA_WIDTH)
*
*/
class smtdv_generic_memory_cb#(
  ADDR_WIDTH = 64,
  DATA_WIDTH = 128
  )extends
    uvm_object;

  typedef smtdv_generic_memory_cb#(ADDR_WIDTH, DATA_WIDTH) mem_cb_t;

  typedef bit [ADDR_WIDTH-1:0] gene_mem_addr_t;
  typedef bit [(DATA_WIDTH>>3)-1:0][7:0] byte16_t;

  string attr_longint[$] = `SMTDV_MEM_VIF_ATTR_LONGINT;
  string table_nm = "";

  `uvm_object_param_utils_begin(mem_cb_t)
  `uvm_object_utils_end

  function new(string name="smtdv_generic_memory_cb");
    super.new(name);
  endfunction

  extern virtual function void create_table();
  extern virtual function void mem_store_byte_cb(gene_mem_addr_t addr, byte unsigned data, longint cyc);
  extern virtual function void mem_load_byte_cb(gene_mem_addr_t addr, byte unsigned  data, longint cyc);

endclass : smtdv_generic_memory_cb

function void smtdv_generic_memory_cb::create_table();
  if (table_nm == "")begin
    `uvm_fatal("NOTBNM", {$psprintf("set table name at generic_mem cb")})
  end
  `uvm_info(this.get_full_name(), {table_nm}, UVM_LOW)
  smtdv_sqlite3::create_tb(table_nm);
  foreach (attr_longint[i])
    smtdv_sqlite3::register_longint_field(table_nm, attr_longint[i]);
  smtdv_sqlite3::exec_field(table_nm);
endfunction : create_table

// need be stream byte
function void smtdv_generic_memory_cb::mem_store_byte_cb(gene_mem_addr_t addr, byte unsigned data, longint cyc);
  smtdv_sqlite3::insert_value(table_nm, "dec_addr",    $psprintf("%d", addr));
  smtdv_sqlite3::insert_value(table_nm, "dec_rw",      $psprintf("%d", WR));
  smtdv_sqlite3::insert_value(table_nm, {$psprintf("dec_data_%03d", 0)}, $psprintf("%d", data));
  smtdv_sqlite3::insert_value(table_nm, "dec_bg_cyc",  $psprintf("%d", cyc));
  smtdv_sqlite3::insert_value(table_nm, "dec_ed_cyc",  $psprintf("%d", cyc));
  smtdv_sqlite3::exec_value(table_nm);
  smtdv_sqlite3::flush_value(table_nm);
endfunction : mem_store_byte_cb

function void smtdv_generic_memory_cb::mem_load_byte_cb(gene_mem_addr_t addr, byte unsigned  data, longint cyc);
  smtdv_sqlite3::insert_value(table_nm, "dec_addr",    $psprintf("%d", addr));
  smtdv_sqlite3::insert_value(table_nm, "dec_rw",      $psprintf("%d", RD));
  smtdv_sqlite3::insert_value(table_nm, {$psprintf("dec_data_%03d", 0)}, $psprintf("%d", data));
  smtdv_sqlite3::insert_value(table_nm, "dec_bg_cyc",  $psprintf("%d", cyc));
  smtdv_sqlite3::insert_value(table_nm, "dec_ed_cyc",  $psprintf("%d", cyc));
  smtdv_sqlite3::exec_value(table_nm);
  smtdv_sqlite3::flush_value(table_nm);
endfunction : mem_load_byte_cb

`endif // __SMTDV_GENERIC_MEMORY_CB_SV__
