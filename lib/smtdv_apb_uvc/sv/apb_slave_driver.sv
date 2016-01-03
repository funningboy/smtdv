
`ifndef __APB_SLAVE_DRIVER_SV__
`define __APB_SLAVE_DRIVER_SV__

typedef class apb_slave_cfg;
typedef class apb_item;
typedef class apb_slave_drive_items;

class apb_slave_driver #(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_driver#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(apb_slave_cfg),
      .REQ(apb_item#(ADDR_WIDTH, DATA_WIDTH))
    );

  typedef apb_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef apb_slave_driver#(ADDR_WIDTH, DATA_WIDTH) drv_t;
  typedef apb_slave_drive_items#(ADDR_WIDTH, DATA_WIDTH) drv_items_t;
  typedef smtdv_thread_handler #(drv_t) th_t;

  // as frontend threads/handler
  th_t th_handler;

  mailbox #(item_t) mbox;
  drv_items_t th0;

  `uvm_component_param_utils_begin(drv_t)
  `uvm_component_utils_end

  function new(string name = "apb_slave_driver", uvm_component parent);
    super.new(name, parent);
    mbox = new();
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th_handler = th_t::type_id::create("apb_slave_handler", this);
    th0 = drv_items_t::type_id::create("apb_slave_drive_items", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    th0.cmp = this; th_handler.add(th0);
  endfunction : connect_phase

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();
  extern virtual task run_threads();

endclass


task apb_slave_driver::run_threads();
  super.run_threads();
  th_handler.run();
endtask : run_threads


task apb_slave_driver::reset_driver();
  reset_inf();
  mbox = new();
endtask : reset_driver

task apb_slave_driver::reset_inf();
  vif.slave.prdata <= 'h0;
  vif.slave.pready <= 1'b0;
  vif.slave.pslverr <= OK;
endtask : reset_inf

task apb_slave_driver::drive_bus();
  case(req.trs_t)
    RD: mbox.put(req);
    WR: mbox.put(req);
    default:
      `uvm_fatal("APB_UNXPCTDPKT",
      $sformatf("RECEIVES AN UNEXPECTED ITEM: \n%s", req.sprint()))
  endcase
endtask : drive_bus

`endif // end of __APB_SLAVE_DRIVER_SV__

