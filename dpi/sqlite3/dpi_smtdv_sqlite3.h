
#ifndef _SMTDV_SQLITE3_
#define _SMTDV_SQLITE3_

#include <cstdio>
#include <stdio.h>
#include <stdlib.h>
#include <utility>
#include <sqlite3.h>
#include <iostream>
#include <string>
#include <sstream>
#include <map>
#include "dpi_smtdv_data.h"
#include "dpi_smtdv_table.h"
#include "dpi_smtdv_pool.h"

using namespace std;
using namespace SMTDV;

namespace SMTDV {

  const bool SMTDV_SQLITE3_DEBUG = true;

  /** SMTDV Sqlite3 */
    class SMTDV_Sqlite3 {
      public:
        SMTDV_Sqlite3(){}
        ~SMTDV_Sqlite3(){}
      public:
         typedef std::map<std::string, SMTDV_Table*>            tp_tb_map;  // table nm : table pp
         typedef std::map<std::string, SMTDV_Table*>::iterator  tp_tb_it;
         typedef std::map<std::string, SMTDV_Pool*>             tp_pl_map;  // table nm : pool pp
         typedef std::map<std::string, SMTDV_Pool*>::iterator   tp_pl_it;
      public:
        /* create table */
        static void create_tb(std::string i_tb_nm);
        /* delete table */
        static void delete_tb(std::string i_tb_nm);
        /* create pool */
        static void create_pl(std::string i_pl_nm);
        /* delete pool */
        static void delete_pl(std::string i_pl_nm);
        /* create db */
        static void create_db(std::string i_db_nm);
        /* delete db */
        static void delete_db(std::string i_db_nm);
        /* clode db */
        static void close_db();
        /* register string field */
        static void register_string_field(std::string i_tb_nm, std::string i_fd_nm);
        /* is string field */
        static bool is_string_field(std::string i_tb_nm, std::string i_fd_nm);
        /* register longint field */
        static void register_longint_field(std::string i_tb_nm, std::string i_fd_nm);
        /* is longint field */
        static bool is_longint_field(std::string i_tb_nm, std::string i_fd_nm);
        /* register longlong field */
        static void register_longlong_field(std::string i_tb_nm, std::string i_fd_nm);
        /* is longlong field */
        static bool is_longlong_field(std::string i_tb_nm, std::string i_fd_nm);
        /* exec field */
        static void exec_field(std::string i_tb_nm);
        /* insert string value */
        static void insert_value(std::string i_tb_nm, std::string i_fd_nm, std::string i_val);
       /* exec value */
        static void exec_value(std::string i_tb_nm);
        /* flush value */
        static void flush_value(std::string i_tb_nm);
        /* exec query */
        static SMTDV_Pool* exec_query(std::string i_tb_nm, std::string i_query);
        /* exec row size */
        static int exec_row_size(SMTDV_Pool *i_pl);
        /* exec row step */
        static SMTDV_Row* exec_row_step(SMTDV_Pool *i_pl, int i_indx);
        /* exec column size */
        static int exec_column_size(SMTDV_Row* i_row);
        /* exec column step */
        static SMTDV_Column* exec_column_step(SMTDV_Row* i_row, int i_indx);
        /* get field type */
        static SMTDV_Data::type get_field_typ(std::string i_tb_nm,std::string i_fd_nm);
      private:
        static int exec_callback(void *data, int argc, char **argv, char **azColName);
      private:
        /* table map */
        static tp_tb_map & get_tb() {
          static tp_tb_map m_tb;
          return m_tb;
        }

        /* pool map */
        static tp_pl_map & get_pl() {
          static tp_pl_map m_pl;
          return m_pl;
        }

        static sqlite3 *m_db;
      };
}
#endif
