`ifndef __APB_MASTER_DRIVER_SV__
`define __APB_MASTER_DRIVER_SV__

typedef class apb_master_cfg;
typedef class apb_item;
typedef class apb_master_drive_items;

class apb_master_driver#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_driver#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface apb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(apb_master_cfg),
      .REQ(apb_item#(ADDR_WIDTH, DATA_WIDTH))
  );

  typedef apb_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef apb_master_driver#(ADDR_WIDTH, DATA_WIDTH) drv_t;
  typedef apb_master_drive_items#(ADDR_WIDTH, DATA_WIDTH) drv_items_t;
  typedef smtdv_queue#(ADDR_WIDTH, DATA_WIDTH, item_t) queue_t;
  typedef smtdv_thread_handler#(drv_t) hdler_t;

  // as frontend threads/handler
  hdler_t th_handler;

  queue_t mbox;
  drv_items_t th0;

  `uvm_component_param_utils_begin(drv_t)
  `uvm_component_utils_end

  function new(string name = "apb_master_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mbox = queue_t::type_id::create("apb_master_mbox");
    th0 = drv_items_t::type_id::create("apb_master_drive_items", this);
    th_handler = hdler_t::type_id::create("apb_master_handler", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    th0.register(this); th_handler.add(th0);
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    th_handler.finalize();
  endfunction : end_of_elaboration_phase

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();
  extern virtual task run_threads();

endclass : apb_master_driver


task apb_master_driver::run_threads();
  super.run_threads();
  th_handler.run();
endtask : run_threads

task apb_master_driver::reset_driver();
  mbox.delete();
  reset_inf();
endtask : reset_driver

task apb_master_driver::reset_inf();
  this.vif.master.paddr <= 'h0;
  this.vif.master.prwd <= 1'b0;
  this.vif.master.pwdata <= 'h0;
  this.vif.master.psel <= 'h0;
  this.vif.master.penable <= 1'b0;
endtask : reset_inf


task apb_master_driver::drive_bus();
  case(req.trs_t)
    RD: begin mbox.async_push_back(req, 0); end
    WR: begin mbox.async_push_back(req, 0); end
    default:
      `uvm_fatal("APB_UNXPCTDPKT",
      $sformatf("RECEIVES AN UNEXPECTED ITEM: %s", req.sprint()))
  endcase
endtask : drive_bus

`endif // end of __APB_MASTER_DRIVER_SV__

