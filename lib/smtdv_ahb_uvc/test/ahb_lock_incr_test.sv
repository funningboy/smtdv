
`ifndef __AHB_LOCK_INCR_TEST_SV__
`define __AHB_LOCK_INCR_TEST_SV__

class ahb_lock_incr_test
  extends `AHB_BASE_TEST;

  `uvm_component_utils(`AHB_LOCK_INCR_TEST)

  function new(string name = "ahb_lock_incr_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    foreach(master_cfg[i])begin
      master_cfg[i].has_busy = 0;
    end

    foreach(slave_cfg[i])begin
      slave_cfg[i].has_error = 0;
      slave_cfg[i].has_split = 0;
      slave_cfg[i].has_retry = 0;
    end

    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `AHB_MASTER_LOCK_INCR_SEQ::type_id::get());
  endfunction

endclass

class ahb_lock_incr_retry_test
  extends `AHB_BASE_TEST;

  `uvm_component_utils(`AHB_LOCK_INCR_RETRY_TEST)

  function new(string name = "ahb_lock_incr_retry_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    foreach(master_cfg[i])begin
      master_cfg[i].has_busy = 0;
    end

    foreach(slave_cfg[i])begin
      slave_cfg[i].has_error = 0;
      slave_cfg[i].has_split = 0;
      slave_cfg[i].has_retry = 1;
    end

    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `AHB_MASTER_LOCK_INCR_SEQ::type_id::get());

  endfunction

endclass

class ahb_lock_incr_error_test
  extends `AHB_BASE_TEST;

  `uvm_component_utils(`AHB_LOCK_INCR_ERROR_TEST)

  function new(string name = "ahb_lock_incr_error_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    foreach(master_cfg[i])begin
      master_cfg[i].has_busy = 0;
    end

    foreach(slave_cfg[i])begin
      slave_cfg[i].has_error = 1;
      slave_cfg[i].has_split = 0;
      slave_cfg[i].has_retry = 0;
    end

    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `AHB_MASTER_LOCK_INCR_SEQ::type_id::get());

  endfunction

endclass

class ahb_lock_incr_split_test
  extends `AHB_BASE_TEST;

  `uvm_component_utils(`AHB_LOCK_INCR_SPLIT_TEST)

  function new(string name = "ahb_lock_incr_split_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    foreach(master_cfg[i])begin
      master_cfg[i].has_busy = 0;
    end

    foreach(slave_cfg[i])begin
      slave_cfg[i].has_error = 0;
      slave_cfg[i].has_split = 1;
      slave_cfg[i].has_retry = 0;
    end

    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `AHB_MASTER_LOCK_INCR_SEQ::type_id::get());

  endfunction

endclass

class ahb_lock_incr_busy_test
  extends `AHB_BASE_TEST;

  `uvm_component_utils(`AHB_LOCK_INCR_BUSY_TEST)

  function new(string name = "ahb_lock_incr_busy_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    foreach(master_cfg[i])begin
      master_cfg[i].has_busy = 1;
    end

    foreach(slave_cfg[i])begin
      slave_cfg[i].has_error = 0;
      slave_cfg[i].has_split = 0;
      slave_cfg[i].has_retry = 0;
    end

    uvm_config_db #(uvm_object_wrapper)::set(this,
      "*master_agent[*0]*.seqr.run_phase",
      "default_sequence",
      `AHB_MASTER_LOCK_INCR_SEQ::type_id::get());

  endfunction

endclass

`endif // end of __AHB_LOCK_INCR_TEST_SV__
