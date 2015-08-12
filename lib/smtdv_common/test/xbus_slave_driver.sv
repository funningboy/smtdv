
`ifndef __XBUS_SLAVE_DRIVER_SV__
`define __XBUS_SLAVE_DRIVER_SV__

class xbus_slave_driver #(
  ADDR_WIDTH  = 14,
  BYTEN_WIDTH = 4,
  DATA_WIDTH = 32
  ) extends
    smtdv_driver#(
      `XBUS_VIF,
      `XBUS_SLAVE_CFG,
      `XBUS_ITEM
    );

  mailbox #(`XBUS_ITEM) mbox;
  `XBUS_SLAVE_DRIVE_ITEMS th0;

  `uvm_component_param_utils_begin(`XBUS_SLAVE_DRIVER)
  `uvm_component_utils_end

  function new(string name = "xbus_slave_driver", uvm_component parent);
    super.new(name, parent);
    mbox = new();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = `XBUS_SLAVE_DRIVE_ITEMS::type_id::create("xbus_slave_drive_items");
    th0.cmp = this;
    this.th_handler.add(th0);
  endfunction

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();

endclass

task xbus_slave_driver::reset_driver();
  reset_inf();
  mbox = new();
endtask

task xbus_slave_driver::reset_inf();
  vif.slave.ack <= 0;
  vif.slave.rdata <= 0;
endtask

task xbus_slave_driver::drive_bus();
  case(req.trs_t)
    RD: mbox.put(req);
    WR: mbox.put(req);
    default:
      `uvm_fatal("UNXPCTDPKT",
      $sformatf("receives an unexpected item: \n%s", req.sprint()))
  endcase
endtask

`endif // end of __XBUS_SLAVE_DRIVER_SV__

