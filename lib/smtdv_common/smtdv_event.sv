
`ifndef __SMTDV_EVENT_SV__
`define __SMTDV_EVENT_SV__

class smtdv_event extends uvm_object;

  `uvm_object_param_utils_begin(smtdv_event)
  `uvm_object_utils_end

  function new(string name = "smtdv_event");
    super.new(name);
  endfunction

endclass

// smtdv register updated cfg event while after setting reg cfg
//
class smtdv_cfg_evt #(
  ADDR_WIDTH = 14,
  DATA_WIDTH = 32
) extends
  smtdv_event;

  typedef struct {
    bit [0:0] match;
    bit [ADDR_WIDTH-1:0] addr;
    bit [DATA_WIDTH-1:0] mask;
    bit [DATA_WIDTH-1:0] data;
    bit require;
    string depent;
    bit visit;
  } rule;

  // virtual TLM notify item get
  smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item;
  // virtual updated cfg
  smtdv_cfg cfg;

  string rulenm;
  rule maps[string];

  `uvm_object_param_utils_begin(smtdv_cfg_evt#(ADDR_WIDTH, DATA_WIDTH))
  `uvm_object_utils_end

  function new(string name = "smtdv_event", smtdv_cfg cfg=null, smtdv_sequence_item#(ADDR_WIDTH, DATA_WIDTH) item=null);
    super.new(name);
    cfg = cfg;
    item = item;
  endfunction

  virtual function void pre_do();
  endfunction

  virtual function void run();
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
  endfunction

  virtual function bit ready_to_update();
    while (maps.next(rulenm)) begin
      if (maps[rulenm].visit == FALSE && maps[rulenm].require == TRUE) begin
        return FALSE;
      end
    end
    return TRUE;
  endfunction

  virtual function void ready_to_clear();
    while (maps.next(rulenm)) begin
      maps[rulenm].visit = FALSE;
    end
  endfunction

  virtual function void update_cfg();
  endfunction

endclass




`endif // __SMTDV_EVENT_SV__
