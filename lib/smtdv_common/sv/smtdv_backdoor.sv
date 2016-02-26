
`ifndef __SMTDV_BACKDOOR_SV__
`define __SMTDV_BACKDOOR_SV__

typedef class smtdv_component;
typedef class smtdv_sequence_item;

/**
* smtdv_backdoor
* parameterize universal backdoor access by querying global db
*
* @class smtdv_backdoor#(ADDR_WIDTH, DATA_WIDTH, CMP, T1)
*
*/
class smtdv_backdoor#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CMP = smtdv_component,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH)
) extends
  uvm_object;

  typedef smtdv_backdoor#(ADDR_WIDTH, DATA_WIDTH, CMP, T1) bak_t;

  smtdv_backdoor_event_t cb_map[string] = `SMTDV_CB_EVENT;

  CMP cmp;

  rand int timeout;   // define remain lifetime to check

  constraint c_timeout { timeout inside {[2:5]}; }

  `uvm_object_param_utils_begin(bak_t)
    `uvm_field_int(timeout, UVM_ALL_ON)
  `uvm_object_utils_end

  function new (string name = "smtdv_backdoor", uvm_component parent=null);
    super.new(name);
    register(parent);
  endfunction : new

  extern virtual function void register(uvm_component parent);
  extern virtual function string gen_query_cmd(string table_nm, string map, ref T1 item);
  extern virtual function void populate_item(string header, int r, int c, string data, ref T1 item);
  extern virtual function void purge_item(T1 item);
  extern virtual function void post_item(string table_nm, T1 item);
  extern virtual function void convert_2_item(string table_nm, string query, T1 item);
  extern virtual function bit compare(string table_nm, T1 item, ref T1 ritem);
  extern virtual function void finalize();

endclass : smtdv_backdoor

function void smtdv_backdoor::finalize();
endfunction : finalize

function void smtdv_backdoor::register(uvm_component parent);
  if (!$cast(cmp, parent))
    `uvm_error("SMTDV_UCAST_CMP",
      {$psprintf("UP CAST TO SMTDV CMP FAIL")})

endfunction : register

/**
 *  generate query cmd for backdoor access
 */
function string smtdv_backdoor::gen_query_cmd(string table_nm, string map, ref smtdv_backdoor::T1 item);
  string cmd;
  case(map)
    "LAST_WR_TRX":
    begin
        cmd = {$psprintf("SELECT * FROM %s WHERE dec_rw=%d AND dec_addr>=%d AND dec_addr<%d ORDER BY dec_ed_cyc DESC limit %d;",
        table_nm, WR, item.addrs[item.addr_idx], item.addrs[item.addr_idx]+item.offset, item.offset)};
    end

    "FRIST_WR_TRX":
    begin
        cmd = {$psprintf("SELECT * FROM %s WHERE dec_rw=%d AND dec_addr>=%d AND dec_addr<%d ORDER BY dec_ed_cyc ASC limit %d;",
        table_nm, WR, item.addrs[item.addr_idx], item.addrs[item.addr_idx]+item.offset, item.offset)};
    end

    // extend your query ...
    default:
    begin
        cmd = {$psprintf("SELECT * FROM %s ORDER BY dec_ed_cyc ASC;", table_nm)};
    end
  endcase

  `uvm_info(get_full_name(), {$psprintf("GET QUERY BACKDOOR CMD\n%s", cmd)}, UVM_LOW)
  return cmd;
endfunction : gen_query_cmd

/**
 * populate org item to backdoor access item if needed
 */
function void smtdv_backdoor::populate_item(string header, int r, int c, string data, ref smtdv_backdoor::T1 item);
  if (!cb_map.exists(header))
    `uvm_fatal("SMTDV_BKDOR_NO_CBMAP", {"CALLBACK HEADER MUST BE SET FOR cb_map: %s", header});

  case(cb_map[header])
    // extend your cb event
    SMTDV_CB_DATA:  begin
      item.data_beat[item.data_idx] |= data.atoi() << (r*8);
    end
  endcase
endfunction : populate_item

/**
 * purage item
 */
function void smtdv_backdoor::purge_item(smtdv_backdoor::T1 item);
  foreach(item.data_beat[i]) begin
    item.data_beat[i] = `SMTDV_UNKNOWN
  end
endfunction

/**
 * do after backdoor access
 */
function void smtdv_backdoor::post_item(string table_nm, smtdv_backdoor::T1 item);
  foreach(item.addrs[i]) begin
    item.addr_idx = i;
    item.data_idx = i;
    convert_2_item(
      table_nm,
      gen_query_cmd(table_nm, "LAST_WR_TRX", item),
      item);
  end
  `uvm_info(get_full_name(), {$psprintf("GET AFTER BACKDOOR ITEM\n%s", item.sprint())}, UVM_LOW)
endfunction

/**
 * convert backdoor access object to sequence item
 */
function void smtdv_backdoor::convert_2_item(string table_nm, string query, smtdv_backdoor::T1 item);
  chandle m_pl;  // iter pool
  chandle m_row; // iter row
  chandle m_col; // iter col
  int m_row_size =0;
  int m_col_size =0;
  int len =0;
  string header, data;

  smtdv_sqlite3::create_pl(table_nm);
  m_pl = smtdv_sqlite3::exec_query(table_nm, query);
  if (!m_pl) begin
    `uvm_warning("NOBACKDATA",{"%s BACKDOOR NOT FOUND AT QUERY: %s,", table_nm, query});
    return;
  end

  // iter row and col
  m_row_size = smtdv_sqlite3::exec_row_size(m_pl);
  for (int r=0; r<m_row_size; r++) begin
    m_row = smtdv_sqlite3::exec_row_step(m_pl, r);
    m_col_size = smtdv_sqlite3::exec_column_size(m_row);

    for (int c=0; c<m_col_size; c++) begin
      m_col = smtdv_sqlite3::exec_column_step(m_row, c);

      if (smtdv_sqlite3::is_longint_data(m_col)) begin
        header = smtdv_sqlite3::exec_header_data(m_col);
        data = smtdv_sqlite3::exec_string_data(m_col);
        populate_item(header, r, c, data, item);
      end

    end

  end

  smtdv_sqlite3::delete_pl(table_nm);
endfunction

/**
 * compare backdoor item with cur sample trx item
 */
function bit smtdv_backdoor::compare(string table_nm, smtdv_backdoor::T1 item, ref smtdv_backdoor::T1 ritem);
  if (!$cast(ritem, item.clone()))
    `uvm_error("SMTDV_DCAST_SEQ_ITEM",
      {$psprintf("DOWN CAST TO SMTDV SEQ_ITEM FAIL")})

  purge_item(ritem);
  post_item(table_nm, ritem);
  return item.compare(ritem);
endfunction


`endif // __SMTDV_BACKDOOR_SV__
