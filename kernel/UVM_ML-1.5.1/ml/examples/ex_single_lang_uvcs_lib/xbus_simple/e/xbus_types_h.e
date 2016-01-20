/*------------------------------------------------------------------------- 
File name   : xbus_types_h.e
Title       : Common type declarations
Project     : UVM XBus UVC 
Developers  :  
Created     : 2008
Description : This file declares common types used throughout the UVC.
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



-- This define controls the address bus widths. Default values are supplied
-- here. However if the user does not want to use the default value, then this
-- define should be defined in user code that is loaded prior to this UVC.
-- Widths greater than 32 are not supported.
#ifndef XBUS_ADDR_WIDTH { define XBUS_ADDR_WIDTH 16; };



-- This type enumerates the logical names of each bus in the Verification 
-- Environment.
type xbus_bus_name_t : [NO_BUS=0];



-- This type enumerates the logical names of each agent (master, slave or
-- arbiter) in the Verification Environment. 
type xbus_agent_name_t : [NO_AGENT=0];



-- This type is used to specify whether an agent is a master, slave or
-- arbiter.
type xbus_agent_kind_t : [MASTER, SLAVE, ARBITER];



-- This type is used to distinguish reads and writes in the transfer
-- structure.
type xbus_read_write_t : [NOP, READ, WRITE] (bits :2);



-- This type is used to specify the address bus width
type xbus_addr_t : uint(bits:XBUS_ADDR_WIDTH);

type xbus_endian_t : [BIG,LITTLE];


type xbus_trans_kind_t : [GENERIC,MONITOR,MASTER,SLAVE];

unit xbus_slave_config_u like uvm_agent_config {
    -- This field holds the logical name of this physical bus. This field is
    -- automatically constrained by the UVC and should not be constrained by
    -- the user.
    bus_name : xbus_bus_name_t;

    -- This field holds the name of slave that this configuration information
    -- is for. This field is automatically constrained by the UVC and should
    -- not be constrained by the user.
    slave_name : xbus_agent_name_t;
          

};

struct xbus_slave_params like uvm_config_params {
    -- This field specifies the lowest address of the range that the slave will
    -- respond to.
    min_addr : xbus_addr_t;
   
    -- This field specifies the highest address of the range that the slave
    -- will respond to.
    max_addr : xbus_addr_t;
};
'>




// Temporary here

<'
type uvm_abstraction_level_t  : [UVM_SIGNAL, UVM_TLM, UVM_ACCEL, UVM_SIGNAL_SC]
                                                                (bits : 2);
'>
