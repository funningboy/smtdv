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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include <assert.h>
#include "bp_common_c.h"
#include "bp_provided.h"
#include "vpi_user.h"

static bp_preInitial_t *localPreInitial;
static int localIsUvm;
static char** localUvmTops;
static char** localUvmTests;
static bp_serror_t* localSerror;

/* Backward compatibility layer for legacy Cadence-only stuff */
typedef struct unilang_api_struct 
{

    /* setup functions */

    /* unilang_reset_type * */ void * unilang_reset;
    /* unilang_set_debug_mode_type */ void *unilang_set_debug_mode;
    /* unilang_register_adapter_type */ void *unilang_register_adapter;
    /* unilang_register_adapter_sc_type */ void *unilang_register_adapter_sc;
    /* unilang_register_top_level_type */ void *unilang_register_top_level;
    /* unilang_connect_type */ void *unilang_connect;
    /* unilang_connect_names_type */ void *unilang_connect_names;

    /* put family */

    /* unilang_put_bitstream_type */ void  *unilang_put_bitstream;
    /* unilang_from_sv_put_bitstream_request_type */ void  *unilang_from_sv_put_bitstream_request;
    /* unilang_put_bitstream_request_type */ void  *unilang_put_bitstream_request;
    /* unilang_try_put_bitstream_type */ void  *unilang_try_put_bitstream;
    /* unilang_can_put_type */ void *unilang_can_put;

    /* unilang_ok_to_put_type */ void *unilang_ok_to_put;
    /* unilang_notify_ok_to_put_type */ void *unilang_notify_ok_to_put;

    /* get family */

    /* unilang_get_bitstream_type */ void  *unilang_get_bitstream;
    /* unilang_from_sv_get_bitstream_request_type  */ void *unilang_from_sv_get_bitstream_request;
    /* unilang_get_bitstream_request_type */ void  *unilang_get_bitstream_request;
    /* unilang_try_get_bitstream_type */ void  *unilang_try_get_bitstream;
    /* unilang_can_get_type */ void *unilang_can_get;
    /* unilang_get_requested_bitstream_type */ void  *unilang_get_requested_bitstream;

    /* unilang_peek_bitstream_type */ void  *unilang_peek_bitstream;
    /* unilang_from_sv_peek_bitstream_request_type */ void  *unilang_from_sv_peek_bitstream_request;
    /* unilang_peek_bitstream_request_type */ void  *unilang_peek_bitstream_request;
    /* unilang_try_peek_bitstream_type */ void  *unilang_try_peek_bitstream;
    /* unilang_can_peek_type */ void *unilang_can_peek;
    /* unilang_peek_requested_bitstream_type */ void  *unilang_peek_requested_bitstream;

    /* unilang_notify_end_task_type */ void *unilang_notify_end_task; // ??

    /* unilang_transport_bitstream_type */ void  *unilang_transport_bitstream;
    /* unilang_from_sv_transport_bitstream_request_type */ void  *unilang_from_sv_transport_bitstream_request;
    /* unilang_transport_bitstream_request_type */ void  *unilang_transport_bitstream_request;
    /* unilang_transport_response_bitstream_type */ void  *unilang_transport_response_bitstream;
    /* unilang_transport_bitstream_type */ void  *unilang_nb_transport_bitstream;

    /* analysis_if */

    /* unilang_write_bitstream_type */ void  *unilang_write_bitstream;

    /* unilang_get_connector_size_type */ void *unilang_get_connector_size;

    /* Max pack size query */

    /* unilang_get_pack_max_size_type */ void *unilang_get_pack_max_size;
    /* unilang_set_pack_max_size_type */ void *unilang_set_pack_max_size;

    /* unilang_get_tight_packing_mode_type */ void  *unilang_get_tight_packing_mode;
    /* unilang_set_tight_packing_mode_type */ void  *unilang_set_tight_packing_mode;

    /* hierarchical construction */
    /* unilang_create_component_type */ void              *unilang_create_component;
    /* unilang_connect_component_type */ void             *unilang_connect_component;
    /* unilang_end_of_elaboration_component_type */ void  *unilang_end_of_elaboration_component;
    /* unilang_start_of_simulation_component_type */ void  *unilang_start_of_simulation_component;
    /* unilang_run_component_type */ void                  *unilang_run_component;

    /* type id */
    /* unilang_get_type_id_from_name_type */ void         *unilang_get_type_id;
    /* unilang_get_type_name_from_id_type */ void         *unilang_get_type_name;         

    /* global time management */
    /* unilang_set_current_simulation_time_type */ void   *unilang_set_current_simulation_time;
    /* unilang_get_current_simulation_time_type */ void   *unilang_get_current_simulation_time;
  /* tlm2 */
  /* unilang_from_sv_tlm2_b_transport_type */ void          *unilang_from_sv_tlm2_b_transport;
  /* unilang_tlm2_b_transport_type */ void                  *unilang_tlm2_b_transport;
  /* unilang_from_sv_tlm2_b_transport_request_type */ void  *unilang_from_sv_tlm2_b_transport_request;
  /* unilang_tlm2_b_transport_request_type */ void          *unilang_tlm2_b_transport_request;
  /* unilang_from_sv_tlm2_b_transport_response_type */ void *unilang_from_sv_tlm2_b_transport_response;
  /* unilang_tlm2_b_transport_response_type */ void         *unilang_tlm2_b_transport_response;
  /* unilang_from_sv_tlm2_nb_transport_fw_type */ void      *unilang_from_sv_tlm2_nb_transport_fw;
  /* unilang_tlm2_nb_transport_fw_type */ void              *unilang_tlm2_nb_transport_fw;
  /* unilang_from_sv_tlm2_nb_transport_bw_type */ void      *unilang_from_sv_tlm2_nb_transport_bw;
  /* unilang_tlm2_nb_transport_bw_type */ void              *unilang_tlm2_nb_transport_bw;
  /* unilang_tlm2_transport_dbg_type */ void                *unilang_tlm2_transport_dbg; // No equivalent in SV yet

  /* tlm2 transaction id */
  /* unilang_assign_transaction_id_type */ void             *unilang_assign_transaction_id;
  /* unilang_set_transaction_mapping_type */ void           *unilang_set_transaction_mapping; 
} unilang_api_struct; 

/* Never dlclose the global handle as we use it for comparisons */
static void *global_handle = 0;
static void *libgcc_handle = 0;
static void *libstdcpp_handle = 0;
static void *cpp_backplane_handle = 0;


static void cdns_close_uvm_ml_backplane() { 
    int result;

    /* Return if we just duplicated the global handle */
    
    if ( cpp_backplane_handle != 0 && cpp_backplane_handle == global_handle ) {
        return;
    }

    if ( cpp_backplane_handle != 0  ) {
        result = dlclose(cpp_backplane_handle);
        cpp_backplane_handle = 0;
        if ( result != 0 ) {
            if (getenv("UVM_ML_DEBUG_MODE")) {
                vpi_printf( "UVM-ML-OA ERROR: Unable to close the backplane handle - %s\n", dlerror());
            }
        } 
    }
    
    if ( libstdcpp_handle != 0 ) { 
        result = dlclose(libstdcpp_handle);
        libstdcpp_handle = 0;
        if ( result != 0 ) {
            if (getenv("UVM_ML_DEBUG_MODE")) {
                vpi_printf( "UVM-ML-OA ERROR: Unable to close the libstdc++ handle - %s\n", dlerror());
            }
        }
    }

    if ( libgcc_handle != 0 ) { 

        result = dlclose(libgcc_handle);
        libgcc_handle = 0;
        if ( result != 0 ) {
            if (getenv("UVM_ML_DEBUG_MODE")) {
                vpi_printf( "UVM-ML-OA ERROR: Unable to close the libgcc_s handle - %s\n", dlerror());
            }
        }
    }
  
}

static const int BUFFER_SIZE=65536;
static const char* backplane_get_provided_tray = "bp_get_provided_tray";

void* cdns_load_uvm_ml_backplane()  { 
    char * (*cdsGetInstallRoot_ptr)();
    char prefix[BUFFER_SIZE];
    char lib_path[BUFFER_SIZE];
    


    if ( cpp_backplane_handle != 0 ) {
        return cpp_backplane_handle;
    }

    if ( global_handle == 0 ) {
        global_handle = dlopen(0, RTLD_GLOBAL | RTLD_LAZY);
        assert(global_handle != 0 );
    }


    /* Check whether the backplane is already present in the global namespace */
    /* If it is, do not load anything, just reuse the global handle */


    if ( NULL != dlsym(global_handle, backplane_get_provided_tray) ) {
      libgcc_handle = NULL;
      libstdcpp_handle = NULL;
      cpp_backplane_handle = global_handle; 
      return cpp_backplane_handle;
      
    } 
      
    
    cdsGetInstallRoot_ptr = ( char* (*)()) dlsym(global_handle, "cdsGetInstallRoot");
    
    if ( cdsGetInstallRoot_ptr == 0 ) { 
        if (getenv("UVM_ML_DEBUG_MODE")) {
            vpi_printf( "UVM-ML-OA ERROR: Failed to locate cdsGetInstallRoot");
        }
        return;
    }
    
    prefix[0] = '\0';
    strcpy(prefix, cdsGetInstallRoot_ptr());
    strcat(prefix, "/tools/lib");

#ifdef BUILD_64BIT
    strcat(prefix , "/64bit");
#endif
    
    strcpy(lib_path, prefix);
    // FIXME - be sure you get the right version here
    strcat(lib_path, "/libgcc_s.so");
    libgcc_handle = dlopen(lib_path, RTLD_GLOBAL | RTLD_LAZY);
    if ( libgcc_handle == 0 ) { 
        if (getenv("UVM_ML_DEBUG_MODE")) {
            vpi_printf( "UVM-ML-OA ERROR: Failed to open libgcc_s.so %s\n", dlerror());
        }
        return 0;
    }

    strcpy(lib_path, prefix);
    // FIXME - be sure you get the right version here
    strcat(lib_path, "/libstdc++.so.6"); 
    libstdcpp_handle = dlopen(lib_path, RTLD_GLOBAL | RTLD_LAZY);
    if ( libstdcpp_handle == 0 ) { 
        if (getenv("UVM_ML_DEBUG_MODE")) {
            vpi_printf( "UVM-ML-OA ERROR: Failed to open libstdc++.so.6 %s\n", dlerror());
        }
        cdns_close_uvm_ml_backplane();
        return 0;
    }
    

    if ( cpp_backplane_handle == 0 ) {
        cpp_backplane_handle = dlopen("libuvm_ml_bp.so",RTLD_GLOBAL | RTLD_LAZY);
    }

    if ( cpp_backplane_handle == 0 ) { 
        if (getenv("UVM_ML_DEBUG_MODE")) {
            vpi_printf( "UVM-ML-OA ERROR: Failed to open libuvm_ml_bp.so %s\n", dlerror());
            /* FIXME eventually - invoke serror here */
        }
        /* Error code is required */
        cdns_close_uvm_ml_backplane();
        return 0;
    }

    return cpp_backplane_handle;
    
}





static int reset_callbacks_registered = 0;




static unilang_api_struct unilang_api;

static unilang_api_struct * unilang_bootstrap_proper 
(
    bp_preInitial_t *preInitial,
    int              is_uvm,
    char **          uvmTops,
    char **          uvmTests,
    bp_serror_t *    serror
);


static PLI_INT32 start_of_reset_handler(p_cb_data cb_data) {
    bp_api_struct* (*bp_get_provided_tray_ptr)();
    bp_api_struct* bp_tray;
    
    if (getenv("UVM_ML_DEBUG_MODE")) {
        vpi_printf( "UVM-ML-OA INFO: Start of reset\n");
    }
    

    cdns_close_uvm_ml_backplane();


    bp_get_provided_tray_ptr = (bp_api_struct* (*)())dlsym(global_handle, backplane_get_provided_tray);
    if ( bp_get_provided_tray_ptr ) { 
        if (getenv("UVM_ML_DEBUG_MODE")) {
            vpi_printf( "UVM-ML-OA INFO: THE BACKPLANE IS STILL LOADED\n");
        }
        bp_tray = bp_get_provided_tray_ptr();
        if ( bp_tray && bp_tray->reset_ptr ) {
          (bp_tray->reset_ptr)();
        }
        /* FIXME  - change the backplane so that no error message is given if bootstrap is reinvoked post-reset */
    } else { 
        if (getenv("UVM_ML_DEBUG_MODE")) {
            vpi_printf( "UVM-ML-OA INFO: THE BACKPLANE HAS BEEN UNLOADED\n");
        }
    }
    

    return 0;
}

static PLI_INT32 end_of_reset_handler(p_cb_data cb_data) {
    cdns_load_uvm_ml_backplane();
    if (getenv("UVM_ML_DEBUG_MODE")) {
        vpi_printf( "UVM-ML-OA INFO: End of reset\nUVM-ML-OA INFO: Re-invoking bootstrap\n");
    }

    unilang_bootstrap_proper(localPreInitial, localIsUvm, localUvmTops, localUvmTests, localSerror);

    return 0; 
}

static inline void bp_cdns_register_callbacks() {


    if ( reset_callbacks_registered == 0 ) {
        reset_callbacks_registered = 1;
    
        s_cb_data start_of_reset_data;
        start_of_reset_data.cb_rtn = start_of_reset_handler;
        start_of_reset_data.reason = cbStartOfReset;
        start_of_reset_data.obj = NULL;
        start_of_reset_data.user_data = NULL;

        vpiHandle start_of_reset_handle = vpi_register_cb(&start_of_reset_data);
        if ( start_of_reset_handle == NULL ) { 
            if (getenv("UVM_ML_DEBUG_MODE")) {
                vpi_printf( "ERROR: Failed to register start of reset handler\n");
            }
        }

        s_cb_data end_of_reset_data; 
        end_of_reset_data.cb_rtn = end_of_reset_handler;
        end_of_reset_data.reason = cbEndOfReset;
        end_of_reset_data.obj = NULL;
        end_of_reset_data.user_data = NULL;

        vpiHandle end_of_reset_handle = vpi_register_cb(&end_of_reset_data);
        if ( end_of_reset_handle == NULL) { 
            if (getenv("UVM_ML_DEBUG_MODE")) {
                vpi_printf( "UVM-ML-OA ERROR: Failed to register end of reset handler\n");
            }
        }


    }
    // ----------------------------------------------------
}


static void unilang_reset_handler() {
    /* For flows where 'reset' comes even before 'run' */
    if (getenv("UVM_ML_DEBUG_MODE")) {
        vpi_printf( "UVM-ML-OA INFO: Unilang reset handler\n");
    }
    bp_cdns_register_callbacks();
}





typedef int (*bp_elaborate_type)(void*);

static int bp_cdns_elaborate(void *cbInfo) { 
    bp_elaborate_type bp_elaborate_ptr = 0;

    if ( bp_elaborate_ptr == 0 ) { 
        bp_elaborate_ptr = (bp_elaborate_type)dlsym(global_handle, "uvm_ml_bp_elaborate");
    }

    assert(bp_elaborate_ptr != 0);
    bp_cdns_register_callbacks();
    return  bp_elaborate_ptr(cbInfo);

}


extern bp_api_struct *bp_bootstrap(char **uvmTops,
                                       char **uvmTests,
                         bp_serror_t   *   serror);

static void cache_bootstrap_data(
    bp_preInitial_t *preInitial,
    int              is_uvm,
    char **          uvmTops,
    char **          uvmTests,
    bp_serror_t *    serror
                                 ) 
{
    int numberOfTops = 0;
    int numberOfTests = 0;
    int i = 0;


    localPreInitial = preInitial;
    localSerror = serror;
    localIsUvm = is_uvm;

    while (uvmTops[numberOfTops]) {
        ++numberOfTops;
    }

    
    
    localUvmTops = calloc(numberOfTops+1, sizeof(char*));
    localUvmTops[numberOfTops] = 0;

    for ( i = 0; i < numberOfTops; ++i ) { 
        localUvmTops[i] = strdup(uvmTops[i]);
    }

    while (uvmTests[numberOfTests]) {
        ++numberOfTests;
    }

    localUvmTests = calloc(numberOfTests+1, sizeof(char*));
    localUvmTests[numberOfTests] = 0;

    for ( i = 0; i < numberOfTests; ++i ) { 
        localUvmTests[i] = strdup(uvmTests[i]);
    }


}


typedef bp_api_struct* (*bp_bootstrap_type)(char**, char**, bp_serror_t*);

static unilang_api_struct * unilang_bootstrap_proper 
(
    bp_preInitial_t *preInitial,
    int              is_uvm,
    char **          uvmTops,
    char **          uvmTests,
    bp_serror_t *    serror
)
{
    bp_bootstrap_type bp_bootstrap_ptr = (bp_bootstrap_type)0;

    bp_bootstrap_ptr = (bp_bootstrap_type)dlsym(global_handle, "uvm_ml_bp_bootstrap");

    assert(bp_bootstrap_ptr != 0);

    if (preInitial) 
    {
      (*preInitial)(bp_cdns_elaborate, (void *) preInitial);
    }
    

    bp_api_struct * bp_api = bp_bootstrap_ptr(uvmTops, uvmTests, serror);

    /*    unilang_backplane_initialized = true; */
    memset(&unilang_api, 0, sizeof(unilang_api_struct));
    

    // Register the reset callback
    unilang_api.unilang_reset = (void*)unilang_reset_handler;
    return &unilang_api;
}

#define cdnEnableDPIExportFunc 961 


void uvm_ml_ncsim_dpi_export_context(int set)
{
    if (getenv("UVM_ML_DEBUG_MODE")) {
        vpi_printf( "UVM-ML-OA INFO: Setting DPI export to %d\n", set);
    }
    vpi_control(cdnEnableDPIExportFunc, set);
}





unilang_api_struct * unilang_bootstrap
(
    bp_preInitial_t *preInitial,
    int              is_uvm,
    char **          uvmTops,
    char **          uvmTests,
    bp_serror_t *    serror
)
{
    cdns_load_uvm_ml_backplane(); 
    cache_bootstrap_data(preInitial, is_uvm, uvmTops, uvmTests, serror);

    unilang_bootstrap_proper(localPreInitial, localIsUvm, localUvmTops, localUvmTests, localSerror);
}
