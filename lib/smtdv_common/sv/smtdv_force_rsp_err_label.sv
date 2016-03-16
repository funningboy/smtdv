`ifndef __SMTDV_FORCE_RSP_ERR_LABEL_SV__
`define __SMTDV_FORCE_RSP_ERR_LABEL_SV__

typedef class smtdv_cfg;
typedef class smtdv_component;
typedef class smtdv_sequence_item;
typedef class smtdv_cfg_label;

class smtdv_force_rsp_err_label#(
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

  typedef smtdv_force_rsp_err_label#(ADDR_WIDTH, DATA_WIDTH, CFG, CMP, T1) label_t;

  `uvm_object_param_utils_begin(label_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_force_rsp_err_label", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void set(meta_t meta);
    cfgtb = '{
        ufid: 0,
        desc: {$psprintf("force set cfg.has_error %d", meta.data)},
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
                        left: 2,
                        right: 2,
                        def: 0,
                        val: 1,
                        desc: "force err rsp back, do as UVC behavior"
                    }
                }
            }
        }
    };
  endfunction : set


  virtual function void callback();
    super.callback();

    if (cfgtb.rows.size() != 1)
      `uvm_error("SMTDV_FORCE_RSP_ERR_LABEL",
          {$psprintf("cfg.rows.size() == 1 FAIL")})

    row = cfgtb.rows[0];
    if (row.cols.size() != 1)
      `uvm_error("SMTDV_FORCE_RSP_ERR_LABEL",
          {$psprintf("cfg.rows[0].cols.size() == 1 FAIL")})

    col = row.cols[0];

    if (col.left!=2 && col.right!=2)
      `uvm_error("SMTDV_FORCE_RSP_ERR_LABEL",
          {$psprintf("cfg.rows[0].cols[0] range must be [2:2] FAIL")})

    if (row.trs == WR)
      cfgtb.cfg.has_error = row.data[col.left-:1];
    else
      row.data[col.left-:1] = cfgtb.cfg.has_error;

    cfgtb.desc = {$psprintf("force set cfg.has_error %d", cfgtb.cfg.has_error)};

  endfunction : callback

endclass : smtdv_force_rsp_err_label

`endif // __SMTDV_FORCE_RSP_ERR_LABEL_SV__

