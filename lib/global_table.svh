

uvm_component SMTDV_DEC_MASTERS[$] = {
  apb_master#(32, 32),
  apb_master#(32, 64),
  apb_master#(64, 64),
  ahb_master#(32, 32),
};

uvm_component SMTDV_DEC_SLAVES[$] = {
  apb_slave#()
};
