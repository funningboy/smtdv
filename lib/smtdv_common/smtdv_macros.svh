
`ifndef __SMTDV_MACROS_SVH__
`define __SMTDV_MACROS_SVH__

`define SMTDV_RAND_VAR(RANDVAR) \
  begin \
    if (!std::randomize(RANDVAR)) begin \
      `uvm_fatal("SMTDV_RAND_ERR", "Randomization failed in SMTDV_RAND_VAR action") \
    end \
  end

`define SMTDV_RAND(HANDLE) \
  begin \
    if (!HANDLE.randomize()) begin \
      `uvm_fatal("SMTDV_RAND_ERR", "Randomization failed in SMTDV_RAND action") \
    end \
  end

`define SMTDV_RAND_ARG(HANDLE, RANDARG) \
  begin \
    if (!HANDLE.randomize(RANDARG)) begin \
      `uvm_fatal("SMTDV_RAND_ERR", "Randomization failed in SMTDV_RAND_ARG action") \
    end \
  end

`define SMTDV_RAND_VAR_WITH(RANDVAR, CONSTRAINTS) \
  begin \
    if (!std::randomize(RANDVAR) with CONSTRAINTS) begin \
      `uvm_fatal("SMTDV_RAND_ERR", "Randomization failed in SMTDV_RAND_VAR_WITH action") \
    end \
  end

`define SMTDV_RAND_WITH(HANDLE, CONSTRAINTS) \
  begin \
    if (!HANDLE.randomize() with CONSTRAINTS) begin \
      `uvm_fatal("SMTDV_RAND_ERR", "Randomization failed in SMTDV_RAND_WITH action") \
    end \
  end

`define SMTDV_RAND_ARG_WITH(HANDLE, RANDARG, CONSTRAINTS) \
  begin \
    if (!HANDLE.randomize(RANDARG) with CONSTRAINTS) begin \
      `uvm_fatal("SMTDV_RAND_ERR", "Randomization failed in SMTDV_RAND_ARG_WITH action") \
    end \
  end

`define SMTDV_SLAVE  0
`define SMTDV_MASTER 1

`define SMTDV_VIF2PORT(has_force, clk, vif, port)\
  always@(clk) begin \
    if (has_force) \
      force port = vif; \
    else release port; \
  end

`define SMTDV_PORT2VIF(has_force, clk, port, vif)\
  always@(clk) begin \
    if (has_force) \
      force vif = port; \
    else release vif; \
  end

`endif
