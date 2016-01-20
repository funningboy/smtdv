//----------------------------------------------------------------------
//   Copyright 2012 Cadence Design Systems, Inc.
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

//------------------------------------------------------------------------------
/*! @file uvm_ml_adapter.cpp
 *
 *  @brief Adapter header implementing the required API.
 */
#define UVM_ML_ADAPTER_CPP
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include "bp_common_c.h"

#include "uvm_ml_adapter_imp_spec_headers.h"
#include "uvm_ml_adapter_imp_spec_macros.h"
#define SC_INCLUDE_DYNAMIC_PROCESSES

#include "systemc.h"

#include <algorithm>
#include <sstream>

#include "common/uvm_ml_adapter.h"
#include "common/ml_tlm2/ml_tlm2_connector.h"
#include "common/uvm_ml_hierarchy.h"
#include "common/uvm_ml_phase.h"
#include "common/uvm_ml_config_rsrc.h"
#include "common/uvm_ml_event.h"
#include "common/uvm_ml_sync.h"
#include "common/uvm_ml_barrier.h"
#include "uvm_imp_spec_macros.h"

#include "base/uvm_factory.h"
#include "base/uvm_packer.h"
#include "base/uvm_component.h"
#include "base/uvm_phase.h"
#include "base/uvm_common_schedule.h"
#include "base/uvm_ids.h"

#include "uvm_ml_packer.h"

#include <queue>
#include <map>
#include <dlfcn.h>
#include <cstdlib>

using namespace std;

using namespace sc_core;
using namespace uvm;
// FIXME
extern void uvm_ml_notify_end_of_quasi_static_elab();

uvm_ml_packed_obj::uvm_ml_packed_obj() :
  size(0), val(0), max_words(0) {
}

uvm_ml_packed_obj::~uvm_ml_packed_obj() {
  if (val) {
    delete[] val;
  }
}

void uvm_ml_packed_obj::allocate(uvm_ml_packed_obj* v, unsigned nwords) {
  if (v->max_words >= nwords)
    return;
  // need to allocate new m/m
  v->max_words = nwords;
  if (v->val) {
    delete[] v->val;
  }
  v->val = new unsigned[v->max_words];
}

///////////////////////

namespace uvm_ml {

#define BP(f) (*bpProvidedAPI->f##_ptr)

//------------------------------------------------------------------------------
//! Function: report_sc_error
/*! uvm_ml-oriented wrapper for sc_error.
 *
 *  @param message - the main message
 *  @param submessage - submessage
 *
 *  @returns: 
 *   void
 */
void uvm_ml_utils::report_sc_error(const char * const message, const char * const submessage) {
    UVM_ML_SC_REPORT_ERROR(message, submessage);
}

void uvm_ml_utils::print_sc_report(const sc_report& ex) {
    UVM_ML_SC_PRINT_REPORT(ex);
}

static unsigned framework_id = INITIALIZE_FRAMEWORK_IF_NEEDED();


//------------------------------------------------------------------------------
//! ML interface for the SC adaptor.
//
class uvm_ml_tlm_rec {
public:
  static int  startup();
  static void sim_bootstrap();
  static int  construct_top(const char* top_identifier, const char * instance_name);

  static void        set_debug_mode(int mode);
  static void        set_packing_mode(int mode);
  static int         find_connector_id_by_name(const char * path); 
  static const char* get_connector_intf_name(unsigned connector_id); 
  static char*       get_connector_REQ_name(unsigned connector_id); 
  static char*       get_connector_RSP_name(unsigned connector_id); 
  static unsigned    is_export_connector(unsigned connector_id); 
  static int         set_multiport(char* port_name);
  
  #include "uvm_ml_tlm_rec_imp_spec.h"

  static int get(
    unsigned           connector_id, 
    unsigned*          stream_size_ptr,
    uvm_ml_stream_t    stream, 
    uvm_ml_time_unit * time_unit, 
    double           * time_value
  );
  static uvm_ml_tlm_transrec_base* get_transrec_base(
    unsigned connector_id
  );
  static uvm_ml_tlm_receiver_base* get_receiver_base(
    unsigned connector_id
  );
  static uvm_ml_tlm_transmitter_base* get_transmitter_base(
    unsigned connector_id
  );

  static int put(
    unsigned connector_id, 
    unsigned stream_size, 
    uvm_ml_stream_t stream, 
    uvm_ml_time_unit * time_unit, 
    double           * time_value
  );
  static int request_put(
    unsigned connector_id, 
    unsigned call_id, 
    unsigned callback_adapter_id, 
    unsigned stream_size, 
    uvm_ml_stream_t stream, 
    uvm_ml_time_unit time_unit, 
    double           time_value
  ); 
  static int nb_put(
    unsigned         connector_id, 
    unsigned         stream_size , 
    uvm_ml_stream_t  stream, 
    uvm_ml_time_unit time_unit, 
    double           time_value
  ); 
  static int can_put(
    unsigned connector_id, 
    uvm_ml_time_unit time_unit, 
    double           time_value
  ); 
  static int request_get(
    unsigned connector_id, 
    unsigned call_id,
    unsigned callback_adapter_id, 
    uvm_ml_time_unit time_unit, 
    double           time_value
  ); 
  static unsigned get_requested(
    unsigned connector_id, 
    unsigned call_id , 
    uvm_ml_stream_t stream 
  ); 
  static int nb_get(
    unsigned connector_id, 
    unsigned * stream_size_ptr,
    uvm_ml_stream_t stream, 
    uvm_ml_time_unit time_unit, 
    double           time_value
  ); 
  static int can_get(
    unsigned         connector_id, 
    uvm_ml_time_unit time_unit, 
    double           time_value
  );
  static int peek(
  unsigned connector_id, 
  unsigned* stream_size_ptr,
  uvm_ml_stream_t stream, 
  uvm_ml_time_unit * time_unit, 
  double           * time_value
  );  
  static int request_peek(
    unsigned connector_id, 
    unsigned call_id,
    unsigned callback_adapter_id, 
    uvm_ml_time_unit time_unit, 
    double           time_value
  ); 
  static unsigned peek_requested(
    unsigned connector_id,
    unsigned call_id,
    uvm_ml_stream_t stream 
   );

  static int nb_peek(
    unsigned connector_id, 
    unsigned * stream_size_ptr,
    uvm_ml_stream_t stream, 
    uvm_ml_time_unit time_unit, 
    double           time_value
  ); 
  static int can_peek(
    unsigned connector_id, 
    uvm_ml_time_unit time_unit, 
    double           time_value
  ); 
  static int transport(
    unsigned connector_id, 
    unsigned req_stream_size, 
    uvm_ml_stream_t req_stream,
    unsigned* rsp_stream_size, 
    uvm_ml_stream_t rsp_stream, 
    uvm_ml_time_unit * time_unit, 
    double           * time_value
  );
  static int request_transport(
    unsigned connector_id, 
    unsigned call_id, 
    unsigned callback_adapter_id, 
    unsigned req_stream_size, 
    uvm_ml_stream_t req_stream,
    unsigned* rsp_stream_size, 
    uvm_ml_stream_t rsp_stream, 
    uvm_ml_time_unit time_unit, 
    double           time_value
  ); 
  static unsigned transport_response(
    unsigned            connector_id,
    unsigned            call_id,
    uvm_ml_stream_t rsp_stream
  );
  static int nb_transport(
    unsigned connector_id, 
    unsigned req_stream_size, 
    uvm_ml_stream_t req_stream,
    unsigned* rsp_stream_size, 
    uvm_ml_stream_t rsp_stream, 
    uvm_ml_time_unit time_unit, 
    double           time_value
  );
  static void write(
    unsigned connector_id, 
    unsigned stream_size , 
    uvm_ml_stream_t stream, 
    uvm_ml_time_unit time_unit, 
    double           time_value
  ); 

  static void notify_end_blocking(
    unsigned call_id, 
    uvm_ml_time_unit time_unit, 
    double           time_value
  );

  // TLM2
  static int tlm2_b_transport(
    unsigned              connector_id, 
    unsigned *            stream_size_ptr,
    uvm_ml_stream_t * stream_ptr,
    uvm_ml_time_unit *    delay_unit,
    double *              delay_value, 
    uvm_ml_time_unit      time_unit, 
    double                time_value
  );

  static int tlm2_b_transport_request(
    unsigned              connector_id, 
    unsigned              call_id,
    unsigned              callback_adapter_id,
    unsigned              stream_size,
    uvm_ml_stream_t   stream,
    uvm_ml_time_unit      delay_unit,
    double                delay_value, 
    uvm_ml_time_unit      time_unit, 
    double                time_value
  );

  static void tlm2_transport_request_helper(
    ml_tlm2_target_connector_base * conn,
    unsigned                        call_id,
    unsigned                        callback_adapter_id,
    MLUPO*                          mlupo_req_stream,
    sc_time_unit                    delay_unit, 
    double                          delay_value, 
    sc_time_unit                    time_unit, 
    double                          time_value
  );

  static int tlm2_b_transport_response(
    unsigned              connector_id, 
    unsigned              call_id,
    unsigned *            stream_size,
    uvm_ml_stream_t * stream
  );

  static uvm_ml_tlm_sync_enum tlm2_nb_transport_fw(
    unsigned              connector_id,
    unsigned *            stream_size,
    uvm_ml_stream_t * stream,
    uvm_ml_tlm_phase *   phase,
    unsigned int          transaction_id,
    uvm_ml_time_unit *    delay_unit,
    double *              delay_value, 
    uvm_ml_time_unit      time_unit, 
    double                time_value
  );

  static uvm_ml_tlm_sync_enum tlm2_nb_transport_bw(
    unsigned              connector_id,
    unsigned *            stream_size,
    uvm_ml_stream_t * stream,
    uvm_ml_tlm_phase *   phase,
    unsigned int          transaction_id,
    uvm_ml_time_unit *    delay_unit,
    double *              delay_value, 
    uvm_ml_time_unit      time_unit, 
    double                time_value  
  );

  static unsigned tlm2_transport_dbg(
    unsigned              connector_id,
    unsigned *            stream_size,
    uvm_ml_stream_t * stream, 
    uvm_ml_time_unit      time_unit, 
    double                time_value
  );

  static void tlm2_turn_off_transaction_mapping(const char* socket_name);

  static void synchronize(
    uvm_ml_time_unit      time_unit, 
    double                time_value
  );

  static int create_child_junction_node(
    const char * component_type_name,
    const char * instance_name,
    const char * parent_full_name,
    int          parent_framework_id,
    int          parent_junction_node_id
  );

  // Debug print tree
  static int get_num_children(const char * component_name);
  static const char * get_child_name(const char * parent_name, unsigned int num);
  static const char * get_component_type_name(const char * component_name);
  static int is_port(const char * component_name);

}; // class uvm_ml_tlm_rec

vector<sc_module *> uvm_ml_utils::quasi_static_tree_nodes;
vector<string> uvm_ml_utils::static_top_names;

class uvm_ml_debug {
public:
  static int receive_command(const char *     command,
                             bp_output_cb_t * output_cb,
                             uvm_ml_time_unit time_unit,
                             double           time_value);
};
 
static bp_frmw_c_api_struct* uvm_ml_sc_get_required_api()
{
    bp_frmw_c_api_struct * required_api = new bp_frmw_c_api_struct();
    memset(required_api, '\0', sizeof(bp_frmw_c_api_struct));
    required_api->set_trace_mode_ptr= uvm_ml_tlm_rec::set_debug_mode;
    required_api->startup_ptr = uvm_ml_tlm_rec::startup;
    required_api->construct_top_ptr=uvm_ml_tlm_rec::construct_top;

    // ----- Phasing APIs
    required_api->transmit_phase_ptr = uvm_ml_phase::transmit_phase;
    required_api->notify_phase_ptr = uvm_ml_phase::notify_phase;
    required_api->notify_runtime_phase_ptr = uvm_ml_phase::notify_runtime_phase;

    required_api->find_connector_id_by_name_ptr = uvm_ml_tlm_rec::find_connector_id_by_name;
    required_api->get_connector_intf_name_ptr = uvm_ml_tlm_rec::get_connector_intf_name;
    required_api->is_export_connector_ptr = uvm_ml_tlm_rec::is_export_connector;
    required_api->try_put_uvm_ml_stream_ptr = uvm_ml_tlm_rec::nb_put;
    required_api->can_put_ptr = uvm_ml_tlm_rec::can_put;
    required_api->put_uvm_ml_stream_request_ptr = uvm_ml_tlm_rec::request_put;
    required_api->get_uvm_ml_stream_request_ptr = uvm_ml_tlm_rec::request_get;
    required_api->get_requested_uvm_ml_stream_ptr = uvm_ml_tlm_rec::get_requested;
    required_api->try_get_uvm_ml_stream_ptr = uvm_ml_tlm_rec::nb_get;
    required_api->can_get_ptr = uvm_ml_tlm_rec::can_get;
    required_api->peek_uvm_ml_stream_request_ptr = uvm_ml_tlm_rec::request_peek;
    required_api->peek_requested_uvm_ml_stream_ptr = uvm_ml_tlm_rec::peek_requested;
    required_api->try_peek_uvm_ml_stream_ptr = uvm_ml_tlm_rec::nb_peek;
    required_api->can_peek_ptr = uvm_ml_tlm_rec::can_peek;
    required_api->transport_uvm_ml_stream_request_ptr = uvm_ml_tlm_rec::request_transport;
    required_api->transport_response_uvm_ml_stream_ptr = uvm_ml_tlm_rec::transport_response;
    required_api->nb_transport_uvm_ml_stream_ptr = uvm_ml_tlm_rec::nb_transport;
    required_api->write_uvm_ml_stream_ptr = uvm_ml_tlm_rec::write;
    required_api->notify_end_blocking_ptr = uvm_ml_tlm_rec::notify_end_blocking;
    required_api->tlm2_b_transport_request_ptr = uvm_ml_tlm_rec::tlm2_b_transport_request;
    required_api->tlm2_b_transport_response_ptr = uvm_ml_tlm_rec::tlm2_b_transport_response;
    required_api->tlm2_nb_transport_fw_ptr =  uvm_ml_tlm_rec::tlm2_nb_transport_fw;
    required_api->tlm2_nb_transport_bw_ptr = uvm_ml_tlm_rec::tlm2_nb_transport_bw;
    required_api->tlm2_transport_dbg_ptr = uvm_ml_tlm_rec::tlm2_transport_dbg;
    required_api->tlm2_turn_off_transaction_mapping_ptr = (uvm_ml_tlm_rec::tlm2_turn_off_transaction_mapping);
    required_api->synchronize_ptr = uvm_ml_tlm_rec::synchronize;

    required_api->create_child_junction_node_ptr = uvm_ml_tlm_rec::create_child_junction_node;

    required_api->notify_config_ptr = uvm_ml_config_rsrc::notify_config;
    required_api->notify_resource_ptr = uvm_ml_config_rsrc::notify_resource;

    required_api->notify_event_ptr = uvm_ml_event::notify_event_by_name;
    required_api->notify_barrier_ptr = uvm_ml_barrier::notify_barrier_by_name;

    required_api->wakeup_srv_register_time_cb_ptr = NULL;
    required_api->wakeup_srv_remove_time_cb_ptr = NULL;
    required_api->notify_time_cb_ptr = uvm_ml_sync::sync;
    required_api->stopper_srv_stop_request_ptr = NULL;
    required_api->phase_srv_check_phase_ptr = NULL;
    required_api->phase_srv_check_future_phase_ptr = NULL;
    required_api->get_num_children_ptr = uvm_ml_tlm_rec::get_num_children;
    required_api->get_child_name_ptr = uvm_ml_tlm_rec::get_child_name;
    required_api->get_component_type_name_ptr = uvm_ml_tlm_rec::get_component_type_name;
    required_api->is_port_ptr = uvm_ml_tlm_rec::is_port;
    required_api->print_srv_print_request_ptr = NULL;
    required_api->notify_command_ptr = uvm_ml_debug::receive_command;

    return required_api;
};

bp_api_struct * bpProvidedAPI = NULL;

static sc_strhash<uvm_ml_new_module_func>* new_module_funcs;

//////////////////////
} // namespace uvm_ml


#include "uvm_ml_adapter_imp_spec.cpp"

namespace uvm_ml {


void report_tlm1_error(uvm_ml_tlm_receiver_base* rec) {
  char msg[1024];
  if (rec) {
    sprintf(msg, "\nSystemC export name is '%s'\n"
            "TLM1 interface is '%s'\n"
            "uvm_object payload type is '%s'\n", 
            rec->object()->name(), 
            rec->get_intf_name().c_str(), 
            rec->get_REQ_name().c_str()
           );
    SC_REPORT_WARNING(ML_UVM_RUN_TIME_ERROR_, msg);
  } else {
    SC_REPORT_WARNING(ML_UVM_RUN_TIME_ERROR_, "\n");
  }
  CURRENT_SIMCONTEXT_SET_ERROR();
}

void report_connector_error(ml_tlm2_connector_base* conn) {
  char msg[1024];
  if (conn) {
    sprintf(msg, "\nTLM2 connector\n");
    SC_REPORT_WARNING(ML_UVM_RUN_TIME_ERROR_, msg);
  } else {
    SC_REPORT_WARNING(ML_UVM_RUN_TIME_ERROR_, "\n");
  }
  CURRENT_SIMCONTEXT_SET_ERROR();
}

} // namespace uvm_ml


///////////////////////

namespace uvm_ml {


uvm_ml_tlm_conn_info::uvm_ml_tlm_conn_info(const string & name, unsigned id) {
  m_name = name;
  m_id = id;
  m_nextid = 0;
  m_object = sc_find_object(name.c_str());
  if (!m_object) {
    char msg[1024];
    sprintf(msg, "\nPort/export is '%s' \n", name.c_str());
    SC_REPORT_ERROR(ML_UVM_OBJ_NOT_FOUND_, msg);
    return;
  }
}

unsigned uvm_ml_utils::m_nextid = 1;   

bool uvm_ml_utils::m_quasi_static_elaboration_started = false;

bool uvm_ml_utils::m_quasi_static_end_of_construction = false;

sc_strhash<uvm_ml_tlm_conn_info*>* uvm_ml_utils::conn_info_by_name = 0;

map<unsigned,uvm_ml_tlm_conn_info*>* uvm_ml_utils::conn_info_by_id = 0;

map<sc_object*, uvm_ml_tlm_transrec_base*>* uvm_ml_utils::obj_transrec_map = 0;

map<string, unsigned>* uvm_ml_utils::socket_map = 0;

map<unsigned, ml_tlm2_connector_base*>* uvm_ml_utils::connector_map = 0;

bool uvm_ml_utils::m_trace_register_on = false;

void uvm_ml_utils::add_tlm2_connector(const string & s, ml_tlm2_connector_base* conn) {
  pair<map<string,unsigned>::iterator,bool> ret_soc; 
  pair<map<unsigned, ml_tlm2_connector_base*>::iterator,bool> ret_conn; 

  if (!socket_map) {
    socket_map = new map<string, unsigned>();
  }
  conn->conn_id = m_nextid++;
  ret_soc = socket_map->insert(pair<string,unsigned>(s,conn->conn_id));
  if (!connector_map) {
    connector_map = new map<unsigned, ml_tlm2_connector_base*>();
  }
  ret_conn = connector_map->insert(pair<unsigned,ml_tlm2_connector_base*>(conn->conn_id,conn));
  register_static_top(s);
}

ml_tlm2_connector_base* uvm_ml_utils::get_ml_tlm2_connector_base(unsigned target_connector_id)
  {
    map<unsigned, ml_tlm2_connector_base*>::iterator it;

    it = connector_map->find(target_connector_id);
    if (it == connector_map->end()) return 0;
    return connector_map->find(target_connector_id)->second;
  }

unsigned uvm_ml_utils::find_socket_id(const string & s) {
  if (socket_map == NULL) return 0;

  map<string,unsigned>::iterator it;
  it = socket_map->find(s);
  if (it == socket_map->end()) return 0;
  return socket_map->find(s)->second;
}

bool uvm_ml_utils::is_tlm2_connector(unsigned connector_id) {
  if (uvm_ml_utils::connector_map == NULL) return false;

  map<unsigned, ml_tlm2_connector_base*>::iterator it;

  it = uvm_ml_utils::connector_map->find(connector_id);
  if (it == uvm_ml_utils::connector_map->end()) 
    return false;
  else
    return true;
}

void uvm_ml_utils::add_transrec_to_map(
  sc_object* obj, 
  uvm_ml_tlm_transrec_base* tr
) {
  if (!obj_transrec_map) {
    obj_transrec_map = new map<sc_object*, uvm_ml_tlm_transrec_base*>();
  }
  (*obj_transrec_map)[obj] = tr;
}

uvm_ml_tlm_transrec_base* uvm_ml_utils::get_transrec(sc_object* obj) {
  if (!obj_transrec_map) return 0;
  return (*obj_transrec_map)[obj];
}

uvm_ml_tlm_conn_info* uvm_ml_utils::get_or_create_conn_info(const string & name) {
  if (!conn_info_by_name) {
    conn_info_by_name = new sc_strhash<uvm_ml_tlm_conn_info*>();
  }
  if (!conn_info_by_id) {
    conn_info_by_id = new map<unsigned,uvm_ml_tlm_conn_info*>();
  }
  uvm_ml_tlm_conn_info* info = get_conn_info(name);
  if (!info) {
    unsigned id = m_nextid++;
    info = new uvm_ml_tlm_conn_info(name,id);
  }
  (*conn_info_by_id)[info->id()] = info;
  conn_info_by_name->insert(strdup(name.c_str()),info);
  return info;
}

uvm_ml_tlm_conn_info* uvm_ml_utils::get_conn_info(const string & name) {
  if (!conn_info_by_name) return 0;
  return (*conn_info_by_name)[name.c_str()];
}

uvm_ml_tlm_conn_info* uvm_ml_utils::get_conn_info(unsigned id) {
  if (!conn_info_by_id) return 0;
  return (*conn_info_by_id)[id];
}

///////////////////////

static unsigned fake_blocking_call_id;

static sc_phash<void*, sc_event*> call_id_trans_dict;

static sc_phash<void*, uvm_ml_packed_obj*> call_id_rec_dict;

// Save delay values for fake blocking
static map<unsigned, sc_time_unit> call_id_delay_unit_dict;
static map<unsigned, double> call_id_delay_value_dict;

unsigned uvm_ml_utils::FrameworkId() { 
  return framework_id; 
}

unsigned uvm_ml_utils::uvm_ml_tlm_id_from_name(const string & name) {
  uvm_ml_tlm_conn_info* info = get_conn_info(name);
  if (!info) return unsigned(-1);
  return info->id();
}

bool uvm_ml_utils::is_tree_node_quasi_static(unsigned root_node_id)
{
  return root_node_id >= static_top_names.size();
}

sc_module * uvm_ml_utils::get_quasi_static_tree_node_by_id(unsigned node_id)
{
 char msg[1024];
  if(!((node_id >= static_top_names.size()) && (node_id < static_top_names.size() + quasi_static_tree_nodes.size()))) {
    sprintf(msg,"\nID is %d", node_id);
    UVM_ML_SC_REPORT_ERROR("UVM-SC adapter: Subtree node was not found",msg);
    return NULL;
  };
  //assert ((node_id >= static_top_names.size()) && (node_id < static_top_names.size() + quasi_static_tree_nodes.size())); // Otherwise an internal error
  return quasi_static_tree_nodes[node_id - static_top_names.size()];
}

// TLM2
static uvm_ml_time_unit m_time_unit = TIME_UNIT_UNDEFINED;
static double           m_time_value = -1;

unsigned int uvm_ml_tlm_trans::tlm2_nb_transport_bw(
      unsigned         connector_id,
      MLUPO *          val,
      unsigned int *   phase,
      unsigned int     transaction_id,
      sc_time_unit *   delay_unit,
      double *         delay_value
) {
  unsigned int ret;
  unsigned *ptr;

  ptr = val->val; // save pointer
  ret = (unsigned int) BP(nb_transport_bw)(
				      framework_id,
				      connector_id,
				      &(val->size),
				      &(val->val),
				      (uvm_ml_tlm_phase *)phase,
                                      transaction_id,
				      (uvm_ml_time_unit *) delay_unit,
				      delay_value,
                                      m_time_unit,
                                      m_time_value
				      );
  if(val->val != ptr) delete[] ptr; // delete old value if it was reassigned
  return ret;
}

unsigned int uvm_ml_tlm_trans::tlm2_nb_transport_fw(
      unsigned         connector_id,
      MLUPO *          val,
      unsigned int *   phase,
      unsigned int     transaction_id,
      sc_time_unit *   delay_unit,
      double *         delay_value 
) {
  unsigned int ret;
  unsigned *ptr;

  ptr = val->val; // save pointer
  ret = (unsigned int) BP(nb_transport_fw)(
				      framework_id,
				      connector_id,
				      &(val->size),
				      &(val->val),
				      (uvm_ml_tlm_phase *)phase,
                                      transaction_id,
				      (uvm_ml_time_unit *) delay_unit,
				      delay_value, 
                                      m_time_unit,
                                      m_time_value
				      );
  if(val->val != ptr) delete[] ptr; // delete old value if it was reassigned
  return ret;
}

unsigned uvm_ml_tlm_trans::tlm2_transport_dbg(
      unsigned              connector_id,
      MLUPO *               val 
) {
  unsigned int ret;
  unsigned *ptr;

  ptr = val->val; // save pointer
  ret = BP(transport_dbg)(
				      framework_id,
				      connector_id,
				      &(val->size),
				      &(val->val),
                                      m_time_unit,
                                      m_time_value
				      );
  if(val->val != ptr) delete[] ptr; // delete old value if it was reassigned
  return ret;
}

void uvm_ml_tlm_trans::tlm2_b_transport(
      unsigned         connector_id,
      MLUPO *          val,
      sc_time_unit *   delay_unit,
      double *         delay_value
) {
  unsigned *ptr;
  unsigned call_id = fake_blocking_call_id++;
  unsigned done = 0;

  ptr = val->val; // save pointer
  int disable = BP(request_b_transport_tlm2)(
				      framework_id,
				      connector_id,
				      call_id,
				      &(val->size),
				      &(val->val),
				      (uvm_ml_time_unit)*delay_unit,
				      *delay_value,
                                      &done,
                                      m_time_unit,
                                      m_time_value
				      );
  if(val->val != ptr) delete[] ptr; // delete old value if it was reassigned

  if (!done) {
    // new sc_event; hash <call_id , event>; wait on event;
    // later target will cause event to be triggered
    void* p_call_id;
    // need to do the cast to unsigned long below before casting to pointer
    // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
    // bits; so casting from unsigned to pointer generates compiler warning;
    // unsigend long  matches the size of pointers on 32 bit and 64 bit m/cs
    p_call_id = (void *)(unsigned long)call_id;

    sc_event* e = new INVISIBLE_EVENT("uvm_fake_blocking");

    call_id_trans_dict.insert(p_call_id, e);
    sc_core::wait(*e);
    // we are here when the target framework has informed us via 
    // the backplane that the call has finished in it;
    // get the return value of get() from the backplane
    ptr = val->val; // save pointer

    int ret = BP(b_transport_tlm2_response)(framework_id,
                                            connector_id,
                                            call_id,
                                            &(val->size),
                                            val->val);
    if (ret != 0) ret = 0; // TBD: issue an error message

    if(val->val != ptr) delete[] ptr; // delete old value if it was reassigned
    delete e;
  }

  if (disable == 1) {

      uvm_ml::dpi_task_disabled();
  }
}



// Return -1 for failure
int uvm_ml_tlm_rec::construct_top(const char* top_identifier, const char * instance_name) {
#ifndef UVM_ML_PORTABLE
 char msg[1024];
 try {
     sc_module * m = NULL;
     // first see if object can be created by uvm factory
     if (uvm_factory::is_component_registered(string(top_identifier))) {
       m = uvm_factory::create_component(string(top_identifier), "", 
                                         string(instance_name));
       // assuming nothing can go wrong in creation
       //assert(m);
       if(m == NULL) {
	 sprintf(msg,"\ntop identifier is %s; instance name is %s\n", top_identifier, instance_name);
	 UVM_ML_SC_REPORT_ERROR("UVM-SC adapter: top component could not be created",msg);
	 return -1;
       };
     } else {
       // not uvm_component registered with factory
       // see if it is sc_module
       m = QUASI_STATIC_CONSTRUCT_TOP(string(top_identifier), string(instance_name));

       if (!m) {
         // not module, now print error that not registered with factory
         char msg[1024];
         sprintf(msg, "\nSystemC object name is '%s'", top_identifier); 
         cerr << "before throwing error"<< endl;
         SC_REPORT_ERROR(ML_UVM_MISSING_REGISTRATION_, msg);
         return -1;
       }
    }
    return uvm_ml_utils::add_quasi_static_tree_node(m);
  }
  UVM_ML_CATCH_SC_KERNEL_EXCEPTION_1(UVM_ML_QUASI_STATIC_ELABORATION, 0, 0, 0)
#else
 sc_object * inst = sc_core::sc_find_object(instance_name);
 if (inst != 0) {
     sc_module * node = DCAST<sc_module *>(inst);
     if (node)
         return uvm_ml_utils::add_quasi_static_tree_node(node);
 } else {
     char msg[1024];
     sprintf(msg,"\nUVM-SC adapter: construct_top() failed, instance name %s was not found", instance_name);
     cout << msg << endl;
     return -1;
 }
#endif
}

void uvm_ml_tlm_rec::set_debug_mode(int mode) {
}

void uvm_ml_tlm_rec::set_packing_mode(int mode) {
}

int uvm_ml_tlm_rec::find_connector_id_by_name(const char * path) { 
  try {
    unsigned conn_id = uvm_ml_utils::find_socket_id(path);
    if (conn_id != 0) {
      return conn_id;
    }
#ifdef MTI_SYSTEMC
    sc_object* obj = sc_find_object(path, sc_get_curr_simcontext());
#else
    sc_object* obj = sc_find_object(path);
#endif
    if (!obj) {

      char msg[1024];
      sprintf(msg, "\nPort/export is '%s' \n", path);
      SC_REPORT_INFO(ML_UVM_OBJ_NOT_FOUND_, msg);
      return (-1);
    }
    uvm_ml_tlm_transrec_base* tr = uvm_ml_utils::get_transrec(obj);
    if (!tr) {
      char msg[1024];
      sprintf(msg, "\nPort/export is '%s' \n", path);
      SC_REPORT_ERROR(ML_UVM_NO_TRANS_REC_, msg);
      return (-1);
    }
    tr->id_is_valid(true);
    uvm_ml_tlm_conn_info* info =
      uvm_ml_utils::get_or_create_conn_info(path);
    return info->id();
  }
  UVM_ML_CATCH_SC_KERNEL_EXCEPTION_1(UVM_ML_QUASI_STATIC_ELABORATION, 0, 0, 0)
}

static const char * map_intf_name(const string & s) {
  const char * c_s = s.c_str();
  try {
    if (s=="tlm_blocking_put_if") return "tlm_blocking_put";
    if (s=="tlm_nonblocking_put_if") return "tlm_nonblocking_put";
    if (s=="tlm_put_if") return "tlm_put";
  
    if (s=="tlm_blocking_get_if") return "tlm_blocking_get";
    if (s=="tlm_nonblocking_get_if") return "tlm_nonblocking_get";
    if (s=="tlm_get_if") return "tlm_get";

    if (s=="tlm_blocking_peek_if") return "tlm_blocking_peek";
    if (s=="tlm_nonblocking_peek_if") return "tlm_nonblocking_peek";
    if (s=="tlm_peek_if") return "tlm_peek";

    if (s=="tlm_blocking_get_peek_if") return "tlm_blocking_get_peek";
    if (s=="tlm_nonblocking_get_peek_if") return "tlm_nonblocking_get_peek";
    if (s=="tlm_get_peek_if") return "tlm_get_peek";

    if (s=="tlm_master_if") return "tlm_master";
    if (s=="tlm_slave_if") return "tlm_slave";

    if (s=="tlm_transport_if") return "tlm_blocking_transport";
    if (s=="tlm_analysis_if") return "tlm_analysis";
    return c_s;
  }
  UVM_ML_CATCH_SC_KERNEL_EXCEPTION_1(UVM_ML_QUASI_STATIC_ELABORATION, c_s, 0, 0)
}

const char* uvm_ml_tlm_rec::get_connector_intf_name(
  unsigned connector_id
) { 
  try {
    if(uvm_ml_utils::is_tlm2_connector(connector_id))
      return map_intf_name(uvm_ml_utils::connector_map->find(connector_id)->second->get_intf_name());
    else {
      uvm_ml_tlm_transrec_base* tr = get_transrec_base(connector_id);
      if (!tr)
        return (char*)("ERROR");

      return map_intf_name(tr->get_intf_name());
    }
  }
  UVM_ML_CATCH_SC_KERNEL_EXCEPTION_1(UVM_ML_QUASI_STATIC_ELABORATION, 0, 0, 0)
}

char* uvm_ml_tlm_rec::get_connector_REQ_name(
  unsigned connector_id
) { 
  try {
    static string sm;
    if(uvm_ml_utils::is_tlm2_connector(connector_id)) {
      char* c = (char*)(sm.c_str());
      return c;
    }
    uvm_ml_tlm_transrec_base* tr = get_transrec_base(connector_id);
    if (!tr) {
      char* e = (char*)("ERROR");
      return e;
    }
    sm = tr->get_REQ_name();
    char* c = (char*)(sm.c_str());
    return c;
  }
  UVM_ML_CATCH_SC_KERNEL_EXCEPTION_1(UVM_ML_QUASI_STATIC_ELABORATION, 0, 0, 0)
}

char* uvm_ml_tlm_rec::get_connector_RSP_name(
  unsigned connector_id
) { 
  try {
    static string sm;
    if(uvm_ml_utils::is_tlm2_connector(connector_id)) {
      char* c = (char*)(sm.c_str());
      return c;
    }
    uvm_ml_tlm_transrec_base* tr = get_transrec_base(connector_id);
    if (!tr) {
      char* e = (char*)("ERROR");
      return e;
    }
    sm = tr->get_RSP_name();
    char* c = (char*)(sm.c_str());
    return c;
  }
  UVM_ML_CATCH_SC_KERNEL_EXCEPTION_1(UVM_ML_QUASI_STATIC_ELABORATION, 0, 0, 0)
}

unsigned uvm_ml_tlm_rec::is_export_connector(
  unsigned connector_id
) { 
  try {
    if(uvm_ml_utils::is_tlm2_connector(connector_id)) {
      ml_tlm2_connector_base* conn = uvm_ml_utils::get_ml_tlm2_connector_base(connector_id);
      return conn->is_target;
    }
    uvm_ml_tlm_conn_info* info = 
      uvm_ml_utils::get_conn_info(connector_id);
    if (!info) {
      SC_REPORT_ERROR(UVM_CONNECTOR_ID_NOT_FOUND_,"");
      return 0;
    }
    sc_object* obj = info->object();
    uvm_ml_tlm_transrec_base* tr = uvm_ml_utils::get_transrec(obj);
    if (!tr) {
      char msg[1024];
      sprintf(msg, "\nPort/export is '%s' \n", obj->name());
      SC_REPORT_ERROR(ML_UVM_NO_TRANS_REC_, msg);
      return 0;
    }
    if (tr->is_transmitter()) {
      return 0;
    }
    return 1;
  }
  UVM_ML_CATCH_SC_KERNEL_EXCEPTION_1(UVM_ML_QUASI_STATIC_ELABORATION, 0, 0, 0)
}

int uvm_ml_tlm_rec::set_multiport(char* port_name) {
  try {
    // multiport, error out
    char msg[1024];
    sprintf(msg, "\nPort is '%s' \n", port_name);
    SC_REPORT_ERROR(ML_UVM_NO_MULTIPORT_, msg);
    return 0;
  }
  UVM_ML_CATCH_SC_KERNEL_EXCEPTION_1(UVM_ML_QUASI_STATIC_ELABORATION, 0, 0, 0)
}

uvm_ml_tlm_transrec_base* uvm_ml_tlm_rec::get_transrec_base(
  unsigned connector_id
) {
  try {
    uvm_ml_tlm_conn_info* info = uvm_ml_utils::get_conn_info(connector_id);
    sc_object* obj = info->object();
    uvm_ml_tlm_transrec_base* tr = uvm_ml_utils::get_transrec(obj);
    if (!tr) {
      // should this really be an assert that tr exists? Should not have come 
      // this far otherwise
      char msg[1024];
      sprintf(msg, "\nPort/export is '%s' \n", obj->name());
      SC_REPORT_ERROR(ML_UVM_NO_TRANS_REC_, msg);
    }
    return tr;
  }
  UVM_ML_CATCH_SC_KERNEL_EXCEPTION_1(UVM_ML_QUASI_STATIC_ELABORATION, 0, 0, 0)
}

uvm_ml_tlm_receiver_base* uvm_ml_tlm_rec::get_receiver_base(
  unsigned connector_id
) {
  try {
    uvm_ml_tlm_transrec_base* tr = get_transrec_base(connector_id);
    if (!tr) return 0;
    if (tr->is_transmitter()) {
      SC_REPORT_ERROR(UVM_RECEIVER_NOT_VALID_,"");
      return 0;
    }
    uvm_ml_tlm_receiver_base* rec = DCAST<uvm_ml_tlm_receiver_base*>(tr);
    if (!rec) {
      SC_REPORT_ERROR(UVM_RECEIVER_NOT_VALID_,"");
      return 0;
    }
    return rec;
  }
  UVM_ML_CATCH_SC_KERNEL_EXCEPTION_1(UVM_ML_QUASI_STATIC_ELABORATION, 0, 0, 0)
}

uvm_ml_tlm_transmitter_base* uvm_ml_tlm_rec::get_transmitter_base(
  unsigned connector_id
) {
  try {
    // never called
    uvm_ml_tlm_transrec_base* tr = get_transrec_base(connector_id);
    if (!tr) return 0;
    if (!(tr->is_transmitter())) {
      SC_REPORT_ERROR(UVM_TRANSMITTER_NOT_VALID_,"");
      return 0;
    }
    uvm_ml_tlm_transmitter_base* trans = DCAST<uvm_ml_tlm_transmitter_base*>(tr);
    if (!trans) {
      SC_REPORT_ERROR(UVM_TRANSMITTER_NOT_VALID_,"");
      return 0;
    }
    return trans;
  }
  UVM_ML_CATCH_SC_KERNEL_EXCEPTION_1(UVM_ML_QUASI_STATIC_ELABORATION, 0, 0, 0)
}

// put takes part in disable protocol as it is blocking,
// so exception catching is more specialized
int uvm_ml_tlm_rec::put(
    unsigned connector_id, 
    unsigned stream_size, 
    uvm_ml_stream_t stream, 
  uvm_ml_time_unit * time_unit, 
  double           * time_value
) {
    ENTER_CO_SIMULATION_CONTEXT2();
  int ret = 0;
  EXCEPTION_HANDLER_STORAGE();
  char msg[1024];
  sprintf(msg, "\nTLM function is put");
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      STORE_OLD_EXCEPTION_HANDLER();
    rec = get_receiver_base(connector_id);
    if (!rec) {
        RESTORE_OLD_EXCEPTION_HANDLER();
        EXIT_CO_SIMULATION_CONTEXT();
      return 0;
    }
    ret = rec->put_bitstream(stream_size, stream);
    RESTORE_OLD_EXCEPTION_HANDLER();
    EXIT_CO_SIMULATION_CONTEXT();
    return ret;
  }
  //CATCH_EXCEPTION_POP(msg);
  SC_KILL_CATCHER()
  catch( const sc_report& ex ) {
      RESTORE_OLD_EXCEPTION_HANDLER();
      EXIT_CO_SIMULATION_CONTEXT();
      UVM_ML_SC_PRINT_REPORT(ex);
    report_tlm1_error(rec);

    return ret;

  }
  catch( const ::std::exception& x )
  {
      RESTORE_OLD_EXCEPTION_HANDLER();
      EXIT_CO_SIMULATION_CONTEXT();
      UVM_ML_REPORT_COMPOSE_MESSAGE(x);
      report_tlm1_error(rec);
      return ret;
  }
  catch( const char* s )
  {
      RESTORE_OLD_EXCEPTION_HANDLER();
      EXIT_CO_SIMULATION_CONTEXT();
    cout << "\n" << s << "\n";
    report_tlm1_error(rec);
    return ret;
  }
  EXIT_CO_SIMULATION_CONTEXT();
  return ret;

}

void put_bitstream_request_helper(
  uvm_ml_tlm_receiver_base* rec,
  unsigned call_id,
  unsigned callback_adapter_id,
  uvm_ml_packed_obj* mlupo_stream
) {
  try {
    // call blocking put()
    rec->put_bitstream(mlupo_stream->size, mlupo_stream->val);
    // when put() returns, callback into source adapter
    // to inform that call has ended
    uvm_ml_tlm_trans::notify_end_blocking(callback_adapter_id, call_id);
    //delete mlupo_stream;
    uvm_ml_utils::release_mlupo_to_pool(mlupo_stream);
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_3
}

int uvm_ml_tlm_rec::request_put(
  unsigned connector_id, 
  unsigned call_id, 
  unsigned callback_adapter_id, 
  unsigned stream_size, 
  uvm_ml_stream_t stream, 
  uvm_ml_time_unit time_unit, 
  double           time_value
) { 
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT();
      rec = get_receiver_base(connector_id);
      if (!rec) { 
          EXIT_CO_SIMULATION_CONTEXT();
          return 0; 
      }
    // this form is called when we're doing fake blocking; so cannot
    // call put() directly and block;
    // instead, spawn a helper thread that will do the blocking call
    // and return
    sc_spawn_options op;

    MARK_THREAD_INVISIBLE(op);
    char name[1024];
    sprintf(name, "put_bitstream_request_helper_%d", call_id);
    
    // copy the stream into a mlupo. This is necessary because it is 
    // likely that in backplane, they use the same stream for 
    // multiple calls - so for back to back calls the arguments will get
    // overwritten until we make a copy here;
    // the helper will delete the mlupo we allocate here when it is done

    //MLUPO* mlupo_stream = new MLUPO;
    MLUPO* mlupo_stream = uvm_ml_utils::get_mlupo_from_pool();
    uvm_ml_utils::fill_mlupo(*mlupo_stream,stream_size,stream);
  
    sc_core::sc_spawn(sc_bind(&put_bitstream_request_helper,
                              rec,
                              call_id,
                              callback_adapter_id,
                              mlupo_stream
                             ),
                        name, 
                        &op
                     );
    EXIT_CO_SIMULATION_CONTEXT2();
    return 0;
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_2_INT
  return 0;
}

int uvm_ml_tlm_rec::nb_put(
  unsigned connector_id, 
  unsigned stream_size , 
  uvm_ml_stream_t stream, 
  uvm_ml_time_unit time_unit, 
  double           time_value
) { 
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT();
      rec = get_receiver_base(connector_id);
    if (!rec) { 
        EXIT_CO_SIMULATION_CONTEXT();
      return 0; 
    }
    int i = rec->try_put_bitstream(stream_size,stream);
    EXIT_CO_SIMULATION_CONTEXT2();
    return i;
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_1
}

int uvm_ml_tlm_rec::can_put(
  unsigned connector_id, 
  uvm_ml_time_unit time_unit, 
  double           time_value
) { 
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT();
    rec = get_receiver_base(connector_id);
    if (!rec) { 
        EXIT_CO_SIMULATION_CONTEXT();
      return 0; 
    }
    int i = rec->can_put();
    EXIT_CO_SIMULATION_CONTEXT();
    return i;
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_1
}

// get_bitstream takes part in disable protocol as it is blocking,
// so exception catching is more specialized
int uvm_ml_tlm_rec::get(
  unsigned connector_id, 
  unsigned* stream_size_ptr,
  uvm_ml_stream_t stream, 
  uvm_ml_time_unit * time_unit, 
  double           * time_value
) { 
    ENTER_CO_SIMULATION_CONTEXT2();
  int ret = 0;
  EXCEPTION_HANDLER_STORAGE();
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      STORE_OLD_EXCEPTION_HANDLER();
    rec = get_receiver_base(connector_id);
    if (!rec) { 
        RESTORE_OLD_EXCEPTION_HANDLER();
        EXIT_CO_SIMULATION_CONTEXT();
      return 0; 
    }
    ret = rec->get_bitstream(stream_size_ptr, stream);
    RESTORE_OLD_EXCEPTION_HANDLER();
    EXIT_CO_SIMULATION_CONTEXT();
    return ret;
  }
  SC_KILL_CATCHER()
  catch( const sc_report& ex ) {
      RESTORE_OLD_EXCEPTION_HANDLER();
      EXIT_CO_SIMULATION_CONTEXT();
      UVM_ML_SC_PRINT_REPORT(ex);
    report_tlm1_error(rec);
    return ret;
  }
  catch( const ::std::exception& x )
  {
      RESTORE_OLD_EXCEPTION_HANDLER();
      EXIT_CO_SIMULATION_CONTEXT();
      UVM_ML_REPORT_COMPOSE_MESSAGE(x);
      
    report_tlm1_error(rec);
    return ret;
  }
  catch( const char* s )
  {
      RESTORE_OLD_EXCEPTION_HANDLER();
      EXIT_CO_SIMULATION_CONTEXT();
    cout << "\n" << s << "\n";
    report_tlm1_error(rec);
    return ret;
  }
  EXIT_CO_SIMULATION_CONTEXT();
  return ret;

}

void get_bitstream_request_helper(
  uvm_ml_tlm_receiver_base* rec,
  unsigned call_id,
  unsigned callback_adapter_id
) {
  try {
    // call blocking get()
    MLUPO* retval = uvm_ml_utils::get_mlupo_from_pool();
    uvm_ml_utils::allocate_mlupo(retval);
    rec->get_bitstream(&(retval->size), retval->val);
    // when get() returns, first hash return value with call id be 
    // retrieved later thru get_requested_bitstream()
    void* p_call_id;
      // need to do the cast to unsigned long below before casting to pointer
      // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
      // bits; so casting from unsigned to pointer generates compiler warning;
      // unsigend long  matches the size of pointers on 32 bit and 64 bit m/cs
    p_call_id = (void *)(unsigned long)call_id;
    call_id_rec_dict.insert(p_call_id, retval);
    // callback into source adapter
    // to inform that call has ended
    uvm_ml_tlm_trans::notify_end_blocking(callback_adapter_id, call_id);
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_3
}

int uvm_ml_tlm_rec::request_get(
  unsigned connector_id, 
  unsigned call_id,
  unsigned callback_adapter_id, 
  uvm_ml_time_unit time_unit, 
  double           time_value
) { 
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT();
    rec = get_receiver_base(connector_id);
    if (!rec) {
        EXIT_CO_SIMULATION_CONTEXT();
      return 0 ;
    }
    // this form is called when we're doing fake blocking; so cannot
    // call get() directly and block;
    // instead, spawn a helper thread that will do the blocking call
    // and return
    sc_spawn_options op;
    char name[1024];
    sprintf(name, "get_bitstream_request_helper_%d", call_id);
    MARK_THREAD_INVISIBLE(op);
    sc_core::sc_spawn(sc_bind(&get_bitstream_request_helper,
                              rec,
                              call_id,
                              callback_adapter_id
                             ),
                      name, 
                      &op
                     );
    EXIT_CO_SIMULATION_CONTEXT();
    return 0;
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_2_INT


  return 0;
}

unsigned uvm_ml_tlm_rec::get_requested(
    unsigned connector_id, 
    unsigned call_id , 
    uvm_ml_stream_t stream
) {
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT2();
    rec = get_receiver_base(connector_id);
    // need to do the cast to unsigned long below before casting to pointer
    // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
    // bits; so casting from unsigned to pointer generates compiler warning;
    // unsigend long  matches the size of pointers on 32 bit and 64 bit m/cs
    void* p_call_id = (void*)(unsigned long)call_id;
    uvm_ml_packed_obj* retval = call_id_rec_dict[p_call_id];
    unsigned size =  uvm_ml_utils::copy_from_mlupo(*retval, stream);

    uvm_ml_utils::release_mlupo_to_pool(retval);
    EXIT_CO_SIMULATION_CONTEXT();
    return size;
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_1
}

int uvm_ml_tlm_rec::nb_get(
  unsigned connector_id, 
  unsigned * stream_size_ptr,
  uvm_ml_stream_t stream, 
  uvm_ml_time_unit time_unit, 
  double           time_value
) {
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT();
    rec = get_receiver_base(connector_id);
    if (!rec) { 
        EXIT_CO_SIMULATION_CONTEXT();
      return 0; 
    }
    int i = rec->try_get_bitstream(stream_size_ptr, stream);
    EXIT_CO_SIMULATION_CONTEXT();
    return i;
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_1
}

int uvm_ml_tlm_rec::can_get(
  unsigned connector_id, 
  uvm_ml_time_unit time_unit, 
  double           time_value
) { 
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT();
    rec = get_receiver_base(connector_id);
    if (!rec) { 
        EXIT_CO_SIMULATION_CONTEXT();
      return 0; 
    }
    int i = rec->can_get();
    EXIT_CO_SIMULATION_CONTEXT();
    return i; 
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_1
}

// peek takes part in disable protocol as it is blocking,
// so exception catching is more specialized
int uvm_ml_tlm_rec::peek(
  unsigned connector_id, 
  unsigned* stream_size_ptr,
  uvm_ml_stream_t stream, 
  uvm_ml_time_unit * time_unit, 
  double           * time_value
) { 
    ENTER_CO_SIMULATION_CONTEXT2();
  int ret = 0;
  EXCEPTION_HANDLER_STORAGE();
  char msg[1024];
  sprintf(msg, "\nTLM function is peek");
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      STORE_OLD_EXCEPTION_HANDLER();
    rec = get_receiver_base(connector_id);
    if (!rec) { 
        RESTORE_OLD_EXCEPTION_HANDLER();
        EXIT_CO_SIMULATION_CONTEXT();
      return 0; 
    }
    ret = rec->peek_bitstream(stream_size_ptr, stream);
    RESTORE_OLD_EXCEPTION_HANDLER();
    EXIT_CO_SIMULATION_CONTEXT();
    return ret;
  } 
  SC_KILL_CATCHER()
  catch( const sc_report& ex ) {
      RESTORE_OLD_EXCEPTION_HANDLER();
      EXIT_CO_SIMULATION_CONTEXT();
      UVM_ML_SC_PRINT_REPORT(ex);
    report_tlm1_error(rec);
    return ret;
  }
  catch( const ::std::exception& x )
  {
      RESTORE_OLD_EXCEPTION_HANDLER();
      EXIT_CO_SIMULATION_CONTEXT();
      UVM_ML_REPORT_COMPOSE_MESSAGE(x);
    report_tlm1_error(rec);
    return ret;
  }
  catch( const char* s )
  {
      RESTORE_OLD_EXCEPTION_HANDLER();
      EXIT_CO_SIMULATION_CONTEXT();
    cout << "\n" << s << "\n";
    report_tlm1_error(rec);
    return ret;
  }
  EXIT_CO_SIMULATION_CONTEXT();
  return ret;
}

void peek_bitstream_request_helper(
  uvm_ml_tlm_receiver_base* rec,
  unsigned call_id,
  unsigned callback_adapter_id
) {
  try {
    MLUPO* retval = uvm_ml_utils::get_mlupo_from_pool();
    uvm_ml_utils::allocate_mlupo(retval);
    // call blocking get()
    rec->peek_bitstream(&(retval->size), retval->val);
    // when get() returns, first hash return value with call id be 
    // retrieved later thru get_requested_bitstream()
    void* p_call_id;
    // need to do the cast to unsigned long below before casting to pointer
    // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
    // bits; so casting from unsigned to pointer generates compiler warning;
    // unsigend long  matches the size of pointers on 32 bit and 64 bit m/cs
    p_call_id = (void*)(unsigned long)call_id;
    call_id_rec_dict.insert(p_call_id, retval);
    // callback into source adapter
    // to inform that call has ended
    uvm_ml_tlm_trans::notify_end_blocking(callback_adapter_id, call_id);
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_3
}

int uvm_ml_tlm_rec::request_peek(
  unsigned connector_id, 
  unsigned call_id,
  unsigned callback_adapter_id, 
  uvm_ml_time_unit time_unit, 
  double           time_value
) { 
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT();
    rec = get_receiver_base(connector_id);
    if (!rec) {
        EXIT_CO_SIMULATION_CONTEXT();
      return 0;
    }
    // this form is called when we're doing fake blocking; so cannot
    // call peek() directly and block;
    // instead, spawn a helper thread that will do the blocking call
    // and return
    sc_spawn_options op;
    char name[1024];
    sprintf(name, "peek_bitstream_request_helper_%d", call_id);
    MARK_THREAD_INVISIBLE(op);
    sc_core::sc_spawn(sc_bind(&peek_bitstream_request_helper,
                              rec,
                              call_id,
                              callback_adapter_id
                             ),
                      name, 
                      &op
                     );
    EXIT_CO_SIMULATION_CONTEXT();
    return 0;
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_2_INT

  return 0;
}

unsigned uvm_ml_tlm_rec::peek_requested (
  unsigned connector_id,
  unsigned call_id,
  uvm_ml_stream_t stream
) {
  uvm_ml_tlm_receiver_base* rec = get_receiver_base(connector_id);
  try {
      ENTER_CO_SIMULATION_CONTEXT2();
    // need to do the cast to unsigned long below before casting to pointer
    // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
    // bits; so casting from unsigned to pointer generates compiler warning;
    // unsigend long  matches the size of pointers on 32 bit and 64 bit m/cs
    void* p_call_id = (void*)(unsigned long)call_id;
    uvm_ml_packed_obj* retval = call_id_rec_dict[p_call_id];
    unsigned size =  uvm_ml_utils::copy_from_mlupo(*retval, stream);
    //delete retval;
    uvm_ml_utils::release_mlupo_to_pool(retval);
    EXIT_CO_SIMULATION_CONTEXT();
    return size;
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_1
}

    

int uvm_ml_tlm_rec::nb_peek(
  unsigned connector_id, 
  unsigned * stream_size_ptr,
  uvm_ml_stream_t stream, 
  uvm_ml_time_unit time_unit, 
  double           time_value
) {
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT();
    rec = get_receiver_base(connector_id);
    if (!rec) { 
        EXIT_CO_SIMULATION_CONTEXT();
      return 0; 
    }
    int i = rec->try_peek_bitstream(stream_size_ptr, stream);
    EXIT_CO_SIMULATION_CONTEXT();
    return i;
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_1
}

int uvm_ml_tlm_rec::can_peek(
  unsigned connector_id, 
  uvm_ml_time_unit time_unit, 
  double           time_value
) { 
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT();
    rec = get_receiver_base(connector_id);
    if (!rec) { 
        EXIT_CO_SIMULATION_CONTEXT();
      return 0;
    }
    int i = rec->can_peek();
    EXIT_CO_SIMULATION_CONTEXT();
    return i; 
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_1
}

// transport_bitstream takes part in disable protocol as it is blocking,
// so exception catching is more specialized

int uvm_ml_tlm_rec::transport(
    unsigned connector_id, 
    unsigned req_stream_size, 
    uvm_ml_stream_t req_stream,
    unsigned* rsp_stream_size, 
    uvm_ml_stream_t rsp_stream, 
  uvm_ml_time_unit * time_unit, 
  double           * time_value
) {
    ENTER_CO_SIMULATION_CONTEXT2();
  int ret = 0;
  EXCEPTION_HANDLER_STORAGE();
  char msg[1024];
  sprintf(msg, "\nTLM function is transport");
  uvm_ml_tlm_receiver_base* rec = 0;

  try {
      STORE_OLD_EXCEPTION_HANDLER();
    rec = get_receiver_base(connector_id);
    if (!rec) { 
        RESTORE_OLD_EXCEPTION_HANDLER();
        EXIT_CO_SIMULATION_CONTEXT();
      return 0; 
    }
    ret = rec->transport_bitstream(
      req_stream_size, 
      req_stream,
      rsp_stream_size, 
      rsp_stream
    );
    RESTORE_OLD_EXCEPTION_HANDLER();
    EXIT_CO_SIMULATION_CONTEXT();
    return ret;
  } 
  SC_KILL_CATCHER()
  catch( const sc_report& ex ) {
      RESTORE_OLD_EXCEPTION_HANDLER();
      EXIT_CO_SIMULATION_CONTEXT();
      UVM_ML_SC_PRINT_REPORT(ex);
    report_tlm1_error(rec);

    return ret;
  }
  catch( const ::std::exception& x )
  {
      RESTORE_OLD_EXCEPTION_HANDLER();
      EXIT_CO_SIMULATION_CONTEXT();
      UVM_ML_REPORT_COMPOSE_MESSAGE(x);
    report_tlm1_error(rec);

    return ret;
  }
  catch( const char* s )
  {
      RESTORE_OLD_EXCEPTION_HANDLER();
      EXIT_CO_SIMULATION_CONTEXT();
    cout << "\n" << s << "\n";
    report_tlm1_error(rec);
    //sc_get_curr_simcontext()->set_error();
    return ret;
  }
  EXIT_CO_SIMULATION_CONTEXT();
  return ret;
}

void transport_bitstream_request_helper(
  uvm_ml_tlm_receiver_base* rec,
  unsigned call_id,
  unsigned callback_adapter_id,
  MLUPO* mlupo_req_stream 
) {
  try {
    MLUPO* rspval = uvm_ml_utils::get_mlupo_from_pool();
    uvm_ml_utils::allocate_mlupo(rspval);
    // call blocking transport()
    rec->transport_bitstream(
      mlupo_req_stream->size,
      mlupo_req_stream->val,
      &(rspval->size), 
      rspval->val
    );
    // when transport() returns, first hash return value with call id to be 
    // retrieved later thru transport_response_bitstream()
    void* p_call_id;
    // need to do the cast to unsigned long below before casting to pointer
    // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
    // bits; so casting from unsigned to pointer generates compiler warning;
    // unsigend long  matches the size of pointers on 32 bit and 64 bit m/cs
    p_call_id = (void*)(unsigned long)call_id;
    call_id_rec_dict.insert(p_call_id, rspval);
    // callback into source adapter
    // to inform that call has ended
    uvm_ml_tlm_trans::notify_end_blocking(callback_adapter_id, call_id);
    //delete mlupo_req_stream;
    uvm_ml_utils::release_mlupo_to_pool(mlupo_req_stream);
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_3
}

int uvm_ml_tlm_rec::request_transport(
    unsigned connector_id, 
    unsigned call_id, 
    unsigned callback_adapter_id, 
    unsigned req_stream_size, 
    uvm_ml_stream_t req_stream,
    unsigned* rsp_stream_size, 
    uvm_ml_stream_t rsp_stream, 
  uvm_ml_time_unit time_unit, 
  double           time_value
)  {
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT();
    rec = get_receiver_base(connector_id);
    if (!rec) {
        EXIT_CO_SIMULATION_CONTEXT();
      return 0 ;
    }
    // this form is called when we're doing fake blocking; so cannot
    // call transport() directly and block;
    // instead, spawn a helper thread that will do the blocking call
    // and return
    sc_spawn_options op;
    char name[1024];
    sprintf(name, "transport_bitstream_request_helper_%d", call_id);
    MARK_THREAD_INVISIBLE(op);

    // copy the req_stream into a mlupo. This is necessary because it is 
    // likely that in backplane, they use the same stream for 
    // multiple calls - so for back to back calls the arguments will get
    // overwritten until we make a copy here;
    // the helper will delete the mlupo we allocate here when it is done
  
    //MLUPO* mlupo_req_stream = new MLUPO;
    MLUPO* mlupo_req_stream = uvm_ml_utils::get_mlupo_from_pool();
    uvm_ml_utils::fill_mlupo(*mlupo_req_stream,req_stream_size,req_stream);

    sc_core::sc_spawn(sc_bind(&transport_bitstream_request_helper,
                              rec,
                              call_id,
                              callback_adapter_id,
                              mlupo_req_stream
                             ),
                      name, 
                      &op
                     );
    EXIT_CO_SIMULATION_CONTEXT();
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_2_INT

  return 0;
}

unsigned uvm_ml_tlm_rec::transport_response(
  unsigned            connector_id,
  unsigned            call_id,
  uvm_ml_stream_t rsp_stream 
) {
  uvm_ml_tlm_receiver_base* rec = get_receiver_base(connector_id);
  try {
      ENTER_CO_SIMULATION_CONTEXT2();
    // need to do the cast to unsigned long below before casting to pointer
    // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
    // bits; so casting from unsigned to pointer generates compiler warning;
    // unsigend long  matches the size of pointers on 32 bit and 64 bit m/cs
    void* p_call_id = (void*)(unsigned long)call_id;
    uvm_ml_packed_obj* rspval = call_id_rec_dict[p_call_id];
    unsigned size =  uvm_ml_utils::copy_from_mlupo(*rspval, rsp_stream);
    //delete rspval;
    uvm_ml_utils::release_mlupo_to_pool(rspval);
    EXIT_CO_SIMULATION_CONTEXT();
    return size;
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_1
}

int uvm_ml_tlm_rec::nb_transport(
    unsigned connector_id, 
    unsigned req_stream_size, 
    uvm_ml_stream_t req_stream,
    unsigned* rsp_stream_size, 
    uvm_ml_stream_t rsp_stream, 
  uvm_ml_time_unit time_unit, 
  double           time_value
) {
    cerr << "Unimplemented: uvm_ml_tlm_rec::nb_transport_bitstream, "
         << "should not be here!!!!!" << endl;
  return 0;
}

void uvm_ml_tlm_rec::write(
  unsigned connector_id, 
  unsigned stream_size , 
  uvm_ml_stream_t stream, 
  uvm_ml_time_unit time_unit, 
  double           time_value
) { 
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
    ENTER_CO_SIMULATION_CONTEXT();
    if(uvm_ml_utils::is_tlm2_connector(connector_id) == false) {
      // uvm_object based TLM1 transaction
      rec = get_receiver_base(connector_id);
      assert (rec != NULL);
      rec->write_bitstream(stream_size,stream);
    } else {
        ml_tlm2_connector_base* conn = uvm_ml_utils::get_ml_tlm2_connector_base(connector_id);
        if (conn) { // tlm_generic_payload based TLM2 transaction
          ml_tlm2_analysis_export_connector_base * analysis_export_conn = dynamic_cast<ml_tlm2_analysis_export_connector_base * >(conn);
          if (analysis_export_conn == NULL) {
            EXIT_CO_SIMULATION_CONTEXT();
            UVM_ML_SC_REPORT_ERROR("UVM-SC adapter: Internal error: connector is not an analysis export connector","");
            return;
	  }
          analysis_export_conn->write_bitstream(stream_size,stream);
	}
        else
	  UVM_ML_SC_REPORT_ERROR("UVM-SC adapter: cannot find a connector for the incoming analysis interface call write()","");
    }
    EXIT_CO_SIMULATION_CONTEXT();
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_2_VOID
}

void uvm_ml_tlm_rec::notify_end_blocking(
  unsigned call_id, 
  uvm_ml_time_unit time_unit, 
  double           time_value
) {
  uvm_ml_tlm_receiver_base* rec = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT3();
    // need to do the cast to unsigned long below before casting to pointer
    // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
    // bits; so casting from unsigned to pointer generates compiler warning;
    // unsigend long  matches the size of pointers on 32 bit and 64 bit m/cs
    void* p_call_id = (void*)(unsigned long)call_id;
    sc_event* e = call_id_trans_dict[p_call_id];
    if (!e) {
        EXIT_CO_SIMULATION_CONTEXT5();
        SC_REPORT_ERROR(ML_UVM_UNKNOWN_CALL_ID_, 0);
    } else {
        e->notify(); // will cause calling SC thread to get scheduled
        EXIT_CO_SIMULATION_CONTEXT4();
    }
  }
  CATCH_KERNEL_EXCEPTION_IN_RECEIVER_2_VOID
}

//////////////////////

// TLM2

int uvm_ml_tlm_rec::tlm2_b_transport(
    unsigned              connector_id, 
    unsigned *            stream_size,
    uvm_ml_stream_t * stream,
    uvm_ml_time_unit *    delay_unit,
    double *              delay_value,
    uvm_ml_time_unit      time_unit, 
    double                time_value
) {
  ml_tlm2_connector_base* conn = 0;

  try {
      ENTER_CO_SIMULATION_CONTEXT();
    conn = uvm_ml_utils::get_ml_tlm2_connector_base(connector_id);
    if (!conn) { 
      EXIT_CO_SIMULATION_CONTEXT();
      return 1; // TBD FIXME
    }
    //assert(conn->is_target);

    ml_tlm2_target_connector_base *target_conn; 
    if(!(conn->is_target) || ((target_conn = dynamic_cast<ml_tlm2_target_connector_base *>(conn)) == NULL) ) {
      EXIT_CO_SIMULATION_CONTEXT();
      UVM_ML_SC_REPORT_ERROR("UVM-SC adapter: tlm2_b_transport connector is not target","");
      return 1;
    };

    
    // Create MLUPO from stream
    uvm_ml_packed_obj& vt = uvm_ml_utils::get_static_mlupo(); 
    uvm_ml_utils::fill_mlupo(vt,*stream_size,*stream);
    
    target_conn->b_transport(vt, (sc_time_unit *) delay_unit, delay_value, (sc_time_unit)time_unit, time_value);
    // Check that the incoming stream is big enough to store the 
    // transaction on the return path
    if (vt.size > *stream_size) 
      *stream = new unsigned[((vt.size-1)/UVM_ML_BLOCK_SIZE)+1];
    // GL *stream = new unsigned[vt.size/UVM_ML_BLOCK_SIZE];
    // it is the caller's responsibility to deallocate both streams
    *stream_size = uvm_ml_utils::copy_from_mlupo(vt, *stream);    


    EXIT_CO_SIMULATION_CONTEXT2();
    return 0;
  }
  CATCH_KERNEL_EXCEPTION_IN_CONNECTOR_4
}

void uvm_ml_tlm_rec::tlm2_transport_request_helper(
  ml_tlm2_target_connector_base* conn,
  unsigned                       call_id,
  unsigned                       callback_adapter_id,
  MLUPO                        * mlupo_req_stream,
  sc_time_unit                   delay_unit, 
  double                         delay_value,
  sc_time_unit                   time_unit, 
  double                         time_value
) {
  try {
    conn->b_transport(
      *mlupo_req_stream,
      &delay_unit,
      &delay_value,
      time_unit,
      time_value
    );
    // need to do the cast to unsigned long below before casting to pointer
    // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
    // bits; so casting from unsigned to pointer generates compiler warning;
    // unsigend long  matches the size of pointers on 32 bit and 64 bit m/cs
    void* p_call_id = (void*)(unsigned long)call_id;
    call_id_rec_dict.insert(p_call_id, mlupo_req_stream);
    call_id_delay_unit_dict[call_id] = delay_unit;
    call_id_delay_value_dict[call_id] = delay_value;
    // callback into source adapter to inform that call has ended
    uvm_ml_tlm_trans::notify_end_blocking(callback_adapter_id, call_id);
  }
  CATCH_KERNEL_EXCEPTION_IN_CONNECTOR_3
}

int uvm_ml_tlm_rec::tlm2_b_transport_request(
    unsigned            connector_id, 
    unsigned            call_id,
    unsigned            callback_adapter_id,
    unsigned            stream_size,
    uvm_ml_stream_t stream,
    uvm_ml_time_unit   delay_unit,
    double              delay_value,
    uvm_ml_time_unit    time_unit, 
    double              time_value
) {
  ml_tlm2_target_connector_base* conn = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT();
    conn = dynamic_cast<ml_tlm2_target_connector_base *>(uvm_ml_utils::get_ml_tlm2_connector_base(connector_id));
    if (!conn) {
        EXIT_CO_SIMULATION_CONTEXT();
        return 1; // TBD FIXME - 1 indicates disabled threads not an internal error
    }

    // this form is called when we're doing fake blocking; so cannot
    // call transport() directly and block;
    // instead, spawn a helper thread that will do the blocking call
    // and return
    sc_spawn_options op;
    char name[1024];
    sprintf(name, "tlm2_transport_request_helper_%d", call_id);
    MARK_THREAD_INVISIBLE(op);

    // copy the req_stream into a mlupo. This is necessary because it is 
    // likely that in backplane, they use the same stream for 
    // multiple calls - so for back to back calls the arguments will get
    // overwritten unless we make a copy here;
    // the helper will delete the mlupo we allocate here when it is done
  
    MLUPO* mlupo_req_stream = uvm_ml_utils::get_mlupo_from_pool();
    uvm_ml_utils::fill_mlupo(*mlupo_req_stream,stream_size,stream);

    sc_core::sc_spawn(sc_bind(&tlm2_transport_request_helper,
                              conn,
                              call_id,
                              callback_adapter_id,
                              mlupo_req_stream,
                              (sc_time_unit)delay_unit,
                              delay_value,
                              (sc_time_unit)time_unit,
                              time_value
                             ),
                      name, 
                      &op
                     );
    EXIT_CO_SIMULATION_CONTEXT2();
    return 0; // TBD FIXME - support disabling of the threads
  }
  CATCH_KERNEL_EXCEPTION_IN_CONNECTOR_4
}

int uvm_ml_tlm_rec::tlm2_b_transport_response(
    unsigned              connector_id, 
    unsigned              call_id,
    unsigned *            stream_size,
    uvm_ml_stream_t * stream
) {
  ml_tlm2_target_connector_base* conn = 0;
  try {
      ENTER_CO_SIMULATION_CONTEXT2();
    conn = dynamic_cast<ml_tlm2_target_connector_base *>(uvm_ml_utils::get_ml_tlm2_connector_base(connector_id));
    // need to do the cast to unsigned long below before casting to pointer
    // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
    // bits; so casting from unsigned to pointer generates compiler warning;
    // unsigend long matches the size of pointers on 32 bit and 64 bit m/cs
    void* p_call_id = (void*)(unsigned long)call_id;
    uvm_ml_packed_obj* rspval = call_id_rec_dict[p_call_id];
    *stream_size =  uvm_ml_utils::copy_from_mlupo(*rspval, *stream);
    uvm_ml_utils::release_mlupo_to_pool(rspval);
    EXIT_CO_SIMULATION_CONTEXT();
    return 0;
  }
  CATCH_KERNEL_EXCEPTION_IN_CONNECTOR_4
}

uvm_ml_tlm_sync_enum uvm_ml_tlm_rec::tlm2_nb_transport_fw(
    unsigned              connector_id,
    unsigned *            stream_size,
    uvm_ml_stream_t * stream,
    uvm_ml_tlm_phase *   phase,
    unsigned int          transaction_id,
    uvm_ml_time_unit *   delay_unit,
    double *              delay_value,
    uvm_ml_time_unit      time_unit, 
    double                time_value
) {
  ml_tlm2_connector_base* conn = 0;
  tlm_sync_enum ret;

  try {
      ENTER_CO_SIMULATION_CONTEXT();
    conn = uvm_ml_utils::get_ml_tlm2_connector_base(connector_id);
    if (!conn) { 
        EXIT_CO_SIMULATION_CONTEXT();
      return UVM_ML_TLM2_COMPLETED; // return error code
    }
    //assert(conn->is_target);
    ml_tlm2_target_connector_base *target_conn;
    if(!(conn->is_target) || (( target_conn = dynamic_cast<ml_tlm2_target_connector_base *>(conn) ) == NULL)) {
      EXIT_CO_SIMULATION_CONTEXT();
      UVM_ML_SC_REPORT_ERROR("UVM-SC adapter: tlm2_nb_transport_fw connector is not target","");
      return UVM_ML_TLM2_COMPLETED; // return error code
    };

    
    // Create MLUPO from stream
    uvm_ml_packed_obj& vt = uvm_ml_utils::get_static_mlupo(); 
    uvm_ml_utils::fill_mlupo(vt,*stream_size,*stream);
    
    ret = target_conn->nb_transport_fw(vt, (tlm_phase_enum *) phase, transaction_id, (sc_time_unit *) delay_unit, delay_value, (sc_time_unit)time_unit, time_value);
    // Check that the incoming stream is big enough to store the 
    // transaction on the return path
    if (vt.size > *stream_size) 
      *stream = new unsigned[((vt.size-1)/UVM_ML_BLOCK_SIZE)+1];
    // GL *stream = new unsigned[vt.size/UVM_ML_BLOCK_SIZE];
    // it is the caller's responsibility to deallocate both streams
    *stream_size = uvm_ml_utils::copy_from_mlupo(vt, *stream);    
    EXIT_CO_SIMULATION_CONTEXT();
    return (uvm_ml_tlm_sync_enum) ret;
  }
  CATCH_KERNEL_EXCEPTION_IN_CONNECTOR_1
}

uvm_ml_tlm_sync_enum uvm_ml_tlm_rec::tlm2_nb_transport_bw(
    unsigned              connector_id,
    unsigned *            stream_size,
    uvm_ml_stream_t * stream,
    uvm_ml_tlm_phase *   phase,
    unsigned int          transaction_id,
    uvm_ml_time_unit *    delay_unit,
    double *              delay_value,
    uvm_ml_time_unit      time_unit, 
    double                time_value
) {
  ml_tlm2_connector_base* conn = 0;
  tlm_sync_enum ret;

  try {
      ENTER_CO_SIMULATION_CONTEXT();
    conn = uvm_ml_utils::get_ml_tlm2_connector_base(connector_id);
    if (!conn) { 
        EXIT_CO_SIMULATION_CONTEXT();
      return UVM_ML_TLM2_COMPLETED; // return error code
    }
    //assert(!conn->is_target);
    ml_tlm2_initiator_connector_base *initiator_conn;
    if((conn->is_target) || ((initiator_conn  = dynamic_cast<ml_tlm2_initiator_connector_base *>(conn)) ==NULL ) )  {
      EXIT_CO_SIMULATION_CONTEXT();
      UVM_ML_SC_REPORT_ERROR("UVM-SC adapter: tlm2_nb_transport_bw connector is not target","");
      return UVM_ML_TLM2_COMPLETED; // return error code
    };
    // Create MLUPO from stream
    uvm_ml_packed_obj& vt = uvm_ml_utils::get_static_mlupo(); 
    uvm_ml_utils::fill_mlupo(vt,*stream_size,*stream);
    
    ret = initiator_conn->nb_transport_bw(vt, (tlm_phase_enum *)phase, transaction_id, (sc_time_unit *)delay_unit, delay_value, (sc_time_unit)time_unit, time_value);
    // Check that the incoming stream is big enough to store the 
    // transaction on the return path
    if (vt.size > *stream_size) 
      *stream = new unsigned[((vt.size-1)/UVM_ML_BLOCK_SIZE)+1];
    // GL *stream = new unsigned[vt.size/UVM_ML_BLOCK_SIZE];
    // it is the caller's responsibility to deallocate both streams
    *stream_size = uvm_ml_utils::copy_from_mlupo(vt, *stream);
    
    EXIT_CO_SIMULATION_CONTEXT();
    return (uvm_ml_tlm_sync_enum) ret;
  }
  CATCH_KERNEL_EXCEPTION_IN_CONNECTOR_1
}

unsigned uvm_ml_tlm_rec::tlm2_transport_dbg(
    unsigned              connector_id,
    unsigned *            stream_size,
    uvm_ml_stream_t * stream,
    uvm_ml_time_unit      time_unit, 
    double                time_value
) {
  ml_tlm2_connector_base* conn = 0;
  unsigned ret;

  try {
      ENTER_CO_SIMULATION_CONTEXT();
    conn = uvm_ml_utils::get_ml_tlm2_connector_base(connector_id);
    if (!conn) { 
        EXIT_CO_SIMULATION_CONTEXT();
      return 0;
    }
    //assert(conn->is_target);
    ml_tlm2_target_connector_base *target_conn;
    if(!(conn->is_target) || (( target_conn = dynamic_cast<ml_tlm2_target_connector_base *>(conn) )==NULL ) ) {
      EXIT_CO_SIMULATION_CONTEXT();
      UVM_ML_SC_REPORT_ERROR("UVM-SC adapter: tlm2_transport_dbg connector is not target","");
      return 0; // return error code
    };
    // Create MLUPO from stream
    uvm_ml_packed_obj& vt = uvm_ml_utils::get_static_mlupo(); 
    uvm_ml_utils::fill_mlupo(vt,*stream_size,*stream);
    
    ret = target_conn->transport_dbg(vt, (sc_time_unit)time_unit, time_value);
    if (vt.size > *stream_size) 
      *stream = new unsigned[((vt.size-1)/UVM_ML_BLOCK_SIZE)+1];
    // GL *stream = new unsigned[vt.size/UVM_ML_BLOCK_SIZE];
    // it is the caller's responsibility to deallocate both streams
    *stream_size = uvm_ml_utils::copy_from_mlupo(vt, *stream);

    EXIT_CO_SIMULATION_CONTEXT();
    return ret;
  }
  CATCH_KERNEL_EXCEPTION_IN_CONNECTOR_1
}


void uvm_ml_tlm_rec::tlm2_turn_off_transaction_mapping(const char *socket_name) {
    ml_tlm2_turn_off_transaction_mapping(socket_name);  
}

void uvm_ml_tlm_rec::synchronize(uvm_ml_time_unit time_unit, 
                                 double           time_value) {

  ENTER_CO_SIMULATION_CONTEXT();
  EXIT_CO_SIMULATION_CONTEXT();
}


int uvm_ml_tlm_rec::create_child_junction_node(const char * component_type_name,
                                               const char * instance_name,
                                               const char * parent_full_name,
                                               int          parent_framework_id,
                                               int          parent_junction_node_id) {

    string componentTypeName = string(component_type_name);
    string instanceName = string(instance_name);
    string parentFullName = string(parent_full_name);

    return uvm_ml_utils::implement_create_child_junction_node(componentTypeName, instanceName, parentFullName, parent_framework_id, parent_junction_node_id);
}

static void * backplane_handle = NULL;

static const char* const backplane_get_provided_tray = "bp_get_provided_tray";



static bool backplane_loader_invoked = false;

static void backplane_close() {
    if ( backplane_handle != NULL ) {
        // Close the backplane through the backplane loader
        // if that was used to open it
        // (Incisive only)
        if ( backplane_loader_invoked ) {
            backplane_loader_invoked = false;
            void * global_handle = dlopen(0, RTLD_LAZY);
            assert(global_handle != 0);
            void (*close_backplane_ptr)() = (void (*)())dlsym(global_handle, 
                                                          "cdns_close_uvm_ml_backplane");
            if ( close_backplane_ptr ) {
                close_backplane_ptr();
            }
            
            dlclose(global_handle);
        } else {
            dlclose(backplane_handle);
        }
    }

}

static volatile struct unloading_handler {
    unloading_handler() {}
    ~unloading_handler() {
        backplane_close();
    }
} v1;


static void backplane_open()
{

    void* (*load_uvm_ml_backplane_ptr)();
    void *global_handle;
    // The backplane library may be compiled in or preloaded
    // So, start with the 'global' namespace
    global_handle  = dlopen(0, RTLD_LAZY);
    
    if ( global_handle != 0) {
        if ( dlsym(global_handle, backplane_get_provided_tray) != 0) {
          backplane_handle = global_handle;
            return;
        }
    }


    load_uvm_ml_backplane_ptr = (void* (*)())dlsym(global_handle, "cdns_load_uvm_ml_backplane");

    dlclose(global_handle);

    if ( load_uvm_ml_backplane_ptr ) {
        if ( getenv("UVM_ML_DEBUG_MODE") ) {
            ::std::cerr << "UVM_ML_OA INFO: using the Incisive backplane loader" << ::std::endl;
        }
        backplane_loader_invoked = true;
        backplane_handle = load_uvm_ml_backplane_ptr();
    } else { 
        const char* const backplane_lib_name = "libuvm_ml_bp.so";

        
        char * lib_location = getenv("UVM_ML_OVERRIDE");

        if (lib_location == NULL) { 
            lib_location = getenv("UNILANG_OVERRIDE");
        }
        
        if (lib_location) {
            backplane_handle  = dlopen(((string)lib_location + "/"+backplane_lib_name).c_str(), RTLD_LAZY | RTLD_GLOBAL);
        } else {
            backplane_handle  = dlopen(backplane_lib_name, RTLD_LAZY | RTLD_GLOBAL);
        }

        if (backplane_handle == NULL) {
            string err_str = (char *) dlerror();
            
            // FIXME - use proper error messaging and proper per-simulator graceful shutdown mechanism here
            
            ::std::cout << "Failed to open the backplane library " << backplane_lib_name << " for the following reason: " << err_str << ::std::endl;
            // FIXME - replace with a macro
            #ifndef UVM_ML_PORTABLE
            exit(0);
            #else
            sc_stop();
            #endif
        }
    }

}

// Debug print tree
uvm_component * find_child(string component_name, uvm_component * parent) {
    vector<uvm_component*> children = parent->get_children();
    for(unsigned i = 0; i < children.size(); i++) {
        if(!strcmp(component_name.c_str(), children[i]->name())) {
	    return children[i];
	} else {
	    uvm_component * child = find_child(component_name, children[i]);
	    if(child != NULL) return child;
	}
    }
    return NULL;
}

int uvm_ml_tlm_rec::get_num_children(const char * parent_name) {
    uvm_component * comp;

    for(unsigned i = 0; i < uvm_ml_utils::quasi_static_tree_nodes.size(); i++) {
        comp = (uvm_component *)uvm_ml_utils::quasi_static_tree_nodes[i];
	if(!strcmp(comp->name(), parent_name)) {
	    return comp->get_num_children();
	} else {
	    uvm_component * child = find_child(parent_name, comp);
	    if(child != NULL) {
	        return child->get_num_children();
	    }
	}
    }
    fprintf(stderr, "*** ERROR get_num_children: component not found %s\n", parent_name);
    return -1;
};

const char * uvm_ml_tlm_rec::get_child_name(const char * parent_name, unsigned num) {
    uvm_component * comp;
    uvm_component * child;

    for(unsigned i = 0; i < uvm_ml_utils::quasi_static_tree_nodes.size(); i++) {
        comp = (uvm_component *)uvm_ml_utils::quasi_static_tree_nodes[i];
	if(!strcmp(comp->name(), parent_name)) {
	    child = comp;
	} else {
	    child = find_child(parent_name, comp);
	}
	if(child != NULL) {
	    vector<uvm_component*> children = child->get_children();
	    if(children.size() > num) {
	        return children[num]->name();
	    } else {
	        fprintf(stderr, "*** ERROR get_child_name: index over the limit %d\n", num);
	        return "";
	    }
	}
    }
    fprintf(stderr, "*** ERROR get_child_name: child not found\n");
    return "";
}

const char * uvm_ml_tlm_rec::get_component_type_name(const char * component_name) {
    return ""; // not implemented
}

int uvm_ml_tlm_rec::is_port(const char * component_name) {
    return 0; // not implemented
}

} // namespace uvm_ml
//////////////////////

EXTERN_DISABLE_SC_START;

// return 0 for error
unsigned uvm_ml_utils::initialize_adapter()
{
    backplane_open();

    //assert(backplane_handle != NULL);
    if(backplane_handle == NULL) {
      UVM_ML_SC_REPORT_ERROR("UVM-SC adapter: backplane not initialized","");
      return 0; // return error code
    };

    bp_api_struct* (*bp_get_provided_tray_ptr)() = (bp_api_struct* (*)())dlsym(backplane_handle, backplane_get_provided_tray);
    bpProvidedAPI = (bp_get_provided_tray_ptr)();
    //assert(bpProvidedAPI != NULL);
    if(bpProvidedAPI == NULL) {
      UVM_ML_SC_REPORT_ERROR("UVM-SC adapter: backplane provided API not available","");
      return 0; // return error code
    };
    char *frmw_ids[3] = {(char*)"UVMSC", (char*)"SC",(char*)""};
    DISABLE_SC_START();

    uvm_ml_phase::Initialize(bpProvidedAPI);        // Initialize phasing
    uvm_ml_config_rsrc::Initialize(bpProvidedAPI);  // Initialize config/rsrc

    uvm_ml_event::initialize(bpProvidedAPI);
    uvm_ml_event_pool::initialize();        // register ml_event_pool

    uvm_ml_barrier::initialize(bpProvidedAPI);
    uvm_ml_barrier_pool::initialize();      // register ml_barrier_pool

    uvm_ml_sync::initialize(bpProvidedAPI);

    uvm_set_type_override(gen_type_name<uvm_event_pool>(), "uvm_ml_event_pool");
    uvm_set_type_override(gen_type_name<uvm_barrier_pool>(), "uvm_ml_barrier_pool");

    return BP(register_framework)((char*)"SystemC",frmw_ids, uvm_ml_sc_get_required_api());
}

//////////////////////
unsigned uvm_ml_utils::get_type_id(const string & name) {
    return BP(get_type_id_from_name)(framework_id, (char*)(name.c_str()));
}

char* uvm_ml_utils::get_type_name(unsigned id) {
    return BP(get_type_name_from_id)(framework_id, id);
}

unsigned int uvm_ml_utils::assign_transaction_id() {
    return BP(assign_transaction_id)(framework_id);
}

//////////////////////


namespace uvm_ml {

  void uvm_ml_connect(const string & port_name, const string & export_name, bool map_transactions) {
        if (IN_ELABORATION()) return;
        if (! ml_tlm2_check_cross_registration(port_name, export_name)) return;
        if (uvm_ml_utils::quasi_static_construction_ended()) {
	    unsigned result = uvm_ml_utils::do_connect(port_name, export_name);
	    if(result == 0) return; // propagate error
            if (map_transactions == false) {
	        uvm_ml_utils::tlm2_turn_off_transaction_mapping(port_name, export_name);
            }
        } else {
            uvm_ml_utils::add_pending_uvm_ml_connect_call(port_name, export_name, map_transactions);
        }
    }

//------------------------------------------------------------------------------
//! Calls backplane to register which framework will provide which service.
/*!
 *  @param srv_providers - List of fields populated with name of framework 
 *                         providing the service.  Null fields are ignored 
 *                         by the backplane. 
 */
  void uvm_ml_register_srv_providers(uvm_ml_srv_provider_struct * srv_providers)
  {
      bp_srv_provider_struct * bp_srv_providers;

      bp_srv_providers = (bp_srv_provider_struct *) (srv_providers);
      BP(register_srv_providers)(framework_id, bp_srv_providers);
  }

#ifdef UVM_ML_PORTABLE
// Temporarily cannot use configuration with the portable adapter because of issues with boost
  static string current_component_type_name;
  static string current_instance_name;
  static string current_parent_name;
  static string current_target_framework_indicator;

  void uvm_ml_set_create_component(const string & component_type_name, const string & instance_name, const string & parent_name, const string & target_framework_indicator)
  {
    current_component_type_name = component_type_name;
    current_instance_name = instance_name;
    current_parent_name = parent_name;
    current_target_framework_indicator = target_framework_indicator;
  }

  void uvm_ml_get_create_component_settings(string & component_type_name, string & instance_name, string & parent_name, string & target_framework_indicator)
  {
    component_type_name = current_component_type_name;
    instance_name = current_instance_name;
    parent_name = current_parent_name;
    target_framework_indicator = current_target_framework_indicator;
  }
#endif // UVM_ML_PORTABLE

  int uvm_ml_execute_command(const string & command, sc_severity error_severity = SC_ERROR)
  {
    if (IN_ELABORATION() == true) return (-1);

    int result = BP(execute_command)(framework_id, command.c_str(), NULL, m_time_unit, m_time_value);
    if (result != 1) {
      if (error_severity >= SC_FATAL)
        SC_REPORT_FATAL("UVM-ML SC", "UVM-ML SC adapter function uvm_ml_execute_command returned an error with fatal severity set");
      else if (error_severity == SC_ERROR)
        SC_REPORT_ERROR("UVM-ML SC", "UVM-ML SC adapter function uvm_ml_execute_command returned an error");
    }
    return result; 
  }

} // namespace uvm_ml


//////////////////////

uvm_ml_tlm_transrec_base::uvm_ml_tlm_transrec_base(const char* name_) 
    //: sc_object(name_) 
{
  m_obj = 0;
  m_id_is_valid = false;
  m_intf_name = "unknown_interface";
  m_REQ_name = "unknown_type";
  m_RSP_name = "unknown_type";
}

uvm_ml_tlm_transrec_base::~uvm_ml_tlm_transrec_base() { }

sc_object* uvm_ml_tlm_transrec_base::object() const { return m_obj; }


bool uvm_ml_tlm_transrec_base::id_is_valid() const {
  return m_id_is_valid;
}

void uvm_ml_tlm_transrec_base::id_is_valid(bool b) {
  m_id_is_valid = b;
}

unsigned uvm_ml_tlm_transrec_base::connection_id() const { 
  return uvm_ml_utils::uvm_ml_tlm_id_from_name(m_obj->name()); 
}

const string & uvm_ml_tlm_transrec_base::get_intf_name() const {
  return m_intf_name;
}

const string & uvm_ml_tlm_transrec_base::get_REQ_name() const {
  return m_REQ_name;
}

const string & uvm_ml_tlm_transrec_base::get_RSP_name() const {
  return m_RSP_name;
}

void uvm_ml_tlm_transrec_base::set_intf_name(const string & s) {
  m_intf_name = s;
}

void uvm_ml_tlm_transrec_base::set_REQ_name(const string & s) {
  m_REQ_name = s;
}

void uvm_ml_tlm_transrec_base::set_RSP_name(const string & s) {
  m_RSP_name = s;
}

void uvm_ml_tlm_transrec_base::unconnected_error() const {
  char msg[1024];
  sprintf(msg, "\nPort/export is '%s'", m_obj->name());
  SC_REPORT_ERROR(ML_UVM_UNCONNECTED_ID_, msg);
}

//////////////////////

uvm_ml_tlm_transmitter_base::uvm_ml_tlm_transmitter_base(const char* name_)
    : uvm_ml_tlm_transrec_base(name_) { }

uvm_ml_tlm_transmitter_base::~uvm_ml_tlm_transmitter_base() { }

bool uvm_ml_tlm_transmitter_base::is_transmitter() const { return true; }

//////////////////////

uvm_ml_tlm_receiver_base::uvm_ml_tlm_receiver_base(const char* name_)
    : uvm_ml_tlm_transrec_base(name_),m_iface(0) { }

uvm_ml_tlm_receiver_base::~uvm_ml_tlm_receiver_base() { }

bool uvm_ml_tlm_receiver_base::is_transmitter() const { return false; }


sc_interface* uvm_ml_tlm_receiver_base::get_interface() const { 
  return m_iface; 
}

//////////////////////

int uvm_ml_utils::get_pack_block_size() {
    return UVM_ML_PACKING_BLOCK_SIZE_INT;
}

int uvm_ml_utils::get_max_bits() {
  static int pack_block_size = get_pack_block_size();
  int size = BP(get_pack_max_size)(framework_id);
  if (size == -1) { // uninitilaized in backplane
    char* c = 0;
    c = getenv("UVM_ML_BITSIZE");
    if (c) {
      size = atoi(c);
    }
    if (size < pack_block_size) {
      size = pack_block_size;
    }
  }
  return size;
}

int round_bits(int nbits) {
  static unsigned pack_block_size = uvm_ml_utils::get_pack_block_size();
  //int i = (nbits - 1)/UVM_PACKING_BLOCK_SIZE + 1;
  //int n = i*UVM_PACKING_BLOCK_SIZE;
  int i = (nbits - 1)/pack_block_size + 1;
  int n = i*pack_block_size;
  return n;
}

int uvm_ml_utils::get_max_words() {
  static int max_bits = uvm_ml_utils::get_max_bits();
  static int round_max_bits = round_bits(max_bits);
  static int max_words = 1 + (round_max_bits - 1)/32;
  return max_words;
}

void uvm_ml_utils::fill_mlupo(MLUPO& vt, unsigned size, void* stream) {
  int nwords;
  vt.size = size;
  uvm_ml_stream_t val = (uvm_ml_stream_t)stream;
  nwords = ((size-1)/UVM_ML_BLOCK_SIZE)+1; // GL nwords = size/UVM_ML_BLOCK_SIZE;
  int round_nbits = round_bits(nwords*32);
  int alloc_words = 1 + (round_nbits - 1)/32;

  // we could for simplicity also allocatethe max_words here, although
  // that is not necessary
 
  // we are always allocate mlupo in multiples of UVM_PACKING_BLOCK_SIZE;
  // not really necessary; optimize in future

  uvm_ml_packed_obj::allocate(&vt, alloc_words);

  memcpy(vt.val, val, nwords*sizeof(unsigned));
}


void uvm_ml_utils::allocate_mlupo(MLUPO* vt) {

  static int alloc_words = uvm_ml_utils::get_max_words();
   

  // we are always allocating mlupo in multiples of UVM_PACKING_BLOCK_SIZE;
  // not really necessary; optimize in future

  uvm_ml_packed_obj::allocate(vt, alloc_words);
}

unsigned uvm_ml_utils::copy_from_mlupo(const MLUPO& vt, void* stream) {
    int nwords;
    unsigned* ustream = (unsigned*)stream;
    nwords = ((vt.size-1)/UVM_ML_BLOCK_SIZE)+1; // GL nwords = vt.size/UVM_ML_BLOCK_SIZE;
    memcpy(ustream, vt.val, nwords*sizeof(unsigned));

    return vt.size;
}


uvm_ml_packed_obj static_mlupo;

uvm_ml_packed_obj& uvm_ml_utils::get_static_mlupo() {
  return static_mlupo;
}

std::queue<uvm_ml_packed_obj*> mlupo_free_q;

uvm_ml_packed_obj* uvm_ml_utils::get_mlupo_from_pool() {
  uvm_ml_packed_obj* n = 0;
  int size = mlupo_free_q.size();
  if (size > 0) {
    n = mlupo_free_q.front();
    mlupo_free_q.pop();
    return n;
  }
  // allocate new mlupo
  //cout << "**************allocating new mlupo " << endl;
#ifdef _NCSC_DEBUG
  dbginfo(U) << "**************allocating new mlupo " << endl;
#endif
  n = new uvm_ml_packed_obj();
  return n;
}
  
void uvm_ml_utils::release_mlupo_to_pool(uvm_ml_packed_obj* n) {
  mlupo_free_q.push(n);
}

void uvm_ml_utils::register_static_top(const string & full_name) {

  if ((IN_ELABORATION() == false) && (uvm_ml_utils::quasi_static_elaboration_started() == false)) {
    string top_name;

    size_t posDelim = full_name.find_first_of(".");
    if (posDelim != string::npos)
      top_name = full_name.substr(0, posDelim);
    else
      top_name = full_name;
  
    if (std::find(static_top_names.begin(), static_top_names.end(), top_name) != static_top_names.end())
      return; // Already registered 

    if (BP(add_root_node)(framework_id,
                          get_next_top_id(),
                          top_name.c_str(),
                          top_name.c_str()) == (-1))
        SC_REPORT_ERROR(ML_UVM_RUN_TIME_ERROR_,"Duplicate top component instance name ");

    static_top_names.push_back(top_name);
  }
}

unsigned int uvm_ml_utils::add_quasi_static_tree_node(sc_module * pmod) { 
    quasi_static_tree_nodes.push_back (pmod); 
    return static_top_names.size() + quasi_static_tree_nodes.size() - 1; 
};

//////

/*! \class uvm_ml_tlm_connection_info
  \brief Maintains information about an interface.

  
*/
class uvm_ml_tlm_connection_info {
public:
    uvm_ml_tlm_connection_info(const string & port_name, const string & export_name, bool map_transactions = true):  
        m_port_name(port_name), m_export_name(export_name), m_map_transactions(map_transactions)
    {
    }
    string m_port_name;
    string m_export_name;
    bool m_map_transactions;
};

typedef std::vector<uvm_ml_tlm_connection_info*> uvm_ml_tlm_connection_vec;

static uvm_ml_tlm_connection_vec* pending_uvm_ml_connect_calls = 0;

unsigned uvm_ml_utils::do_connect (const string & port_name, const string & export_name) {
    //assert (bpProvidedAPI != NULL);
    if(bpProvidedAPI == NULL) {
      char msg[1024];
      sprintf(msg, "\nPort is '%s'; Export is '%s' \n", port_name.c_str(), export_name.c_str());
      UVM_ML_SC_REPORT_ERROR("UVM-SC adapter: do_connect failed",msg);
      return 0; // propagate error 
    };
    return BP(connect)(framework_id,port_name.c_str(),export_name.c_str());
}

void uvm_ml_utils::add_pending_uvm_ml_connect_call(const string & port_name,
                                                   const string & export_name, 
                                                   bool map_transactions) {
  if (!pending_uvm_ml_connect_calls) {
    pending_uvm_ml_connect_calls = new uvm_ml_tlm_connection_vec;
  }
  uvm_ml_tlm_connection_info* info = 
      new uvm_ml_tlm_connection_info(port_name, export_name, map_transactions);
  pending_uvm_ml_connect_calls->push_back(info);
}

void uvm_ml_utils::tlm2_turn_off_transaction_mapping(const string & port_name, 
                                                     const string & export_name) {
    BP(turn_off_transaction_mapping)(framework_id, port_name.c_str());
    BP(turn_off_transaction_mapping)(framework_id, export_name.c_str());
}

int uvm_ml_utils::do_pending_uvm_ml_connect_calls() {

  int result = 1;
  if (pending_uvm_ml_connect_calls) {

      for (unsigned i = 0; i < pending_uvm_ml_connect_calls->size(); i++) {
          uvm_ml_tlm_connection_info* info = (*pending_uvm_ml_connect_calls)[i];
          result = uvm_ml_utils::do_connect(info->m_port_name, info->m_export_name);
          if (result == 0) {
              // user cannot process the connection result because it was postponed
              SC_REPORT_INFO("UVM-SC adapter: TLM connection failed","");
              return 0;
	  }
          if (info->m_map_transactions == false) {
              tlm2_turn_off_transaction_mapping(info->m_port_name, info->m_export_name);
          }
      }
      pending_uvm_ml_connect_calls->clear();
  }
  return result;
}

int uvm_ml_debug::receive_command(const char *     command,
                                  bp_output_cb_t * output_cb,
                                  uvm_ml_time_unit time_unit,
                                  double           time_value) {
  string         command_s = command;
  stringstream   ss(command_s);
  string         token;
  vector<string> tokens;

  while (std::getline(ss, token, ' '))
      if (!token.empty())
          tokens.push_back(token);

  // Meantime the adapter supports only one command: "trace_register"
  if ((tokens[0] == "trace_register") || 
      (tokens[0] == "uvm_ml_trace_register") || 
      (tokens[0] == "trace_register_tlm")) {
      // The adapter does not check legality of syntax of the predefined command
      // The backplane is responsible for checking the syntax and printing the help for this command

      if (output_cb != NULL)
         SC_REPORT_WARNING(ML_UVM_RUN_TIME_ERROR_, "Currently command trace_register does not support re-direction of the output");    

      if (tokens[1] == "-on")
	  uvm_ml_utils::set_trace_register (true);
      else if (tokens[1] == "-off")
	  uvm_ml_utils::set_trace_register (false);
      else
        return 0;
      return 1; //success of setting trace_register
  }
  return -1; // other commands return UNRECOGNIZED_COMMAND (-1) 
}

// ///////////////////////

void uvm_ml_tlm_trans::request_put(
  unsigned port_connector_id,
  MLUPO* arg 
) {
  unsigned call_id = fake_blocking_call_id++;
  unsigned done = 0;
  int disable = BP(request_put)(
    framework_id,
    port_connector_id,
    call_id,
    arg->size,
    arg->val,
    &done,
    &m_time_unit,
    &m_time_value
  );
  if (!done) {
    //SC_REPORT_ERROR(UVM_DONE_BIT_,"");
    void* p_call_id;
    // need to do the cast to unsigned long below before casting to pointer
    // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
    // bits; so casting from unsigned to pointer generates compiler warning;
    // unsigend long  matches the size of pointers on 32 bit and 64 bit m/cs
    p_call_id = (void *)(unsigned long)call_id;
    sc_event *e = new INVISIBLE_EVENT("uvm_fake_blocking");
    call_id_trans_dict.insert(p_call_id, e);
    sc_core::wait(*e);
    // we are here when the target adaptor has informed us via 
    // the backplane that the call has finished in it;
    // delete call_id and event ptrs
    delete e;
  }
  if (disable == 1) {
    // rule out the cases that 1) SC process initiated call (ECC) and child
    // SV is disabled; this is illegal at present
    // 2) e initiated call and somehow 1 is returned here
      uvm_ml::dpi_task_disabled();
  }
}

int uvm_ml_tlm_trans::nb_put(
  unsigned local_port_id, 
  MLUPO* val
) {
    return BP(nb_put)(
    framework_id,
    local_port_id,
    val->size,
    val->val,
    m_time_unit,
    m_time_value
  );
}

int uvm_ml_tlm_trans::can_put(unsigned local_port_id) {
    return BP(can_put)(framework_id,local_port_id, m_time_unit, m_time_value);
}

void uvm_ml_tlm_trans::notify_end_blocking(
  unsigned callback_adapter_id,
  unsigned call_id
) {
    BP(notify_end_blocking)(framework_id, callback_adapter_id, call_id, m_time_unit, m_time_value);
}

//

void uvm_ml_tlm_trans::request_get(
  unsigned port_connector_id,
  MLUPO* arg
) {
  unsigned call_id = fake_blocking_call_id++;
  unsigned done = 0;
  int disable = BP(request_get)(
    framework_id,
    port_connector_id,
    call_id,
    &(arg->size),
    arg->val,
    &done,
    &m_time_unit,
    &m_time_value
  );
  if (!done) { // fake blocking
    //SC_REPORT_ERROR(UVM_DONE_BIT_,"");
    // new sc_event; hash <call_id , event>; wait on event;
    // later target will cause event to be triggered
    void* p_call_id;
    // need to do the cast to unsigned long below before casting to pointer
    // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
    // bits; so casting from unsigned to pointer generates compiler warning;
    // unsigend long  matches the size of pointers on 32 bit and 64 bit m/cs
    p_call_id = (void *)(unsigned long)call_id;
    sc_event* e = new INVISIBLE_EVENT("uvm_fake_blocking");
    call_id_trans_dict.insert(p_call_id, e);
    sc_core::wait(*e);
    // we are here when target adaptor has informed us via 
    // the backplane that the call has finished in it;
    // get the return value of get() from the backplane
    arg->size = BP(get_requested)(
      framework_id,
      port_connector_id,
      call_id,
      arg->val
    );
    // delete call_id and event ptrs
    delete e;
  }
  if (disable == 1) {
      uvm_ml::dpi_task_disabled();
  }
}

int uvm_ml_tlm_trans::nb_get(unsigned local_port_id, MLUPO* val) {
    return BP(nb_get)(
    framework_id, 
    local_port_id, 
    &(val->size),
    val->val,
    m_time_unit,
    m_time_value
  );
}

int uvm_ml_tlm_trans::can_get(unsigned local_port_id) {
    return BP(can_get)(framework_id, local_port_id, m_time_unit, m_time_value);
}

void uvm_ml_tlm_trans::request_peek(
  unsigned port_connector_id,
  MLUPO* arg
) {
  unsigned call_id = fake_blocking_call_id++;
  unsigned done = 0;
  int disable = BP(request_peek)(
    framework_id,
    port_connector_id,
    call_id,
    &(arg->size),
    arg->val,
    &done,
    &m_time_unit,
    &m_time_value
  );
  if (!done) {
    // new sc_event; hash <call_id , event>; wait on event;
    // later target will cause event to be triggered
    void* p_call_id;
    // need to do the cast to unsigned long below before casting to pointer
    // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
    // bits; so casting from unsigned to pointer generates compiler warning;
    // unsigend long  matches the size of pointers on 32 bit and 64 bit m/cs
    p_call_id = (void *)(unsigned long)call_id;

    sc_event* e = new INVISIBLE_EVENT("uvm_fake_blocking");
    call_id_trans_dict.insert(p_call_id, e);
    sc_core::wait(*e);
    // we are here when the target framework has informed us via 
    // the backplane that the call has finished in it;
    // get the return value of get() from the backplane
    arg->size = BP(peek_requested)(
      framework_id,
      port_connector_id,
      call_id,
      arg->val
    );
    // delete call_id and event ptrs
    delete e;
  }
  if (disable == 1) {
      uvm_ml::dpi_task_disabled();
  }
}

int uvm_ml_tlm_trans::nb_peek(unsigned local_port_id, MLUPO* val) {
    return BP(nb_peek)(
    framework_id, 
    local_port_id, 
    &(val->size),
    val->val,
    m_time_unit,
    m_time_value
  );
}

int uvm_ml_tlm_trans::can_peek(unsigned local_port_id) {
    return BP(can_peek)(framework_id, local_port_id, m_time_unit, m_time_value);
}

int uvm_ml_tlm_trans::request_transport(
  unsigned port_connector_id,
  MLUPO* req,
  MLUPO* rsp
) {
  unsigned call_id = fake_blocking_call_id++;
  unsigned done = 0;
  int disable = BP(request_transport)(
    framework_id,
    port_connector_id,
    call_id,
    req->size,
    req->val,
    &(rsp->size),
    rsp->val,
    &done,
    &m_time_unit,
    &m_time_value
  );
  if (!done) {
    //SC_REPORT_ERROR(UVM_DONE_BIT_,"");
    // new sc_event; hash <call_id , event>; wait on event;
    // later target will cause event to be triggered
    void* p_call_id;
    // need to do the cast to unsigned long below before casting to pointer
    // because on 64 bit m/cs pointers are 64 bits, whereas unsigned is 32
    // bits; so casting from unsigned to pointer generates compiler warning;
    // unsigend long  matches the size of pointers on 32 bit and 64 bit m/cs
    p_call_id = (void *)(unsigned long)call_id;

    sc_event* e = new INVISIBLE_EVENT("uvm_fake_blocking");

    call_id_trans_dict.insert(p_call_id, e);
    sc_core::wait(*e);
    // we are here when target adaptor has informed us via
    // the backplane that the call has finished in it;
    // get the return value of get() from the backplane
    rsp->size = BP(transport_response)(
      framework_id,
      port_connector_id,
      call_id,
      rsp->val
    );
    // delete call_id and event ptrs
    delete e;
  }
  if (disable == 1) {
      uvm_ml::dpi_task_disabled();
  }

  return 0;
}

void uvm_ml_tlm_trans::write(
  unsigned local_port_id, 
  MLUPO* val
) {
    BP(write)(
    framework_id,
    local_port_id,
    val->size,
    val->val,
    m_time_unit,
    m_time_value
  );
}
