//----------------------------------------------------------------------
//   Copyright 2012 Cadence Design Systems, Inc.
//   Copyright 2013 Advanced Micro Devices Inc.
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

// /////////////////////////////////////////
//
// UVM_ML Adapter Package Scope Definitions
//
// /////////////////////////////////////////


// //////////////////////////////////////////
//
// Temporary definitions duplicated from UVM SV
//
// //////////////////////////////////////////

`ifndef UVM_PACK_MAX_SIZE
  `define UVM_PACK_MAX_SIZE `UVM_OVM_(STREAMBITS)
`endif

`ifdef QUESTA
`ifndef UVM_TLM_B_MASK
`define UVM_TLM_B_MASK      (1<<2)
`endif

`ifndef UVM_TLM_NB_FW_MASK
`define UVM_TLM_NB_FW_MASK  (1<<0)
`endif
`endif
////////////////////////////////////////////////////

`define MAX_STREAM_SIZE    (`UVM_PACK_MAX_SIZE/32)
`define MAX_STREAM_BITSIZE  `UVM_PACK_MAX_SIZE

typedef bit [`MAX_STREAM_SIZE-1:0][31:0] uvm_ml_intstream_t;
`define STREAM_T  uvm_ml_intstream_t

// /////////////////////////////////////////////////////////////////
//
// Adapter initialization and registration at the UVM-ML Backplane:
//

// bit: sv_phase_master
// Set to 1 if adapter should register SV as the phase service provider to backplane during <initialize>
bit sv_phase_master = 1;
int unsigned  adapter_id = initialize();


// ////////////////////////////////

int unsigned  global_next_connector_id = 0;
int global_phase_error_flag = 0;

typedef class uvm_ml_class_packer_t;

uvm_ml_class_packer_t uvm_ml_packer = new(); // Predefined UVM-ML Packer Class

// ////////////////////////////////
// Temporary Debug Trace Facility
// ////////////////////////////////

  int trace_mode;

// /////////////////////////////////////////////////////////////////
//
// trace_msg
//
  function void trace_msg(string s);
      if (trace_mode != 0)
          $display("#%0t: %s", $time, s);
  endfunction : trace_msg

// ////////////////////////////////

//
// Struct: uvm_ml_srv_provider_struct
// 
// Structure containing fields of type string representing
// the name of the framework providing the service.
//
typedef struct {
   string  phase_srv_provider;
   string  wakeup_srv_provider;
   string  stopper_srv_provider;
   string  print_srv_provider;
} uvm_ml_srv_provider_struct;

//
// Enum: uvm_ml_stream_kind_e
//
// UVM_ML_STREAM_NULL         - null object
// UVM_ML_STREAM_TYPED_OBJECT - user-defined typed class
// UVM_ML_STREAM_RAW          - raw data representation
// UVM_ML_STREAM_STRING       - string
//
typedef enum
{
    UVM_ML_STREAM_NULL = 0,
    UVM_ML_STREAM_TYPED_OBJECT,
    UVM_ML_STREAM_RAW,
    UVM_ML_STREAM_STRING
} uvm_ml_stream_kind_e;

//
// Enum: uvm_ml_phase_action_e
//
// UVM_ML_PHASE_STARTED      - phase starting
// UVM_ML_PHASE_EXECUTING    - phase executing
// UVM_ML_PHASE_READY_TO_END - phase ready to end
// UVM_ML_PHASE_ENDED        - phase ended
//
typedef enum 
{
    UVM_ML_PHASE_STARTED,
    UVM_ML_PHASE_EXECUTING,
    UVM_ML_PHASE_READY_TO_END,
    UVM_ML_PHASE_ENDED
} uvm_ml_phase_action_e;

// ////////////////////////////////

typedef enum 
{
    UVM_ML_TIME_UNIT_FS,
    UVM_ML_TIME_UNIT_PS,
    UVM_ML_TIME_UNIT_NS,
    UVM_ML_TIME_UNIT_US,
    UVM_ML_TIME_UNIT_MS,
    UVM_ML_TIME_UNIT_SEC,
    UVM_ML_TIME_UNIT_UNDEFINED
} uvm_ml_time_unit_e;

typedef enum
{
    UVM_ML_RESOURCE_SET,
    UVM_ML_RESOURCE_SET_DEFAULT,
    UVM_ML_RESOURCE_SET_OVERRIDE,
    UVM_ML_RESOURCE_SET_OVERRIDE_NAME,
    UVM_ML_RESOURCE_WRITE_BY_NAME,
    UVM_ML_CONFIG_SET
} uvm_ml_resource_notify_action_e;

typedef enum
{
    UVM_ML_EVENT_NEW,
    UVM_ML_EVENT_TRIGGER,
    UVM_ML_EVENT_RESET,
    UVM_ML_EVENT_CANCEL,
    UVM_ML_EVENT_DELETE
} uvm_ml_event_notify_action_e;

typedef enum
{
    UVM_ML_BARRIER_NEW,
    UVM_ML_BARRIER_RESET,
    UVM_ML_BARRIER_SET_AUTO_RESET,
    UVM_ML_BARRIER_SET_THRESHOLD,
    UVM_ML_BARRIER_CANCEL,
    UVM_ML_BARRIER_DELETE
} uvm_ml_barrier_notify_action_e;

virtual class tlm_connector_base extends uvm_component;

    static tlm_connector_base connector_map[int unsigned]; // map by id
    static tlm_connector_base connector_name_map[string];  // map by actual port/socket full name

    static int unsigned       m_global_next_connector_id = 0;

    int unsigned              m_conn_id;

// /////////////////////////////////////////////////////////////////
//
// tlm_connector_base::new
//
    function new (string name, uvm_component parent);
        super.new(name, parent);
        m_conn_id =  m_global_next_connector_id++;
    endfunction : new

// /////////////////////////////////////////////////////////////////
//
// tlm_connector_base::get_id
//
    function int unsigned get_id();
        return m_conn_id;
    endfunction :get_id 

// /////////////////////////////////////////////////////////////////
//
// tlm_connector_base::get
//
    static function tlm_connector_base get(int unsigned connector_id);
        if (connector_map.exists(connector_id))
            return connector_map[connector_id];
        else begin
            //assert (0); Calling functions check for null
            // TODO: uvm_ovm_(report_fatal) ("MLNOCON", "");
            return null;
        end
    endfunction : get

// /////////////////////////////////////////////////////////////////
//
// tlm_connector_base::find_connector_by_inst_name
//
    static function int find_connector_by_inst_name(string name);
        if (connector_name_map.exists(name))
            return connector_name_map[name].get_id();
        else
            return (-1);
    endfunction : find_connector_by_inst_name

// /////////////////////////////////////////////////////////////////
//
// tlm_connector_base::add_connector
//
    static function void add_connector(tlm_connector_base conn, string name);
        connector_map[conn.m_conn_id] = conn;
        connector_name_map[name] = conn;
    endfunction : add_connector

    pure virtual function string          get_if_name();

    pure virtual function string          get_T1_name();

    pure virtual function string          get_T2_name();

    pure virtual function uvm_port_type_e get_actual_port_type();
  
    pure virtual function void            do_connect();

    pure virtual function string          get_connection_name();

    // ///////////////////////////////////
    //
    // Export API
    //
    //    
    virtual function void export_put_request(int unsigned call_id, 
                                             int unsigned callback_adapter_id, 
                                             int unsigned stream_size, 
                                             `STREAM_T    stream);
        uvm_report_error ("put_request", "UVM-ML interface function not implemented", UVM_NONE);
    endfunction : export_put_request

    virtual function void export_transport_request(int unsigned call_id, 
                                                   int unsigned callback_adapter_id, 
                                                   int unsigned req_stream_size, 
                                                   `STREAM_T    req_stream);    
        uvm_report_error ("transport_request", "UVM-ML interface function not implemented", UVM_NONE);
    endfunction : export_transport_request

    virtual function bit export_try_put(int unsigned stream_size, `STREAM_T stream);
        uvm_report_error ("try_put", "UVM-ML interface function not implemented", UVM_NONE);
        return 0;
    endfunction : export_try_put

    virtual function bit export_can_put();
        uvm_report_error ("can_put", "UVM-ML interface function not implemented", UVM_NONE);
        return 0;
    endfunction : export_can_put

    virtual function bit export_try_get(output int unsigned stream_size, output `STREAM_T stream);
        uvm_report_error ("try_get", "UVM-ML interface function not implemented", UVM_NONE);
        return 0;
    endfunction : export_try_get

    virtual function bit export_can_get();
        uvm_report_error ("can_get", "UVM-ML interface function not implemented", UVM_NONE);
        return 0;
    endfunction : export_can_get

    virtual function bit export_try_peek(output int unsigned stream_size, output `STREAM_T stream);
        uvm_report_error ("try_peek", "UVM-ML interface function not implemented", UVM_NONE);
        return 0;
    endfunction : export_try_peek

    virtual function bit export_can_peek();
        uvm_report_error ("can_peek", "UVM-ML interface function not implemented", UVM_NONE);
        return 0;
    endfunction : export_can_peek

    virtual function bit export_nb_transport(int unsigned        req_stream_size, 
                                             ref `STREAM_T       req_stream, 
                                             output int unsigned rsp_stream_size, 
                                             output `STREAM_T    rsp_stream);
        uvm_report_error ("nb_transport", "UVM-ML interface function not implemented", UVM_NONE);
        return 0;
    endfunction : export_nb_transport

    virtual function void export_write(int unsigned stream_size, `STREAM_T stream);
        uvm_report_error ("write", "UVM-ML interface function not implemented", UVM_NONE);
    endfunction : export_write
endclass

/////////

uvm_component hierarchical_nodes[$];
int unsigned  hierarchical_node_ids[uvm_component];

function int unsigned get_hierarchical_node_id(uvm_component comp);
    static int unsigned next_id = 0;

    if (hierarchical_node_ids.exists(comp)) begin
        return hierarchical_node_ids[comp];
    end
    else begin
        hierarchical_node_ids[comp] = hierarchical_nodes.size();
        hierarchical_nodes.push_back(comp);
        return next_id++;
    end
endfunction : get_hierarchical_node_id

// /////////////////////////////////////////
//
// get_phase_state
//
// /////////////////////////////////////////
  function uvm_phase_state get_phase_state(uvm_ml_phase_action_e action);
    case(action)
        UVM_ML_PHASE_STARTED: return UVM_PHASE_STARTED;
        UVM_ML_PHASE_EXECUTING: return UVM_PHASE_EXECUTING;
        UVM_ML_PHASE_READY_TO_END: return UVM_PHASE_READY_TO_END;
        UVM_ML_PHASE_ENDED: return UVM_PHASE_ENDED;
    endcase
  endfunction : get_phase_state


// /////////////////////////////////////////////////////////////////////////////////////////
//
// Auxiliary object that can be used to represent a foreign configuration/resource accessor
//
////////////////////////////////////////////////////////////////////////////////////////////

class uvm_ml_accessor_proxy_t extends uvm_object;
  `uvm_object_utils(uvm_ml_accessor_proxy_t)

  function new(string name = "");
    super.new(name);
  endfunction: new

endclass : uvm_ml_accessor_proxy_t

`define UVM_ML_TRACE_ACCESSOR_PROXY_OBJECT(A,S) if (uvm_config_db_options::is_tracing()) A = new(S); else A = null;

// ////////////////////////////////////////////////
//
// Base class for extending pool functionality with
// facility to create and manage local named pools
//
///////////////////////////////////////////////////

class uvm_ml_ext_object_string_pool #(type T=uvm_object, type TPOOL = uvm_object_string_pool #(T)) extends uvm_object_string_pool #(T);

  typedef uvm_ml_ext_object_string_pool #(T,TPOOL) this_type;

  const static string type_name = {"uvm_ml_ext_object_string_pool"};

  static protected TPOOL m_pools[string];

  typedef uvm_object_registry #(TPOOL) pool_type_id;

  function new (string name="");
    super.new(name);
  endfunction : new

  virtual function string get_type_name ();
    return type_name;
  endfunction : get_type_name

  // Function: get_pool
  //
  // Creates a new pool with the given ~name~ if not exist and if already exists, return existing one.

  static function TPOOL get_pool(string name, uvm_object owner=null);
    string n = name;
    if (owner != null) begin
      if (name == "") begin
        n = owner.get_full_name();
      end
      else begin
        n = {owner.get_full_name(), ".", name};
      end
    end
    if (!m_pools.exists(n)) begin
      m_pools[n] = this_type::pool_type_id::create(n);
    end
    return m_pools[n];
  endfunction : get_pool

  // Function: pool_exists
  //
  // Check if a pool exists or not with the given ~name~.

  static function int pool_exists(string name);
    return m_pools.exists(name);
  endfunction : pool_exists

  // Function: get_global_pool
  //
  // Returns the singleton global pool for the item type, T. 
  //
  // This allows items to be shared amongst components throughout the
  // verification environment.

  static function TPOOL get_global_pool ();
    return get_pool("global_pool"); 
  endfunction : get_global_pool

endclass : uvm_ml_ext_object_string_pool

`ifdef UVM_VERSION_1_2

`define UVM_ML_PACK_FIELD_ARRAY_INT_ELEMENT pack_field_array_int_element
`define UVM_ML_UNPACK_FIELD_ARRAY_INT_ELEMENT unpack_field_array_int_element
`define UVM_ML_INTEGRAL_T uvm_integral_t

`define UVM_ML_GET_ROOT(R) \
  begin \
    uvm_coreservice_t cs; \
    cs = uvm_coreservice_t::get(); \
    R = cs.get_root(); \
  end

`define UVM_ML_GET_FACTORY(F) \
  begin \
    uvm_coreservice_t cs; \
    cs = uvm_coreservice_t::get(); \
    F = cs.get_factory(); \
  end

typedef uvm_ml_ext_object_string_pool #(uvm_barrier, uvm_barrier_pool) uvm_ext_barrier_pool;
typedef uvm_ml_ext_object_string_pool #(uvm_event, uvm_event_pool)   uvm_ext_event_pool;

`else

`define UVM_ML_PACK_FIELD_ARRAY_INT_ELEMENT pack_field_element
`define UVM_ML_UNPACK_FIELD_ARRAY_INT_ELEMENT unpack_field_element 
`define UVM_ML_INTEGRAL_T logic[63:0]

`define UVM_ML_GET_ROOT(R) R= `uvm_ovm_(root)::get();
`define UVM_ML_GET_FACTORY(F) F= `uvm_ovm_(factory)::get();

typedef uvm_barrier_pool uvm_ext_barrier_pool;
typedef uvm_event_pool uvm_ext_event_pool;

`endif
