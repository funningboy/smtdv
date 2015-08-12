
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include "dpi_smtdv_lib.h"


int main(int argc, char* argv[])
{

    dpi_smtdv_delete_db("test_db.db");

    dpi_smtdv_new_db("test_db.db");
    dpi_smtdv_create_tb("\"test_tb_0.tt\"");

    /* build up table fields ... */
    dpi_smtdv_register_string_field("\"test_tb_0.tt\"", "addr");
    dpi_smtdv_register_longint_field("\"test_tb_0.tt\"", "cycle");
    dpi_smtdv_exec_field("\"test_tb_0.tt\"");

    /* insert dec values ... */
    dpi_smtdv_insert_value("\"test_tb_0.tt\"", "addr", "a");
    dpi_smtdv_insert_value("\"test_tb_0.tt\"", "cycle", "100000");
    dpi_smtdv_exec_value("\"test_tb_0.tt\"");
    dpi_smtdv_flush_value("\"test_tb_0.tt\"");
    dpi_smtdv_insert_value("\"test_tb_0.tt\"", "addr", "b");
    dpi_smtdv_insert_value("\"test_tb_0.tt\"", "cycle", "2000000");
    dpi_smtdv_exec_value("\"test_tb_0.tt\"");
    dpi_smtdv_flush_value("\"test_tb_0.tt\"");


    dpi_smtdv_create_pl("\"test_tb_0.tt\"");
    int m_row_size, m_col_size;

    void* m_pool = (void*) dpi_smtdv_exec_query("\"test_tb_0.tt\"", "SELECT * from \"test_tb_0.tt\";");

    /* explore all leafs */
    m_row_size = dpi_smtdv_exec_row_size(m_pool);
    for (int r=0; r<m_row_size; r++) {
      void* m_row = (void*) dpi_smtdv_exec_row_step(m_pool, r);
      m_col_size  = dpi_smtdv_exec_column_size(m_row);
      for (int c=0; c<m_col_size; c++) {
        void* m_col = dpi_smtdv_exec_column_step(m_row, c);
        std::cout << " r:" << r << " c:" << c << " => " << dpi_smtdv_exec_string_data(m_col) << std::endl;
      }
    }

//    // compare expected result
//    void* m_row_0 = dpi_smtdv_exec_row_step(m_pool, 0);
//    void* m_col_0 = dpi_smtdv_exec_column_step(m_row_0, 0);
//    assert(std::string(dpi_smtdv_exec_string_data(m_col_0)) == "30" && "query unittest fail");
//
//    // compare expected result
//    void* m_row_1 = dpi_smtdv_exec_row_step(m_pool, 1);
//    void* m_col_1 = dpi_smtdv_exec_column_step(m_row_1, 0);
//    assert(std::string(dpi_smtdv_exec_string_data(m_col_1)) == "31" && "query unittest fail");


    dpi_smtdv_delete_pl("\"test_tb_0.tt\"");
    dpi_smtdv_delete_tb("\"test_tb_0.tt\"");

    /*query */
    // using sqlite3 command tool to analysis it...
    // ref : http://zetcode.com/db/sqlite/tool/
    //$ sqlite3 test_db.db
    //sqlite> .tables
    //sqlite> .mode column
    //sqlite> .headers on
    //sqlite> SELECT * FROM test_tb
    /* close db */
    dpi_smtdv_close_db();

   return 0;
}
