/*------------------------------------------------------------------------- 
File name   : xbus_slave_agent.e
Title       : XBus Slave Agent
Project     : UVM XBus UVC
Developers  :  
Created     : 2008
Description : 
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

extend ACTIVE SLAVE xbus_agent_u {

    -- This is the sequence driver for an ACTIVE SLAVE agent.
    driver: xbus_slave_driver_u is instance;
        keep driver.bus_name == read_only(bus_name);
        keep driver.slave_name == read_only(agent_name);

    -- This is the BFM for an ACTIVE SLAVE agent.
    bfm : SLAVE xbus_bfm_u is instance;
        keep bfm.use_ram == read_only(use_ram);
        keep bfm.config == read_only(config);
    
    connect_pointers() is also {
        driver.synch = synch;
        bfm.driver = driver;
        bfm.synch = synch;
        bfm.smp = smp;
        bfm.ram = ram;
    };
    
    -- This is a sparse RAM model used to generate read data according
    -- to past write data.
    ram : simple_ram_env_u is instance;
    
    -- If this field is TRUE then write data will be written into the ram
    -- field and read data will be taken from the ram field. If this field
    -- is FALSE, then read data must be supplied by the slave sequence.
    use_ram : bool;
        keep soft use_ram == TRUE;
    
    
}; -- extend ACTIVE SLAVE xbus_agent_u

'>

Configuration

<'


extend SLAVE xbus_agent_u {
    configure(ctr : uint, new_params : xbus_slave_params) is {
        check that new_params.min_addr <= new_params.max_addr else
          dut_error("Configuring slave ", agent_name, 
                    " to an Illegal address space - min_addr ", 
                    new_params.min_addr,
                   " max_addr ", new_params.max_addr);
        config.params = new_params.copy();
    }; -- configure

}; -- extend SLAVE xbus_agent_u
'>




