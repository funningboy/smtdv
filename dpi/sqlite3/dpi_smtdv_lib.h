
#include <iostream>
#include <sstream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "dpi_smtdv_sqlite3.h"

using namespace std;
using namespace SMTDV;

#ifdef __cplusplus
extern "C" {

    /** build up new db */
    void dpi_smtdv_new_db(char* i_db_nm);
    /** system call delete db if it exist */
    void dpi_smtdv_delete_db(char* i_db_nm);
    /** close db */
    void dpi_smtdv_close_db();
    /** create table */
    void dpi_smtdv_create_tb(char* i_tb_nm);
    /** delete table */
    void dpi_smtdv_delete_tb(char* i_tb_nm);
    /** create pool */
    void dpi_smtdv_create_pl(char* i_tb_nm);
    /** delete pool */
    void dpi_smtdv_delete_pl(char* i_tb_nm);
    /** register string field nm, and type */
    void dpi_smtdv_register_string_field(char* i_tb_nm, char* i_fd_nm);
   /** register longint field nm, and type */
    void dpi_smtdv_register_longint_field(char* i_tb_nm, char* i_fd_nm);
    /** register longlong field nm, and type */
    void dpi_smtdv_register_longlong_field(char* i_tb_nm, char* i_fd_nm);
    /** exec field nm, and type */
    void dpi_smtdv_exec_field(char* i_tb_nm);
    /** insert value */
    void dpi_smtdv_insert_value(char* i_tb_nm, char* i_fd_nm, char* i_val);
    /** exec value */
    void dpi_smtdv_exec_value(char* i_tb_nm);
    /** flush status */
    void dpi_smtdv_flush_value(char* i_tb_nm);
    /** exec query */
    void* dpi_smtdv_exec_query(char* i_tb_nm, char* i_query);
    /** exec row size */
    int dpi_smtdv_exec_row_size(void* i_pl);
    /** exec row */
    void* dpi_smtdv_exec_row_step(void* i_pl, int i_indx);
    /** exec column size */
    int dpi_smtdv_exec_column_size(void* i_row);
    /** exec column */
    void* dpi_smtdv_exec_column_step(void* i_row, int i_indx);
    /** exec as string */
    char* dpi_smtdv_exec_string_data(void* i_dt);
    /** is_string_data */
    bool dpi_smtdv_is_string_data(void* i_dt);
    /** is_longint_data */
    bool dpi_smtdv_is_longint_data(void* i_dt);
    /** is_longlong_data */
    bool dpi_smtdv_is_longlong_data(void* i_dt);
//    /** find field index based on field name */
//    int dpi_smtdv_find_field_indx(char* i_tb_nm, char* i_fd_nm);
//    /** find field name based on field indx */
//    char* dpi_smtdv_find_field_name(char* i_tb_nm, int i_fd_indx);
}
#endif
