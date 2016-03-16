
`ifndef __SMTDV_FORCE_REPLAY_LABEL_SV__
`define __SMTDV_FORCE_REPLAY_LABEL_SV__

//ph0:  wait DUT is working into idle mode
//ph1:  using force vif to control DUT and switch to UVC ctrl
//ph2:  block (stop) UVC, wait all settings are already
//ph3:  flush all sequences at sequencer
//ph4:  set preload sequence ID to sequencer
//ph5:  start to preload
//ph6:  interrupt while sequence is completed
//ph7:  release UVC ctrl to original DUT

/*
* using FW ctl to replaying img/seq to DUT
*/
class smtdv_force_replay_label#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type CFG = smtdv_cfg,
  type CMP = smtdv_component,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH)
  ) extends
  smtdv_cfg_label#(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .CFG(CFG),
    .CMP(CMP),
    .T1(T1)
  );

  typedef struct {
    trs_type_t trs;
    bit [ADDR_WIDTH-1:0] addr;
    bit [DATA_WIDTH-1:0] data;
    CMP cmp;
    CFG cfg;
  } meta_t;

  typedef smtdv_force_replay_label#(ADDR_WIDTH, DATA_WIDTH, CFG, CMP, T1) label_t;

  `uvm_object_param_utils_begin(label_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_force_replay_label", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void set(meta_t meta);
    cfgtb = '{
        ufid: 0,
        desc: {$psprintf("force set cfg.stlid as %d", meta.data)},
        cmp: meta.cmp,
        cfg: meta.cfg,
        rows: '{
            '{
                urid: 0,
                addr: meta.addr,
                data: meta.data,
                trs: meta.trs,
                attr: '{
                    match: FALSE,
                    require: TRUE,
                    clear: TRUE,
                    depends: '{-1},
                    visit: FALSE
                },
                cols: '{
                    '{
                        ucid: 0,
                        left: 5,
                        right: 3,
                        def: 0,
                        val: 0,
                        desc: "stl id, default 0"
                    }
                }
            }
        }
    };
  endfunction : set

  virtual function void callback();
    super.callback();

    if (cfgtb.rows.size() != 1)
      `uvm_error("SMTDV_FORCE_REPLAY_LABEL",
          {$psprintf("cfg.rows.size() == 1 FAIL")})

    row = cfgtb.rows[0];
    if (row.cols.size() != 1)
      `uvm_error("SMTDV_FORCE_REPLAY_LABEL",
          {$psprintf("cfg.rows[0].cols.size() == 1 FAIL")})

    col = row.cols[0];

    if (col.left!=5 && col.right!=3)
      `uvm_error("SMTDV_FORCE_RSP_ERR_LABEL",
          {$psprintf("cfg.rows[0].cols[0] range must be [5:3] FAIL")})

    if (row.trs == WR)
      cfgtb.cfg.stlid = row.data[col.left-:3];
    else
      row.data[col.left-:3] = cfgtb.cfg.stlid;

    cfgtb.desc =  {$psprintf("force set cfg.stlid as %d", cfgtb.cfg.stlid)};

  endfunction : callback

endclass : smtdv_force_replay_label

`endif // end of __smtdv_FORCE_replay_SV__
