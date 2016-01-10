
`ifndef __OVERRIDE_TYPEDEFS_SV__
`define __OVERRIDE_TYPEDEFS_SV__

`define SMTDV_RX_AGENT(INTF) \
  ``INTF``_pkg::``INTF``_rx_agent #()

`define SMTDV_RX_CFG(INTF) \
  ``INTF``_pkg::``INTF``_rx_cfg

`define SMTDV_RX_SEQUENCER(INTF) \
  ``INTF``_pkg::``INTF``_rx_sequencer #()

`define SMTDV_RX_BASE_SEQ(INTF) \
  ``INTF``_pkg::``INTF``_rx_base_seq #()

`define SMTDV_TX_AGENT(INTF) \
  ``INTF``_pkg::``INTF``_tx_agent #()

`define SMTDV_TX_CFG(INTF) \
  ``INTF``_pkg::``INTF``_tx_cfg

`define SMTDV_SLAVE_AGENT(INTF, ADDR_WIDTH, DATA_WIDTH) \
  ``INTF``_pkg::``INTF``_slave_agent #(ADDR_WIDTH, DATA_WIDTH)

`define SMTDV_SLAVE_CFG(INTF) \
  ``INTF``_pkg::``INTF``_slave_cfg

`define SMTDV_SLAVE_SEQUENCER(INTF, ADDR_WIDTH, DATA_WIDTH) \
  ``INTF``_pkg::``INTF``_slave_sequencer #(ADDR_WIDTH, DATA_WIDTH)

`define SMTDV_SLAVE_BASE_SEQ(INTF, ADDR_WIDTH, DATA_WIDTH) \
  ``INTF``_pkg::``INTF``_slave_base_seq #(ADDR_WIDTH, DATA_WIDTH)

`define SMTDV_SLAVE_STL_SEQ(INTF, ADDR_WIDTH, DATA_WIDTH) \
  ``INTF``_pkg::``INTG``_slave_stl_seq #(ADDR_WIDTH, DATA_WIDTH)

`define SMTDV_MASTER_AGENT(INTF, ADDR_WIDTH, DATA_WIDTH) \
  ``INTF``_pkg::``INTF``_master_agent #(ADDR_WIDTH, DATA_WIDTH)

`define SMTDV_MASTER_CFG(INTF) \
  ``INTF``_pkg::``INTF``_master_cfg

`define SMTDV_MASTER_SEQUENCER(INTF, ADDR_WIDTH, DATA_WIDTH) \
  ``INTF``_pkg::``INTF``_master_sequencer #(ADDR_WIDTH, DATA_WIDTH)

`define SMTDV_MASTER_BASE_SEQ(INTF, ADDR_WIDTH, DATA_WIDTH) \
  `INTF``_pkg::``INTF``_master_base_seq #(ADDR_WIDTH, DATA_WIDTH)

`define SMTDV_MASTER_STL_SEQ(INTF, ADDR_WIDTH, DATA_WIDTH) \
  ``INTF``_pkg::``INTF``_master_stl_seq #(ADDR_WIDTH, DATA_WIDTH)

`define SMTDV_COLLECT_COVER_GROUP(INTF, ADDR_WIDTH, DATA_WIDTH) \
  ``INTF``_pkg::``INTF``_collect_cover_group #(ADDR_WIDTH, DATA_WIDTH)

`define SMTDV_ENV(INTF) \
  ``INTF``_pkg::``INTF``_env

`endif // end of __OVERRIDE_TYPEDEFS_SV__
