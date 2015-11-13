
#ifndef _SMTDV_POOL_
#define _SMTDV_POOL_

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include <vector>
#include "dpi_smtdv_data.h"

using namespace std;
using namespace SMTDV;

namespace SMTDV {

    /* debug option */
    const bool SMTDV_POOL_DEBUG = false;

    class SMTDV_Column : public SMTDV_Data {
      public:
        SMTDV_Column(int i_typ, std::string i_name, std::string i_val) : SMTDV_Data(i_typ, i_name, i_val){}
        ~SMTDV_Column(){}
   };

    class SMTDV_Row {
      public:
        SMTDV_Row() {}
        ~SMTDV_Row(){}
      public:
        typedef std::vector<SMTDV_Column*>            tp_col;
        typedef std::vector<SMTDV_Column*>::iterator  tp_col_it;
      public:
        /** clear */
        void clear();
        /** set */
        void set(SMTDV_Column* i_col);
        /** get */
        SMTDV_Column* get(int i_indx);
        /** get */
        tp_col get();
        /** dump */
        void dump();
      private:
        tp_col m_col;
    };

    /* SMTDV Pool */
    class SMTDV_Pool {
      public:
        SMTDV_Pool(std::string i_tb_nm) : m_tb_nm(i_tb_nm){}
        ~SMTDV_Pool(){}
        typedef std::vector<SMTDV_Row*>            tp_row;
        typedef std::vector<SMTDV_Row*>::iterator  tp_row_it;
      public:
        /** clear */
        void clear();
        /** set */
        void set(SMTDV_Row* i_row);
        /** get */
        SMTDV_Row* get(int i_indx);
        /** get */
        tp_row get();
        /** dump */
        void dump();
      private:
          std::string   m_tb_nm;
          tp_row        m_row;
      };
}

#endif
