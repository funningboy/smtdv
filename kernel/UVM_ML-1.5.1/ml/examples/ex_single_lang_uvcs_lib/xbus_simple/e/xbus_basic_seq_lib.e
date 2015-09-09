/*-------------------------------------------------------------------------  
File name   : xbus_basic_seq_lib.e
Title       : ACTIVE master sequence lib
Project     : XBus UVC
Created     : 2008
Description : This file provides basic sequences for the master.
Notes       : 
-------------------------------------------------------------------------*/ 

<'

package cdn_xbus;
'>

<'
extend xbus_master_sequence_kind : [WRITE_TRANSFER,
                                    READ_TRANSFER,
                                    WRITE_AND_READ];

extend WRITE_TRANSFER xbus_master_sequence {
    -- This field specifies the base address
    base_addr : uint(bits:16);
        keep soft base_addr == 0;
    
    size : uint;
      keep size in [1, 2, 4, 8];
    
    -- This field contains the payload of the frame to be written.
    data      : uint(bits:64);
    
    body() @driver.clock is only {
        write(size, base_addr, data);
    }; -- body()
};

extend READ_TRANSFER xbus_master_sequence {
    -- This field specifies the base address
    base_addr : uint(bits:16);
        keep soft base_addr in [0,0x7ff0 ];
    
    size : uint;
      keep size in [1, 2, 4, 8];
    
    -- This field contains the payload of the frame to be written.
    data      : uint(bits:64);
    
    body() @driver.clock is only {
        data = read(size, base_addr);
    }; -- body()
};

extend WRITE_AND_READ xbus_master_sequence {
    -- This field specifies the base address
    base_addr : uint(bits:16);
        keep soft base_addr == 0;
    
    -- This field contains the payload of the frame to be written.
    data : byte;

    !write_transfer : WRITE_TRANSFER xbus_master_sequence;
    !read_transfer  : READ_TRANSFER xbus_master_sequence;
    
    body() @driver.clock is only {
    
        do write_transfer keeping {
            .base_addr == base_addr;
            .data == data;
        };
        do read_transfer keeping {
            .base_addr == base_addr;
        };
    }; -- body()
};

extend xbus_master_sequence_kind : [SEQ_WRITES_AND_READS];

extend SEQ_WRITES_AND_READS xbus_master_sequence {
     -- This field specifies the base address
    base_addr : uint(bits:16);
        keep soft base_addr == 0;

    start_data : byte;
        keep soft start_data == 0;
    
    !wr_seq: WRITE_AND_READ xbus_master_sequence;
    
    seq_length : uint;
         keep soft seq_length in [5..15];
    
    body() @driver.clock is only {
        for i from 0 to seq_length-1 {
            do wr_seq keeping {
                .base_addr == base_addr + i;
                .data == start_data + i;
            };
        };
    };   
};


'>


 
