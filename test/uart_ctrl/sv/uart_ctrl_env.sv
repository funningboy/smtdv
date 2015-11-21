
`include "uart_ctrl_defines.svh"

// apb env cluster
// only use 1 master
class apb_cluster0
  extends
  `APB_ENV

  parameter ADDR_WIDTH = `APB_ADDR_WIDTH;
  parameter DATA_WIDTH = `APB_DATA_WIDTH;

  `APB_RST_VIF apb_rst_vif;

  smtdv_reset_model #(`APB_RST_VIF) apb_rst_model;

// UVM_REG: Point to the Register Model
    uart_ctrl_reg_model_c reg_model;
    // Adaptor sequence and predictor
    `APB_REG_ADAPTER reg2apb;
    uvm_reg_predictor#(`APB_ITEM) apb_predr;
    uart_ctrl_reg_sequencer reg_seqr;

  `uvm_component_param_utils_begin(`APB_ENV)
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
    start_addr = `APB_START_ADDR(1)
    end_addr = `APB_END_ADDR(1)
    master_cfg[0].add_slave(slave_cfg[1], 1, start_addr, end_addr);

    master_agent[0] = `UART_APB_S_AGENT::type_id::create({$psprintf("master_agent[%0d]", 0)}, this);
    uvm_config_db#(uvm_bitstream_t)::set(null, "/.+master_agent[*0]*/", "is_active", UVM_ACTIVE);
    uvm_config_db#(`UART_APB_S_CFG)::set(null, "/.+master_agent[*0]*/", "cfg", master_cfg[0]);

    // override cover group to system define
    master_agent[0].mon.del(master_agent[0].mon.th4);
    master_covgroup[0] = `UART_APB_S_COVER_GROUP::type_id::create({$psprintf("uart_apb_s_cover_group")})
    master_agent[0].mom.add(master_covgroup[0])

    // resetn
    apb_rst_model = smtdv_reset_model#(`APB_RST_VIF)::type_id::create("apb_rst_model");
    if(!uvm_config_db#(`APB_RST_VIF)::get(this, "", "apb_rst_vif", apb_rst_vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".apb_rst_vif"});
    apb_rst_model.create_rst_monitor(apb_rst_vif);

    reg2apb = `APB_REG_ADAPTER::
    apb_predr =
    reg_seqr =
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    apb_predr.map = reg_model.default_map;
    apb_predr.adapter = reg2apb;
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    apb_rst_model.add_component(this);
    apb_rst_model.set_rst_type(ALL_RST);
    apb_rst_model.show_components(0);
  endfunction

  virtual function void
    if (master_cfg[0].find_slave(item.addr)>=0) begin
      if (item.trs_t == WR) begin
        write_effects(item);
      end
      else if (item.trs_t == RD) begin
        read_effects(item);
      end
    end


endclass


class uart_env
  smtdv_env


endclass


class uart_ctl_env
  extends
    smtdv_env


