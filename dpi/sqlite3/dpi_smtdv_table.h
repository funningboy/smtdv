
#ifndef _SMTDV_TABLE_
#define _SMTDV_TABLE_

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include <sstream>
#include <map>
#include "dpi_smtdv_data.h"
#include "dpi_smtdv_util.h"

using namespace std;
using namespace SMTDV;

namespace SMTDV {

    /* debug option */
    const bool SMTDV_TABLE_DEBUG = false;

    /* SMTDV Table */
    class SMTDV_Table {
      public:
        enum status { T_READ, T_WRITE, T_NONE };               // status : READ => READ from DB, WRITE => WRITE to DB
        SMTDV_Table(std::string i_tb_nm) : m_tb_nm(i_tb_nm){}
        ~SMTDV_Table(){}
      public:
        typedef std::pair<int,SMTDV_Data*>                 tp_pair; // SMTDV_Data :: <status, <type, value>>
        typedef std::map<std::string, tp_pair>            tp_map;  // field nm : SMTDV_Data
        typedef std::map<std::string, tp_pair>::iterator  tp_it;

      public:
        /* register field */
        void iregister(int i_typ, std::string i_fd_nm);
        /* is string */
        bool is_string(std::string i_fd_nm);
        /* is longint */
        bool is_longint(std::string i_fd_nm);
        /* is longlong */
        bool is_longlong(std::string i_fd_nm);
        /* insert field and value */
        void insert(std::string i_fd_nm, std::string i_val);
        /* get field and value */
        std::string get(std::string i_fd_nm);
        /*dump */
        void dump();
        /* flush field update status */
        void flush();
        /* return header items */
        std::string return_table_items();
        /* return body items */
        std::string return_body_items();
        /*return body values */
        std::string return_body_values();
        /* exec to sqlite3 create table ommand */
        std::string exec_field();
        /* exec to sqlite3 insert data to table command */
        std::string exec_value();
        /* clear */
      private:
          tp_map        m_record;
          std::string   m_tb_nm;
    };
}

#endif

