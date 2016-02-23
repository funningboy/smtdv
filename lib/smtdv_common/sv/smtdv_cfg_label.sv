
`ifndef __SMTDV_CFG_label_SV__
`define __SMTDV_CFG_label_SV__

typedef class smtdv_sequence_item;
typedef class smtdv_cfg;
typedef class smtdv_component;
typedef class smtdv_run_label;

/*
* ex:
'{
    addr: 0x0,
    mask: 0xf,
    data: 0x1,
    require: TRUE,
    depend: -1,
    visit: FALSE
}
desc:
func: magt.cfg.force;
*/

/*
* smtdv register updated cfg label while after setting reg cfg
*
* @class smtdv_cfg_label#
*/
class smtdv_cfg_label#(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32,
  type T1 = smtdv_sequence_item#(ADDR_WIDTH,DATA_WIDTH),
  type CFG = smtdv_cfg,          // need to update cfg
  type CMP = smtdv_component     // belong to which cmp
) extends
  smtdv_run_label#(CMP);

  typedef smtdv_cfg_label#(ADDR_WIDTH, DATA_WIDTH, T1, CFG, CMP) label_t;

  /* declare rule table */
  typedef struct {
    bit [0:0] match;
    bit [ADDR_WIDTH-1:0] addr;
    bit [DATA_WIDTH-1:0] mask;
    bit [DATA_WIDTH-1:0] data;
    bit require;
    int depend; // depend on index correlation
    bit visit;
  } rule_t;

  typdef struct {
    rule_t rule;
    uvm_void func; // callback func
    string desc;
  } cfgtb_t;

  T1 item;   // notify item get
  CFG cfg;   // notify cfg put

  int idx;
  cfgtb_t cfgtb;

  `uvm_object_param_utils_begin(label_t)
  `uvm_object_utils_end

  function new(string name = "smtdv_label", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  extern virtual function void pre_do();
  extern virtual function void run();
  extern virtual function void post_do();
  extern virtual function bit ready_to_update();
  extern virtual function void ready_to_clear();
  extern virtual function void update_item(T1 iitem);
  extern virtual function void flush();

endclass : smtdv_cfg_label

/*
*  that should be called at monitor thread when latest even trigger
*/
function void smtdv_cfg_label::update_item(smtdv_cfg_label::T1 iitem);
  item = iitem;
endfunction : update_item


/*
* check no circular dependency at lookup table
*/
function void smtdv_cfg_label::pre_do();
  while (lookup.next(idx)) begin
    sorted[idx] = lookup[idx].rule.dependency;
  end
  sorted.sort
endfunction : pre_do

/*
* visit lookup table and update while item updated
*/
function void smtdv_cfg_label::run();
  while (lookup.next(idx)) begin
    foreach(item.addrs[i]) begin
      if (item.addrs[i] == lookup[idx].rule.addr) begin
        // if match, compare data and expected value is eq
        if (lookup[idx].rule.match) begin
          if (item.unpack_data(i) & lookup[idx].rule.mask == lookup[idx].rule.data) begin
            lookup[idx].rule.visit = TRUE;
          end
        end
        //collect item data
        else begin
          lookup[idx].rule.data = item.unpack_data(i) & lookup[idx].rule.mask;
          lookup[idx].rule.visit = TRUE;
        end
      end
    end
  end
endfunction : run


function bit smtdv_cfg_label::ready_to_update();
  while (lookup.next(idx)) begin
    if (lookup[idx].rule.visit == FALSE && lookup[idx].rule.require == TRUE) begin
      return FALSE;
    end
  end
  return TRUE;
endfunction : ready_to_update


function void smtdv_cfg_label::ready_to_clear();
  while (lookup.next(idx)) begin
    lookup[idx].rule.visit = FALSE;
  end
endfunction : ready_to_clear


function void smtdv_cfg_label::flush();
  ready_to_clear();
endfunction : flush


`endif // __SMTDV_CFG_label_SV__
