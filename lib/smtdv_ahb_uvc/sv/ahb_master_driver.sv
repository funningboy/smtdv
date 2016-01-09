`ifndef __AHB_MASTER_DRIVER_SV__
`define __AHB_MASTER_DRIVER_SV__

typedef class ahb_master_cfg;
typedef class ahb_item;
typedef class ahb_master_drive_addr;
typedef class ahb_master_drive_data;

class ahb_master_driver #(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_driver#(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .VIF(virtual interface ahb_if#(ADDR_WIDTH, DATA_WIDTH)),
      .CFG(ahb_master_cfg),
      .REQ(ahb_item#(ADDR_WIDTH, DATA_WIDTH))
    );

  typedef ahb_item#(ADDR_WIDTH, DATA_WIDTH) item_t;
  typedef ahb_master_driver#(ADDR_WIDTH, DATA_WIDTH) drv_t;
  typedef ahb_master_drive_addr#(ADDR_WIDTH, DATA_WIDTH) drv_addr_t;
  typedef ahb_master_drive_data#(ADDR_WIDTH, DATA_WIDTH) drv_data_t;
  typedef smtdv_thread_handler#(drv_t) hdler_t;

  //as frontend threads/handler
  hdler_t th_handler;

  mailbox #(item_t) addrbox;
  mailbox #(item_t) databox;

  drv_addr_t th0;
  drv_data_t th1;

  `uvm_component_param_utils_begin(drv_t)
  `uvm_component_utils_end

  function new(string name = "ahb_master_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = drv_addr_t::type_id::create("ahb_master_drive_addr", this);
    th1 = drv_data_t::type_id::create("ahb_master_drive_data", this);
    th_handler = hdler_t::type_id::create("ahb_master_handler", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    th0.register(this); th_handler.add(th0);
    th1.register(this); th_handler.add(th1);
  endfunction : connect_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    th_handler.finalize();
  endfunction : end_of_elaboration_phase

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();
  extern virtual task run_threads();

endclass : ahb_master_driver


task ahb_master_driver::run_threads();
  super.run_threads();
  th_handler.run();
endtask : run_threads


task ahb_master_driver::reset_driver();
  addrbox = new();
  databox = new();
  reset_inf();
endtask : reset_driver


task ahb_master_driver::reset_inf();
  this.vif.master.hbusreq <= 1'b0;

  this.vif.master.haddr <= 'h0;
  this.vif.master.htrans <= IDLE;
  this.vif.master.hwrite <= 1'b0;
  this.vif.master.hsize <= 'h0;
  this.vif.master.hburst <= 'h0;
  this.vif.master.hprot <= 'h0;
  this.vif.master.hwdata <= 'h0;
  this.vif.master.hmastlock <= 1'b0;
endtask : reset_inf


task ahb_master_driver::drive_bus();
  case(req.trs_t)
    RD: begin addrbox.put(req); databox.put(req); end
    WR: begin addrbox.put(req); databox.put(req); end
    default:
      `uvm_fatal("UNXPCTDPKT",
      $sformatf("receives an unexpected item: %s", req.sprint()))
  endcase
endtask : drive_bus

`endif // end of __AHB_MASTER_DRIVER_SV__

