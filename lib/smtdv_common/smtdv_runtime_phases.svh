
`ifndef __smtdv_RUNTIME_PHASES_SVH__
`define __smtdv_RUNTIME_PHASES_SVH__

class smtdv_pre_reset_phase extends uvm_pre_reset_phase;

  function new(string name = "pre_reset");
    super.new(name);
  endfunction
endclass

class smtdv_reset_phase extends uvm_reset_phase;

  function new(string name = "reset");
    super.new(name);
  endfunction
endclass

class smtdv_post_reset_phase extends uvm_post_reset_phase;

  function new(string name = "post_reset");
    super.new(name);
  endfunction
endclass

class smtdv_pre_configure_phase extends uvm_pre_configure_phase;

  function new(string name = "pre_configure");
    super.new(name);
  endfunction
endclass

class smtdv_configure_phase extends uvm_configure_phase;

  function new(string name = "configure");
    super.new(name);
  endfunction
endclass

class smtdv_post_configure_phase extends uvm_post_configure_phase;

  function new(string name = "post_configure");
    super.new(name);
  endfunction
endclass

class smtdv_pre_main_phase extends uvm_pre_main_phase;

  function new(string name = "pre_main");
    super.new(name);
  endfunction
endclass

class smtdv_main_phase extends uvm_main_phase;

  function new(string name = "main");
    super.new(name);
  endfunction
endclass

class smtdv_post_main_phase extends uvm_post_main_phase;

  function new(string name = "post_main");
    super.new(name);
  endfunction
endclass

class smtdv_pre_shutdown_phase extends uvm_pre_shutdown_phase;

  function new(string name = "pre_shutdown");
    super.new(name);
  endfunction
endclass

class smtdv_shutdown_phase extends uvm_shutdown_phase;

  function new(string name = "shutdown");
    super.new(name);
  endfunction
endclass

class smtdv_post_shutdown_phase extends uvm_post_shutdown_phase;

  function new(string name = "post_shutdown");
    super.new(name);
  endfunction
endclass

`endif // end of __smtdv_RUNTIME_PHASES_SVH__
