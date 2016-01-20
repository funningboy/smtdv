//----------------------------------------------------------------------
//   Copyright 2012 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

<'
import testbench;

// Create and configure the ubus VIP
extend testbench {
   // configure UBUS
   keep uvm_config_set("*", "num_masters", 2);
   keep uvm_config_set("*", "num_slaves", 2);
   keep uvm_config_set("*", "slave0_max", 16'h7fff); // slave 0 address space
   keep uvm_config_set("*", "slave1_max", 16'hffff); // slave 1 address space
   keep uvm_config_set("*", "slave_seq_name", "slave_memory_seq");
}; // extend testbench


// do only sequences from virtual sequencer
extend MAIN ubus_master_sequence {
  keep count == 0;
};


// Main sequence started from virtual sequencer
extend ubus_master_sequence_kind : [WRITE_READ];

// driving write+read UBUS items and sequences
extend WRITE_READ ubus_master_sequence {
   !req     : ubus_transfer;
   !my_seq1 : WRITE_WORD ubus_master_sequence;
   !my_seq2 : READ_WORD ubus_master_sequence;
   
   body() @driver.clock is only {
      var save_ad  : int;
      driver.raise_objection(TEST_DONE);
     
      message(LOW, "WRITE_READ sequence starting ");
      // Write and read back item
      do req keeping {
         .read_write == WRITE;
         .addr in [0 .. 4095];
         .size == 4;
      };
      message(LOW, "wrote item ", hex(req.data));
      save_ad = req.addr;
      do req keeping {
         .read_write == READ;
         .addr == save_ad;
         .size == 4;
      };
      message(LOW, "read item ", hex(req.data));
      wait delay(200 ns);

      // Use remote write_word and read_word sequences from UBUS
      do my_seq1 keeping{
         .exported_seq.start_addr in [0 .. 4095];
         .exported_seq.transmit_del == 0;
      };

      do my_seq2 keeping{
         .exported_seq.start_addr == my_seq1.exported_seq.start_addr;
         .exported_seq.transmit_del == 0;
      };

      wait delay(500 ns); // drain time
    
      driver.drop_objection(TEST_DONE);
   }; // body()
}; // extend WRITE_READ


// Virtual sequence driving the same sequence in two sequencers 
extend MAIN ubus_virt_seq {
   
   body() @driver.clock is only {      
      driver.raise_objection(TEST_DONE);
      message(LOW, "MAIN sequence starting");
      all of {
         {
            do WRITE_READ ubus_sequence keeping 
            {.driver == driver.ubus_driver_0};
         };         
         {
            do WRITE_READ ubus_sequence keeping 
            {.driver == driver.ubus_driver_1};
         };         
      };
      out("TEST PASSED");
      driver.drop_objection(TEST_DONE);
   }; // body()

}; // extend MAIN ubus_virt_seq


'>
