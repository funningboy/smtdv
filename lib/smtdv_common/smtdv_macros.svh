
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

`endif
