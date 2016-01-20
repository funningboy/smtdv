//----------------------------------------------------------------------
//   Copyright 2009 Cadence Design Systems, Inc.
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

/*! \file uvm_ids.h
  \brief UVM SystemC kernel message IDs.
*/
#ifndef UVM_IDS_H
#define UVM_IDS_H

#include "sysc/utils/sc_report.h"


//-----------------------------------------------------------------------------
// Report ids (uvm) following the style of SystemC kernel message reporting.
//
// Report ids in the range of 1-100.

// If SystemC kernel is modified to be aware of the UVM message ids,
// then sysc/utils/sc_utils_ids.cpp has to include this file, and 
// has to define UVM_DEFINE_MESSAGE suitably with an offset added 
// to the message id such that the id does not clash with any id 
// already used by the SystemC kernel.  
//-----------------------------------------------------------------------------

#ifndef UVM_DEFINE_MESSAGE


#if (defined(UVM_IDS_CPP) && !defined(NC_SYSTEMC))

#define UVM_DEFINE_MESSAGE(id, unused, text) \
    namespace sc_core { extern const char id[] = text; }
#else
#define UVM_DEFINE_MESSAGE(id, unused, text) \
    namespace sc_core { extern const char id[]; }
#endif

#endif
//
// UVM-SC messages
//

UVM_DEFINE_MESSAGE(UVM_MULTIPLE_STOP_PROCS_    , 1, \
        "uvm_component has multiple children named 'stop'; did you mistakenly declare 'SC_THREAD(stop)'?")
UVM_DEFINE_MESSAGE(UVM_PACKER_UNPACK_INDEX_, 2, \
        "uvm_packer unpack_index > pack_index")
UVM_DEFINE_MESSAGE(UVM_PACKER_UNPACK_OBJECT_, 3, \
        "uvm_packer unpack_object failed")
UVM_DEFINE_MESSAGE(UVM_CREATOR_NOT_FOUND_, 4, \
        "uvm creator not found for type")
UVM_DEFINE_MESSAGE(UVM_CREATOR_NOT_OBJECT_, 5, \
        "uvm creator is not an object creator")
UVM_DEFINE_MESSAGE(UVM_CREATOR_NOT_COMP_, 6, \
        "uvm creator is not a component creator")
UVM_DEFINE_MESSAGE(UVM_OVERRIDE_EXISTS_, 7, \
        "uvm type override already exists")
UVM_DEFINE_MESSAGE(UVM_CONFIG_INTERNAL_, 8, \
        "uvm config internal error")
UVM_DEFINE_MESSAGE(UVM_UNPACK_DCAST_, 9, \
        "DCAST from uvm_object failed in uvm_packer operator >>")
UVM_DEFINE_MESSAGE(UVM_PACK_NULL_, 10, \
        "Attempt to pack null uvm_object")
UVM_DEFINE_MESSAGE(UVM_UNPACK_OBJ_NO_METADATA_, 11, \
        "Attempt to unpack uvm_object without metadata")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_PHASE_UNSPECIFIED, 12, \
        "Initial phase not specified for schedule")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_PHASE_TYPE, 13, \
        "Phase not correct type for pre-run or post-run - ")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_POST_RUN_NONE, 14, \
        "No post-run phases to execute - skipping...")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_GLOBAL_TIMEOUT, 15, \
        "Global time out reached - terminating run")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_STOP_DURATION, 16, \
        "Simulation stop reason:  UVM_STOP_REASON_DURATION_COMPLETE")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_STOP_GLOBAL_TIMEOUT, 17, \
        "Simulation stop reason:  UVM_STOP_REASON_GLOBAL_TIMEOUT")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_STOP_PHASE_COMPLETE, 18, \
        "Simulation stop reason:  UVM_STOP_REASON_PHASE_COMPLETE")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_STOP_USER_REQUEST, 19, \
        "Simulation stop reason:  UVM_STOP_REASON_USER_REQUEST")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_STOP_PRERUN_PHASE_FATAL, 20, \
        "Simulation stop reason:  UVM_STOP_REASON_PRERUN_PHASE_FATAL")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_STOP_POSTRUN_PHASE_FATAL, 21, \
        "Simulation stop reason:  UVM_STOP_REASON_POSTRUN_PHASE_FATAL")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_STOP_RUN_PHASE_FATAL, 22, \
        "Simulation stop reason:  UVM_STOP_REASON_RUN_PHASE_FATAL")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_STOP_MAX_ERRORS, 23, \
        "Simulation stop reason:  UVM_STOP_REASON_MAX_ERRORS")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_STOP_UNKNOWN, 24, \
        "Simulation stop reason:  UVM_STOP_REASON_UNKNOWN")
UVM_DEFINE_MESSAGE(UVM_PHASE_CTRL_STOP_USER, 25, \
        "Simulation stopped by user")
UVM_DEFINE_MESSAGE(UVM_PHASE_UNKNOWN, 26, \
        "Unknown phase - ")
UVM_DEFINE_MESSAGE(UVM_PHASE_NULL, 27, \
        "Phase is NULL - skipping")
UVM_DEFINE_MESSAGE(UVM_PHASE_STATE_INVALID, 28, \
        "Invalid state")
UVM_DEFINE_MESSAGE(UVM_PHASE_TYPE_INVALID, 29, \
        "Invalid type")
UVM_DEFINE_MESSAGE(UVM_PHASE_CALLBACK_INVALID, 30, \
        "Unable to find callback agent for schedule/phase/state requested")
UVM_DEFINE_MESSAGE(UVM_RESOURCE_NOT_FOUND, 31, \
        "Resource not found")
UVM_DEFINE_MESSAGE(UVM_RESOURCE_READ_ONLY, 32, \
        "Resource is read-only")


#endif
