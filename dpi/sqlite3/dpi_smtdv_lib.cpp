
#include "dpi_smtdv_lib.h"
using namespace std;
using namespace SMTDV;

/* shared lib build up */
#ifdef __cplusplus
extern "C" {

    /** build up new db */
    void dpi_smtdv_new_db(char* i_db_nm) {
      SMTDV_Sqlite3::create_db(i_db_nm);
    }

    /** system call delete db, if it is exist */
    void dpi_smtdv_delete_db(char* i_db_nm) {
      SMTDV_Sqlite3::delete_db(i_db_nm);
    }

    /** close db */
    void dpi_smtdv_close_db() {
      SMTDV_Sqlite3::close_db();
    }

    /** create table */
    void dpi_smtdv_create_tb(char* i_tb_nm) {
      SMTDV_Sqlite3::create_tb(i_tb_nm);
    }

    /** delete table */
    void dpi_smtdv_delete_tb(char* i_tb_nm) {
      SMTDV_Sqlite3::delete_tb(i_tb_nm);
    }

    /** create pool */
    void dpi_smtdv_create_pl(char* i_tb_nm) {
      SMTDV_Sqlite3::create_pl(i_tb_nm);
    }

    /** delete pool */
    void dpi_smtdv_delete_pl(char* i_tb_nm) {
      SMTDV_Sqlite3::delete_pl(i_tb_nm);
    }

    /** register string field nm */
    void dpi_smtdv_register_string_field(char* i_tb_nm, char* i_fd_nm) {
      SMTDV_Sqlite3::register_string_field(i_tb_nm, i_fd_nm);
    }

    /** is string field */
    bool dpi_smtdv_is_string_field(char* i_tb_nm, char* i_fd_nm) {
      return SMTDV_Sqlite3::is_string_field(i_tb_nm, i_fd_nm);
    }

    /** register longint field nm */
     void dpi_smtdv_register_longint_field(char* i_tb_nm, char* i_fd_nm) {
      SMTDV_Sqlite3::register_longint_field(i_tb_nm, i_fd_nm);
    }

    /** is longint field */
    bool dpi_smtdv_is_longint_field(char* i_tb_nm, char* i_fd_nm) {
      return SMTDV_Sqlite3::is_longint_field(i_tb_nm, i_fd_nm);
    }

    /** register longlong field nm */
    void dpi_smtdv_register_longlong_field(char* i_tb_nm, char* i_fd_nm) {
      SMTDV_Sqlite3::register_longlong_field(i_tb_nm, i_fd_nm);
    }

    /** is longlong field */
    bool dpi_smtdv_is_longlong_field(char* i_tb_nm, char* i_fd_nm) {
      return SMTDV_Sqlite3::is_longlong_field(i_tb_nm, i_fd_nm);
    }

    /** exec field nm, and type */
    void dpi_smtdv_exec_field(char* i_tb_nm) {
      SMTDV_Sqlite3::exec_field(i_tb_nm);
    }

    /** insert string field value */
    void dpi_smtdv_insert_value(char* i_tb_nm, char* i_fd_nm, char* i_val) {
      SMTDV_Sqlite3::insert_value(i_tb_nm, i_fd_nm, i_val);
    }

    /** exec value */
    void dpi_smtdv_exec_value(char* i_tb_nm) {
      SMTDV_Sqlite3::exec_value(i_tb_nm);
    }

    /** flush status */
    void dpi_smtdv_flush_value(char* i_tb_nm) {
      SMTDV_Sqlite3::flush_value(i_tb_nm);
    }

    /** exec query */
    void* dpi_smtdv_exec_query(char* i_tb_nm, char* i_query) {
      SMTDV_Pool* pl = SMTDV_Sqlite3::exec_query(i_tb_nm, i_query);
      assert(pl!=NULL && "ERROR: dpi_smtdv_exec_query fail");
      return reinterpret_cast<void*>(pl);
    }

    /** exec row size */
    int dpi_smtdv_exec_row_size(void* i_pl) {
      SMTDV_Pool* pl = reinterpret_cast<SMTDV_Pool*>(i_pl);
      assert(pl!=NULL && "ERROR: dpi_smtdv_exec_row_size fail");
      return SMTDV_Sqlite3::exec_row_size(pl);
    }

    /** exec row step */
    void* dpi_smtdv_exec_row_step(void* i_pl, int i_indx) {
      SMTDV_Pool* pl = reinterpret_cast<SMTDV_Pool*>(i_pl);
      assert(pl!=NULL && "ERROR: dpi_smtdv_exec_row_step fail");
      SMTDV_Row* row = SMTDV_Sqlite3::exec_row_step(pl, i_indx);
      return reinterpret_cast<void*>(row);
    }

    /** exec column size */
    int dpi_smtdv_exec_column_size(void* i_row) {
      SMTDV_Row* row = reinterpret_cast<SMTDV_Row*>(i_row);
      assert(row!=NULL && "ERROR: dpi_smtdv_exec_column_size fail");
      return SMTDV_Sqlite3::exec_column_size(row);
    }

    /** exec column step */
    void* dpi_smtdv_exec_column_step(void* i_row, int i_indx) {
      SMTDV_Row* row = reinterpret_cast<SMTDV_Row*>(i_row);
      assert(row!=NULL && "ERROR: dpi_smtdv_exec_column_step fail");
      SMTDV_Column* col = SMTDV_Sqlite3::exec_column_step(row, i_indx);
      return reinterpret_cast<void*>(col);
    }

    /* exec string data*/
    char* dpi_smtdv_exec_string_data(void* i_dt) {
      SMTDV_Data* dt = reinterpret_cast<SMTDV_Data*>(i_dt);
      assert(dt!=NULL && "ERROR: dpi_smtdv_exec_string_data fail");
      char *cstr = new char[dt->val.length() + 1];
      strcpy(cstr, dt->val.c_str());
      return cstr;
    }

    /* exec header data*/
    char* dpi_smtdv_exec_header_data(void* i_dt) {
      SMTDV_Data* dt = reinterpret_cast<SMTDV_Data*>(i_dt);
      assert(dt!=NULL && "ERROR: dpi_smtdv_exec_header_data fail");
      char *cstr = new char[dt->name.length() + 1];
      strcpy(cstr, dt->name.c_str());
      return cstr;
    }

    /* dpi_smtdv_is_string_data */
    bool dpi_smtdv_is_string_data(void *i_dt) {
      SMTDV_Data* dt = reinterpret_cast<SMTDV_Data*>(i_dt);
      assert(dt!=NULL && "ERROR: dpi_smtdv_is_string_data fail");
      return dt->typ == SMTDV_Data::T_STRING;
    }

    /* dpi_smtdv_is_longint_data */
    bool dpi_smtdv_is_longint_data(void *i_dt) {
      SMTDV_Data* dt = reinterpret_cast<SMTDV_Data*>(i_dt);
      assert(dt!=NULL && "ERROR: dpi_smtdv_is_string_data fail");
      return dt->typ == SMTDV_Data::T_LONGINT;
    }

    /* dpi_smtdv_is_longlong_data */
    bool dpi_smtdv_is_longlong_data(void *i_dt) {
      SMTDV_Data* dt = reinterpret_cast<SMTDV_Data*>(i_dt);
      assert(dt!=NULL && "ERROR: dpi_smtdv_is_string_data fail");
      return dt->typ == SMTDV_Data::T_LONGLONG;
    }
}
#endif
