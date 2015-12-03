`ifndef __APB_MONITOR_SV__
`define __APB_MONITOR_SV__

typedef class apb_slave_sequencer;

class apb_monitor #(
  ADDR_WIDTH  = 14,
  DATA_WIDTH = 32
  ) extends
    smtdv_monitor#(
      `APB_VIF,
      smtdv_cfg
      );

  `APB_SLAVE_SEQUENCER seqr;

  /* tlm analysis port to dumper/scoreboard or third part golden model(c/systemc) */
  uvm_analysis_port #(`APB_ITEM) item_collected_port;
  uvm_analysis_port #(`APB_ITEM) item_asserted_port;
  mailbox #(`APB_ITEM) cbox;
  mailbox #(`APB_ITEM) ebox;

  `APB_COLLECT_WRITE_ITEMS th0;
  `APB_COLLECT_READ_ITEMS th1;
  `APB_COLLECT_STOP_SIGNAL th2;
  `APB_COLLECT_COVER_GROUP th3;
  `APB_EXPORT_COLLECTED_ITEMS th4;

  `uvm_component_param_utils_begin(`APB_MONITOR)
  `uvm_component_utils_end

  function new (string name = "apb_monitor", uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
    item_asserted_port = new("item_asserted_port", this);
    cbox = new();
    ebox = new();
  endfunction

  // register thread to thread handler
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    th0 = `APB_COLLECT_WRITE_ITEMS::type_id::create("apb_collect_write_items"); th0.cmp = this; this.th_handler.add(th0);
    th1 = `APB_COLLECT_READ_ITEMS::type_id::create("apb_collect_read_items");   th1.cmp = this; this.th_handler.add(th1);
    th2 = `APB_COLLECT_STOP_SIGNAL::type_id::create("apb_collect_stop_signal"); th2.cmp = this; this.th_handler.add(th2);
    th3 = `APB_COLLECT_COVER_GROUP::type_id::create("apb_collect_cover_group"); th3.cmp = this; this.th_handler.add(th3);
    th4 = `APB_EXPORT_COLLECTED_ITEMS::type_id::create("apb_export_collected_items"); th4.cmp = this; this.th_handler.add(th4);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    // populate vif to child
    if(seqr == null) begin
      if(!uvm_config_db#(`APB_SLAVE_SEQUENCER)::get(this, "", "seqr", seqr))
      `uvm_warning("NOSEQR",{"slave sequencer must be set while slave is on UVM_ACTIVE: ",get_full_name(),".seqr"});
    end
  endfunction

endclass

`endif // end of __APB_MONITOR_SV__

