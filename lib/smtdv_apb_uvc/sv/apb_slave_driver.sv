
`ifndef __APB_SLAVE_DRIVER_SV__
`define __APB_SLAVE_DRIVER_SV__

typedef class apb_slave_cfg;
typedef class apb_sequence_item;
typedef class apb_slave_drive_items;

/*
* a template apb slave driver
*
* @class apb_slave_driver#(ADDR_WIDTH, DATA_WIDTH)
*/
class apb_slave_driver#(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32
  ) extends
  smtdv_driver#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
    .CFG(apb_slave_cfg),
    .REQ(apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef apb_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef apb_slave_driver#(ADDR_WIDTH, DATA_WIDTH) drv_t;
  typedef apb_slave_drive_items#(ADDR_WIDTH, DATA_WIDTH) drv_items_t;
  typedef smtdv_queue#(item_t) queue_t;
  typedef smtdv_thread_handler#(drv_t) hdler_t;

  // as frontend threads/handler
  hdler_t th_handler;

  queue_t mbox;
  drv_items_t th0;

  `uvm_component_param_utils_begin(drv_t)
  `uvm_component_utils_end

  function new(string name = "apb_slave_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mbox = queue_t::type_id::create("apb_slave_mbox");

    th_handler = hdler_t::type_id::create("apb_slave_handler", this); `SMTDV_RAND(th_handler)
    th0 = drv_items_t::type_id::create("apb_slave_drive_items", this); `SMTDV_RAND(th0)
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    th0.register(this); th_handler.add(th0);
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    th_handler.register(this);
    th_handler.finalize();
  endfunction : end_of_elaboration_phase

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();
  extern virtual task run_threads();

endclass


task apb_slave_driver::run_threads();
  super.run_threads();
  th_handler.run();
  th_handler.watch();
endtask : run_threads


task apb_slave_driver::reset_driver();
  reset_inf();
  mbox.delete();
endtask : reset_driver


task apb_slave_driver::reset_inf();
  vif.slave.prdata <= 'h0;
  vif.slave.pready <= 1'b0;
  vif.slave.pslverr <= OK;
endtask : reset_inf


task apb_slave_driver::drive_bus();
  case(req.trs_t)
    RD: begin mbox.async_push_back(req, 0); end
    WR: begin mbox.async_push_back(req, 0); end
    default:
      `uvm_fatal("APB_UNXPCTDPKT",
      $sformatf("RECEIVES AN UNEXPECTED ITEM: \n%s", req.sprint()))
  endcase
endtask : drive_bus

`endif // end of __APB_SLAVE_DRIVER_SV__

