
`ifndef __APB_SLAVE_DRIVER_SV__
`define __APB_SLAVE_DRIVER_SV__

class apb_slave_driver #(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_driver#(
      `APB_VIF,
      `APB_SLAVE_CFG,
      `APB_ITEM
    );

  mailbox #(`APB_ITEM) mbox;
  `APB_SLAVE_DRIVE_ITEMS th0;

  `uvm_component_param_utils_begin(`APB_SLAVE_DRIVER)
  `uvm_component_utils_end

  function new(string name = "apb_slave_driver", uvm_component parent);
    super.new(name, parent);
    mbox = new();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = `APB_SLAVE_DRIVE_ITEMS::type_id::create("apb_slave_drive_items"); th0.cmp = this; this.th_handler.add(th0);
  endfunction

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();

endclass

task apb_slave_driver::reset_driver();
  reset_inf();
  mbox = new();
endtask

task apb_slave_driver::reset_inf();
  vif.slave.prdata <= 0;
  vif.slave.pready <= 0;
  vif.slave.pslverr <= 0;
endtask

task apb_slave_driver::drive_bus();
  case(req.trs_t)
    RD: mbox.put(req);
    WR: mbox.put(req);
    default:
      `uvm_fatal("UNXPCTDPKT",
      $sformatf("receives an unexpected item: \n%s", req.sprint()))
  endcase
endtask

`endif // end of __APB_SLAVE_DRIVER_SV__

