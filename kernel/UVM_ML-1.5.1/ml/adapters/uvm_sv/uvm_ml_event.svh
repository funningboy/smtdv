//----------------------------------------------------------------------
//   Copyright 2014 Advanced Micro Devices Inc.
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
// UVM-ML event facilities
//
//-----------------------------------------------------

// /////////////////////////////////////////
//
// ML event class
//
// /////////////////////////////////////////

typedef class uvm_ml_event_pool;

class uvm_ml_event extends uvm_event;

  local uvm_ml_event_pool m_pool = null;

  function new(string name="");
    super.new(name);
  endfunction

  virtual function void set_pool(uvm_ml_event_pool pool);
    m_pool = pool;
  endfunction

  virtual function void trigger_without_bp_notification (uvm_object data=null);
    super.trigger(data);
  endfunction

  virtual function void trigger (uvm_object data=null);
    trigger_without_bp_notification(data);
    notify_ml_event(UVM_ML_EVENT_TRIGGER, data);
  endfunction

  virtual function void reset_without_bp_notification (bit wakeup=0);
    super.reset(wakeup);
  endfunction

  virtual function void reset (bit wakeup=0);
    reset_without_bp_notification(wakeup);
    notify_ml_event(UVM_ML_EVENT_RESET);
  endfunction

  virtual function void cancel_without_bp_notification ();
    super.cancel();
  endfunction

  virtual function void cancel ();
    cancel_without_bp_notification();
    notify_ml_event(UVM_ML_EVENT_CANCEL);
  endfunction

  virtual function uvm_object create(string name="");
    uvm_ml_event v;
    v=new(name);
    return v;
  endfunction

  static function void notify_event_by_name(string                       scope_name,
                                            string                       event_name,
                                            uvm_ml_event_notify_action_e action,
                                            int unsigned                 stream_size,
                                            `STREAM_T                    stream);
    uvm_ml_event_pool pool;
    uvm_ml_event e;
    uvm_object obj;

    if (!$cast(pool, uvm_ext_event_pool::get_pool(scope_name))) begin
      string msg;
      msg = {"cannot get a pool with type uvm_ml_event_pool"};
      uvm_report_fatal("MLEPOOLGET", msg, UVM_NONE);
    end
    if (pool.exists(event_name)) begin

      if (action == UVM_ML_EVENT_DELETE) begin
        pool.delete_without_bp_notification(event_name);
        return;
      end

    end

    if (!$cast(e, pool.get(event_name))) begin
      string msg;
      msg = {"cannot get an event with type uvm_ml_event"};
      uvm_report_fatal("MLEPOOLGET", msg, UVM_NONE);
    end

    case (action)
      UVM_ML_EVENT_NEW : ;
      UVM_ML_EVENT_TRIGGER : begin
        obj = uvm_ml_serialization_kit::unmarshall_top_object(stream_size, stream);
        e.trigger_without_bp_notification(obj);
      end
      UVM_ML_EVENT_RESET : e.reset_without_bp_notification(0); // systemc has no wakeup parammeters
      UVM_ML_EVENT_CANCEL : e.cancel_without_bp_notification();
    endcase

  endfunction

  function void notify_ml_event(uvm_ml_event_notify_action_e action, uvm_object data=null);
    // notify backplane
    int unsigned stream_size;
    `STREAM_T    stream;
    if (m_pool == null) begin
      uvm_report_error("MLEVENTBAD",
        $sformatf("ml event '%s' is not created by ml pool", get_name()));
      return;
    end
    stream_size = uvm_ml_serialization_kit::pack_cur_stream(data, stream);
    uvm_ml_notify_event(m_pool.get_full_name(), get_name(), action, stream_size, stream);
  endfunction

endclass : uvm_ml_event

// /////////////////////////////////////////
//
// ML event pool class
//
// /////////////////////////////////////////

class uvm_ml_event_pool extends uvm_event_pool;

  const static string type_name = {"uvm_ml_event_pool"};

  typedef uvm_object_registry #(uvm_ml_event_pool, "uvm_ml_event_pool") type_id;

  function new (string name="");
    super.new(name);
  endfunction

  virtual function string get_type_name ();
    return type_name;
  endfunction

  function uvm_event get (string key);
    uvm_ml_event e;
    if (!pool.exists(key)) begin
      e = new (key);
      e.set_pool(this);
      pool[key] = e;
    end
    return pool[key];
  endfunction

  virtual function void delete (string key);
    int unsigned stream_size;
    `STREAM_T    stream;
    delete_without_bp_notification(key);
    stream_size = uvm_ml_serialization_kit::pack_cur_stream(null, stream);
    uvm_ml_notify_event(get_full_name(), key, UVM_ML_EVENT_DELETE, stream_size, stream);
  endfunction

  function void delete_without_bp_notification (string key);
    if (!exists(key)) begin
      uvm_report_warning("MLEPOOLDEL",
        $sformatf("delete: key '%s' doesn't exist", key));
      return;
    end
    pool.delete(key);
  endfunction

  virtual function uvm_object create(string name="");
    uvm_ml_event_pool v;
    v=new(name);
    return v;
  endfunction

endclass

