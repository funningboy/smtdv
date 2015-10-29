`ifndef __AHB_MASTER_DRIVER_SV__
`define __AHB_MASTER_DRIVER_SV__

class ahb_master_driver #(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_driver#(
      `AHB_VIF,
      `AHB_MASTER_CFG,
      `AHB_ITEM
      );

  mailbox #(`AHB_ITEM) addrbox;
  mailbox #(`AHB_ITEM) databox;

  `AHB_MASTER_DRIVE_ADDR th0;
  `AHB_MASTER_DRIVE_DATA th1;

  `uvm_component_param_utils_begin(`AHB_MASTER_DRIVER)
  `uvm_component_utils_end

  function new(string name = "ahb_master_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = `AHB_MASTER_DRIVE_ADDR::type_id::create("ahb_master_drive_addr"); th0.cmp = this; this.th_handler.add(th0);
    th1 = `AHB_MASTER_DRIVE_DATA::type_id::create("ahb_master_drive_data"); th1.cmp = this; this.th_handler.add(th1);
  endfunction

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();

endclass

task ahb_master_driver::reset_driver();
  addrbox = new();
  databox = new();
  reset_inf();
endtask

task ahb_master_driver::reset_inf();
  this.vif.master.hbusreq <= 0;

  this.vif.master.haddr <= 0;
  this.vif.master.htrans <= IDLE;
  this.vif.master.hwrite <= 0;
  this.vif.master.hsize <= 0;
  this.vif.master.hburst <= 0;
  this.vif.master.hprot <= 0;
  this.vif.master.hwdata <= 0;
  this.vif.master.hmastlock <= 0;
endtask

task ahb_master_driver::drive_bus();
  case(req.trs_t)
    RD: begin addrbox.put(req); databox.put(req); end
    WR: begin addrbox.put(req); databox.put(req); end
    default:
      `uvm_fatal("UNXPCTDPKT",
      $sformatf("receives an unexpected item: %s", req.sprint()))
  endcase
endtask

`endif // end of __AHB_MASTER_DRIVER_SV__

