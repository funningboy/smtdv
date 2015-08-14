`ifndef __APB_MASTER_DRIVER_SV__
`define __APB_MASTER_DRIVER_SV__

class apb_master_driver #(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_driver#(
      `APB_VIF,
      `APB_MASTER_CFG,
      `APB_ITEM
      );

  mailbox #(`APB_ITEM) mbox;
  `APB_MASTER_DRIVE_ITEMS th0;

  `uvm_component_param_utils_begin(`APB_MASTER_DRIVER)
  `uvm_component_utils_end

  function new(string name = "apb_master_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = `APB_MASTER_DRIVE_ITEMS::type_id::create("apb_master_drive_items");
    th0.cmp = this;
    this.th_handler.add(th0);
  endfunction

  extern virtual task reset_driver();
  extern virtual task reset_inf();
  extern virtual task drive_bus();

endclass

task apb_master_driver::reset_driver();
  mbox = new();
  reset_inf();
endtask

task apb_master_driver::reset_inf();
  this.vif.master.paddr <= 0;
  this.vif.master.prwd <= 0;
  this.vif.master.pwdata <= 0;
  this.vif.master.psel <= 0;
  this.vif.master.penable <= 0;
endtask

task apb_master_driver::drive_bus();
  case(req.trs_t)
    RD: mbox.put(req);
    WR: mbox.put(req);
    default:
      `uvm_fatal("UNXPCTDPKT",
      $sformatf("receives an unexpected item: %s", req.sprint()))
  endcase
endtask

`endif // end of __APB_MASTER_DRIVER_SV__

