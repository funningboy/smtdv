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

// define global mem vif attr table field
// 128 bit = 16 * 8(bit) = byte[8];
`define SMTDV_MEM_VIF_ATTR_LONGINT \
  { \
  "dec_uuid", \
  "dec_id", \
  "dec_addr", \
  "dec_rw", \
  "dec_data_000", \
  "dec_bg_cyc", \
  "dec_ed_cyc", \
  "dec_bg_time", \
  "dec_ed_time" \
  };

// define global bus vif attr table field
`define SMTDV_BUS_VIF_ATTR_LONGINT \
    { \
      "dec_uuid", \
      "dec_id", \
      "dec_addr", \
      "dec_rw", \
      "dec_len", \
      "dec_burst", \
      "dec_size", \
      "dec_lock", \
      "dec_prot", \
      "dec_data_000", \
      "dec_data_001", \
      "dec_data_002", \
      "dec_data_003", \
      "dec_data_004", \
      "dec_data_005", \
      "dec_data_006", \
      "dec_data_007", \
      "dec_data_008", \
      "dec_data_009", \
      "dec_data_010", \
      "dec_data_011", \
      "dec_data_012", \
      "dec_data_013", \
      "dec_data_014", \
      "dec_data_015", \
      "dec_resp", \
      "dec_bg_cyc", \
      "dec_ed_cyc", \
      "dec_bg_time", \
      "dec_ed_time" \
    };

// define global bus/mem callback event while using backdoor access
`define SMTDV_CB_EVENT \
   '{ \
    "dec_uuid": SMTDV_CB_UUID, \
    "dec_id": SMTDV_CB_ID, \
    "dec_addr": SMTDV_CB_ADDR, \
    "dec_rw": SMTDV_CB_RW, \
    "dec_len": SMTDV_CB_LEN, \
    "dec_burst": SMTDV_CB_BURST, \
    "dec_size": SMTDV_CB_SIZE, \
    "dec_lock": SMTDV_CB_LOCK, \
    "dec_prot": SMTDV_CB_PROT, \
    "dec_data_000": SMTDV_CB_DATA, \
    "dec_data_001": SMTDV_CB_DATA, \
    "dec_data_002": SMTDV_CB_DATA, \
    "dec_data_003": SMTDV_CB_DATA, \
    "dec_data_004": SMTDV_CB_DATA, \
    "dec_data_005": SMTDV_CB_DATA, \
    "dec_data_006": SMTDV_CB_DATA, \
    "dec_data_007": SMTDV_CB_DATA, \
    "dec_data_008": SMTDV_CB_DATA, \
    "dec_data_009": SMTDV_CB_DATA, \
    "dec_data_010": SMTDV_CB_DATA, \
    "dec_data_011": SMTDV_CB_DATA, \
    "dec_data_012": SMTDV_CB_DATA, \
    "dec_data_013": SMTDV_CB_DATA, \
    "dec_data_014": SMTDV_CB_DATA, \
    "dec_data_015": SMTDV_CB_DATA, \
    "dec_resp": SMTDV_CB_RESP, \
    "dec_bg_cyc": SMTDV_CB_BG_CYC, \
    "dec_ed_cyc": SMTDV_CB_ED_CYC, \
    "dec_bg_time": SMTDV_CB_BG_TIME, \
    "dec_ed_time": SMTDV_CB_ED_TIME \
  };

`endif
