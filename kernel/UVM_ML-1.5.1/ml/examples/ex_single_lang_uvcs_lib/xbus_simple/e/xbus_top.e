/*-------------------------------------------------------------------------  
File name   : xbus_top.e
Title       : Top Level of UVC
Project     : UVM XBus UVC
Created     : 2008
Description : This file imports all the files of the UVC.
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

import simple_ram_env.e;

import xbus_types_h;
import xbus_trans_h;
import xbus_signal_map_h;
import xbus_bus_monitor_h;
import xbus_agent_h;
import xbus_env_h;
import xbus_master_sequence_h;
import xbus_slave_sequence_h;

import xbus_bus_monitor;
import xbus_protocol_checker;

import xbus_bfm.e;
import xbus_master_bfm;
import xbus_slave_bfm;

import xbus_slave_agent; 
import xbus_master_agent;
import xbus_slave_agent;
import xbus_basic_seq_lib;

import xbus_env;
import xbus_coverage;
import xbus_end_test;
'>

