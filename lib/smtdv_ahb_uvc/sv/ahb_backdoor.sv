`ifndef __AHB_BACKDOOR_SV__
`define __AHB_BACKDOOR_SV__

class ahb_mem_backdoor #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  smtdv_backdoor;

  `uvm_component_param_utils_begin(`AHB_MEM_BACKDOOR)
  `uvm_component_utils_end

  function new(string name = "ahb_mem_backdoor", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function string gen_query_cmd(string table_nm, string map, ref `AHB_ITEM item);
    string cmd;
    case(map)
      "LAST_WR_TRX": begin
          cmd = {$psprintf("SELECT * FROM %s WHERE dec_rw=%d AND dec_addr>=%d AND dec_addr<%d ORDER BY dec_ed_cyc DESC limit %d;",
            table_nm, WR, item.addrs[item.addr_idx], item.addrs[item.addr_idx]+item.offset, item.offset)};
        end
      "FRIST_WR_TRX": begin
          cmd = {$psprintf("SELECT * FROM %s WHERE dec_rw=%d AND dec_addr>=%d AND dec_addr<%d ORDER BY dec_ed_cyc ASC limit %d;",
            table_nm, WR, item.addrs[item.addr_idx], item.addrs[item.addr_idx]+item.offset, item.offset)};
      end
      // extend your query ...
      default: begin
          cmd = {$psprintf("SELECT * FROM %s ORDER BY dec_ed_cyc ASC;", table_nm)};
      end
    endcase
    return cmd;
  endfunction

  virtual function void populate_item(string header, int r, int c, string data, ref `AHB_ITEM item);

    // construct back to seq item
    case(cb_map[header])
      // extend your cb event
      SMTDV_CB_DATA:  begin
        item.data_beat[item.data_idx] |= data.atoi() << (r*8);
      end
      default:  begin  end
    endcase
  endfunction

  virtual function void prepare_item(ref `AHB_ITEM item);
    bit [ADDR_WIDTH-1:0] addrs[$];
    bit [(DATA_WIDTH>>3)-1:0][7:0] data_beat[$];
    item.post_addr(item.addr, item.trx_size, item.bst_len, item.bst_type, addrs);
    item.post_data(item.bst_len, data_beat);
    item.addrs.delete();
    item.data_beat.delete();
    item.addr_idx = 0;
    item.data_idx = 0;

    foreach(addrs[i]) begin
      item.addrs.push_back(addrs[i]);
    end
    foreach(data_beat[i])begin
      item.data_beat.push_back(0);
    end
  endfunction

  virtual function void post_item(string table_nm, `AHB_ITEM item);
    for(item.data_idx =0; item.data_idx < item.bst_len; item.data_idx++) begin
      convert_2_item(
        table_nm,
        gen_query_cmd(table_nm, "LAST_WR_TRX", item),
        item);
    end
  endfunction

  virtual function void convert_2_item(string table_nm, string query, `AHB_ITEM item);
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
      //`uvm_warning("NOBACKDATA",{"backdoor %s not found at query: %s,", table_nm, query});
      return;
    end

    // iter row and col
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

  virtual function bit compare(string table_nm, `AHB_ITEM item, ref `AHB_ITEM ritem);
    prepare_item(item);
    $cast(ritem, item.clone());
    post_item(table_nm, ritem);
    return item.compare(ritem);
  endfunction

endclass


`endif // end of __AHB_BACKDOOR_SV__
