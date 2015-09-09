/*-------------------------------------------------------------------------  
File name   : xbus_trans_h.e
Title       : Transfer structure
Project     : XBus UVC
Created     : 2008
Description : This file declares the base struct that represents a single
            : transfer on the bus.
Notes       : The addr, read_write and data fields are marked as physical
            : fields (with a % symbol). These fields are not used for
            : packing in this UVC and so the % symbols are not required.
            : However, marking these fields as such indicates that these
            : are the fields that are physically driven to the DUT. It
            : also facilitates the use of the deep_compare_physical()
            : method, should the user need to do so.
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


-- This struct represents a single XBus transfer. It is used as the item for
-- the master agent's sequence driver.
struct xbus_trans_s like any_sequence_item {

    -- This field is used to sub-type the transfer struct. By default the
    -- transfer is a GENERIC transfer, but other parts of the UVC extend the
    -- enumerated values to create sub-types that can have extra fields etc.
    -- for special purposes (e.g. a master can create a MASTER xbus_trans_s
    -- with extra fields).
    kind : xbus_trans_kind_t;
        keep soft kind == GENERIC;
        
    -- This field contains the address for the transfer.
    %addr : xbus_addr_t;
         
    -- This field indicates value to be written to bus
    %size_ctrl : uint (bits : 2);
       keep size == 1 => size_ctrl == 0;
       keep size == 2 => size_ctrl == 1;
       keep size == 4 => size_ctrl == 2;
       keep size == 8 => size_ctrl == 3;
      
    -- This field indicates whether this is a a read or write transfer.
    %read_write : xbus_read_write_t;
        keep read_write in [READ, WRITE];

    -- This field indicates the size of the transfer in bytes.
    size : uint [1, 2, 4, 8];

    -- This field contains the data to be transferred as a list of bytes, the
    -- size of the list depends on the size field.
    %data[size] : list of byte;
    
    master_name : xbus_agent_name_t;
      keep soft master_name == NO_AGENT;
    slave_name  : xbus_agent_name_t;
      keep soft slave_name == NO_AGENT;

    -- This method returns the transfer in a "nice" string form that gives a
    -- brief summary of the transfer.
    nice_string() : string is only {
        if read_write == WRITE {
            result = append(read_write, 
                        "(", 
                        size,
                        ",", 
                        addr,
                        ",{",
                        data,
                        "})");
        } else {
            result = append(read_write, 
                        "(", 
                        size,
                        ",", 
                        addr,
                        ")");
        };
    }; -- nice_string()
    
}; -- struct xbus_trans_s

'>

