`ifndef __UART_TYPEDEFS_SV__
`define __UART_TYPEDEFS_SV__

`define UART_DEBUG true

typedef enum bit {GOOD_PARITY, BAD_PARITY} parity_e;

`define UART_PARAMETER #()
`define UART_PARAMETER2 #(CFG)
`define UART_PARAMETER3 #(NUM_OF_INITOR, NUM_OF_TARGETS)

`define UART_TX_MONITOR uart_monitor `UART_PARAMETER

`define UART_RST_VIF virtual smtdv_gen_rst_if #("uart_rst_if", 100, 0)

`define UART_VIF virtual uart_if `UART_PARAMETER
`define UART_ITEM uart_item `UART_PARAMETER

`define UART_MONITOR uart_monitor `UART_PARAMETER

`define UART_GEN_SAMPLE_RATE uart_gen_sample_rate `UART_PARAMETER2
`define UART_START_SYNCHRONIZER uart_start_synchronizer `UART_PARAMETER2
`define UART_SAMPLE_AND_STORE uart_sample_and_store `UART_PARAMETER2
`define UART_COLLECT_STOP_SIGNAL uart_collect_stop_signal `UART_PARAMETER2
`define UART_COLLECT_COVER_GROUP uart_collect_cover_group `UART_PARAMETER2
`define UART_EXPORT_COLLECTED_ITEMS uart_export_collected_items `UART_PARAMETER2

`define UART_RX_DRIVE_ITEMS uart_rx_drive_items `UART_PARAMETER
`define UART_RX_SAMPLE_RATE uart_rx_sample_rate `UART_PARAMETER

`define UART_TX_DRIVE_ITEMS uart_tx_drive_items `UART_PARAMETER
`define UART_TX_SAMPLE_RATE uart_tx_sample_rate `UART_PARAMETER

`define UART_BASE_CFG uart_base_cfg

`define UART_RX_CFG uart_rx_cfg
`define UART_SLAVE_CFG `UART_RX_CFG
`define UART_RX_AGENT uart_rx_agent `UART_PARAMETER
`define UART_SLAVE_AGENT `UART_RX_AGENT
`define UART_RX_DRIVER uart_rx_driver `UART_PARAMETER
`define UART_RX_SEQUENCER uart_rx_sequencer `UART_PARAMETER

`define UART_TX_CFG uart_tx_cfg
`define UART_MASTER_CFG `UART_TX_CFG
`define UART_TX_AGENT uart_tx_agent `UART_PARAMETER
`define UART_MASTER_AGENT `UART_TX_AGENT
`define UART_TX_DRIVER uart_tx_driver `UART_PARAMETER
`define UART_TX_SEQUENCER uart_tx_sequencer `UART_PARAMETER

`define UART_BASE_SEQ uart_base_seq `UART_PARAMETER
`define UART_INCR_PAYLOAD_SEQ uart_incr_payload_seq `UART_PARAMETER
`define UART_BAD_PARITY_SEQ uart_bad_parity_seq `UART_PARAMETER
`define UART_TRANSMIT_SEQ uart_transmit_seq `UART_PARAMETER
`define UART_SHORT_TRANSMIT_SEQ uart_short_transmit_seq `UART_PARAMETER

`define TX_BASE_SEQ tx_base_seq `UART_PARAMETER
`define TX_INCR_PAYLOAD_SEQ tx_incr_payload_seq `UART_PARAMETER
`define TX_BAD_PARITY_SEQ tx_bad_parity_seq `UART_PARAMETER
`define TX_TRANSMIT_SEQ tx_transmit_seq `UART_PARAMETER
`define TX_SHORT_TRANSMIT_SEQ tx_short_transmit_seq `UART_PARAMETER

`define RX_BASE_SEQ rx_base_seq `UART_PARAMETER
`define RX_INCR_PAYLOAD_SEQ rx_incr_payload_seq `UART_PARAMETER
`define RX_BAD_PARITY_SEQ rx_bad_parity_seq `UART_PARAMETER
`define RX_TRANSMIT_SEQ rx_transmit_seq `UART_PARAMETER
`define RX_SHORT_TRANSMIT_SEQ rx_short_transmit_seq `UART_PARAMETER
`define RX_LOOPBACK_BASE_SEQ rx_loopback_base_seq `UART_PARAMETER

`define UART_ENV uart_env
`define UART_BASE_SCOREBOARD uart_base_scoreboard `UART_PARAMETER3
`define UART_MEM_BKDOR_WR_COMP uart_mem_bkdor_wr_comp `UART_PARAMETER3
`define UART_MEM_BKDOR_RD_COMP uart_mem_bkdor_rd_comp `UART_PARAMETER3
`define UART_BUS_BACKDOOR uart_bus_backdoor `UART_PARAMETER
`define UART_MEM_BACKDOOR uart_mem_backdoor `UART_PARAMETER

`define UART_BASE_TEST uart_base_test
`define UART_SEQ_TEST uart_seq_test
`define UART_LOOPBACK_TEST uart_loopback_test

`endif // __UART_TYPEDEFS_SV__
