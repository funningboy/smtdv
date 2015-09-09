`ifndef __AHB_SLAVE_DRIVER_SV__
`define __AHB_SLAVE_DRIVER_SV__

class ahb_slave_driver #(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_driver#(
      `AHB_VIF,
      `AHB_SLAVE_CFG,
      `AHB_ITEM
    );

  mailbox #(`AHB_ITEM) addrbox;
  mailbox #(`AHB_ITEM) databox;

  `AHB_SLAVE_DRIVE_ADDR th0;
  `AHB_SLAVE_DRIVE_DATA th1;

  `uvm_component_param_utils_begin(`AHB_SLAVE_DRIVER)
  `uvm_component_utils_end

  function new(string name = "ahb_slave_driver", uvm_component parent);
    super.new(name, parent);
    addrbox = new();
    databox = new();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = `AHB_SLAVE_DRIVE_ADDR::type_id::create("ahb_slave_drive_addr");
    th0.cmp = this;
    this.th_handler.add(th0);
    th1 = `AHB_SLAVE_DRIVE_DATA::type_id::create("ahb_slave_drive_data");
    th1.cmp = this;
    this.th_handler.add(th1);
  endfunction

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();

endclass

task ahb_slave_driver::reset_driver();
  reset_inf();
  addrbox = new();
  databox = new();
endtask

task ahb_slave_driver::reset_inf();
  this.vif.slave.hrdata <= 0;
  this.vif.slave.hready <= 0;
  this.vif.slave.hresp <= 0;
endtask

task ahb_slave_driver::drive_bus();
  case(req.trs_t)
    smtdv_common_pkg::RD: begin addrbox.put(req); databox.put(req); end
    smtdv_common_pkg::WR: begin addrbox.put(req); end
    default:
      `uvm_fatal("UNXPCTDPKT",
      $sformatf("receives an unexpected item: \n%s", req.sprint()))
  endcase
endtask

`endif // end of __AHB_SLAVE_DRIVER_SV__

