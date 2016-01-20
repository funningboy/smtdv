
`ifndef __AHB_INTERRUPT_TEST_SV__
`define __AHB_INTERRUPT_TEST_SV__

class apb_interrupt_test
  extends
  apb_base_test;

  typedef apb_slave_base_seq#(ADDR_WIDTH, DATA_WIDTH) s_bseq_t;
//  typedef apb_slave_interrupt_seq#(ADDR_WIDTH, DATA_WIDTH) s_cseq_t;
//  typedef apb_master_interrupt_seq#(ADDR_WIDTH, DATA_WIDTH) m_seq_t;



endclass : apb_interrupt_test

`endif // __AHB_INTERRUPT_TEST_SV__

