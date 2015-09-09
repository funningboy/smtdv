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

//-----------------------------------------------------
//
// UVM-ML configuration and resource sharing facilities
//
//-----------------------------------------------------

static bit uvm_ml_in_export_notify_resource = 0;

//----------------------------------------------------------------------
// Class: uvm_ml_resource_value_notifier_base
//
//----------------------------------------------------------------------

virtual class uvm_ml_resource_value_notifier_base extends uvm_object;
  function new(string name = "");
    super.new(name);
  endfunction

  bit m_initialized;

  virtual function uvm_bitstream_t get_stream();
    uvm_report_error("RSRCGETSTREAM", 
        "function uvm_ml_resource_value_notifier_base::get_stream() not implemented");
    return 0; 
  endfunction

  virtual function uvm_object get_object();
    uvm_report_error("RSRCGETOBJ", 
        "function uvm_ml_resource_value_notifier_base::get_object() not implemented");
    return null; 
  endfunction

  virtual function string get_string();
    uvm_report_error("RSRCGETSTRING", 
        "function uvm_ml_resource_value_notifier_base::get_string() not implemented");
    return ""; 
  endfunction

  virtual function void set_stream(uvm_bitstream_t t, int bitsize, uvm_object accessor = null);
    uvm_report_error("RSRCSETSTREAM", "function uvm_ml_resource_value_notifier_base::set_stream() not implemented");
  endfunction

  virtual function void set_object(uvm_object t, uvm_object accessor = null);
    uvm_report_error("RSRCSETOBJ", "function uvm_ml_resource_value_notifier_base::set_object() not implemented");
  endfunction

  virtual function void set_string(string t, uvm_object accessor = null);
    uvm_report_error("RSRCSETSTR", "function uvm_ml_resource_value_notifier_base::set_string() not implemented");
  endfunction

  virtual function void notify(string scope, string name, string accessor_name, string action_name, string inst_name);
    uvm_report_error("RSRCNOTIFY", "function uvm_ml_resource_value_notifier_base::notify() not implemented");
  endfunction

endclass : uvm_ml_resource_value_notifier_base

//----------------------------------------------------------------------
// Class: uvm_ml_resource_value_default_notifier
//
// Implements a default mechanism for strorage and retrieval of the resource
// value if it does not need or cannot be transmitted to a callback
//----------------------------------------------------------------------

class uvm_ml_resource_value_default_notifier #(type T=int);

  typedef uvm_ml_resource_value_default_notifier#(T) this_type;

  T val;

  function T read();
    return val;
  endfunction

  function void write(T t);
    val = t;
  endfunction

endclass : uvm_ml_resource_value_default_notifier

typedef class uvm_ml_extended_singular_resource;

//----------------------------------------------------------------------
// Class: uvm_ml_resource_value_holder_base;
//
// Base class implementation of a resource value holder object
//----------------------------------------------------------------------

virtual class uvm_ml_resource_value_holder_base;

  uvm_ml_resource_value_notifier_base value_notifier;

  uvm_resource_base this_resource_kind_type_handle;

  extern static function uvm_resource_base get_resource_of_bitstream_t_type();

  extern static function uvm_resource_base get_resource_of_uvm_object_type();

  extern static function uvm_resource_base get_resource_of_string_type();

  // Static variables are used at runtime to identify the resource value kind: 
  // integral, object, string or none of them
  static uvm_resource_base integral_resource_type_handle = get_resource_of_bitstream_t_type();

  static uvm_resource_base object_resource_type_handle = get_resource_of_uvm_object_type();

  static uvm_resource_base string_resource_type_handle = get_resource_of_string_type();

  function void notify(string scope, string name, string accessor_name, string action_name, string inst_name);
    if (value_notifier != null)
        value_notifier.notify (scope, name, accessor_name, action_name, inst_name);
  endfunction

  function void copy_from_compatible_base(uvm_ml_resource_value_holder_base base_holder);

    this_resource_kind_type_handle = base_holder.this_resource_kind_type_handle; // Must assign
                                                                                 // because kind_type_handle of
                                                                                 // objects in null upon
                                                                                 // construction
    value_notifier = base_holder.value_notifier;
    
  endfunction : copy_from_compatible_base

endclass : uvm_ml_resource_value_holder_base

typedef class uvm_ml_resource_value_string_notifier;
typedef class uvm_ml_resource_value_integral_notifier;
typedef class uvm_ml_resource_value_object_notifier;

//----------------------------------------------------------------------
// Class: uvm_ml_resource_value_holder #(T)
//
// Parameterized resource value holder
//----------------------------------------------------------------------

class uvm_ml_resource_value_holder #(type T=int) extends uvm_ml_resource_value_holder_base;

  typedef uvm_ml_resource_value_holder#(T) this_type;

  uvm_ml_resource_value_default_notifier #(T) default_notifier;

  function new();

    T t;

    if (uvm_resource_options::is_notifying()) begin
      string tmp_string;
      if ($typename(T) == "string" 
`ifndef QUESTA
        && ($cast(tmp_string, t) == 1)
`endif
      ) begin
        value_notifier = uvm_ml_resource_value_string_notifier::type_id::create("value_notifier");
        this_resource_kind_type_handle = string_resource_type_handle;
      end
      else begin
        uvm_bitstream_t tmp;
        if ($cast(tmp, t) == 1) begin
          value_notifier = uvm_ml_resource_value_integral_notifier::type_id::create("value_notifier");
          this_resource_kind_type_handle = integral_resource_type_handle;
        end
        // We cannot deduct whether a type is a uvm_object at this point without an actual value
      end
    end
    else    
      default_notifier = new;
  endfunction

  function T read();

    T res;

    if (default_notifier != null)
      res = default_notifier.read();
    else begin
      if (this_resource_kind_type_handle == integral_resource_type_handle)
        $cast(res, value_notifier.get_stream());
      else if (this_resource_kind_type_handle == object_resource_type_handle)
        $cast(res, value_notifier.get_object());
`ifndef QUESTA
      else if (this_resource_kind_type_handle == string_resource_type_handle)
        $cast(res, value_notifier.get_string());
`endif
      // else means read() was called before write - so simply return the initial type value in res
    end
    return res;
  endfunction

  function void write(uvm_resource_base rsrc, T t, uvm_object accessor = null);

    if ((default_notifier == null) && (this_resource_kind_type_handle == null)) begin
      // Check whether T is a uvm_object
      uvm_object tmp_object;

      if ($cast(tmp_object, t) == 1) begin
        this_resource_kind_type_handle = object_resource_type_handle;
        value_notifier = uvm_ml_resource_value_object_notifier::type_id::create("value_notifier");
      end
      else
        default_notifier = new;
    end

    if (default_notifier != null)
      default_notifier.write(t);
    else begin
      if (this_resource_kind_type_handle == integral_resource_type_handle) begin
        uvm_bitstream_t tmp;
        // Unfortunately this does not pass elaboration: int s = $bits(T);
        int s = $bits(tmp);

        $cast(tmp, t);
        value_notifier.set_stream(tmp, s, accessor);
      end
      else if (this_resource_kind_type_handle == object_resource_type_handle) begin
        uvm_object tmp_object;
        $cast(tmp_object, t);
        value_notifier.set_object(tmp_object, accessor);
      end
`ifndef QUESTA
      else if (this_resource_kind_type_handle == string_resource_type_handle) begin
        string tmp_string;
        $cast(tmp_string, t);
        value_notifier.set_string(tmp_string, accessor);
      end
`endif
      // TBD Else add an internal error
    end
  endfunction

  static function uvm_ml_resource_value_holder_base is_base_convertible(uvm_resource_base rsrc_base);

    T                              val;
    uvm_resource_base              rsrc_base_type_handle;
    uvm_ml_resource_value_holder_base ret;

    rsrc_base_type_handle = rsrc_base.get_type_handle();
    if (rsrc_base_type_handle == integral_resource_type_handle) begin
      uvm_ml_extended_singular_resource#(uvm_bitstream_t) stream_rsrc;

      if ($cast(stream_rsrc, rsrc_base)) begin
        uvm_bitstream_t tmp_stream;
        if ($cast(val, tmp_stream))
          ret = stream_rsrc.value_holder;
        else
          ret = null; // Value in the db is incompatible with uvm_bitstream_t
      end
      else ret = null; // Resource is not extended_singular (can happen if set before the db was set to use extended singular resources (e.g. before run_test)
    end
    else if (rsrc_base_type_handle == object_resource_type_handle) begin
      uvm_ml_extended_singular_resource#(uvm_object) object_rsrc;

      if ($cast(object_rsrc, rsrc_base)) begin
        uvm_object                base_val;
        base_val = object_rsrc.value_holder.read();
        if ($cast(val, base_val))
           ret = object_rsrc.value_holder;
        else ret = null; // Value in the db is of an incompatible type
      end
      else ret = null; // Resource is not extended_singular (can happen if set before the db was set to use extended singular resources (e.g. before run_test)
    end // Note that string type should provide an exact match and hence is_base_convertible should not be called

    return ret;
  endfunction : is_base_convertible

  function void copy_from_compatible_base(uvm_ml_resource_value_holder_base base_holder);
    assert (default_notifier == null); // it should not get there with a default notifier

    this_resource_kind_type_handle = base_holder.this_resource_kind_type_handle; // Must assign
                                                                                 // because kind_type_handle of
                                                                                 // objects in null upon
                                                                                 // construction
    value_notifier = base_holder.value_notifier;
    
  endfunction : copy_from_compatible_base

endclass : uvm_ml_resource_value_holder

class uvm_ml_extended_singular_resource #(type T=int) extends uvm_resource #(T);

  typedef uvm_resource#(T) this_type_base;
  typedef uvm_ml_extended_singular_resource#(T) this_type_actual;

  // Can't be rand since things like rand strings are not legal.
  // protected T val;
  uvm_ml_resource_value_holder #(T) value_holder;

  function new(string name="", scope="");
    super.new(name, scope);

    value_holder = new;
  endfunction

  virtual function string convert2string_over();
`ifdef UVM_USE_RESOURCE_CONVERTER
    void'(m_get_converter());

    return m_r2s.convert2string(value_holder.read());
`else
    return $sformatf("(%s) %0p", `uvm_typename(val), value_holder.read());
`endif
  endfunction
      
  static function this_type_base get_by_name_compatible (string scope,
                                                         string name,
                                                         bit rpterr = 1);
    uvm_resource_pool rp = uvm_resource_pool::get();
    uvm_resource_base rsrc_base;
    this_type_base    rsrc;

    rsrc_base = rp.get_by_name(scope, name, null, 0); // Find a resource of any type bearing this name
    if (rsrc_base == null) 
      return null;

    if (get_type() == rsrc_base.get_type_handle()) // exact match
      $cast(rsrc, rsrc_base);
    else if (is_base_convertible(rsrc_base, rsrc)) begin
      if (rsrc != null)
        rsrc.set_override();
      else begin
        // It is possible that the resource is a base class - set before config_db was substituted
	if ($cast(rsrc, rsrc_base) == 0) begin
          string msg;
          rsrc = null;
          if(rpterr) begin
              $sformat(msg, "Resource with name %s in scope %s in the resource database exists but has incompatible value type", name, scope);
            `uvm_warning("RSRCTYPEINC", msg);
          end
        end
      end
    end
    return rsrc;
  endfunction

  static function this_type_base get_by_name(string scope,
                                             string name,
                                             bit rpterr = 1);

    uvm_resource_pool rp = uvm_resource_pool::get();
    uvm_resource_base rsrc_base;
    this_type_base rsrc;
    string msg;

    if (uvm_resource_options::is_notifying())
      return get_by_name_compatible (scope, name, rpterr);

    rsrc_base = rp.get_by_name(scope, name, my_type, rpterr);
    if(rsrc_base == null)
      return null;

    if(!$cast(rsrc, rsrc_base)) begin
      if(rpterr) begin
        $sformat(msg, "Resource with name %s in scope %s has incorrect type", name, scope);
        `uvm_warning("RSRCTYPE", msg);
      end
      return null;
    end

    return rsrc;
    
  endfunction

  virtual function T read_over(uvm_object accessor = null);
    record_read_access(accessor);

    return value_holder.read();
  endfunction

  virtual function void write_over(T t, uvm_object accessor = null);

    if(is_read_only()) begin
      uvm_report_error("resource", $sformatf("resource %s is read only -- cannot modify", get_name()));
      return;
    end

    // Set the modified bit and record the transaction only if the value
    // has actually changed.

    if (value_holder.read() == t)
      return;

    record_write_access(accessor);

    // set the value and set the dirty bit
    value_holder.write(this, t, accessor);
    modified = 1;
  endfunction

  virtual function void notify(string scope, string name, uvm_object accessor, string action_name, string inst_name = "");
    string accessor_name;

    if (accessor != null) accessor_name = accessor.get_full_name();

    value_holder.notify(scope, name, accessor_name, action_name, inst_name);
  endfunction : notify

  static function this_type_actual refine(uvm_resource_base rsrc_base, uvm_ml_resource_value_holder_base base_holder);
    this_type_actual result;

    result = new (rsrc_base.get_name(), rsrc_base.get_scope());

    if (rsrc_base.is_read_only())
      result.set_read_only();
    else
      result.set_read_write();
    result.precedence = rsrc_base.precedence;
`ifndef UVM_VERSION_1_2
    result.m_is_regex_name = rsrc_base.m_is_regex_name;
`endif

    result.value_holder.copy_from_compatible_base(base_holder);
    return result;
  endfunction : refine

  static function bit is_base_convertible(uvm_resource_base rsrc_base, output this_type_actual rsrc);
    uvm_ml_resource_value_holder_base holder;

    holder = uvm_ml_resource_value_holder#(T)::is_base_convertible(rsrc_base);
    if (holder == null)
      return 0;
    else begin
      rsrc = refine(rsrc_base, holder);
      return 1;
    end
  endfunction : is_base_convertible

endclass : uvm_ml_extended_singular_resource

function uvm_resource_base uvm_ml_resource_value_holder_base::get_resource_of_bitstream_t_type();
  return uvm_resource#(uvm_bitstream_t)::get_type();
endfunction

function uvm_resource_base uvm_ml_resource_value_holder_base::get_resource_of_uvm_object_type();
  return uvm_resource#(uvm_object)::get_type();
endfunction

function uvm_resource_base uvm_ml_resource_value_holder_base::get_resource_of_string_type();
  return uvm_resource#(string)::get_type();
endfunction

// --------------------------

// Temporary implementation till some simulators do not support $cast for strings

class uvm_ml_extended_string_resource_value_holder extends uvm_ml_resource_value_holder_base;

  uvm_ml_resource_value_default_notifier #(string) default_notifier;

  function new();

    string t;

    if (uvm_resource_options::is_notifying()) begin
      value_notifier = uvm_ml_resource_value_string_notifier::type_id::create("value_notifier");
      this_resource_kind_type_handle = string_resource_type_handle;
    end
    else    
      default_notifier = new;
  endfunction

  function string read();

    string res;

    if (default_notifier != null)
      res = default_notifier.read();
    else
      res = value_notifier.get_string();

    return res;
  endfunction

  function void write(uvm_resource_base rsrc, string t, uvm_object accessor = null);

    if (default_notifier != null)
      default_notifier.write(t);
    else
      value_notifier.set_string(t, accessor);
  endfunction

endclass : uvm_ml_extended_string_resource_value_holder


class uvm_ml_extended_string_resource extends uvm_resource #(string);

  typedef uvm_resource#(string) this_type_base;

  // Can't be rand since things like rand strings are not legal.
  uvm_ml_extended_string_resource_value_holder value_holder;

  function new(string name="", scope="");
    super.new(name, scope);

    value_holder = new;
  endfunction

  virtual function string convert2string_over();
`ifdef UVM_USE_RESOURCE_CONVERTER
    void'(m_get_converter());

    return m_r2s.convert2string(value_holder.read());
`else
    return $sformatf("(%s) %0p", `uvm_typename(val), value_holder.read());
`endif
  endfunction
      
  static function this_type_base get_by_name_compatible (string scope,
                                                         string name,
                                                         bit rpterr = 1);
    uvm_resource_pool rp = uvm_resource_pool::get();
    uvm_resource_base rsrc_base;
    this_type_base    rsrc;

    rsrc_base = rp.get_by_name(scope, name, null, 0); // Find a resource of any type bearing this name
    if (rsrc_base == null) 
      return null;

    if (get_type() == rsrc_base.get_type_handle()) // for strings - exact match only
      $cast(rsrc, rsrc_base);

    return rsrc;
  endfunction

  static function this_type_base get_by_name(string scope,
                                             string name,
                                             bit rpterr = 1);

    uvm_resource_pool rp = uvm_resource_pool::get();
    uvm_resource_base rsrc_base;
    this_type_base rsrc;
    string msg;

    if (uvm_resource_options::is_notifying())
      return get_by_name_compatible (scope, name, rpterr);

    rsrc_base = rp.get_by_name(scope, name, my_type, rpterr);
    if(rsrc_base == null)
      return null;

    if(!$cast(rsrc, rsrc_base)) begin
      if(rpterr) begin
        $sformat(msg, "Resource with name %s in scope %s has incorrect type", name, scope);
        `uvm_warning("RSRCTYPE", msg);
      end
      return null;
    end

    return rsrc;    
  endfunction

  virtual function string read_over(uvm_object accessor = null);
    record_read_access(accessor);
    return value_holder.read();
  endfunction

  virtual function void write_over(string t, uvm_object accessor = null);

    if(is_read_only()) begin
      uvm_report_error("resource", $sformatf("resource %s is read only -- cannot modify", get_name()));
      return;
    end

    // Set the modified bit and record the transaction only if the value
    // has actually changed.

    if (value_holder.read() == t)
      return;

    record_write_access(accessor);

    // set the value and set the dirty bit
    value_holder.write(this, t, accessor);

    modified = 1;
  endfunction

  virtual function void notify(string scope, string name, uvm_object accessor, string action_name, string inst_name = "");
    string accessor_name;

    if (accessor != null) accessor_name = accessor.get_full_name();

    value_holder.notify(scope, name, accessor_name, action_name, inst_name);
  endfunction : notify

endclass : uvm_ml_extended_string_resource

////////////////////////////////////////////////////////////////////////

class m_uvm_ml_resource_notifier;
    `STREAM_T stream;
    int stream_size;

    static function uvm_ml_resource_notify_action_e resource_action_name_to_enum(string action_name);
        uvm_ml_resource_notify_action_e action_kind;

        case (action_name)
            "RESOURCE_SET": action_kind = UVM_ML_RESOURCE_SET;
            "RESOURCE_SET_DEFAULT": action_kind = UVM_ML_RESOURCE_SET;
            "RESOURCE_SET_OVERRIDE": action_kind = UVM_ML_RESOURCE_SET_OVERRIDE;
            "RESOURCE_SET_OVERRIDE_NAME": action_kind = UVM_ML_RESOURCE_SET_OVERRIDE_NAME;
            "RESOURCE_WRITE_BY_NAME": action_kind = UVM_ML_RESOURCE_WRITE_BY_NAME;
            "CONFIG_SET": action_kind = UVM_ML_CONFIG_SET;
        endcase
        return action_kind;
    endfunction : resource_action_name_to_enum

    virtual function void notify(string scope, string name, string accessor_name, string action_name, string inst_name);

        if ((uvm_ml_in_export_notify_resource == 0) // Do not send back the notification received from the backplane
            && (stream_size != -1))                 // The value was serialized successfully
        begin 
            if (action_name == "CONFIG_SET") begin
                uvm_ml_notify_config(scope, inst_name, name, stream_size, stream);
            end
            else begin
                uvm_ml_resource_notify_action_e action_kind;

                action_kind = resource_action_name_to_enum(action_name);
                uvm_ml_notify_resource(action_kind, scope, name, accessor_name, stream_size, stream);
            end
        end
    endfunction : notify
endclass : m_uvm_ml_resource_notifier

// /////////////////////////////////////////
//
// Resource integral value processing class
//
// /////////////////////////////////////////

class uvm_ml_resource_value_integral_notifier extends uvm_ml_resource_value_notifier_base;

  m_uvm_ml_resource_notifier m_notifier;

  function new(string name = "");
    super.new(name);
    m_notifier = new;
  endfunction : new

  `uvm_object_utils (uvm_ml_resource_value_integral_notifier)

  uvm_bitstream_t val;

  virtual function uvm_bitstream_t get_stream();
    if (m_initialized == 0)
        set_stream(val, $bits(val));
    return val; 
  endfunction : get_stream

  virtual function uvm_object get_object();
    assert (0); // Should not get here
    return null;
  endfunction : get_object

  virtual function string get_string();
    assert (0); // Should not get here
    return "";
  endfunction  : get_string

  virtual function void set_stream(uvm_bitstream_t t, int bitsize, uvm_object accessor = null);

    int kind = uvm_ml_stream_kind_e'(UVM_ML_STREAM_RAW);
    int kind2 = 'hffff;

    val = t;
    m_initialized = 1;
    
    m_notifier.stream = { val, kind};

    for (int i = $bits(val) + $bits(kind); i < $bits(m_notifier.stream); i++)
        m_notifier.stream[i] = 0;

    m_notifier.stream_size = bitsize + 32;

  endfunction : set_stream

  virtual function void set_object(uvm_object t, uvm_object accessor = null);
    assert (0); // Should not get here
  endfunction : set_object

  virtual function void set_string(string t, uvm_object accessor = null);
    assert (0); // Should not get here
  endfunction : set_string

  virtual function void notify(string scope, string name, string accessor_name, string action_name, string inst_name);

     m_notifier.notify(scope, name, accessor_name, action_name, inst_name);
  endfunction : notify
endclass : uvm_ml_resource_value_integral_notifier

// ///////////////////////////////////////////
//
// Resource uvm_object value processing class
//
// ///////////////////////////////////////////

class uvm_ml_resource_value_object_notifier extends uvm_ml_resource_value_notifier_base;

  m_uvm_ml_resource_notifier m_notifier;

  function new(string name = "");
    super.new(name);
    m_notifier = new;
  endfunction : new

  `uvm_object_utils (uvm_ml_resource_value_object_notifier)

  uvm_object val;

  virtual function uvm_bitstream_t get_stream();
    assert (0); // Should not get here
    return 0;
  endfunction : get_stream

  virtual function uvm_object get_object();
    if (m_initialized == 0)
      set_object(val);
    return val;
  endfunction : get_object

  virtual function string get_string();
    assert (0); // Should not get here
    return "";
  endfunction : get_string

  virtual function void set_stream(uvm_bitstream_t t, int bitsize, uvm_object accessor = null);
    assert (0); // Should not get here
  endfunction : set_stream

  virtual function void set_object(uvm_object t, uvm_object accessor = null);
    m_initialized = 1;
    val = t;
    if (t.get_object_type() != null)
      m_notifier.stream_size = uvm_ml_serialization_kit::pack_cur_stream(val, m_notifier.stream);
    else
      // The object cannot be serialzied because it has no uvm_object_utils
      m_notifier.stream_size = -1;
  endfunction : set_object

  virtual function void set_string(string t, uvm_object accessor = null);
    assert (0); // Should not get here
  endfunction : set_string

  virtual function void notify(string scope, string name, string accessor_name, string action_name, string inst_name);
     m_notifier.notify(scope, name, accessor_name, action_name, inst_name);
  endfunction : notify
endclass : uvm_ml_resource_value_object_notifier

// /////////////////////////////////////////
//
// Resource string value processing class
//
// /////////////////////////////////////////

class uvm_ml_resource_value_string_notifier extends uvm_ml_resource_value_notifier_base;

  m_uvm_ml_resource_notifier m_notifier;

  function new(string name = "");
    super.new(name);
    m_notifier = new;
  endfunction : new

  `uvm_object_utils (uvm_ml_resource_value_string_notifier)

  string val;

  virtual function uvm_bitstream_t get_stream();
    assert (0); // Should not get here
    return 0;
  endfunction : get_stream

  virtual function uvm_object get_object();
    assert (0); // Should not get here
    return null;
  endfunction : get_object

  virtual function string get_string();
    if (m_initialized == 0)
        set_string(val);
    return val;
  endfunction : get_string

  virtual function void set_stream(uvm_bitstream_t t, int bitsize, uvm_object accessor = null);
    assert (0); // Should not get here
  endfunction : set_stream

  virtual function void set_object(uvm_object t, uvm_object accessor = null);
    assert (0); // Should not get here
  endfunction : set_object

  virtual function void set_string(string t, uvm_object accessor = null);
    m_initialized = 1;
    val = t;

    m_notifier.stream_size = uvm_ml_serialization_kit::pack_top_string(val, m_notifier.stream);
  endfunction : set_string

  virtual function void notify(string scope, string name, string accessor_name, string action_name, string inst_name);
    m_notifier.notify(scope, name, accessor_name, action_name, inst_name);
  endfunction : notify

endclass : uvm_ml_resource_value_string_notifier

typedef class uvm_ml_resource_db_caller;

typedef class uvm_ml_resource_db_set_caller;
typedef class uvm_ml_resource_db_set_default_caller;
typedef class uvm_ml_resource_db_set_override_caller;
typedef class uvm_ml_resource_db_set_override_name_caller;
typedef class uvm_ml_resource_db_write_by_name_caller;
typedef class uvm_ml_resource_db_config_set_caller;

// /////////////////////////////////////////////////
//
// Virtual base clss uvm_ml_resource_db_caller #(T, CONFIG_DB_T)
//
// /////////////////////////////////////////////////
  
`define UVM_ML_CONFIG_DB_IMPLEMENTATION_T uvm_config_db_implementation_t#(T)

virtual class uvm_ml_resource_db_caller #(type T = uvm_bitstream_t, type CONFIG_DB_T = `UVM_ML_CONFIG_DB_IMPLEMENTATION_T);

    static uvm_ml_resource_db_caller#(T, CONFIG_DB_T)  m_resource_db_callers[uvm_ml_resource_notify_action_e];

    static bit initialized;

    extern static function void initialize();

    static function uvm_ml_resource_db_caller#(T, CONFIG_DB_T) get_caller(uvm_ml_resource_notify_action_e action);
        if (!initialized) initialize();
        return m_resource_db_callers[action];
    endfunction

    pure virtual function bit call_db(string       scope,
                                      string       name,
                                      T            val,
                                      string       accessor_name);
endclass : uvm_ml_resource_db_caller

// ///////////////////////////////////
//
// uvm_ml_resource_db_set_caller #(T)
//
// ///////////////////////////////////
  
class uvm_ml_resource_db_set_caller #(type T = uvm_bitstream_t, type CONFIG_DB_T = uvm_config_db#(T)) extends uvm_ml_resource_db_caller #(T, CONFIG_DB_T);

    typedef uvm_ml_resource_db_set_caller #(T, CONFIG_DB_T) this_type;

    static this_type m_caller;

    static function uvm_ml_resource_db_caller #(T, CONFIG_DB_T) get();
        if (m_caller == null)
            m_caller = new;
        return m_caller;
    endfunction

    virtual function bit call_db(string       scope,
                                 string       name,
                                 T            val,
                                 string       accessor_name);
        uvm_ml_accessor_proxy_t accessor;

        `UVM_ML_TRACE_ACCESSOR_PROXY_OBJECT(accessor,accessor_name)

        uvm_resource_db#(T)::set(scope, name, val, accessor);
        return 1;
    endfunction   
endclass : uvm_ml_resource_db_set_caller

// ///////////////////////////////////////////
//
// uvm_ml_resource_db_set_default_caller #(T)
//
// ///////////////////////////////////////////
  
class uvm_ml_resource_db_set_default_caller #(type T = uvm_bitstream_t, type CONFIG_DB_T = `UVM_ML_CONFIG_DB_IMPLEMENTATION_T) extends uvm_ml_resource_db_caller #(T, CONFIG_DB_T);

    typedef uvm_ml_resource_db_set_default_caller #(T, CONFIG_DB_T) this_type;

    static this_type m_caller;

    static function uvm_ml_resource_db_caller #(T, CONFIG_DB_T) get();
        if (m_caller == null)
            m_caller = new;
        return m_caller;
    endfunction

    virtual function bit call_db(string       scope,
                                 string       name,
                                 T            val,
                                 string       accessor_name);

        void'(uvm_resource_db#(T)::set_default(scope, name));
        return 1;
    endfunction  
endclass : uvm_ml_resource_db_set_default_caller

// ////////////////////////////////////////////
//
// uvm_ml_resource_db_set_override_caller #(T)
//
// ////////////////////////////////////////////
  
class uvm_ml_resource_db_set_override_caller #(type T = uvm_bitstream_t, type CONFIG_DB_T = `UVM_ML_CONFIG_DB_IMPLEMENTATION_T) extends uvm_ml_resource_db_caller #(T, CONFIG_DB_T);

    typedef uvm_ml_resource_db_set_override_caller #(T, CONFIG_DB_T) this_type;

    static this_type m_caller;

    static function uvm_ml_resource_db_caller #(T, CONFIG_DB_T) get();
        if (m_caller == null)
            m_caller = new;
        return m_caller;
    endfunction

    virtual function bit call_db(string       scope,
                                 string       name,
                                 T            val,
                                 string       accessor_name);
        uvm_ml_accessor_proxy_t accessor;

        `UVM_ML_TRACE_ACCESSOR_PROXY_OBJECT(accessor,accessor_name)

        uvm_resource_db#(T)::set_override(scope, name, val, accessor);
        return 1;
    endfunction   
endclass : uvm_ml_resource_db_set_override_caller

// /////////////////////////////////////////////////
//
// uvm_ml_resource_db_set_override_name_caller #(T, CONFIG_DB_T)
//
// /////////////////////////////////////////////////
  
class uvm_ml_resource_db_set_override_name_caller #(type T = uvm_bitstream_t, type CONFIG_DB_T = `UVM_ML_CONFIG_DB_IMPLEMENTATION_T) extends uvm_ml_resource_db_caller #(T, CONFIG_DB_T);

    typedef uvm_ml_resource_db_set_override_name_caller #(T, CONFIG_DB_T) this_type;

    static this_type m_caller;

    static function uvm_ml_resource_db_caller #(T, CONFIG_DB_T) get();
        if (m_caller == null)
            m_caller = new;
        return m_caller;
    endfunction

    virtual function bit call_db(string       scope,
                                 string       name,
                                 T            val,
                                 string       accessor_name);
        uvm_ml_accessor_proxy_t accessor;

        `UVM_ML_TRACE_ACCESSOR_PROXY_OBJECT(accessor,accessor_name)

        uvm_resource_db#(T)::set_override_name(scope, name, val, accessor);
        return 1;
    endfunction
endclass : uvm_ml_resource_db_set_override_name_caller

// /////////////////////////////////////////////
//
// uvm_ml_resource_db_write_by_name_caller #(T, CONFIG_DB_T)
//
// /////////////////////////////////////////////
  
class uvm_ml_resource_db_write_by_name_caller #(type T = uvm_bitstream_t, type CONFIG_DB_T = `UVM_ML_CONFIG_DB_IMPLEMENTATION_T) extends uvm_ml_resource_db_caller #(T, CONFIG_DB_T);

    typedef uvm_ml_resource_db_write_by_name_caller #(T, CONFIG_DB_T) this_type;

    static this_type m_caller;

    static function uvm_ml_resource_db_caller #(T, CONFIG_DB_T) get();
        if (m_caller == null)
            m_caller = new;
        return m_caller;
    endfunction

    virtual function bit call_db(string       scope,
                                 string       name,
                                 T            val,
                                 string       accessor_name);
        uvm_ml_accessor_proxy_t accessor;

        `UVM_ML_TRACE_ACCESSOR_PROXY_OBJECT(accessor,accessor_name)

        return uvm_resource_db#(T)::write_by_name(scope, name, val, accessor);
    endfunction
endclass : uvm_ml_resource_db_write_by_name_caller

// ///////////////////////////////////////////
//
// uvm_ml_resource_db_config_set_caller #(T, CONFIG_DB_T)
//
// ///////////////////////////////////////////
  
class uvm_ml_resource_db_config_set_caller #(type T = uvm_bitstream_t, type CONFIG_DB_T = `UVM_ML_CONFIG_DB_IMPLEMENTATION_T) extends uvm_ml_resource_db_caller #(T, CONFIG_DB_T);

    typedef uvm_ml_resource_db_config_set_caller #(T, CONFIG_DB_T) this_type;

    static this_type m_caller;

    static function uvm_ml_resource_db_caller #(T, CONFIG_DB_T) get();
        if (m_caller == null)
            m_caller = new;
        return m_caller;
    endfunction

    virtual function bit call_db(string       scope,
                                 string       name,
                                 T            val,
                                 string       accessor_name);
        uvm_ml_accessor_proxy_t accessor;
        uvm_config_db_implementation_t #(T) imp = uvm_config_db_implementation_t #(T)::get_imp();
        int depth = 1;

        foreach(accessor_name[i])
            if (accessor_name[i] == ".") ++depth;

        // We rely on export_notify_config() that scope was already concatenated from cntxt and instance_name

        `UVM_ML_TRACE_ACCESSOR_PROXY_OBJECT(accessor, accessor_name);
        imp.set_value("", scope, name, val, depth, accessor);

        return 1;
    endfunction
endclass : uvm_ml_resource_db_config_set_caller

function void uvm_ml_resource_db_caller::initialize();

    m_resource_db_callers[UVM_ML_RESOURCE_SET] = uvm_ml_resource_db_set_caller#(T, CONFIG_DB_T)::get();
    m_resource_db_callers[UVM_ML_RESOURCE_SET_DEFAULT] = uvm_ml_resource_db_set_default_caller#(T, CONFIG_DB_T)::get();
    m_resource_db_callers[UVM_ML_RESOURCE_SET_OVERRIDE] = uvm_ml_resource_db_set_override_caller#(T, CONFIG_DB_T)::get();
    m_resource_db_callers[UVM_ML_RESOURCE_SET_OVERRIDE_NAME] = uvm_ml_resource_db_set_override_name_caller#(T, CONFIG_DB_T)::get();
    m_resource_db_callers[UVM_ML_RESOURCE_WRITE_BY_NAME] = uvm_ml_resource_db_write_by_name_caller#(T, CONFIG_DB_T)::get();
    m_resource_db_callers[UVM_ML_CONFIG_SET] = uvm_ml_resource_db_config_set_caller#(T, CONFIG_DB_T)::get();

    initialized = 1;
endfunction

class uvm_ml_singular_config_db_implementation_t #(type T=int) extends uvm_config_db_implementation_t #(T);
//  function new (string name = "uvm_ml_config_db_implementation_t #(T)");
  function new (string name = "");
  endfunction : new

  `uvm_object_param_utils(uvm_ml_singular_config_db_implementation_t #(T))

  virtual function bit get_value (uvm_component     cntxt,
                                  string            inst_name,
                                  string            field_name,
                                  inout T           value);

    uvm_resource_pool                     rp = uvm_resource_pool::get();
    uvm_resource_base                     rsrc_base;
    uvm_resource_types::rsrc_q_t          rq;
    uvm_ml_extended_singular_resource#(T) r;
    uvm_resource #(T)                     r_ne;
    bit                                   result;

    // Base class's (uvm_config_db_implementation_t) method needs to be re-written and cannot be reused
    // because of the following:
    // 1. The resource with the given name can be legally located in a pool of resources with the different type
    //    (e.g. int value could be passed as uvm_bitstream_t)
    // 2. Need to find a resource with the highest priority in the resource pool and not in a static method 
    //    uvm_resource#(T)::get_highest_precedence()
    // 3. Look for a resource of any type with same names (see lookup_regex_names(inst_name, field_name, null)
    // 4. Check if the resource that was found can be cast to the resource of the requested type.
    //    If yes - OK

    if(cntxt == null) 
      cntxt = uvm_root::get();
    if(inst_name == "") 
      inst_name = cntxt.get_full_name();
    else if(cntxt.get_full_name() != "") 
      inst_name = {cntxt.get_full_name(), ".", inst_name};
 
    rq = rp.lookup_regex_names(inst_name, field_name, null);

    rsrc_base = rp.get_highest_precedence(rq);

    if (rsrc_base == null) begin
      if(uvm_config_db_options::is_tracing())
        m_show_msg("CFGDB/GET", "Configuration","read", inst_name, field_name, cntxt, null);

      return 0;
    end
    else if ($cast(r, rsrc_base) == 0) begin // not the extended_singular_resource of the given type
      if (rsrc_base.get_type_handle() == 
           uvm_ml_extended_singular_resource#(uvm_config_object_wrapper)::get_type()) 
      // predefined class uvm_config_object_wrapper is handled separately because it is used internally in UVM
      begin
        uvm_resource#(uvm_config_object_wrapper) rcow;
        uvm_config_object_wrapper                cow;
        int                                      cast_res;

        $cast(rcow, rsrc_base);
        cow = rcow.read();

        if(uvm_config_db_options::is_tracing()) begin
          $cast(r_ne, rcow);
          m_show_msg("CFGDB/GET", "Configuration","read", inst_name, field_name, cntxt, r_ne);
        end
        cast_res = $cast(value, cow.obj);

        if(uvm_config_db_options::is_tracing()) begin
          string msg=`uvm_typename(value);

          if (cast_res == 1)
            $sformat(msg, "%s '%s%s' (type %s) %s by %s = %0p",
                     "Configuration",inst_name, field_name=="" ? "" : {".",field_name}, msg,"read",
                     (cntxt != null) ? cntxt.get_full_name() : "<unknown>",
                     value);
          else
            $sformat(msg, "%s '%s%s' (type %s) %s by %s = %s",
                     "Configuration",inst_name, field_name=="" ? "" : {".",field_name}, msg,"read",
                     (cntxt != null) ? cntxt.get_full_name() : "<unknown>",
                     "null (failed type casting)");

        `uvm_info("CFGDB/GET", msg, UVM_LOW)
        end

        return (cast_res == 1);
      end else if (uvm_ml_extended_singular_resource#(T)::is_base_convertible(rsrc_base, r) == 1)
          r.set_override();
    end

    if (r != null) // Resource found in the pool is extended_singular (set in SV) or is_base_convertible (can happen if set from ML)
    begin
      value = r.read(cntxt);
      r_ne = r;
      result = 1;
    end
    else if ($cast(r_ne, rsrc_base) != 0) // Can happen if the resource was set before the config db
                                          // was substituted, for example, before run_test
    begin
      value = r_ne.read(cntxt);
      result = 1;
    end
    else begin
      r_ne = null;
      result = 0;
    end

    if(uvm_config_db_options::is_tracing())
      m_show_msg("CFGDB/GET", "Configuration","read", inst_name, field_name, cntxt, r_ne);
    return result;
  endfunction : get_value

  virtual function bit config_parameter_exists(uvm_component cntxt, 
                                               string        inst_name,
                                               string        field_name, 
                                               bit           rpterr);
    if(cntxt == null)
      cntxt = uvm_root::get();
    if(inst_name == "")
      inst_name = cntxt.get_full_name();
    else if(cntxt.get_full_name() != "")
      inst_name = {cntxt.get_full_name(), ".", inst_name};

    return (uvm_ml_extended_singular_resource#(T)::get_by_name(inst_name,field_name, rpterr) != null);

  endfunction : config_parameter_exists


  virtual function uvm_resource#(T) m_new_resource(string field_name,
                                                   string inst_name);
    uvm_ml_extended_singular_resource#(T) result;

    result = new(field_name, inst_name);

    return result;
  endfunction

  virtual function bit m_is_resource_base_convertible(uvm_resource_base rsrc_base, uvm_resource#(T) r);
    return uvm_ml_extended_singular_resource#(T)::is_base_convertible(rsrc_base, r);
  endfunction

  virtual function uvm_resource#(T) m_get_by_name(string inst_name,
                                                  string field_name,
                                                  bit    rpterr=1);
    return uvm_ml_extended_singular_resource#(T)::get_by_name(inst_name,field_name,rpterr);
  endfunction

  virtual function void m_notify(uvm_resource#(T) rsrc, 
                                 string           cntxt_name, 
                                 string           field_name, 
                                 uvm_object       accessor, 
                                 string           action_name, 
                                 string           inst_name);

    uvm_ml_extended_singular_resource #(T) r;

    assert ($cast(r, rsrc) == 1);

    r.notify(cntxt_name, field_name, accessor, action_name, inst_name);
  endfunction

endclass : uvm_ml_singular_config_db_implementation_t

class uvm_ml_string_config_db_implementation_t extends uvm_config_db_implementation_t #(string);
  function new (string name = "uvm_ml_config_db_implementation_t #(string)");
  endfunction : new

  `uvm_object_param_utils(uvm_ml_string_config_db_implementation_t)

  virtual function bit get_value (uvm_component     cntxt,
                                  string            inst_name,
                                  string            field_name,
                                  inout string      value);

    uvm_resource_pool            rp = uvm_resource_pool::get();
    uvm_resource_base            rsrc_base;
    uvm_resource_types::rsrc_q_t rq;
    uvm_ml_extended_string_resource r;

    if(cntxt == null) 
      cntxt = uvm_root::get();
    if(inst_name == "") 
      inst_name = cntxt.get_full_name();
    else if(cntxt.get_full_name() != "") 
      inst_name = {cntxt.get_full_name(), ".", inst_name};
 
    rq = rp.lookup_regex_names(inst_name, field_name, null);

    rsrc_base = rp.get_highest_precedence(rq);

    if ((rsrc_base == null) || ($cast(r,rsrc_base) == 0)) begin
      if(uvm_config_db_options::is_tracing())
        m_show_msg("CFGDB/GET", "Configuration","read", inst_name, field_name, cntxt, null);
      return 0;
    end

    if(uvm_config_db_options::is_tracing())
      m_show_msg("CFGDB/GET", "Configuration","read", inst_name, field_name, cntxt, r);

    value = r.read(cntxt);
    return 1;
  endfunction : get_value

  virtual function bit config_parameter_exists(uvm_component cntxt, 
                                               string        inst_name,
                                               string        field_name, 
                                               bit           rpterr);
    if(cntxt == null)
      cntxt = uvm_root::get();
    if(inst_name == "")
      inst_name = cntxt.get_full_name();
    else if(cntxt.get_full_name() != "")
      inst_name = {cntxt.get_full_name(), ".", inst_name};

    return (uvm_ml_extended_string_resource::get_by_name(inst_name,field_name, rpterr) != null);

  endfunction : config_parameter_exists


  virtual function uvm_resource#(string) m_new_resource(string field_name,
                                                        string inst_name);
    uvm_ml_extended_string_resource result;

    result = new(field_name, inst_name);

    return result;
  endfunction : m_new_resource

  virtual function bit m_is_resource_base_convertible(uvm_resource_base rsrc_base, uvm_resource#(T) r);
    return 0;
  endfunction : m_is_resource_base_convertible

  virtual function uvm_resource#(string) m_get_by_name(string inst_name,
                                                       string field_name,
                                                       bit    rpterr=1);
    return uvm_ml_extended_string_resource::get_by_name(inst_name,field_name,rpterr);
  endfunction : m_get_by_name

  virtual function void m_notify(uvm_resource#(string) rsrc, 
                                 string                cntxt_name, 
                                 string                field_name, 
                                 uvm_object            accessor, 
                                 string                action_name, 
                                 string                inst_name);

    uvm_ml_extended_string_resource r;

    assert ($cast(r, rsrc) == 1);

    r.notify(cntxt_name, field_name, accessor, action_name, inst_name);
  endfunction : m_notify

endclass : uvm_ml_string_config_db_implementation_t

`define UVM_ML_SUBSTITUTE_SINGULAR_CONFIG_DB_IMP(T) \
 uvm_config_db_implementation_t #(T)::type_id::set_type_override(uvm_ml_singular_config_db_implementation_t #(T)::get_type()); \
 uvm_config_db_implementation_t #(T)::set_imp();

function bit uvm_ml_set_resource(uvm_ml_resource_notify_action_e action,
                                 string                          scope,
                                 string                          name,
                                 string                          accessor_name,
                                 int unsigned                    stream_size,
                                 `STREAM_T                       stream);
    bit                  result;
    uvm_ml_stream_kind_e kind;

    uvm_ml_in_export_notify_resource = 1;

    kind = uvm_ml_stream_kind_e'(stream[0]);

    if (kind == UVM_ML_STREAM_STRING) begin
        string val;
        uvm_ml_resource_db_caller#(string, uvm_ml_string_config_db_implementation_t) caller_object;

        caller_object = uvm_ml_resource_db_caller#(string, uvm_ml_string_config_db_implementation_t)::get_caller(action);
        val = uvm_ml_serialization_kit::unpack_top_string(stream_size, stream);

        result = caller_object.call_db(scope, name, val, accessor_name);
    end
    else if (kind == UVM_ML_STREAM_RAW) begin
        uvm_bitstream_t val;
        int unsigned    kind_tmp;
        uvm_ml_resource_db_caller#(uvm_bitstream_t, uvm_ml_singular_config_db_implementation_t#(uvm_bitstream_t)) caller_object;

        caller_object = uvm_ml_resource_db_caller#(uvm_bitstream_t, uvm_ml_singular_config_db_implementation_t#(uvm_bitstream_t))::get_caller(action);

        assert (stream_size > $bits(kind)); // Else internal error

        {val, kind_tmp} = stream;
        kind = uvm_ml_stream_kind_e'(kind_tmp);

        for (int i = stream_size - $bits(kind); i < $bits(val); i++)
            val[i] = 0;

        result = caller_object.call_db(scope, name, val, accessor_name); // This is temporary quick solution -
                                                                         // retrieval will work only via
                                                                         // uvm_resource_db#(uvm_bitstream_t)
                                                                         // and not - via uvm_resource_db#(actual_type).
                                                                         // Later we can add an intermediate pool and
                                                                         // override the resources pool so it will
                                                                         // search in the intermediate pool first
    end
    else begin // kind == UVM_ML_STREAM_TYPED_OBJECT or null
        int unsigned stream_int_size;
        stream_int_size = stream_size/32;
        if (uvm_ml_serialization_kit::is_registered_object_type(stream_int_size, stream)) begin // STREAMSIZE: is_registered_object_type() receives size in ints
            uvm_object val;
            uvm_ml_resource_db_caller#(uvm_object, uvm_ml_singular_config_db_implementation_t#(uvm_object)) caller_object;

            val = uvm_ml_serialization_kit::unmarshall_top_object(stream_int_size, stream); // STREAMSIZE: unmarshall_top_object receives size in ints
            caller_object = uvm_ml_resource_db_caller#(uvm_object, uvm_ml_singular_config_db_implementation_t#(uvm_object))::get_caller(action);
            result = caller_object.call_db(scope, name, val, accessor_name);
        end
        else begin
            // The incoming stream is typed on the initiator side but does not match any uvm_object
            // on the UVM SV side. It may be not targeted to SV (broadcasted by the backplane) or
            // intended to be mapped to a non-uvm_object type, for example, to a SV struct. 
            // In order to support the latter, we deserialize the stream to a raw stream and keep
            // the configuration element
            
            uvm_bitstream_t val;
            int             type_id;
            int unsigned    kind_tmp;
            uvm_ml_resource_db_caller#(uvm_bitstream_t, uvm_ml_singular_config_db_implementation_t#(uvm_bitstream_t)) caller_object;
            caller_object = uvm_ml_resource_db_caller#(uvm_bitstream_t, uvm_ml_singular_config_db_implementation_t#(uvm_bitstream_t))::get_caller(action);

            assert ((stream_size) > $bits(kind)); // STREAMSIZE: Switching to bit size on the Backplane APi level
                                                  // Else internal error
            {val, type_id, kind_tmp} = stream;
            kind = uvm_ml_stream_kind_e'(kind_tmp);

            for (int i = (stream_size) - $bits(kind); i < $bits(val); i++) // STREAMSIZE
                val[i] = 0;
            result = caller_object.call_db(scope, name, val, accessor_name);        
        end
    end
    uvm_ml_in_export_notify_resource = 0;
    return result;
endfunction : uvm_ml_set_resource

