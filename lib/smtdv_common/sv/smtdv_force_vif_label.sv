
`ifndef __SMTDV_FORCE_VIF_LABEL_SV__
`define __SMTDV_FORCE_VIF_LABEL_SV__

typedef class smtdv_cfg;
typedef class smtdv_component;
typedef class smtdv_sequence_item;
typedef class smtdv_cfg_label;


class smtdv_force_vif_label#(
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

  typedef smtdv_force_vif_label#(ADDR_WIDTH, DATA_WIDTH, CFG, CMP, T1) label_t;

  typedef struct {
    trs_type_t trs;
    bit [ADDR_WIDTH-1:0] addr;
    bit [DATA_WIDTH-1:0] data;
    CMP cmp;
    CFG cfg;
  } meta_t;
  meta_t meta;


  `uvm_object_param_utils_begin(label_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_force_vif_label", uvm_component parent=null);
    super.new(name, parent);
    register(parent);

    cfgtb = '{
        ufid: 0,
        desc: {$psprintf("force set cfg.has_force as %d", meta.data)},
        cmp: cmp,
        cfg: cfg,
        rows: '{
            '{
                urid: 0,
                addr: meta.addr,
                data: meta.data,
                trs: meta.trs,
                attr: '{
                    match: TRUE,
                    require: TRUE,
                    depends: '{-1},
                    visit: FALSE
                },
                cols: '{
                    '{
                        ucid: 0,
                        left: 0,
                        right: 0,
                        def: 0,
                        val: 1,
                        desc: "force vif, default 1"
                    }
                }
            }
        }
    };

  endfunction : new

  virtual function void set(meta_t data);
    meta = '{
        trs: data.trs,
        addr: data.addr,
        data: data.data,
        cmp: data.cmp,
        cfg: data.cfg
    };
  endfunction : set

  virtual function void callback();

    if (cfgtb.rows.size() != 1)
      `uvm_error("SMTDV_FORCE_VIF_LABEL",
          {$psprintf("cfg.rows.size() == 1 FAIL")})

    row = cfgtb.rows[0];
    if (row.cols.size() != 1)
      `uvm_error("SMTDV_FORCE_VIF_LABEL",
          {$psprintf("cfg.rows[0].cols.size() == 1 FAIL")})

    col = row.cols[0];

    if (col.left!=0 && col.right!=0)
      `uvm_error("SMTDV_FORCE_VIF_LABEL",
          {$psprintf("cfg.rows[0].cols[0] range must be [0:0] FAIL")})

    if (row.trs == WR)
      cfgtb.cfg.has_force = row.data[col.left-:1];
    else
      row.data[col.left-:1] = cfgtb.cfg.has_force;

  endfunction : callback

endclass : smtdv_force_vif_label

`endif // __SMTDV_FORCE_VIF_LABEL_SV__

