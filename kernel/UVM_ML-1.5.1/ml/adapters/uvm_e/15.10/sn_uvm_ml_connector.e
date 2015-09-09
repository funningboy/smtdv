<'

//API methods defined in sn_uvm_ml
extend sn_ML_LIB_adapter {
    internal_find_connector_id(name: string) : int is undefined;
    internal_find_port_by_name(name: string) : any_port is undefined;
    internal_add_connector_for_port(p: any_port): int is undefined;
    internal_id_not_found(p:any_port,give_error:bool) :int is undefined;
};

////////////////////////////////////

struct sn_uvm_ml_map_id_port {
    port: any_port;
    id: int;
};

extend sn_ML_LIB_adapter {

    connector_list : list of any_port;
    connector_id_list: list (key: port) of sn_uvm_ml_map_id_port;
  
    /////////////////////////////////////////////////////////////
    // E implementation of the backplane required API function 
    // Returns a backplane connector id find_connector_id_by_name
    /////////////////////////////////////////////////////////////
    
    sn_ml_find_connector_id_by_name(name:string) : int is only {
        result = internal_find_connector_id(name); // Looking for already exisiting id
        if (result == UNDEF) { 
            var p: any_port = internal_find_port_by_name(name);
            if (p == NULL) {
                //no need to generate error in case BP is intersted in quering if 
                //SN has that path
                //error(appendf("Specman UVM-ML adapter(find_connector_id_by_name): there is no port/socket matching the name '%s'",name));
                result = -1;
            }
            else {
                result = internal_add_connector_for_port(p); // Note: simple, event etc. ports curently will be flagged as error
                // This method stores additional information so that SN can check that all external ports are properly connected
            };
        };
    };
    
    ///////////////////////////////////////////////////////////////
    // Method for obtaining the backplane id for a port at runtime
    ///////////////////////////////////////////////////////////////
    
    get_connector_id_for_port(p:any_port, issue_error: bool) : int is {
        var map := connector_id_list.key(p);
        if (map != NULL) {
            result = map.id;
        } else {
            result = internal_id_not_found (p, issue_error);
        };
    };
};
'>