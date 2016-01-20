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
// UVM-ML barrier facilities
//
//-----------------------------------------------------

// /////////////////////////////////////////
//
// ML barrier class
//
// /////////////////////////////////////////

typedef class uvm_ml_barrier_pool;

class uvm_ml_barrier extends uvm_barrier;

  local uvm_ml_barrier_pool m_pool = null;

  function new(string name="", int threshold=0);
    super.new(name, threshold);
  endfunction

  virtual function void set_pool(uvm_ml_barrier_pool pool);
    m_pool = pool;
  endfunction

  virtual task wait_for_without_bp_notification ();
    super.wait_for();
  endtask

  virtual task wait_for ();
    notify_ml_barrier(UVM_ML_BARRIER_SET_THRESHOLD, get_threshold() - 1);
    wait_for_without_bp_notification();
  endtask

  virtual function void reset_without_bp_notification (bit wakeup=0);
    super.reset(wakeup);
  endfunction

  virtual function void reset (bit wakeup=0);
    notify_ml_barrier(UVM_ML_BARRIER_RESET, wakeup);
    reset_without_bp_notification(wakeup);
  endfunction

  virtual function void set_auto_reset_without_bp_notification (bit value=1);
    super.set_auto_reset(value);
  endfunction

  virtual function void set_auto_reset (bit value=1);
    notify_ml_barrier(UVM_ML_BARRIER_SET_AUTO_RESET, value);
    set_auto_reset_without_bp_notification(value);
  endfunction

  virtual function void set_threshold_without_bp_notification (int threshold);
    super.set_threshold(threshold);
  endfunction

  virtual function void set_threshold (int threshold);
    notify_ml_barrier(UVM_ML_BARRIER_SET_THRESHOLD, threshold);
    set_threshold_without_bp_notification(threshold);
  endfunction

  virtual function void cancel_without_bp_notification ();
    super.cancel();
  endfunction

  virtual function void cancel ();
    notify_ml_barrier(UVM_ML_BARRIER_CANCEL);
    cancel_without_bp_notification();
  endfunction

  virtual function uvm_object create(string name="");
    uvm_ml_barrier v;
    v=new(name);
    return v;
  endfunction

  static function void notify_barrier_by_name(string                         scope_name,
                                              string                         barrier_name,
                                              uvm_ml_barrier_notify_action_e action,
                                              int                            count);
    uvm_ml_barrier_pool pool;
    uvm_ml_barrier b;

    if (!$cast(pool, uvm_ext_barrier_pool::get_pool(scope_name))) begin
      string msg;
      msg = {"cannot get a pool with type uvm_ml_barrier_pool"};
      uvm_report_fatal("MLBPOOLGET", msg, UVM_NONE);
    end
    if (pool.exists(barrier_name)) begin

      if (action == UVM_ML_BARRIER_DELETE) begin
        pool.delete_without_bp_notification(barrier_name);
        return;
      end

    end

    if (!$cast(b, pool.get(barrier_name))) begin
      string msg;
      msg = {"cannot get a barrier with type uvm_ml_barrier"};
      uvm_report_fatal("MLBPOOLGET", msg, UVM_NONE);
    end

    case (action)
      UVM_ML_BARRIER_NEW : ;
      UVM_ML_BARRIER_RESET :
       begin
        b.reset_without_bp_notification(count);
       end
      UVM_ML_BARRIER_SET_AUTO_RESET :
       begin
        b.set_auto_reset_without_bp_notification(count);
       end
      UVM_ML_BARRIER_SET_THRESHOLD :
       begin
        b.set_threshold_without_bp_notification(count);
       end
      UVM_ML_BARRIER_CANCEL : b.cancel_without_bp_notification();
    endcase

  endfunction

  function void notify_ml_barrier(uvm_ml_barrier_notify_action_e action, int count=0);
    // notify backplane
    if (m_pool == null) begin
      uvm_report_error("MLBARRIERBAD",
        $sformatf("ml barrier '%s' is not created by ml pool", get_name()));
      return;
    end
    uvm_ml_notify_barrier(m_pool.get_full_name(), get_name(), action, count);
  endfunction

endclass : uvm_ml_barrier

// /////////////////////////////////////////
//
// ML barrier pool class
//
// /////////////////////////////////////////

class uvm_ml_barrier_pool extends uvm_barrier_pool;

  const static string type_name = {"uvm_ml_barrier_pool"};

  typedef uvm_object_registry #(uvm_ml_barrier_pool, "uvm_ml_barrier_pool") type_id;

  function new (string name="");
    super.new(name);
  endfunction

  virtual function string get_type_name ();
    return type_name;
  endfunction

  function uvm_barrier get (string key);
    uvm_ml_barrier b;
    if (!pool.exists(key)) begin
      b = new (key);
      b.set_pool(this);
      pool[key] = b;
    end
    return pool[key];
  endfunction

  virtual function void delete (string key);
    delete_without_bp_notification(key);
    uvm_ml_notify_barrier(get_full_name(), key, UVM_ML_BARRIER_DELETE, 0);
  endfunction

  function void delete_without_bp_notification (string key);
    if (!exists(key)) begin
      uvm_report_warning("MLBPOOLDEL",
        $sformatf("delete: key '%s' doesn't exist", key));
      return;
    end
    pool.delete(key);
  endfunction 

  virtual function uvm_object create(string name="");
    uvm_ml_barrier_pool v;
    v=new(name);
    return v;
  endfunction

endclass

