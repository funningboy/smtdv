/*------------------------------------------------------------------------- 
File name   : simple_ram_env.e
Title       : Simple RAM model env
Project     : UVM xbus
Developers  : 
Created     : 2008
Description : Provide a generic RAM model. This is implemented as a simple
            : sparse byte-oriented RAM.
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

#ifdef SPECMAN_FULL_VERSION_08_20_001 {
  import uvm_lib/e/uvm_e_top.e;
};

#ifndef SPECMAN_FULL_VERSION_08_20_001 {
  import uvm_e/e/uvm_e_top.e;
};


-- simple_ram_location_s represents a single memory location
struct simple_ram_location_s {
    address : uint;
    value   : byte;
}; -- struct simple_ram_location_s


-- simple_ram_env_u is a RAM implemented as a sparse byte-wide memory
unit simple_ram_env_u like uvm_env {


    -- keyed list of locations in the RAM
    !locations : list(key : address) of simple_ram_location_s;

    
    -- write a single byte to the RAM
    write_byte(addr : uint, data : byte) is {
        if locations.key_exists(addr) {
            locations.key(addr).value = data;
        } else {
            var temp : simple_ram_location_s = new;
            temp.address = addr;
            temp.value = data;
            locations.add(temp);
        };
    }; -- write_byte()
    

    -- check whether a byte already exists in the RAM
    byte_exists(addr : uint) : bool is {
        result = locations.key_exists(addr);
    }; -- byte_exists()


    -- read a single byte from the RAM
    read_byte(addr : uint) : uint is {
        if locations.key_exists(addr) then {
            result = locations.key(addr).value 
        } else {
            result = 0; -- higher levels of code should use byte_exists() 
                        -- method to check for this posibility
        };
    }; -- read_byte()
    
    -- write multiple bytes to the RAM
    write(addr : uint, data : list of byte) is {
        for each (d) in data do {
            write_byte(addr + index, d);
        };
    }; -- write()
    
    -- zero multiple bytes in the RAM
    zero(addr : uint, size : uint) is {
        for i from 0 to (size - 1) {
            write_byte(addr + i, 0);
        };
    }; -- zero()

    -- read multiple bytes from the RAM
    read(addr : uint, num_bytes : uint) : list of byte is {
        for i from 0 to (num_bytes - 1) {
            result.add(read_byte(addr + i));
        };
    }; -- read()
    
    -- clear entire contents of the RAM
    clear() is {
        locations.clear();
    }; -- clear()
        
}; -- uvm_env simple_ram_env_u


'>

