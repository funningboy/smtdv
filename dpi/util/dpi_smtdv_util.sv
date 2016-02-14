

`ifndef __SMTDV_UTIL__
`define __SMTDV_UTIL__

import "DPI-C" function string getenv(input string env_name);
import "DPI-C" function void setenv(input string env_name, input string env_value, int overwrite);

class smtdv_util;

  static function string getenv(string env_name);
    return getenv(env_name);
  endfunction : getenv

  static function void setenv(string env_name, string env_value, int overwrite);
    setenv(env_name, env_value, overwrite);
  endfunction : setenv

endclass : smtdv_util

`endif // __SMTDV_UTIL__
