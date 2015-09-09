//----------------------------------------------------------------------
//   Copyright 2012-2013 Advanced Micro Devices Inc.
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

#include "uvm_ml_print_service.h"
#include "bp_provided.h"
#include "bp_utils.h"
#include <iostream>


using namespace Bp;
using namespace std;

extern "C" 
{
    bp_api_struct * bp_get_provided_tray();
} 


UvmMlPrintService* UvmMlPrintService::m_print_service = 0;

///////////////////////////////////////////////////////////////////////
/// UvmMlPrintService Singleton.
/// Returns a pointer to UvmMlPrintService
///
/// @return UvmMlPrintService - pointer to singleton
///
///////////////////////////////////////////////////////////////////////
UvmMlPrintService* UvmMlPrintService::GetPrintService() 
{
    if (m_print_service == 0) {
        m_print_service = new UvmMlPrintService();
    }
    return m_print_service;
}


///////////////////////////////////////////////////////////////////////
/// UvmMlPrintService Constructor.
///
///////////////////////////////////////////////////////////////////////
UvmMlPrintService::UvmMlPrintService() {}

///////////////////////////////////////////////////////////////////////
/// UvmMlPrintService Destructor.
///
///////////////////////////////////////////////////////////////////////
UvmMlPrintService::~UvmMlPrintService() {}


void UvmMlPrintService::srvc_print_request(const char * message) {
    fprintf(stdout, "%s\n", message);
}



