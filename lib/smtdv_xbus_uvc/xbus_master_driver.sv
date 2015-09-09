
`ifndef __XBUS_MASTER_DRIVER_SV__
`define __XBUS_MASTER_DRIVER_SV__

class xbus_master_driver #(
  ADDR_WIDTH  = 14,
  BYTEN_WIDTH = 4,
  DATA_WIDTH = 32
  ) extends
    smtdv_driver#(
      `XBUS_VIF,
      `XBUS_MASTER_CFG,
      `XBUS_ITEM
      );

  mailbox #(`XBUS_ITEM) mbox;

  `XBUS_MASTER_DRIVE_ITEMS th0;

  `uvm_component_param_utils_begin(`XBUS_MASTER_DRIVER)
  `uvm_component_utils_end

  function new(string name = "xbus_master_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = `XBUS_MASTER_DRIVE_ITEMS::type_id::create("xbus_master_drive_items"); th0.cmp = this; this.th_handler.add(th0);
  endfunction

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();

endclass

task xbus_master_driver::reset_driver();
  mbox = new();
  reset_inf();
endtask

task xbus_master_driver::reset_inf();
  this.vif.master.req <= 0;
  this.vif.master.addr <= 0;
  this.vif.master.wdata <= 0;
  this.vif.master.byten <= 0;
  this.vif.master.rw <= 0;
endtask

task xbus_master_driver::drive_bus();
  case(req.trs_t)
    RD: mbox.put(req);
    WR: mbox.put(req);
    default:
      `uvm_fatal("UNXPCTDPKT",
      $sformatf("receives an unexpected item: %s", req.sprint()))
  endcase
  // nonblock trx to block trx, RD, WR at same channel
  //wait(req.done);
endtask

`endif // end of __XBUS_MASTER_DRIVER_SV__

