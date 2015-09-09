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

#ifndef UVM_COMMANDLINE_H
#define UVM_COMMANDLINE_H

#include <string>
#include <map>


namespace uvm {

//------------------------------------------------------------------------------
// Class: uvm_commandline_plugin
//  Base class plugin for command line
//------------------------------------------------------------------------------
class uvm_commandline_plugin
{
public:
    uvm_commandline_plugin();
    virtual ~uvm_commandline_plugin();

    virtual void execute(std::string file_name) = 0;
private:
};


//------------------------------------------------------------------------------
// Class: uvm_commandline
//  Process command line arguments
//------------------------------------------------------------------------------
class uvm_commandline 
{
public:
    uvm_commandline();
    ~uvm_commandline();

    void execute(int argc, char **argv);
    void register_plugin(std::string file_ext, uvm_commandline_plugin *plugin);

private:
    std::map<std::string, uvm_commandline_plugin*> _plugin_map;
};

}  // namespace

#endif // UVM_COMMANDLINE_H
