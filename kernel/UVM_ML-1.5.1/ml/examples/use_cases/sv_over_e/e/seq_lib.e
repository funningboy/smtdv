//----------------------------------------------------------------------
//   Copyright 2008-2010 Cadence Design Systems, Inc.
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
// Define layering sequence in master and slave sequencers
extend xbus_master_sequence_kind : [ML_MASTER_SERVICE_SEQ];


----------------------- MASTER SERVICE SEQ ------------------------------
// Layering sequence
extend ML_MASTER_SERVICE_SEQ xbus_master_sequence {
   do_user_seq(p : ml_seq) @ driver.clock is empty;
};

// exported sequences
struct WRITE_TRANSFER like ml_seq {
   % base_addr : uint(bits:16);
   % size      : uint;
   % data      : uint(bits:64);
}; // struct WRITE_TRANSFER

extend ML_MASTER_SERVICE_SEQ xbus_master_sequence {
   !wt_user_seq : WRITE_TRANSFER xbus_master_sequence;
   
   do_user_seq(p : ml_seq) @ driver.clock is also {
      if(p.kind == "WRITE_TRANSFER") {
         do wt_user_seq keeping {
            .base_addr == p.as_a(WRITE_TRANSFER).base_addr;
            .size == p.as_a(WRITE_TRANSFER).size;
            .data == p.as_a(WRITE_TRANSFER).data;
         }; // do wt_user_seq
      };
   }; // do_user_seq()
};


struct READ_TRANSFER like ml_seq {
   % base_addr : uint(bits:16);
   % size      : uint;
   % data      : uint(bits:64);
}; // struct READ_TRANSFER

extend ML_MASTER_SERVICE_SEQ xbus_master_sequence {
   !rt_user_seq : READ_TRANSFER xbus_master_sequence;
   
   do_user_seq(p : ml_seq) @ driver.clock is also {
      if(p.kind == "READ_TRANSFER") {
         do rt_user_seq keeping {
            .base_addr == p.as_a(READ_TRANSFER).base_addr;
            .size == p.as_a(READ_TRANSFER).size;
            .data == p.as_a(READ_TRANSFER).data;
         }; // do rt_user_seq
         p.as_a(READ_TRANSFER).data=rt_user_seq.data;         
      };
   }; // do_user_seq()
};

'>

