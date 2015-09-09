//----------------------------------------------------------------------
//   Copyright 2012 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

#include "bp_utils.h"
#include <sstream>

extern "C" {
void * BpDlsym(const char * sym)
{
    static int   init = 0;
    static void *libHandle = NULL;

    if(!init) 
    {
        libHandle = dlopen(0, RTLD_LAZY | RTLD_GLOBAL);
        if(!libHandle) return NULL;
        init = 1;
    }
    return dlsym(libHandle, sym);
}


}

namespace Bp 
{

const string & BpExtractBaseName(const string & typeName)
{
    size_t pos = typeName.find_last_of(':');
    if (pos == string::npos) return typeName;
    else {
        static string r;
        r = typeName.substr(pos+1);
        return r;
    }
}

bool BpPrefixCompare(const string & prefixStr, const string & x, const string separators)
{
    size_t prefix_len = prefixStr.length();
    size_t x_len = x.length();
    if ((prefix_len > x_len) || 
        ((prefix_len < x_len) && (separators.find(x[prefix_len]) == string::npos)))
        return false;

    return (x.compare(0, prefix_len, prefixStr, 0, prefix_len) == 0);
}

string GetToken(const string &x, int nToken)
{
  stringstream ss(x);
  ss.clear();
  string token;//empty
  try
  {
    for(int nPos=0; ss.good() && (nPos <= nToken); nPos++)
      ss >> token;
  }
  catch(...)
  {
    return string("");
  }
  return (!ss.fail()) ? token : string("");
}

} // end namespace



extern "C" {
    void bp_utils_uvm_ml_printf(int level, const char * caller_name, const char *string,... ) {
                va_list args;

        va_start (args, string);
        Bp::BpUtils::uvm_ml_printf(level, caller_name, string, args);
        va_end(args);

    }

    const char* bp_utils_convert_uvm_ml_time_unit_to_c_str(uvm_ml_time_unit unit) { 
        return Bp::BpUtils::convert_uvm_ml_time_unit_to_c_str(unit);
    }
} // extern "C" for helper functions
