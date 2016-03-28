`ifndef __SMTDV_RSP_BACK_THREADS_SV__
`define __SMTDV_RSP_BACK_THREADS_SV__

typedef class smtdv_driver;

class smtdv_rsp_back#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CMP = smtdv_driver,
  type REQ = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
  smtdv_run_thread#(CMP);

  REQ ritem, item;

  typedef smtdv_master_cfg mst_cfg_t;
  typedef smtdv_rsp_back#(ADDR_WIDTH, DATA_WIDTH, CMP, REQ) rsp_back_t;

  mst_cfg_t mst_cfg;

  `uvm_object_param_utils_begin(rsp_back_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_rsp_back", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual task run();

endclass : smtdv_rsp_back


task smtdv_rsp_back::run();
  int founds[$];

  fork
    forever begin

      this.cmp.mon_get_port.get(item);
      wait(item.addr_complete && item.data_complete);

      if ($cast(mst_cfg,this.cmp.cfg)) begin

        this.cmp.bbox.find_idxs(item, founds);
        if (founds.size()!=1) begin
          `uvm_error("SMTDV_RSP_UPDATE",
              {$psprintf("RSP UPDATE BACK FAIL")})

          `uvm_info(get_full_name(),
            {$psprintf("mon get %s", item.sprint())}, UVM_LOW)

          this.cmp.bbox.dump(4);
        end

        this.cmp.bbox.async_get(founds[0], 0, ritem);
        this.cmp.update_rsp_back(ritem, item);

      end

      if (this.cmp.cfg.has_debug)
        update_timestamp();

    end
  join_none
endtask : run


`endif // __SMTDV_RSP_BACK_THREADS_SV__
