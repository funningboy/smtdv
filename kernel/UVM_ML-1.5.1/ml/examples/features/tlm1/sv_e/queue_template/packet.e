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
struct cppi_pkt_data {
   %val : uint;
   %pkt_data : list of int;
   keep soft pkt_data.size() == 1;
}; // struct cppi_pkt...

struct packet like any_sequence_item {
  %combined : list of cppi_pkt_data;
    to_string() : string is {
        result = appendf("{ val = %d pkt_data = %d}",
         combined[0].val,
         combined[0].pkt_data[0]);
    };
};
struct psi_word like packet {
   %data : int(bits:WIDTH);
}; // struct

'>