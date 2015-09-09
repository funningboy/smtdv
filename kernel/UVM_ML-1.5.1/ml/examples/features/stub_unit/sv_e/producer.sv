
class producer #(type T=operation) extends uvm_component;

 uvm_get_imp #(T, producer) get_imp;
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
      get_imp = new("get_imp", this);
      `uvm_info(get_type_name(),"SV producer::new",UVM_LOW);
   endfunction
   
   typedef producer#(T) prod_type;
   `uvm_component_utils_begin(prod_type)
   `uvm_component_utils_end
    
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(),"SV producer::build",UVM_LOW);
   endfunction
   
   //get functions implementation
   virtual task get(output T obj);
      int res;
      obj = new;
      res = obj.randomize();
      `uvm_info(get_type_name(),$sformatf("SV producre sending a = %0d b = %0d", obj.a, obj.b),UVM_LOW);
      #10ns;
   endtask // get
   
   virtual function bit try_get(output T obj);
      int  res;
      obj = new;
      res = obj.randomize();
      `uvm_info(get_type_name(),$sformatf("SV producre sending a = %0d b = %0d", obj.a, obj.b),UVM_LOW); 
   endfunction // try_get
   
   virtual function bit can_get();
      `uvm_info(get_type_name(),$sformatf("going to return %d",can_get),UVM_LOW);
   endfunction 
   
   
   
endclass