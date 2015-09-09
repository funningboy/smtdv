/*-------------------------------------------------------------------------  
File name   : xbus_port_config.e
Title       : Deault binding of ports. Used in RTL
Project     : XBus UVC
Created     : March 2008
Description : This file binds the signal ports to external, and default 
            : signal names
Notes       : 
--------------------------------------------------------------------------- 
//----------------------------------------------------------------------
//   Copyright 2008-2010 Cadence Design Systems, Inc.
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
-------------------------------------------------------------------------*/ 

<'
package cdn_xbus;


extend xbus_synchronizer_u {
    keep  bind(sig_clock, external);
    keep  bind(sig_reset, external);
};

extend xbus_signal_map_u {
    keep  bind(sig_start, external);
    keep  bind(sig_addr, external);
    keep  bind(sig_size, external);
    keep  bind(sig_read, external);
    keep  bind(sig_write, external);
    keep  bind(sig_bip, external);
    keep  bind(sig_wait, external);
    keep  bind(sig_error, external);
    keep  bind(sig_data, external);
};

extend xbus_master_signal_map_u {
    keep  bind(sig_request, external);
    keep  bind(sig_grant, external);  
};

'>

  Default signal names

<'
extend xbus_synchronizer_u {
    keep soft sig_clock.hdl_path() == "xbus_clock";
    keep soft sig_reset.hdl_path() == "xbus_reset";
};
extend xbus_signal_map_u {
    keep soft sig_start.hdl_path() == "xbus_start";
    keep soft sig_addr.hdl_path()  == "xbus_addr";
    keep soft sig_size.hdl_path()  == "xbus_size";
    keep soft sig_read.hdl_path()  == "xbus_read";
    keep soft sig_write.hdl_path() == "xbus_write";
    keep soft sig_bip.hdl_path()   == "xbus_bip";
    keep soft sig_wait.hdl_path()  == "xbus_wait";
    keep soft sig_error.hdl_path() == "xbus_error";
    keep soft sig_data.hdl_path()  == "xbus_data";  
};


'>
