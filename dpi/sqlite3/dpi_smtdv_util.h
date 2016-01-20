
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include <sstream>
#include <map>

using namespace std;

namespace SMTDV {

    /* dec str to long int */
    static unsigned long int str_2_longint(std::string st) {
      std::stringstream ss;
      unsigned long int x;
      if (st=="") return 0;
      ss << std::dec << st;
      ss >> x;
      return x;
    }

    static std::string dpi_longint_2_str(unsigned long int i){
      std::stringstream ss;
      string x;
      ss << std::dec << i;
      ss >> x;
      return x;
    }

    /* hex str to long int */
    static unsigned long int hexstr_2_longint(std::string st) {
      std::stringstream ss;
      unsigned long int x;
      if (st=="") return 0;
      ss << std::hex << st;
      ss >> x;
      return x;
    }

    /* long int 2 hex str */
    static std::string dpi_longint_2_hexstr(unsigned long int i){
      std::stringstream ss;
      string x;
      ss << std::hex << i;
      ss >> x;
      return x;
    }
}

