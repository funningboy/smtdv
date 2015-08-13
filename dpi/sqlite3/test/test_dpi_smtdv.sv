
import smtdv_sqlite3_pkg::*;

module test();

chandle m_pl;
chandle m_row;
chandle m_col;
int cyc;

string table_nm = "\"uvm_test_top.slave_agent[0].mon\"";

initial begin
    int m_row_size, m_col_size;
    smtdv_sqlite3::delete_db("test_db.db");
    smtdv_sqlite3::new_db("test_db.db");
    smtdv_sqlite3::create_tb(table_nm);

    /* build up table fields ... */
    smtdv_sqlite3::register_string_field(table_nm, "addr");
    smtdv_sqlite3::register_longint_field(table_nm, "cyc");
    smtdv_sqlite3::exec_field(table_nm);

    cyc = 100000000;
    /* insert values ... */
    smtdv_sqlite3::insert_value(table_nm, "addr", "a");
    smtdv_sqlite3::insert_value(table_nm, "cyc", $psprintf("%d", cyc));
    smtdv_sqlite3::exec_value(table_nm);
    smtdv_sqlite3::flush_value(table_nm);

    /* insert values ... */
    smtdv_sqlite3::insert_value(table_nm, "addr", "b");
    smtdv_sqlite3::insert_value(table_nm, "cyc", "200000000");
    smtdv_sqlite3::exec_value(table_nm);
    smtdv_sqlite3::flush_value(table_nm);

    smtdv_sqlite3::create_pl(table_nm);
    m_pl = smtdv_sqlite3::exec_query(table_nm, "SELECT addr, cyc from \"uvm_test_top.slave_agent[0].mon\";");
    m_row_size = smtdv_sqlite3::exec_row_size(m_pl);
    for (int r=0; r<m_row_size; r++) begin
      m_row = smtdv_sqlite3::exec_row_step(m_pl, r);
      m_col_size = smtdv_sqlite3::exec_column_size(m_row);
      for (int c=0; c<m_col_size; c++) begin
        m_col = smtdv_sqlite3::exec_column_step(m_row, c);
        $display("r : %d, c : %d, %s", r, c, smtdv_sqlite3::exec_string_data(m_col));
      end
    end
    smtdv_sqlite3::delete_pl(table_nm);

    /*query */
    // using sqlite3 command tool to analysis it...
    // ref : http://zetcode.com/db/sqlite/tool/
    //$ sqlite3 test_db.db
    //sqlite> .tables
    //sqlite> .mode column
    //sqlite> .headers on
    //sqlite> SELECT * FROM test_tb
    /* close db */
    smtdv_sqlite3::close_db();
//    smtdv_sqlite3::delete_db("test_db.db");

end
endmodule
