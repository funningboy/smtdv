
#ifndef _SMTDV_DATA_
#define _SMTDV_DATA_

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>

using namespace std;

namespace SMTDV {

    /* Data type and nm */
    class SMTDV_Data{
      public:
        enum type { T_STRING, T_LONGINT, T_LONGLONG, T_HEX };          // type
        SMTDV_Data(int i_typ, std::string i_val) : typ(i_typ), val(i_val){}
        ~SMTDV_Data(){}
      public :
        int         typ;
        std::string val;
    };
}

#endif
