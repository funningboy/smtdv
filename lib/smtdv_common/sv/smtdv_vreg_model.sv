class smtdv_vip_vreg extends uvm_reg;

   uvm_reg_field REVISION_ID;
   uvm_reg_field CHIP_ID;
   uvm_reg_field PRODUCT_ID;

   function new(string name = "smtdv_vip_vreg");
      super.new(name,32,UVM_NO_COVERAGE);
   endfunction

   virtual function void build();
      this.REVISION_ID = uvm_reg_field::type_id::create("REVISION_ID");
          this.CHIP_ID = uvm_reg_field::type_id::create("CHIP_ID");
       this.PRODUCT_ID = uvm_reg_field::type_id::create("PRODUCT_ID");

      this.REVISION_ID.configure(this, 8,  0, "RO",   0, 8'h03, 1, 0, 1);
          this.CHIP_ID.configure(this, 8,  8, "RO",   0, 8'h5A, 1, 0, 1);
       this.PRODUCT_ID.configure(this, 10, 16,"RO", 0, 10'h176, 1, 0, 1);
   endfunction

   `uvm_object_utils(smtdv_vip_vreg)

endclass : smtdv_vip_vreg



class smtdv_force_vif_vreg extends uvm_reg;

   uvm_reg_field value;

   function new(string name = "dut_DATA");
      super.new(name,32,UVM_NO_COVERAGE);
   endfunction

   virtual function void build();
      this.value = uvm_reg_field::type_id::create("value");
      this.value.configure(this, 32, 0, "RW", 1, 32'h0, 1, 0, 1);
   endfunction

   `uvm_object_utils(dut_DATA)

endclass
