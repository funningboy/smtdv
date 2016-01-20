#include "tcl.h"
#include <stdio.h>
#include <iostream>
#include <string.h>
#include <dlfcn.h>
#include <stdlib.h>
#include "../../backplane/bp_provided.h"

using namespace std;

#if ( TCL_MAJOR_VERSION != 8 || TCL_MINOR_VERSION != 4 ) 
#error *** Only TCL 8.4 is supported by UVM-ML Tcl based debug
#endif

extern "C" {

static void * backplane_handle = NULL;

typedef void (*ncsim_dpi_export_context_type)(int);
static ncsim_dpi_export_context_type ncsim_dpi_export_context_ptr = (ncsim_dpi_export_context_type)(-1);

bp_api_struct * bpProvidedAPI = NULL;

#define BP(f) (*(GetBpProvidedAPI()->f##_ptr))
#define NCSIM_TCL_WRAP(S) \
  if (ncsim_dpi_export_context_ptr == (ncsim_dpi_export_context_type)(-1)) { \
    ncsim_dpi_export_context_ptr = (ncsim_dpi_export_context_type) BpDlsym("uvm_ml_ncsim_dpi_export_context"); \
  } \
  if (ncsim_dpi_export_context_ptr != (ncsim_dpi_export_context_type)(0)) \
    (*ncsim_dpi_export_context_ptr)(S);

#define BP_CALL_WRAP_BEGIN \
  try { \
    NCSIM_TCL_WRAP(1)

#define BP_CALL_WRAP_END \
    NCSIM_TCL_WRAP(0) \
  } \
  catch (int) { \
    return TCL_ERROR; \
}
 
// Forwarding tcl input commands to backplane
// Connecting to the backplane
static int UvmMlDebugInit() {
    backplane_handle  = dlopen(0, RTLD_LAZY);
    if ( backplane_handle != 0) {
        if (dlsym(backplane_handle, "bp_get_provided_tray") != 0) {
	    bp_api_struct* (*bp_get_provided_tray_ptr)() = 
	      (bp_api_struct* (*)())dlsym(backplane_handle, "bp_get_provided_tray");
	    bpProvidedAPI = (bp_get_provided_tray_ptr)();
            if(bpProvidedAPI == NULL) {
	        fprintf(stderr, "*** ERROR: provided tray was not obtained\n");
	        return 0; // return error code
            };
        } else {
	    fprintf(stderr, "*** ERROR: backplane_handle was not obtained\n%s\n", dlerror());
            return 0; // return error code 
        }
    } else {
        fprintf(stderr, "*** ERROR: backplane was not be loaded\n%s\n", dlerror());
        return 0; // return error code 
    }
    if(strcmp(TCL_VERSION, "8.4")) {
      fprintf(stderr, "*** ERROR: Tcl version %s not supported", TCL_VERSION);
      return 0;
    }
    return 1;
}

static bp_api_struct * GetBpProvidedAPI()
{
    if (UvmMlDebugInit() == 0) throw 0;
    return bpProvidedAPI;
}
 
static int ParsePackagePrefix(Tcl_Obj *CONST objv0, string &command)
{
  int length;
  command = string(Tcl_GetStringFromObj(objv0, &length));

  string package_prefix = "uvm_ml_ext::";

  if ((command.size() <= package_prefix.size()) || (command.compare(0, package_prefix.size(), package_prefix) != 0)) {
    fprintf(stderr, "*** UVM-ML Internal ERROR: Expected a command prefixed with %s package name", package_prefix.c_str());
    return TCL_ERROR;
  }
  // Strip the package prefix
  command = command.substr(package_prefix.size(), string::npos);

  return TCL_OK;
}

static int UvmMlInvokeCommand(string &command, 
			      unsigned arguments_token_id, 
			      int         objc, 
			      Tcl_Obj *CONST objv[])
{
  int length;
  int j = arguments_token_id; 
  char *token_ptr;
  
  while((j < objc) &&  (token_ptr = Tcl_GetStringFromObj(objv[j], &length)) && (length > 0))
  {
    command += string(" ") + token_ptr;
    j++;
  }

  int result;
  BP_CALL_WRAP_BEGIN
  result = BP(execute_command)((-1), command.c_str(), NULL, TIME_UNIT_UNDEFINED, 0);
  BP_CALL_WRAP_END

  return (result == 0) ? TCL_ERROR : TCL_OK; //UVM_ML_UNRECOGNOZED_COMMAND (-1) assumed success
}


static int UvmMlExecuteSpecificCmd(ClientData clientData,
                                  Tcl_Interp *interp,
                                  int         objc, 
                                  Tcl_Obj *CONST objv[]) 
{
  string command;
  unsigned arguments_token_id;

  // The old format is "uvm_ml_<any_command> [arguments]
  // Support old style commands where the command was concatenated with thte uvm_ml_prefix
  if (ParsePackagePrefix(objv[0], command) == TCL_OK)
  {
    string old_style_prefix = "uvm_ml_";
    if ((command.size() > old_style_prefix.size()) && (command.compare(0, old_style_prefix.size(), old_style_prefix) == 0)) {
      command = command.substr(old_style_prefix.size(), string::npos);
      arguments_token_id = 1;
    }
    else {
      fprintf(stderr, "*** ERROR: Unrecognized command %s\n", command.c_str());
      return TCL_ERROR;
    }
  }
  else
    return TCL_ERROR;
    
  return UvmMlInvokeCommand(command, arguments_token_id, objc, objv);
}

static int UvmMlExecuteGenericCmd(ClientData clientData,
                                  Tcl_Interp *interp,
                                  int         objc, 
                                  Tcl_Obj *CONST objv[]) 
{
  string command;
  unsigned arguments_token_id;
  int length;

  // The new command format is "uvm_ml {<any_command> [arguments]} | "-h[elp]"
  if (ParsePackagePrefix(objv[0], command) == TCL_OK)
  {
    if (command == "uvm_ml") {
      command = Tcl_GetStringFromObj(objv[1], &length);
      arguments_token_id = 2;
    }
    else {
      fprintf(stderr, "*** ERROR: Unrecognized command %s\n", command.c_str());
      return TCL_ERROR;
    }
  }
  else
    return TCL_ERROR;
    
  return UvmMlInvokeCommand(command, arguments_token_id, objc, objv);
}


// Declare tcl package uvm_ml_ext implementing UvmMlPhaseCmd and UvmMlTreeCmd
int Uvm_ml_ext_Init(Tcl_Interp *interp ) { 
    if ( Tcl_InitStubs(interp, TCL_VERSION, 0 ) == NULL ) { 
        return TCL_ERROR;
    }

    Tcl_CreateObjCommand(interp, "uvm_ml_ext::uvm_ml", UvmMlExecuteGenericCmd, 
			 (ClientData)NULL, (Tcl_CmdDeleteProc*)NULL);
    Tcl_CreateObjCommand(interp, "uvm_ml_ext::uvm_ml_phase", UvmMlExecuteSpecificCmd,
			 (ClientData)NULL, (Tcl_CmdDeleteProc*)NULL);
    Tcl_CreateObjCommand(interp, "uvm_ml_ext::uvm_ml_print_tree", UvmMlExecuteSpecificCmd, 
			 (ClientData)NULL, (Tcl_CmdDeleteProc*)NULL);
    Tcl_CreateObjCommand(interp, "uvm_ml_ext::uvm_ml_print_connections", UvmMlExecuteSpecificCmd, 
			 (ClientData)NULL, (Tcl_CmdDeleteProc*)NULL);
    Tcl_CreateObjCommand(interp, "uvm_ml_ext::uvm_ml_trace_register", UvmMlExecuteSpecificCmd, 
			 (ClientData)NULL, (Tcl_CmdDeleteProc*)NULL);

    Tcl_PkgProvide(interp, "uvm_ml_ext","1.0");
    return TCL_OK;
}

} // extern "C"
