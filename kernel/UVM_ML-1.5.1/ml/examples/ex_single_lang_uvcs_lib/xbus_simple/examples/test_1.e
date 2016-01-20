/*------------------------------------------------------------------------- 
File name   : test_1.e
Title       : XBus eVC demo - example testcase file
Description : Example testcase file for demo purposes.
            : Master_0 sends 10..12 transfers
            : The slaves respond with error for every transfer longer than 4
            : Slave_0 responds on transfers addessed to 0..0x7fff
--------------------------------------------------------------------------- 
-------------------------------------------------------------------------*/ 

<'
package cdn_xbus;

-- import the eVC configuration file (which in turn imports the XBus eVC)
import xbus_simple/examples/xbus_config;


-- SLAVE_0 responds to all transfers > 4 bytes long with an error in byte
-- position 4.
extend xbus_slave_response_s {
    keep read_only(transfer.size > 4) => error_pos == 4;
}; 

-- Make sure masters expect errors as described above.
extend MASTER xbus_trans_s {
    keep read_only(size > 4) =>  error_pos_master == 4;
};

extend MASTER_0 MAIN xbus_master_sequence {
    keep count in [10..12];
};

extend MASTER xbus_trans_s {
    keep addr in [0..0x7fff];
};

extend xbus_bus_monitor_u {
    on transfer_end {
        message(LOW, "bus_monitor saw transfer sent from ",
                transfer.master_name, 
                " of length ", transfer.data.size(), 
                transfer.error_pos_mon == 0 ? "" : " and Error raised"); 
    };
};
'>


