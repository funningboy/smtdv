
`ifndef __SMTDV_GENERIC_MEMORY_SV__
`define __SMTDV_GENERIC_MEMORY_SV__

class smtdv_generic_memory #(ADDR_WIDTH = 64, DATA_WIDTH = 128) extends uvm_object;

  typedef bit [(ADDR_WIDTH-1):0] gene_mem_addr_t;
  typedef bit [(DATA_WIDTH>>3)-1:0][7:0] byte16_t;

  bit has_callback = TRUE;
  smtdv_generic_memory_cb#(ADDR_WIDTH, DATA_WIDTH) mem_cb;

//byte memory[gene_mem_addr_t];
  reg [7:0] memory[gene_mem_addr_t];

  `uvm_object_param_utils_begin(smtdv_generic_memory#(ADDR_WIDTH, DATA_WIDTH))
  `uvm_object_utils_end

  extern function new(string name = "smtdv_generic_memory");
  extern virtual task mem_store_byte(gene_mem_addr_t addr, byte data[], longint cyc);
  extern virtual task mem_load_byte(gene_mem_addr_t addr, int bcnt, ref byte data[], longint cyc);
  extern virtual task mem_store(gene_mem_addr_t addr, byte16_t data[], longint cyc);
  extern virtual task mem_load(gene_mem_addr_t addr, int bcnt, ref byte16_t data[], longint cyc);

endclass : smtdv_generic_memory


/*****
  Task/Function Declaration
*****/

function smtdv_generic_memory::new(string name = "smtdv_generic_memory");
  super.new(name);
  mem_cb = new();
endfunction : new


task smtdv_generic_memory::mem_store(gene_mem_addr_t addr, byte16_t data[], longint cyc);
  byte16_t tmp16;
  byte tmp;

  byte data_byte[];
  int byte_idx;
  data_byte= new[16*data.size()];
  byte_idx= 0;

  for(int i=0; i<data.size(); i++) begin
    tmp16= data[i];
    for(int j=0; j<16; j++) begin
        tmp= byte'(tmp16[j]);
        data_byte[byte_idx]= tmp;
        byte_idx++;
        end
    end

  mem_store_byte(addr, data_byte, cyc);

endtask : mem_store


task smtdv_generic_memory::mem_load(gene_mem_addr_t addr, int bcnt, ref byte16_t data[], longint cyc);
  byte data_byte[];
  byte16_t tmp16;

  int byte16_size= (bcnt >> 4) + ((bcnt % 16) ? 1 : 0);
  int byte16_idx;
  data= new[byte16_size];
  byte16_idx= 0;

  mem_load_byte(addr, bcnt, data_byte, cyc);
  for(int i=0; i<data_byte.size(); i++) begin
    tmp16[i[3:0]]= data_byte[i];
    if((i[3:0] == 4'hf)) begin
      data[byte16_idx]= tmp16;
      byte16_idx++;
      end
    else if(i == (data_byte.size() - 1)) begin
      for(int j=int'(i[3:0]+1); j<16; j++) begin
        tmp16[j[3:0]]= 0;
        end
      data[byte16_idx]= tmp16;
      end
    end
endtask : mem_load


task smtdv_generic_memory::mem_store_byte(gene_mem_addr_t addr, byte data[], longint cyc);
  for(int i=0; i<data.size(); i++) begin
    if(memory.exists(addr+i)) begin
       if(memory[addr+i] == 0) begin
          uvm_report_warning(get_full_name(),
             $sformatf("[@%0t] ### INITIALIZED: Mem Addr 'h%h exists, CONTENT='h%h. ###",
                $time, (addr+i), memory[addr+i]), UVM_MEDIUM);
       end
       else begin
          uvm_report_warning(get_full_name(),
             $sformatf("[@%0t] ### EXISTS: Mem Addr 'h%h exists, CONTENT='h%h. ###",
                $time, (addr+i), memory[addr+i]), UVM_MEDIUM);
       end
    end //if
    memory[addr+i]= data[i];
    if (has_callback) begin void'(mem_cb.mem_store_byte_cb(addr+i, data[i], cyc)); end
    end

endtask : mem_store_byte


task smtdv_generic_memory::mem_load_byte(gene_mem_addr_t addr, int bcnt, ref byte data[], longint cyc);
  data= new[bcnt];
  for(int i=0; i<bcnt; i++) begin
    if(!memory.exists(addr+i)) begin
      byte temp;
      `SMTDV_RAND_VAR(temp)
      memory[addr+i]= temp;
      end
    data[i]= memory[addr+i];
    if (has_callback) begin
      // skip RD cb while accessing MEM, only record wr trx
      //void'(mem_cb.mem_load_byte_cb(addr+i, data[i], cyc));
    end
  end

endtask : mem_load_byte

/*################################
  Class smtdv_generic_memory END
#################################*/

`endif
