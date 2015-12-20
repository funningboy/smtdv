
`ifndef __SMTDV_CFG_label_SV__
`define __SMTDV_CFG_label_SV__

typedef class smtdv_sequence_item;
typedef class smtdv_cfg;
typedef class smtdv_component;

// smtdv register updated cfg label while after setting reg cfg
//
class smtdv_cfg_label #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH,DATA_WIDTH),
  type CFG = smtdv_cfg,          // need to update cfg
  type CMP = smtdv_component     // belong to which cmp
) extends
  smtdv_label#(CMP);

  typedef struct {
    bit [0:0] match;
    bit [ADDR_WIDTH-1:0] addr;
    bit [DATA_WIDTH-1:0] mask;
    bit [DATA_WIDTH-1:0] data;
    bit require;
    string depent;
    bit visit;
  } rule;

  T1 item;   // notify item get
  CFG cfg;   // notify cfg put

  string rulenm;
  rule maps[string];

  `uvm_object_param_utils_begin(smtdv_cfg_label#(ADDR_WIDTH, DATA_WIDTH, T1, CFG, CMP))
  `uvm_object_utils_end

  function new(string name = "smtdv_label", CFG cfg=null, CMP parent=null);
    super.new(name, parent);
    cfg = cfg;
  endfunction

  extern virtual function void run();
  extern virtual function bit ready_to_update();
  extern virtual function void ready_to_clear();
  extern virtual function CFG update_cfg();
  extern virtual function void update_item(T1 iitem);
  extern virtual function void flush();

endclass : smtdv_cfg_label

function void smtdv_cfg_label::update_item(T1 iitem);
  item = iitem;
endfunction : update_item

function void smtdv_cfg_label::run();
  while (maps.next(rulenm)) begin
    foreach(item.addrs[i]) begin
      if (item.addrs[i] == maps[rulenm].addr) begin
        if (maps[rulenm].match) begin
          if (item.unpack_data(i) & maps[rulenm].mask == maps[rulenm].data) begin
            maps[rulenm].visit = TRUE;
          end
        end
        else begin
          maps[rulenm].data = item.unpack_data(i) & maps[rulenm].mask;
          maps[rulenm].visit = TRUE;
        end
      end
    end
  end
endfunction : run

function bit smtdv_cfg_label::ready_to_update();
  while (maps.next(rulenm)) begin
    if (maps[rulenm].visit == FALSE && maps[rulenm].require == TRUE) begin
      return FALSE;
    end
  end
  return TRUE;
endfunction : ready_to_update

function void smtdv_cfg_label::ready_to_clear();
  while (maps.next(rulenm)) begin
    maps[rulenm].visit = FALSE;
  end
endfunction : ready_to_clear

function void smtdv_cfg_label::flush();
  ready_to_clear();
endfunction : flush

function smtdv_cfg_label::CFG smtdv_cfg_label::update_cfg();
  return cfg;
endfunction : update_cfg


class



`endif // __SMTDV_CFG_label_SV__
