//------------------------------------------------------------------------------
//   Copyright 2007-2009 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the "License"); you may not
//   use this file except in compliance with the License.  You may obtain a copy
//   of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//   WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//   License for the specific language governing permissions and limitations
//   under the License.
//------------------------------------------------------------------------------

/*typedef enum {
  UVM_PORT ,
  UVM_EXPORT ,
  UVM_IMPLEMENTATION
} uvm_port_type_e;*/

typedef class uvm_external_connector;

//
// ----------------------------------------------------------------------------
// Classes added to support external TLM communication
// ----------------------------------------------------------------------------
//

class tlm_event;
  event trigger;
endclass

//------------------------------------------------------------------------------
//
// CLASS: uvm_if_base_abstract
//
//------------------------------------------------------------------------------
// uvm_if_base_abstract is an abstract base class for any standardized (TLM) interface
// All the port and export classes inherit from uvm_if_base_abstract.
// uvm_if_base_abstract's defines, among others, virtual functions and tasks that operate 
// with generic transactions of uvm_object type
// The base connector class has a member function that returns the generic interface
// this connector is asscoiated with
// 
//------------------------------------------------------------------------------

virtual class uvm_if_base_abstract extends uvm_report_object;

// This class is abstract, hence its functions and tasks should not be called. Otherwise it is an error 

  virtual function bit is_port ();
    $display("In uvm_if_base_abstract::is_port");
  endfunction

  virtual function bit is_export ();
    $display("In uvm_if_base_abstract::is_export");
  endfunction

  virtual function bit is_imp ();
    $display("In uvm_if_base_abstract::is_imp");
  endfunction

  virtual function uvm_port_type_e get_port_type ();
    get_port_type = is_port() ? UVM_PORT : (is_export() ? UVM_EXPORT : UVM_IMPLEMENTATION);
  endfunction

  virtual task put_object (input uvm_object tr);
    $display("In uvm_if_base_abstract::put_object");
  endtask

  virtual task get_object (output uvm_object tr);
    $display("In uvm_if_base_abstract::get_object");
  endtask

  virtual task peek_object (output uvm_object tr);
    $display("In uvm_if_base_abstract::peek_object");
  endtask

  virtual function bit try_put_object (uvm_object tr);
    $display("In uvm_if_base_abstract::try_put_object");
    return 1;
  endfunction

  virtual function bit can_put ();
    $display("In uvm_if_base_abstract::can_put");
    return 1;
  endfunction

  virtual function tlm_event ok_to_put();
    $display("In uvm_if_base_abstract::ok_to_put");
  endfunction

  virtual function bit try_get_object (output uvm_object tr);
    $display("In uvm_if_base_abstract::try_get_object");
    return 1;
  endfunction

  virtual function bit can_get ();
    $display("In uvm_if_base_abstract::can_get");
    return 1;
  endfunction

  virtual function bit try_peek_object (output uvm_object tr);
    $display("In uvm_if_base_abstract::try_peek_object");
    return 1;
  endfunction

  virtual function bit can_peek ();
    $display("In uvm_if_base_abstract::can_peek");
    return 1;
  endfunction

  virtual task transport_object (input uvm_object req, output uvm_object rsp);
    $display("In uvm_if_base_abstract::transport");
  endtask

  virtual function bit nb_transport_object (input uvm_object req, output uvm_object rsp);
    $display("In uvm_if_base_abstract::nb_transport");
  endfunction

  virtual function void write_object (input uvm_object tr);
    $display("In uvm_if_base_abstract::write_object");
  endfunction

  // More virtual functions TBD

  virtual function void connect_external(uvm_external_connector connector, string external_path = "");
    $display("In uvm_if_base_abstract::connect_external");
  endfunction

endclass

//------------------------------------------------------------------------------
//
// CLASS: uvm_external_connector
//
//------------------------------------------------------------------------------
// uvm_external_connector is an abstract base class for implementation of 
// mixed-language ports. The actual member functions should be implemented in
// a non-abstract class which inherits from uvm_external_connector
// 
//------------------------------------------------------------------------------

virtual class uvm_external_connector;

  virtual function int unsigned size();
    return 0;
  endfunction

  virtual function void inc_size();
    return; // Meantime we don't support multiple binding
  endfunction

  virtual function void set_port_data(string port_full_name, int unsigned port_if_mask, string external_path, uvm_port_type_e port_type);
    return;
  endfunction

  virtual function void resolve_bindings();
  endfunction

  virtual function string get_type_name();
    return "uvm_external_connector";
  endfunction

  virtual function bit is_external_producer();
    return 0;
  endfunction

  virtual function bit try_put(input uvm_object obj);
    $display("In uvm_external_connector::try_put");
  endfunction

  virtual function bit can_put();
    $display("In uvm_external_connector::can_put");
  endfunction

  virtual function tlm_event ok_to_put();
    $display("In uvm_external_connector::ok_to_put");
  endfunction

  virtual function bit try_get(output uvm_object obj);
    $display("In uvm_external_connector::try_get");
  endfunction

  virtual function bit can_get();
    $display("In uvm_external_connector::can_get");
  endfunction

  virtual task put(input uvm_object obj);
    $display("In uvm_external_connector::put");
  endtask

  virtual task get(output uvm_object obj);
    $display("In uvm_external_connector::get");
  endtask

  virtual task peek(output uvm_object obj);
    $display("In uvm_external_connector::peek");
  endtask

  virtual function bit try_peek(output uvm_object obj);
    $display("In uvm_external_connector::try_peek");
  endfunction

  virtual function bit can_peek();
    $display("In uvm_external_connector::can_peek");
  endfunction

  virtual function void write( input uvm_object obj );
    $display("In uvm_external_connector::write");
  endfunction

  virtual task transport(input uvm_object req, output uvm_object rsp);
    $display("In uvm_external_connector::transport");
  endtask

  virtual function bit nb_transport( input uvm_object req, output uvm_object rsp);
    $display("In uvm_external_connector::nb_transport");
  endfunction

  // More interface functions and tasks TBD

  virtual function void set_T1_name(string T1_type_name);
    $display("In uvm_external_connector::set_T1_name");
  endfunction

  virtual function void set_T2_name(string T2_type_name);
    $display("In uvm_external_connector::set_T2_name");
  endfunction

  virtual function void set_export_if(uvm_if_base_abstract eif);
  endfunction

  virtual function uvm_external_connector resolve(uvm_if_base_abstract port_base_if, uvm_if_base_abstract eif);
    uvm_external_connector external_connector_for_redirection;
    if (is_external_producer()) begin
      external_connector_for_redirection = this;
      if (eif != null) // If it is an export which is also an external producer
        set_export_if(eif);
    end
    else begin
      if (port_base_if.is_port()) begin
        // Port is hierarchically connected to a source port
        set_export_if(port_base_if);
//        external_connector_for_redirection = this;
        external_connector_for_redirection = null;
      end
      else begin
        set_export_if(eif);
        external_connector_for_redirection = null;
      end
    end
    return external_connector_for_redirection;
  endfunction

  virtual function uvm_if_base_abstract get_export_if();
  endfunction

endclass

