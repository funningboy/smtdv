//----------------------------------------------------------------------
//   Copyright 2012 Cadence Design Systems, Inc.
//   Copyright 2012-2013 Advanced Micro Devices Inc.
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

#include <iostream>
#include <string>
#include <sstream>
#include <algorithm> // for copy
#include <iterator> // for ostream_iterator

#include "bp_interconnect.h"
#include "bp_top_descriptor.h"


namespace Bp 
{

// Phase debug
BpInterconnect::BpStopRequestClass BpInterconnect::m_debug_requests;
unsigned int                       BpInterconnect::BpStopRequestClass::m_last_id = 0;
vector<BpInterconnect::BpStopRequestClass::bp_stop_request_struct*> 
                                   BpInterconnect::BpStopRequestClass::m_requests;
string                             BpInterconnect::m_current_phase_name;
bool                               BpInterconnect::m_first_phase;

vector<string>                     BpInterconnect::BpDebugClass::m_command_backlog;

// BpStopRequestClass

BpInterconnect::BpStopRequestClass::BpStopRequestClass () {};

BpInterconnect::BpStopRequestClass::~BpStopRequestClass() {};

// /////////////////////////////////////////////////
// check if stop request is pending for this phase
// /////////////////////////////////////////////////


bool BpInterconnect::BpStopRequestClass::CheckStopRequest(const char *        phase_name, 
                                                          uvm_ml_phase_action phase_action) 
{
    for (unsigned i = 0; i < m_requests.size(); i++) {

        if (m_requests[i]->phase_action == phase_action && 
            !strcmp(m_requests[i]->phase_name.c_str(), phase_name))
        {
          string beginOrEnd;
          switch(m_requests[i]->phase_action)
          {
            case UVM_ML_PHASE_STARTED:
              beginOrEnd = "begin"; 
              break;
            case UVM_ML_PHASE_ENDED:
              beginOrEnd = "end";
              break;
            default:
              break;
          }
          PrintMessage("UVM-ML: Stopping at phase %s %s", m_requests[i]->phase_name.c_str(), beginOrEnd.c_str());
            return true; // found pending request
        } 
    }
    return false; // no pending request for this phase
};

void BpInterconnect::BpStopRequestClass::PrintStop (bp_stop_request_struct * req) 
{ 
    PrintMessage ("UVM-ML: Stop #%d %s %s", req->id, req->phase_name.c_str(), 
             (req->phase_action == UVM_ML_PHASE_STARTED) ? "begin":"end");
}

void BpInterconnect::BpStopRequestClass::CheckPhaseName (bp_stop_request_struct * req) {
    if(!req->checked && !PhaseSrvCheckPhase(req->phase_name.c_str())) {
        ErrorMsg("CheckPhaseName found stop request with unsupported phase '%s'", req->phase_name.c_str());
    }
}


bool BpInterconnect::BpStopRequestClass::RequestStopPhase(const char *phase_name, 
                                                          uvm_ml_phase_action phase_action)
{
    if(m_first_phase) { // phase service provider already initialized
        if(!PhaseSrvCheckPhase(phase_name)) {
            ErrorMsg("Could not set stop on unrecognized phase '%s'", phase_name);
            return false;
        }
        if(!PhaseSrvCheckFuturePhase(phase_name, phase_action)) {
            ErrorMsg("Could not set stop on phase that passed '%s'", phase_name);
            return false;
        }
    }
    if(phase_action != UVM_ML_PHASE_STARTED && phase_action != UVM_ML_PHASE_ENDED) {
      ErrorMsg("Invalid phase action (must be either 'begin' or 'end'");
      return false;
    }
    // skip if already set
    for(unsigned i = 0; i < m_requests.size(); i++) {
        if (!strcmp(m_requests[i]->phase_name.c_str(), phase_name) &&
             m_requests[i]->phase_action == phase_action) return true;
    };
    m_requests.push_back(new bp_stop_request_struct(phase_name, phase_action, m_first_phase));
    return true;
}


// cancel pending request
// ////////////////////////

void BpInterconnect::BpStopRequestClass::CancelStopPhase(const char *        phase_name, 
                                                         uvm_ml_phase_action phase_action)
{
    for (unsigned i = 0; i < m_requests.size(); i++) {
        if (!strcmp(m_requests[i]->phase_name.c_str(), phase_name) &&
             m_requests[i]->phase_action == phase_action) 
        {
            m_requests.erase(m_requests.begin()+i);
            return;
        } 
    }
    ErrorMsg("Request to be canceled was not found");
}

// ////////////////////////
// list pending requests
// ////////////////////////

void BpInterconnect::BpStopRequestClass::ListStopRequests()
{
    std::for_each(m_requests.begin(), m_requests.end(), PrintStop);
}

// ////////////////////////
// Delete a stop request
// ////////////////////////

void BpInterconnect::BpStopRequestClass::DeleteStopRequest(const char * index)
{
    int i;
    i = atoi(index);
    if((i > 0) && (i <= (int) m_last_id)) {
        m_requests.erase(m_requests.begin()+i-1);
    } else {
        ErrorMsg("Illegal index value in delete command");
    }
}

// Get current phase
void BpInterconnect::BpStopRequestClass::GetPhaseRequest()
{
    if (m_srv_providers.phase_srv_provider) {
      if (m_current_phase_name.empty())
        PrintMessage("UVM-ML: Phasing has not been started yet");
      else
        PrintMessage("UVM-ML: Current phase is %s", m_current_phase_name.c_str());
    }
    else
      ErrorMsg("Phasing service provider is not available");
}

// Cancel all phase requests
void BpInterconnect::BpStopRequestClass::CancelPhaseRequests()
{
    for (unsigned i=0; i<m_requests.size(); ) {
        m_requests.erase(m_requests.begin());
    }
}

// ////////////////////////
// Print tree
// ////////////////////////

// Count the number of dots in path
int BpInterconnect::BpCommandPrintTree::count_dots(string name) {
    int cnt = 0;
    std::size_t found = name.find_first_of(".");
    while (found!=std::string::npos) {
        cnt++;
        found=name.find_first_of(".",found+1);
    }
    return cnt;
};


  
bool BpInterconnect::BpCommandPrintTree::IsChildProxy(const string & current_name,
                                                string & target_name,
                                                int * target_ind) 
{
    for (unsigned int j = 0; j < m_child_proxy_registry.size(); j++) {
        if(m_child_proxy_registry[j]->GetName() == current_name) {
            int target_fw = m_child_proxy_registry[j]->GetTargetFrameworkId();
            FrameworkProxyClass * target = GetFramework(target_fw);
            const vector<string> & target_indicators = target->GetIndicators();
            target_name = target_indicators[0];
            *target_ind = target_fw;
            return true;
        };
    };
    return false;
};

bool BpInterconnect::BpCommandPrintTree::IsComponentToTraverse(FrameworkProxyClass * frmw, const string & child_name)
{
  string dummy_name;
  int dummy_index;

  return m_val.show_port || IsChildProxy(child_name, dummy_name, &dummy_index) || !frmw->IsPort(child_name);
}

bool BpInterconnect::BpCommandPrintTree::HasChildrenToTraverse(FrameworkProxyClass * frmw, const string & current_name)
{
  int num = frmw->GetNumChildren(current_name);
  if (num <= 0)
    return false;

  for(int i = 0; i < num; i++) {
    string child_name = frmw->GetChildName(current_name, i);
    if(!child_name.empty()) 
      if (IsComponentToTraverse(frmw, child_name))
        return true;
  }
  return false;
}

bool 
BpInterconnect::BpCommandPrintTree::PrintSubtree(const string & current_name,
                                                 FrameworkProxyClass * frmw,
                                                 string frmw_name,
                                                 string prefix,
                                                 int current_level,
                                                 int root_level, 
                                                 bool skip_proxy, 
                                                 int frmw_name_len) 
{ 
    string target_name;
    int target_index;

    // skip printing if not under requested root and not printing the proxy itself
    if((m_val.root_name.empty() || BpPrefixCompare(m_val.root_name, current_name)) && !skip_proxy) {
        string msg;
        string fw_name = frmw_name.substr(0,frmw_name_len);
        msg = fw_name + ":" + string(frmw_name_len-fw_name.size(), ' ');
        if(m_val.show_full_path) {
            msg += current_name;
        } else { // indented tree
            msg += prefix;
            size_t last = current_name.find_last_of(".");
            msg += current_name.substr(last+1);
        };
        
        if(m_val.show_type) { // add type name
            msg = msg + " [" + frmw->GetComponentTypeName(current_name) + "]";
        };
        if (m_val.depth != -1 
                && current_level == m_val.depth-1+root_level  //truncated due to the depth parameter
                && HasChildrenToTraverse(frmw, current_name)) {
            msg += " .../ ...";
            m_components_unshown_by_depth = true;
        }
        PrintMessage(msg);
    };
    
    // iterate on all child components
    int num = frmw->GetNumChildren(current_name);
    switch(num)
    {
        case -1:
	  if(!IsChildProxy(current_name, target_name, &target_index)) {
	      //In a case of a "sandwitch" hierarchy with the single component in the middle layer, there may be two components
	      //with the same hierarchical name. In this marginal scenario, get_num_children() returns (-1) as it's a wrong hierarchy.
	      //We are working around this issue here.
	      PrintMessage("*** ERROR Could not find number of children for %s", current_name.c_str());
	      return false;
	    }
	    return true;
	case 0:
	    return true;
    } 

    // Update prefix for children
    if(prefix.size() >= 3) {
        if(prefix.substr(prefix.size()-3,prefix.size()) == "\\__") {
            prefix = prefix.substr(0, prefix.size()-3) + "   ";
        };
    };
    if(m_val.depth == -1 || current_level < m_val.depth-1+root_level) { // check max level
        if(prefix == "") prefix = "|__"; 
        else prefix = prefix.substr(0,prefix.size()-2) + "  |__";
        for(int i = 0; i < num; i++) {
            string child_name = frmw->GetChildName(current_name, i);
            if(strcmp(child_name.c_str(), "")) {
                if(i == num-1) 
                    prefix = prefix.substr(0,prefix.size()-3) + "\\__";
                 // recursive call excluding ports unless requested
                if(IsComponentToTraverse(frmw, child_name)) {
		    bool res;
                    if(IsChildProxy(child_name, target_name, &target_index)) {
                        FrameworkProxyClass *target = GetFramework(target_index);
                        res = PrintSubtree(child_name, target, target_name, prefix, current_level+1, root_level, false, frmw_name_len);
			if (!res) return false;
                        // explore children of proxy without printing the proxy itself
                        res = PrintSubtree(child_name, frmw, frmw_name, prefix, current_level+1, root_level, true, frmw_name_len);
                    } else {
                        res = PrintSubtree(child_name, frmw, frmw_name, prefix, current_level+1, root_level, false, frmw_name_len);
                    };
		    if (!res) return false;
                };
            };
        };
        prefix = prefix.substr(0,prefix.size()-3);
    };
    return true;
};


void BpInterconnect::BpCommandPrintConnections::PrintPair(BpConnectionClass * src, BpConnectionClass * trg, const string &arrow, bool show_type) {
  if (!m_item_is_printed)
  {
      PrintMessage("List of UVM-ML connections: ");
      m_item_is_printed = true;
  }
  string msg = src->GetFrmw()->GetName() + ":" + src->GetPath();
  if(show_type) 
    msg += src->GetTypeName();
  PrintMessage(msg);

  msg = arrow + trg->GetFrmw()->GetName()  + ":" + trg->GetPath();
  if(show_type) 
    msg += trg->GetTypeName();
  PrintMessage(msg);
}

int BpInterconnect::BpDebugClass::ExecuteCommand(int              frameworkId,
                                                 const string &   command_with_arguments,
                                                 bp_output_cb_t * outputCb,
                                                 uvm_ml_time_unit timeUnit, 
                                                 double           timeValue)
{

  exec_status exec_status = UVM_ML_UNRECOGNIZED_COMMAND;//assume failure as initial status
  BpPredefinedCommand *predefined_cmd = NULL;
  BpCommandBase *cmd = NULL;

  if ((predefined_cmd = GetCommand(command_with_arguments)) != NULL) 
  {
    switch(predefined_cmd->GetMatchResult())
    {
      case BpCommandOptionsBase::MATCH_CMD_INVALID_OPTIONS:
        return UVM_ML_COMMAND_FAILURE;
      case BpCommandOptionsBase::HELP_OPTION:
        predefined_cmd->PrintCmdHelp();
        return UVM_ML_COMMAND_SUCCESS;
      default:
        break;
    }

    predefined_cmd->ResetAndInit(command_with_arguments, frameworkId);
    BpCommandOptionsBase::parse_status parse_status = 
      predefined_cmd->GetParser()->ParseCheckSyntax(command_with_arguments);

    switch(parse_status)
    {
      case BpCommandOptionsBase::PARSE_FAILURE:
        return UVM_ML_COMMAND_FAILURE;
      case BpCommandOptionsBase::ASKED_FOR_HELP:
        predefined_cmd->PrintCmdHelp();
        return UVM_ML_COMMAND_SUCCESS;
      case UVM_ML_COMMAND_SUCCESS:
        break;
    }
    cmd = predefined_cmd;       
  }
  else 
  {
    if (GenericCmdHelpRequired(command_with_arguments))
    {
      BpPredefinedCommand::PrintGenericCommandHelp();
      return UVM_ML_COMMAND_SUCCESS; 
    }
    //unrecognized command, assumed custom command to be broadcasted
    cmd = BpCustomCommand::GetInstance();
    cmd->ResetAndInit(command_with_arguments, frameworkId);
  }

  try
  {
    cmd->TraceExecute(frameworkId);
    exec_status = cmd->Execute(outputCb, 
                               timeUnit,
                               timeValue);
    cmd->TraceResult(exec_status); 
  }
  catch(int)
  {
    ErrorMsg("execution of the UVM-ML debug command '%s' failed due to exception occured", command_with_arguments.c_str());
    exec_status = UVM_ML_COMMAND_FAILURE;
  }

  return (int)exec_status;
}

void BpInterconnect::BpDebugClass::Reset()
{
    m_command_backlog.clear();
}


vector<BpInterconnect::BpPredefinedCommand *> BpInterconnect::BpPredefinedCommand::m_predef_commands;

void BpInterconnect::BpPredefinedCommand::Init()
{
  if (m_predef_commands.empty())
  {
    m_predef_commands.push_back(GetInstance<BpCommandPrintTree>());
    m_predef_commands.push_back(GetInstance<BpCommandPrintConnections>());
    m_predef_commands.push_back(GetInstance<BpCommandPhase>());
    m_predef_commands.push_back(GetInstance<BpCommandTraceRegister>());
  }
}

BpInterconnect::BpPredefinedCommand *BpInterconnect::BpDebugClass::GetCommand(const string &command_with_arguments)
{
  BpPredefinedCommand::Init();

  vector<BpPredefinedCommand *>::iterator it;
  for(it = BpPredefinedCommand::m_predef_commands.begin(); 
      it != BpPredefinedCommand::m_predef_commands.end(); 
      it++)
  {
    if (*it != NULL)
    {
      BpPredefinedCommand* cmd_ptr = *it;
      if (cmd_ptr->MatchCommand(command_with_arguments))
        return cmd_ptr;
    }
  }    
  return NULL;
}

bool BpInterconnect::BpDebugClass::GenericCmdHelpRequired(const string &command_with_arguments)
{
  string basename = GetToken(command_with_arguments);
  if(!basename.empty())
  {
    if ((basename == "-help") || (basename == "-h"))
      return true;
    if (!isalpha(basename[0])) //the command name should start with character
    {
      ErrorMsg("Invalid UVM-ML debugging command: \"%s\"", command_with_arguments.c_str());
      return true;
    }
  }
  else
    return true;//empty or spaces only - print help

  return false;
}

bool BpInterconnect::BpPredefinedCommand::MatchCommand(const string &command_with_arguments)
{
  m_match_result = MatchesCommandName(command_with_arguments) ? 
    BpCommandOptionsBase::MATCH : 
    BpCommandOptionsBase::MISMATCH;

  return m_match_result == BpCommandOptionsBase::MATCH;
}

bool  BpInterconnect::BpCommandPhase::MatchCommand(const string &command_with_arguments)
{
  SetMandatoryOptionVariant(NO_MANDATORY_VARIANT);

  if (MatchesCommandName(command_with_arguments))
  {
    m_match_result = m_options.MatchMandatoryOption(command_with_arguments);
    return m_match_result != BpCommandOptionsBase::MISMATCH;//returns true for MATCH, MATCH_CMD_INVALID_OPTIONS, HELP_OPTION
  }
  return false;
}

void BpInterconnect::BpPredefinedCommand::PrintGenericCommandHelp()
{
  PrintMessage("Usage:\t\tuvm_ml <command>| -h | -help\nThe predefined commands are: ");
  Init();

  string msg;
  vector<BpPredefinedCommand *>::iterator it;
  for(it = m_predef_commands.begin(); it != m_predef_commands.end(); it++)
  {
    if (*it)
    {
      BpPredefinedCommand *cmd = *it;
      msg += cmd->Name();
      if (*it != m_predef_commands.back())
        msg += ", ";
    }
  } 
  msg += "\nCall <command> -help to get the command-specific information\n";  
  PrintMessage(msg.c_str());
}

void BpInterconnect::BpPredefinedCommand::PrintCmdHelp()
{
  stringstream ss;
  ss << Name();
  copy(m_cmd_help.begin(), m_cmd_help.end(), ostream_iterator<string>(ss, "\n"));
  PrintMessage(ss.str());
}

BpInterconnect::exec_status 
BpInterconnect::BpCommandBase::DoBroadcastCommand(bp_output_cb_t * outputCb,
                                                  uvm_ml_time_unit timeUnit,
                                                  double           timeValue,
                                                  bool addBacklog)
{
  const char *command_with_args = GetExternalCommand().c_str();
  exec_status status = UVM_ML_UNRECOGNIZED_COMMAND;
  
  for (unsigned int i = 0; i < GetFrameworkRegistry().size(); i++)
  {
    FrameworkProxyClass * frmw = GetFrameworkRegistry()[i];
    if (frmw)
    {
      int res = frmw->NotifyCommand(command_with_args, outputCb, timeUnit, timeValue);
      if (res == (int)UVM_ML_COMMAND_FAILURE) 
      {
        ErrorMsg("Command '%s' request failed for framework %s", command_with_args, frmw->GetName().c_str());
        return UVM_ML_COMMAND_FAILURE;
      }
      else if (res == UVM_ML_COMMAND_SUCCESS)
        status = UVM_ML_COMMAND_SUCCESS;
    }
    else
      ErrorMsg("Failed to get framework (%d) for the command %s", i, command_with_args);
  }

  if (addBacklog && (m_elaboration_passed == false))
    BpDebugClass::AddBacklogCommand(command_with_args);

  return status;
}

string BpInterconnect::BpCommandBase::CommandOriginated(int frameworkId)
{
  string origin;
  if (frameworkId == (-1)) origin = "interactively";
  else
    origin = string("by ") + GetFramework(frameworkId)->GetName() + " adapter";

  return origin;
}

void BpInterconnect::BpInternalCommand::TraceExecute(int frameworkId)
{
  DebugTrace("Executing command '%s' originated %s", Name().c_str(), CommandOriginated(frameworkId).c_str());
}

void BpInterconnect::BpInternalCommand::TraceResult(exec_status result)
{
  switch(result)
  {
    case UVM_ML_COMMAND_SUCCESS:
      DebugTrace("Command '%s' passed successfully.", Name().c_str());
      break;
    case UVM_ML_COMMAND_FAILURE:
      DebugTrace("Command '%s' failed%s", 
                 Name().c_str(), 
                 m_execute_err.empty() ? "." : (string(": ") + m_execute_err).c_str());      
      break;
    default:
      assert(false); //internal commands cannot be unrecognized
  }
}


void BpInterconnect::BpExternalCommand::TraceExecute(int frameworkId)
{
  string msg_format = "Broadcasting command '%s' originated %s, to framework adapters";
  if (m_elaboration_passed == false)
    msg_format += ", it is also backlogged for later broadcasting.";
  DebugTrace(msg_format.c_str(), GetExternalCommand().c_str(), CommandOriginated(frameworkId).c_str());
}

void BpInterconnect::BpExternalCommand::TraceResult(exec_status result)
{
  switch(result)
  {
    case UVM_ML_COMMAND_SUCCESS:
      DebugTrace("Command '%s' passed successfully.", GetExternalCommand().c_str());
      break;
    case UVM_ML_COMMAND_FAILURE:
      break; //for broadcasted command failure is reported immediately
    case UVM_ML_UNRECOGNIZED_COMMAND:
      if (m_elaboration_passed == false)
        WarningMsg("No framework had recognized the command request: %s\n"
                   "                     it will be backlogged until the beginning of pre-run phases\n"
                   "                     and it will be tried on each framework that registers itself by that time",
                   GetExternalCommand().c_str());
      else 
        ErrorMsg("No framework had recognized the command request: %s", GetExternalCommand().c_str());
  }
}

void BpInterconnect::BpCustomCommand::TraceExecute(int frameworkId)
{
  DebugTrace("Broadcasting command '%s' originated %s, to framework adapters",  GetExternalCommand().c_str(), CommandOriginated(frameworkId).c_str());
}

void BpInterconnect::BpCustomCommand::TraceResult(exec_status result)
{
  switch(result)
  {
    case UVM_ML_COMMAND_SUCCESS:
      DebugTrace("Command '%s' passed successfully.", GetExternalCommand().c_str());
    case UVM_ML_COMMAND_FAILURE:
      break; //for broadcasted command failure is reported immediately
    case UVM_ML_UNRECOGNIZED_COMMAND:
      if (m_elaboration_passed == false)
        WarningMsg("No framework had recognized command request: %s", GetExternalCommand().c_str());
      else 
        ErrorMsg("No framework had recognized command request '%s'; it might be misspelled", GetExternalCommand().c_str());
  }
}


BpInterconnect::exec_status BpInterconnect::BpCommandPrintTree::Execute(bp_output_cb_t * outputCb,
                                                                        uvm_ml_time_unit timeUnit,
                                                                        double timeValue)
{
  string prefix = "";
  int current_level = 0;
  int root_level = count_dots(m_val.root_name);
  unsigned len = 1;
  bool result = false;

  // ToDo Check if build phase is done

  // find max len of framework name
  for (unsigned int j = 0; j < m_top_level_registry.size(); j++) {
    BpTopDescriptorClass * top = m_top_level_registry[j];
    string frmw_name = top->GetFrameworkIndicator(); //frmw->GetName()
    if(frmw_name.size() > len) len = frmw_name.size();
    FrameworkProxyClass * frmw = top->GetFrmw();
    frmw_name = frmw->GetName();
    if(frmw_name.size() > len) len = frmw_name.size();
  };
  for (unsigned int j = 0; j < m_child_proxy_registry.size(); j++) {
    int target_fw = m_child_proxy_registry[j]->GetTargetFrameworkId();
    FrameworkProxyClass * target = GetFramework(target_fw);
    const vector<string> & target_indicators = target->GetIndicators();
    string frmw_name = target_indicators[0];
    if(frmw_name.size() > len) len = frmw_name.size();
  };

  // Collect the trees of all top components
  for (unsigned int j = 0; j < m_top_level_registry.size(); j++) {
    BpTopDescriptorClass * top = m_top_level_registry[j];
    FrameworkProxyClass * frmw = top->GetFrmw();
    const string & top_name = top->GetInstanceName();
    string root = m_val.root_name.substr(0,m_val.root_name.find_first_of("."));
    
    if(m_val.root_name.empty() || BpPrefixCompare(root, top_name)) {
      string frmw_name = top->GetFrameworkIndicator(); //frmw->GetName()
      bool res = PrintSubtree(top_name, frmw, frmw_name, prefix, current_level, root_level, false, len);
      if (!res)
	return UVM_ML_COMMAND_FAILURE;
    };
  };
  if (m_components_unshown_by_depth)
    PrintMessage("Note: the full tree depth is bigger than %d%s,\n"
                 "      childen of the components followed by '.../ ...' mark are not shown", 
                 m_val.depth, m_options.IsSupplied(DEPTH) ? "" : " (default value)");
  return UVM_ML_COMMAND_SUCCESS;
}

BpInterconnect::BpPredefinedCommand* BpInterconnect::BpCommandPrintTree::m_the_instance = NULL;


BpInterconnect::BpCommandPrintTree::BpCommandPrintTree() : m_options()
{
  const char *m_help_msg[] = { " [-d[epth] depth|all] -s[hort[_path[s]]]] [-p[orts]] [-t[ype]] [-r[oot] path]",
                               "\t-d[epth] depth      the number of levels to display or 'all'",
                               "\t-r[oot] path        the full path to the root node where the display starts",
                               "\t-s[hort[_path[s]]]] display only the component name (short format)",
                               "\t-p[orts]            include ports",
                               "\t-t[ype]             print type names"}; 

  m_command = "print_tree";
  m_options.SetCommand(this);
  SetDefaultsAll();
  m_cmd_help.assign(m_help_msg, m_help_msg+sizeof(m_help_msg)/sizeof(m_help_msg[0]));
}

const BpInterconnect::BpCommandPrintTree::_option_values BpInterconnect::BpCommandPrintTree::m_defaults = {
    3,         //depth
    true,      //show_full_path
    false,     //show_port
    false,     //  show_type
    string("") //   root_name
};


void BpInterconnect::BpCommandPrintTree::SetDefaultsAll()
{
  m_val = m_defaults;
  m_components_unshown_by_depth = false;
};



bool BpInterconnect::BpCommandPrintTree::SetOptionArgument(int optIndex, const char *argumentPtr)
{
  bool result = true;
  
  switch((enum options_descr)optIndex)
  {
    case DEPTH:
    {
      long levels = 0;
      if (0 == strcmp(argumentPtr, "all"))
          levels = -1;
      else
      {
        char *endptr = NULL;
        errno = 0;
        levels = strtol(argumentPtr, &endptr, 10);

        if (errno != 0 || levels <= 0)
        {
           stringstream ss;
           ss << "wrong argument of option -depth \"" << argumentPtr << "\"";
           m_options.ReportError(ss);
           errno = 0;
           result = false;
        }
      }
      if (result)
        m_val.depth = levels;     
    }
    break;
    case ROOT://-root
      m_val.root_name = argumentPtr;
      break;
    default:
      result = false;
      break;
  }
  return result;
}

bool BpInterconnect::BpCommandPrintTree::MissedArgumentError(int optIndex, const char *argumentPtr)
{
  switch((enum options_descr)optIndex)
  {
    case DEPTH:
      if (!argumentPtr || (argumentPtr[0] == '-'))
           m_options.ReportError("missing value parameter for depth option (must be a positive integer or 'all')");
      break;
    case ROOT://-root
      if (!argumentPtr || (argumentPtr[0] == '-'))
           m_options.ReportError("missing path parameter for -root option");
      break;
     default: //the rest of options do not require argument
       break;
  }
  return false; 
}

bool BpInterconnect::BpCommandPrintTree::SetTheOption(int optIndex)
{
  bool result = true;
  switch((enum options_descr)optIndex)
  {
    case FULL_PATH://-short
      m_val.show_full_path = false;
      break;
    case PORTS://-ports
      m_val.show_port = true;
      break;
    case TYPE://-types
      m_val.show_type = true;
      break;
    default:
      result = false;
  }
  return result;
}

BpInterconnect::exec_status BpInterconnect::BpCommandPrintConnections::Execute(bp_output_cb_t * outputCb,
                                                                               uvm_ml_time_unit timeUnit,
                                                                               double timeValue)
{
  vector< BpConnectionClass * >::iterator it;
  vector< BpConnectionClass * >::iterator ot;

  for (it = m_port_registry.begin(); it != m_port_registry.end(); it++) {
    vector<BpConnectionClass *>& fanout = (*it)->GetFanout();
    for(ot = fanout.begin(); ot != fanout.end(); ot++) {
      if(m_val.root_name == "" || (*it)->CheckInRange(m_val.root_name)) {
        PrintPair(*it, *ot, "    -> ", m_val.show_type);
      } else if((*ot)->CheckInRange(m_val.root_name)) {
        PrintPair(*ot, *it, "    <- ", m_val.show_type);
      }
    }
  }
  if (!m_item_is_printed)
    PrintMessage("No UVM-ML connections found.");
  return UVM_ML_COMMAND_SUCCESS;
}

BpInterconnect::BpPredefinedCommand* BpInterconnect::BpCommandPrintConnections::m_the_instance = NULL;


BpInterconnect::BpCommandPrintConnections::BpCommandPrintConnections() : m_options(), m_item_is_printed(false)
{
  const char *m_help_msg[] = {" [-t[ype]] [-r[oot] path]",
                              "\t-r[oot]  path   the full path to the root node where the display starts",
                              "\t-t[ype]         print type names"};

  m_command = "print_connections";
  m_options.SetCommand(this);
  SetDefaultsAll();
  m_cmd_help.assign(m_help_msg, m_help_msg+sizeof(m_help_msg)/sizeof(m_help_msg[0]));
}

const BpInterconnect::BpCommandPrintConnections::_option_values BpInterconnect::BpCommandPrintConnections::m_defaults = {
    false,     //  show_type
    string("") //   root_name
};

void BpInterconnect::BpCommandPrintConnections::SetDefaultsAll()
{
  m_val = m_defaults;
  m_item_is_printed = false;
};

bool BpInterconnect::BpCommandPrintConnections::SetOptionArgument(int optIndex, const char *argumentPtr)
{
  m_val.root_name = argumentPtr; //the only with required argument is -root
  return true;
}

bool BpInterconnect::BpCommandPrintConnections::SetTheOption(int optIndex)
{
  m_val.show_type = true; //the only option switch is -type
  return true;
}

bool BpInterconnect::BpCommandPrintConnections::MissedArgumentError(int optIndex, const char *argumentPtr)
{
  switch((enum options_descr)optIndex)
  {
    case ROOT://-root
      if (!argumentPtr || (argumentPtr[0] == '-'))
           m_options.ReportError("missing value parameter for depth option (must be a positive integer or 'all')");
      break;
    default:
      break;
  }
  return false;
}


BpInterconnect::exec_status BpInterconnect::BpCommandPhase::Execute(bp_output_cb_t * outputCb,
                                                                    uvm_ml_time_unit timeUnit,
                                                                    double timeValue)
{
  exec_status status = UVM_ML_COMMAND_SUCCESS;
  uvm_ml_phase_action phase_action = ((m_val.which_end != end) ? UVM_ML_PHASE_STARTED :  UVM_ML_PHASE_ENDED);
  switch(m_mandatory_variant_selector)
  {
    case STOP_AT:
    case RUN:
      if (!BpStopRequestClass::RequestStopPhase(m_val.act_phase.c_str(), phase_action))
        status = UVM_ML_COMMAND_FAILURE;
      break;
    case REMOVE_STOP:
      if (m_val.all_stops)
        BpStopRequestClass::CancelPhaseRequests();
      else
        BpStopRequestClass::CancelStopPhase(m_val.act_phase.c_str(), phase_action);
      break;
    case GET:
      BpStopRequestClass::GetPhaseRequest();
      break;
    case LIST_STOP:
      BpStopRequestClass::ListStopRequests();
      break;
  }     
  return status;
}

BpInterconnect::BpPredefinedCommand* BpInterconnect::BpCommandPhase::m_the_instance = NULL;


//constant (-1) for support of m_mandatory_variant_selector of the phase command
const int BpInterconnect::BpCommandPhase::NO_MANDATORY_VARIANT = UNKNOWN;

BpInterconnect::BpCommandPhase::BpCommandPhase() : m_mandatory_variant_selector(NO_MANDATORY_VARIANT), m_options(m_mandatory_variant_selector)
{
  const char* m_help_msg[] = {" -stop_at (((-begin | -end) <phase_name>) | -build_done)",
                              "uvm_ml phase -remove_stop (((-begin | -end) <phase_name>) | -all)",
                              "uvm_ml phase -run <phase_name>",
                              "uvm_ml phase -list_stop",
                              "uvm_ml phase -get",
                              "\t-stop_at      set breakpoint at the beginning or end of the phase",
                              "\t-remove_stop  remove the breakpoint",
                              "\t-run phase    set break at the beginning of the phase and resume the session",
                              "\t-list_stop    list the pending stop requests",
                              "\t-get          display current phase"};


  m_command = "phase"; 
  m_options.SetCommand(this);
  SetDefaultsAll();
  m_cmd_help.assign(m_help_msg, m_help_msg+sizeof(m_help_msg)/sizeof(m_help_msg[0]));
}

const BpInterconnect::BpCommandPhase::_option_values BpInterconnect::BpCommandPhase::m_defaults = {
    false,     //  mandatory_variant flag 
    string(""), //   the phase to act upon
    BpCommandPhase::unknown, //should be begin or end of phase
    false       //all stops - only for the sub-command -remove_stop
};

void BpInterconnect::BpCommandPhase::SetDefaultsAll()
{
  m_val = m_defaults;
};

void BpInterconnect::BpCommandPhase::SetMandatoryOptionVariant(int selector) 
{ 
  m_mandatory_variant_selector = selector; 
}

bool BpInterconnect::BpCommandPhase::SetOptionArgument(int optIndex, const char *argumentPtr)
{
  bool result = false;

  if (AmbiguousPhaseParameter())
    return false;

  switch( m_mandatory_variant_selector)
  {
    case STOP_AT:
    case REMOVE_STOP:
      m_val.act_phase = argumentPtr;
      m_val.which_end  = (optIndex == BEGIN) ? begin : end;
      return true;
    case RUN:
      if(m_orignated_framework_id != -1) //running should be called interactively only
      {
        WarningMsg("Specman 'run' command cannot be used in the mixed language UVM mode and it is ignored.");
        return false;
      }
      m_val.act_phase = argumentPtr;
      m_val.which_end = begin;
      m_val.mandatory_option = true;
      return true;
    default:
      return false;
  }
  return false;
}

bool BpInterconnect::BpCommandPhase::SetTheOption(int optIndex)
{
  bool result = true;
  if (optIndex == MANDATORY_OPTION)
    m_val.mandatory_option = true;
  else
  {
    if (AmbiguousPhaseParameter())
      return false;
    switch(m_mandatory_variant_selector)
    {
      case STOP_AT://-build_done
        m_val.act_phase = "build";
        m_val.which_end = end;
        break;
      case REMOVE_STOP: //-all
        m_val.all_stops = true;
        break;
     default:
       result = false;
    }    
  }
  return result;
}

bool BpInterconnect::BpCommandPhase::AmbiguousPhaseParameter()
{
  if (! m_val.act_phase.empty())
  {
    switch(m_mandatory_variant_selector)
    {
      case STOP_AT://-build_done
        m_options.ReportError("only 1 -stop_at parameter allowed");
        return true;
      case REMOVE_STOP: //-all
        m_options.ReportError("only 1 -remove_stop parameter allowed");
        return true;
      default:
        break;
    }
  }
  return false;
}


bool BpInterconnect::BpCommandPhase::MissedArgumentError(int optIndex, const char *argumentPtr)
{
  switch(optIndex)
  {
    case MANDATORY_OPTION:
      m_options.ReportError("no phase parameter supplied for the option -run");
      break;
    case BEGIN: 
      m_options.ReportError("no phase parameter supplied for the option -begin");
      break;
    case END: 
      m_options.ReportError("no phase parameter supplied for the option -end");
      break;
    default:
      break;
  }
  return false; //phase cannot execute with missing argument for any option
}

//to check contradicting or missing flags/arguments
bool BpInterconnect::BpCommandPhase::QueryOptionsConsistency()
{
  if (!m_val.mandatory_option)
    return false;

  //check the phase to be fully specified
  switch(m_mandatory_variant_selector)
  {
    case STOP_AT:
      if (!m_val.act_phase.empty())
        return true;
      m_options.ReportError("could not stop at unspecified phase. Please provide a phase parameter to the option -stop_at");
      return false;
    case REMOVE_STOP:
      if (m_val.all_stops)
        return true;
      if (!m_val.act_phase.empty())
        return true;
      m_options.ReportError("could not remove breakpoint at unspecified phase. Please provide a phase parameter to the option -remove_stop");
      return false;
    case RUN:
      return !m_val.act_phase.empty(); //handled on parsing the -run option
    case GET:
    case LIST_STOP:
    case HELP:
      return true;
  }
  return false;
}

BpInterconnect::exec_status 
BpInterconnect::BpCommandTraceRegister::Execute(bp_output_cb_t * outputCb,
                                                uvm_ml_time_unit timeUnit,
                                                double           timeValue)
{
  return DoBroadcastCommand(outputCb,
                            timeUnit,
                            timeValue);
}

BpInterconnect::BpPredefinedCommand* BpInterconnect::BpCommandTraceRegister::m_the_instance = NULL;


BpInterconnect::BpCommandTraceRegister::BpCommandTraceRegister() : m_options(), m_command_lens()
{
  const char *m_help_line = { " -on | -off | -h[elp]"};

  m_command = "trace_register_tlm";//trace_register[_tlm]
  m_command_lens.insert((unsigned char)(strlen("trace_register"))); //shortened variant length
  m_options.SetCommand(this);
  SetDefaultsAll();
  m_cmd_help.push_back(m_help_line);
}

//override the virtual function for the command trace_register[_tlm] having two variants of basename
string BpInterconnect::BpCommandTraceRegister::Name()
{
  string resName = "uvm_ml "; //common prefix
  size_t prev_pos=0;
  for (set<unsigned char>::iterator it = m_command_lens.begin();
       it != m_command_lens.end();
       it++)
  {
    resName += m_command.substr(prev_pos, *it-prev_pos) + '[';
    prev_pos = *it;
  }
  resName += m_command.substr(prev_pos); //up to the end of string
  for(int i = m_command_lens.size(); i > 0 ; i--)
    resName += ']';
  return resName;
}

//override the virtual function to check for both variants of the command trace_register[_tlm] 
bool BpInterconnect::BpCommandTraceRegister::MatchCommand(const string & command_with_arguments)
{
  bool matches =  MatchesCommandName(command_with_arguments);
  if (!matches)
  {
    string basename = GetToken(command_with_arguments);
    matches = (m_command_lens.find((unsigned char)(basename.length())) != m_command_lens.end());
  }
  return matches;
}

const BpInterconnect::BpCommandTraceRegister::_option_values 
BpInterconnect::BpCommandTraceRegister::m_defaults = {
  UNKNOWN  //yet not defined
};


void BpInterconnect::BpCommandTraceRegister::SetDefaultsAll()
{
  m_val = m_defaults;
};


bool BpInterconnect::BpCommandTraceRegister::SetOptionArgument(int optIndex, const char *argumentPtr)
{
  return true;//no arguments for this command
}

bool BpInterconnect::BpCommandTraceRegister::SetTheOption(int optIndex)
{
  bool result = true;
  if (m_val.trace_switch != UNKNOWN)
  {
    m_options.ReportError("only 1 trace_register parameter allowed");
    return false;
  }
  switch((enum options_descr)optIndex)
  {
    case ON://-on
      m_val.trace_switch = ON;
      break;
    case OFF://-off
      m_val.trace_switch = OFF;
      break;
    default:
      result = false;
  }
  return result;
}


bool BpInterconnect::BpCommandTraceRegister::QueryOptionsConsistency()
{
  if (m_val.trace_switch == UNKNOWN)
  {
    m_external_cmd_line += " -on";
  }
  return true;
}

BpInterconnect::exec_status 
BpInterconnect::BpCustomCommand::Execute(bp_output_cb_t * outputCb,
                                         uvm_ml_time_unit timeUnit,
                                         double           timeValue)
{
  return DoBroadcastCommand(outputCb,
                             timeUnit,
                             timeValue,
                             false);
}

BpInterconnect::BpCustomCommand* BpInterconnect::BpCustomCommand::m_the_instance = NULL;

} // end namespace Bp
