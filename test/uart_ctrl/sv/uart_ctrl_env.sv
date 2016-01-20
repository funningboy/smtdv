`ifndef __UART_CTRL_ENV_SV__
`define __UART_CTRL_ENV_SV__

// apb env cluster for power domain issue
// only use 1 master
class uart_cluster0
  extends
  `SMTDV_ENV(apb);

  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 32;

  // UVM_REG: Point to the Register Model
  uart_ctrl_reg_model_c reg_model;
  // Adaptor sequence and predictor
  `APB_REG_ADAPTER reg2apb;
  uvm_reg_predictor#(`APB_ITEM) apb_predr;
  `UART_CTRL_REG_SEQUENCER reg_seqr;

  `uvm_component_param_utils_begin(`UART_CLUSTER0)
    `uvm_field_object(reg_model, UVM_DEFAULT|UVM_REFERENCE)
    `uvm_field_object(reg2apb, UVM_DEFAULT|UVM_REFERENCE)
  `uvm_component_utils_end

  function new(string name = "apb_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // master cfg, agent
    master_cfg[0] = `UART_APB_S_CFG::type_id::create({$psprintf("master_cfg[%0d]", 0)}, this);
    `SMTDV_RAND_WITH(master_cfg[0], {
      has_force == 1;
      has_coverage == 1;
      has_export == 1;
    })
    start_addr = `APB_START_ADDR(0)
    end_addr = `APB_END_ADDR(0)
    master_cfg[0].add_slave(slave_cfg[0], 0, start_addr, end_addr);

    master_agent[0] = `UART_APB_S_AGENT::type_id::create({$psprintf("master_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+master_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(`UART_APB_S_CFG)::set(null, "/.+master_agent[*0]*/", "cfg", master_cfg[0]);

    // Register model create
    reg2apb = `APB_REG_ADAPTER::type_id::create("reg2apb");
    apb_predr = uvm_reg_predictor#(`APB_ITEM)::type_id::create("apb_predr", this);
    reg_seqr = `UART_CTRL_REG_SEQUENCER::type_id::create("reg_seqr", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    apb_predr.map = reg_model.default_map;
    apb_predr.adapter = reg2apb;
  endfunction

  virtual function void write(`APB_ITEM item);
    if (master_cfg[0].find_slave(item.addr)>=0) begin
      if (item.trs_t == WR) begin
        write_effects(item);
      end
      else if (item.trs_t == RD) begin
        read_effects(item);
      end
    end
  endfunction

  virtual function void write_effects(`APB_ITEM item);
    case(item.addr)
      master_cfg[0].start_addr + `LINE_CTRL :
      begin
        this.get_parent().cluster1.master_cfg[0].char_length = item.data_beat[0][0][1:0];
        this.get_parent().cluster1.master_cfg[0].nbstop      = item.data_beat[0][0][2];
        this.get_parent().cluster1.master_cfg[0].parity_en   = item.data_beat[0][0][3];
        this.get_parent().cluster1.master_cfg[0].parity_mode = item.data_beat[0][1][1:0];
        div_en = item.data_beat[0][1][3];
        this.get_parent().cluster1.master_cfg[0].ConvToIntChrl();
        this.get_parent().cluster1.master_cfg[0].ConvToIntStpBt();
      end
      master_cfg[0].start_addr + `DIVD_LATCH1 :
      begin
        if(div_en) begin
          this.get_parent().cluster1.master_cfg[0].baud_rate_gen = item.data_beat[0][0][7:0];
        end
      end
      mater_cfg[0].start_addr + `DIVD_LATCH2 :
      begin
        if(div_en) begin
          this.get_parent().cluster1.master_cfg[0].baud_rate_div = item.data_beat[0][0][7:0];
        end
      end
      default: `uvm_warning("REG2MEM", "Write access not Control/Status Register\n")
endclass


class uart_cluster1
  extends
  `SMTDV_ENV(uart);

  function new(string name = "apb_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // master cfg, agent
    master_cfg[0] = `UART_APB_S_CFG::type_id::create({$psprintf("master_cfg[%0d]", 0)}, this);
    `SMTDV_RAND_WITH(master_cfg[0], {
      has_force == 1;
      has_coverage == 1;
      has_export == 1;
    })


endclass
//
//
//class uart_ctl_env
//  extends
//    smtdv_env
//
//  `APB_RST_VIF apb_rst_vif;

  smtdv_reset_model #(`APB_RST_VIF) apb_rst_model;

    // resetn
    apb_rst_model = smtdv_reset_model#(`APB_RST_VIF)::type_id::create("apb_rst_model");
    if(!uvm_config_db#(`APB_RST_VIF)::get(this, "", "apb_rst_vif", apb_rst_vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".apb_rst_vif"});
    apb_rst_model.create_rst_monitor(apb_rst_vif);

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    apb_rst_model.add_component(this);
    apb_rst_model.set_rst_type(ALL_RST);
    apb_rst_model.show_components(0);
  endfunction

`endif // end of __UART_CTRL_ENV_SV__
