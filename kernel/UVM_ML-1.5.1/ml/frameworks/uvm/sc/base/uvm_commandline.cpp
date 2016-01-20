//----------------------------------------------------------------------
//   Copyright 2012 Advanced Micro Devices Inc.
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

#include "uvm_commandline.h"

namespace uvm {

const std::string FILE_FLAG = "-F";

//------------------------------------------------------------------------------
// Constructor: uvm_commandline
//------------------------------------------------------------------------------
uvm_commandline::uvm_commandline()
{
}

//------------------------------------------------------------------------------
// Destructor: uvm_commandline
//------------------------------------------------------------------------------
uvm_commandline::~uvm_commandline()
{
}

//------------------------------------------------------------------------------
// Function: execute()
//   Process the commandline arguments
//------------------------------------------------------------------------------
void uvm_commandline::execute(int argc, char **argv)
{
  std::string str;
  std::string file_name;
  std::string file_ext;
  size_t pos;
  uvm_commandline_plugin *p_plugin = NULL;

  // First argument is always the executable
  // If less than 2 arg, then no commandline
  if (argc < 2) return;

  // Loop through commandline arguments
  for (int i = 0; i < argc; i++)
  {
    str = argv[i];
    if (str == FILE_FLAG)
    {
      file_name = argv[i+1];
      pos = file_name.find(".");
      file_ext = file_name.substr(pos + 1);
      p_plugin = _plugin_map[file_ext];

      if (p_plugin != NULL)
        p_plugin->execute(file_name);
    }
  }
}


} // namespace



