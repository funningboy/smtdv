//----------------------------------------------------------------------
//   Copyright 2015 Cadence Design Systems, Inc.
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
#include <limits>

#include "bp_interconnect.h"

//external variables to get additional info of parsing results by getopt()/getopt_long()/getopt_long_only() LINUX/GNU API
#define GETOPT_API_ARGUMENT_PTR    (optarg)
#define GETOPT_API_NEXT_TOKEN_POS (optind)
#define GETOPT_API_RETURNED_ERROR (opterr)
#define GETOPT_API_FAILED_FOR_OPTION_INDEX (optopt)


namespace Bp
{

  BpInterconnect::OptionsDescriptor::OptionsDescriptor(const option opts[], size_t numOpts, int *flag_ptr, const char *optstring, bool appendHelp) : 
    m_options(opts, opts+numOpts), 
    m_short_options(optstring),
    m_legal_lengths(appendHelp ? numOpts+1 : numOpts) 
  {
    for(unsigned i = 0; i < numOpts; i++)
      m_options[i].flag = flag_ptr;

    if (appendHelp)
    {
      m_options.push_back(m_HelpOption);
      m_legal_lengths.back().insert(strlen("h")); //-h[elp]
    }
    m_options.push_back(m_NULL); //NULL struct terminator is mandatory for getopt_long API
  }

  const bool BpInterconnect::OptionsDescriptor::IsLegalAbbreviation(int option_index, string& abbreviatedOption)
  {
    size_t length = abbreviatedOption.length();
    size_t post_dash = abbreviatedOption.find_first_not_of('-');
    if (post_dash != string::npos)
      length -= post_dash;

    if ( length  == strlen(m_options[option_index].name) )
      return true;

    if (m_legal_lengths[option_index].find(length) != m_legal_lengths[option_index].end()) //this length is legal abbreviation
      return true;

    return false;
  }

  BpInterconnect::BpCommandOptionsBase::BpCommandOptionsBase()
  {
  }

  BpInterconnect::BpCommandOptionsBase::parse_status BpInterconnect::BpCommandOptionsBase::ParseCheckSyntax(const string& command_with_arguments)
  {
    parse_status status = SUCCESS;

    m_tokens.clear();
    m_supplied_options.clear();
    GetTokens(command_with_arguments, m_tokens);
    
    if (m_tokens.size() > 1)
    {
      try
      {
	int opt = DoParseLoop(); 
	status = HandleParseEndCondition(opt);
	if (status == PARSE_FAILURE)
	  DebugTrace("Parsing of predefined command %s failed", m_command->Name().c_str());
      }
      catch(int)
      {
    	_ParsingError("fatal error on parsing command line");
    	return PARSE_FAILURE;
      }
    }

    if (status == SUCCESS)
       status = m_command->QueryOptionsConsistency() ? SUCCESS : PARSE_FAILURE;

    return status;
  }
  
  //resetting internal mechanism of getopt() GNU LINUX API to get prepared for new command parsing
  int BpInterconnect::BpCommandOptionsBase::InitializeGetopt(char* const* argv,  OptionsDescriptorBase *options)
  {
    int dummy_index;

    GETOPT_API_NEXT_TOKEN_POS = 0;     //zero means this is the first call; initialize.
    int opt = getopt_long(1, argv,  options->GetShortOptionsString(), options->GetLongOptionsPtr(0), &dummy_index); 
    GETOPT_API_RETURNED_ERROR = 0; //getopt() called on pos=0 returns error, but consistently resets to initial parsing state for new parsing

    return GETOPT_API_NEXT_TOKEN_POS;//=1: positioned on the first m_options[1] token (next after command itself)
  }


  int BpInterconnect::BpCommandOptionsBase::DoParseLoop()
  {
    vector<const char *> argv;
    transform (m_tokens.begin(), m_tokens.end(), back_inserter(argv), const_mem_fun_ref_t<const char *, string>(&string::c_str));
    OptionsDescriptorBase *options = GetOptions();
    m_supplied_options = vector<bool>(options->Size(), false);
    int opt, dummy_index;

    m_last_pos = InitializeGetopt((char* const*)(argv.data()), options);
    
    while((opt = getopt_long_only((int)(m_tokens.size()), 
				  (char* const*)(argv.data()), 
				  options->GetShortOptionsString(), 
				  options->GetLongOptionsPtr(0), 
				  &dummy_index)) == 0) 
    {
      if (!m_supplied_options[m_matched_option_index])
      {
	if (!HandleTheOption(options->GetLongOptionsPtr(m_matched_option_index)->has_arg)) 
	  return ERROR_WITH_OPTION;
	m_supplied_options[m_matched_option_index] = true;
	m_last_pos =  GETOPT_API_NEXT_TOKEN_POS;
      }
      else 
      {
	string optionStr = string("-") + options->GetLongOptionsPtr(m_matched_option_index)->name;
	string err = string("second occurrence of the option ") + optionStr;
	string err2 = string("Only one ") + optionStr + string(" option is allowed");
	  _ParsingError(err.c_str(), err2.c_str());
	 return DUPLICATED_OPTION;
     }
   }
   return opt;
 }

  bool BpInterconnect::BpCommandOptionsBase::HandleTheOption(int has_arg)
  {
    bool result = false;

    if (has_arg != no_argument) //any argument is exepected for the option
    {
      if (!GETOPT_API_ARGUMENT_PTR 
	  || GETOPT_API_ARGUMENT_PTR[0] == '-') //getopt assumes the next option '-.." to be missed argument
      {
	result = m_command->MissedArgumentError(m_matched_option_index, GETOPT_API_ARGUMENT_PTR); 
	--GETOPT_API_NEXT_TOKEN_POS; //fix position to recover for subsequent parameter parsing
      }
      else
	result = m_command->SetOptionArgument(m_matched_option_index, GETOPT_API_ARGUMENT_PTR);
    }
    else //no argument required for this option flag
      result = m_command->SetTheOption(m_matched_option_index);

    if (result) 
    {
      if (!GetOptions()->IsLegalAbbreviation(m_matched_option_index, m_tokens[m_last_pos]))
      {
	//matched the option, but wrong option's abbreviation
	string err("illegal option abbreviation");
	string err2 =  string("Suggest: -")  + GetOptions()->GetLongOptionsPtr(m_matched_option_index)->name;
	_ParsingError(err.c_str(), err2.c_str());
	result = false;
      }
    }
    return result;
  }

  BpInterconnect::BpCommandOptionsBase::parse_status 
  BpInterconnect::BpCommandOptionsBase::HandleParseEndCondition(int opt)
  {
    parse_status status = PARSE_FAILURE;
    switch(opt)
    {
      case ERROR_WITH_OPTION:
      case DUPLICATED_OPTION:
	break;
      case NON_OPTION_OR_ALL_TOKENS_DONE:
	if (AllTokensDone())
	  status = SUCCESS;
	else
	  _PrintSyntaxOptions("unknown parameter", true);
	break;
      case HELP:
	status = ASKED_FOR_HELP;
	break;
      case UNKNOWN_OPTION:
	_PrintSyntaxOptions("unknown option", false);
	break;
      case MISSED_REQUIRED_ARGUMENT:
	if (m_command->MissedArgumentError(GETOPT_API_FAILED_FOR_OPTION_INDEX, GETOPT_API_ARGUMENT_PTR)) //returned SUCCESS
	  status == SUCCESS; //means, in this case absence of the argument didn't cause parsing to fail
	break;
      default:
	ErrorMsg("fatal error - unknown option character \\%o'", opt);
	break;
    }
    return status;
  }

  bool BpInterconnect::BpCommandOptionsBase::IsSupplied(unsigned option_index)
  { 
    if (option_index < m_supplied_options.size())
      return m_supplied_options[option_index];
    return false;
  }

  string BpInterconnect::BpCommandOptionsBase::_ParsingErrorMessage(const char *err)
  {
    stringstream ss;
    ss << err;
    unsigned pos = m_last_pos;
    if (pos >= m_tokens.size())
      pos = m_tokens.size()-1;

    ss << " '" << m_tokens[pos] << "' at the position " << pos+1;
    return ss.str();
  }

  void BpInterconnect::BpCommandOptionsBase::_ParsingError(const char *err, const char *err2)
  {
    string errstr = _ParsingErrorMessage(err);
    if (err2)
      errstr += string(". ") + err2;
    ReportError(errstr);
  }

  void BpInterconnect::BpCommandOptionsBase::_PrintSyntaxOptions(const char *err, bool hasArgOnly)
  {
    bool headList = true;
    stringstream ss;
    string errstr = _ParsingErrorMessage(err);

    ss << errstr;
    if (hasArgOnly)
      ss << "\n\t\tPerhaps you meant to specify either: ";
    else
      ss << "\n\t\tThe only options allowed for this command are: ";

    for(unsigned i = 0; i < GetOptions()->Size(); i++)
    {
      const option *ptrOption = GetOptions()->GetLongOptionsPtr(i);
      if (hasArgOnly && ptrOption->has_arg == no_argument)
	continue;
      if (!headList)
	ss << ", ";
      else
	headList = false;

      ss << "-" << ptrOption->name;
    }
    if (headList == true && hasArgOnly) //no any option that requires argument
      ErrorMsg((errstr + "\n\t\tNo argument is expected for any of this command options").c_str());
    else
      ErrorMsg(ss.str().c_str());
  }

  void BpInterconnect::BpCommandOptionsBase::ReportError(stringstream &ss) 
  { 
    ReportError(ss.str().c_str());
  }


  void BpInterconnect::BpCommandOptionsBase::ReportError(string &msg)
  {
    ReportError(msg.c_str());
  }

  void BpInterconnect::BpCommandOptionsBase::ReportError(const char *cstr_msg)
  {
    string prefixed_msg = '"' + m_command->Name() + "\" parsing error: " + cstr_msg;
    ErrorMsg(prefixed_msg.c_str()); 

  }

  option BpInterconnect::OptionsDescriptor::m_HelpOption = {"help", no_argument, NULL, 'h'};
  option BpInterconnect::OptionsDescriptor::m_NULL = {NULL, 0, NULL, 0};


  void BpInterconnect::BpCommandOptionsBase::GetTokens(const string &command_with_argument, vector<string> &tokens_out)
  {
    tokens_out.clear();

    stringstream ss(command_with_argument);
    ss.clear();
    string param;
    while(!ss.eof() && (ss >> param))
    {
      tokens_out.push_back(param);
    }
  }

  const option BpInterconnect::BpPrintTreeCommandOptions::m_PrintTreeOpts[] =
    {
      {"depth", required_argument, NULL, 0},
      {"short_paths", no_argument, NULL, 1},
      {"ports", no_argument, NULL, 2},
      {"type", no_argument, NULL, 3},  
      {"root", required_argument, NULL, 4}
    };

  BpInterconnect::BpPrintTreeCommandOptions::BpPrintTreeCommandOptions() : m_descr(m_PrintTreeOpts, sizeof(m_PrintTreeOpts)/sizeof(option),&m_matched_option_index,(const char *)":0:1234:h")
  {
    m_descr.AddLegalLength(BpCommandPrintTree::DEPTH, strlen("d")); //-[d]epth
    m_descr.AddLegalLength(BpCommandPrintTree::FULL_PATH, strlen("s")); //-s
    m_descr.AddLegalLength(BpCommandPrintTree::FULL_PATH, strlen("short")); //-short
    m_descr.AddLegalLength(BpCommandPrintTree::FULL_PATH, strlen("short_path")); //-short_path[s]
    m_descr.AddLegalLength(BpCommandPrintTree::PORTS, strlen("p")); //-p[orts]
    m_descr.AddLegalLength(BpCommandPrintTree::TYPE, strlen("t")); //-t[ype]
    m_descr.AddLegalLength(BpCommandPrintTree::ROOT, strlen("r")); //-r[oot]
  }


  BpInterconnect::BpPrintTreeCommandOptions::~BpPrintTreeCommandOptions() 
  { }


  const option BpInterconnect::BpPrintConnectionsCommandOptions::m_PrintConnOpts[] =
  {
    {"type", no_argument, NULL, 0},  
    {"root", required_argument, NULL, 1}
  };


  BpInterconnect::BpPrintConnectionsCommandOptions::BpPrintConnectionsCommandOptions() : m_descr(m_PrintConnOpts, sizeof(m_PrintConnOpts)/sizeof(option), &m_matched_option_index, ":01:h")
  {
    m_descr.AddLegalLength(BpCommandPrintConnections::TYPE, strlen("t")); //-t[ype]
    m_descr.AddLegalLength(BpCommandPrintConnections::ROOT, strlen("r")); //-r[oot]
  }


  BpInterconnect::BpPrintConnectionsCommandOptions::~BpPrintConnectionsCommandOptions() 
  {

  }

  const option BpInterconnect::BpPhaseCommandOptions::m_PhaseOpts_SA[] = 
  {
    {"stop_at", no_argument, NULL, 0},
    {"begin", required_argument, NULL, 1},
    {"end", required_argument, NULL, 2},
    {"build_done", no_argument, NULL, 3}
  };

  const option BpInterconnect::BpPhaseCommandOptions::m_PhaseOpts_RS[] = 
  {
    {"remove_stop", no_argument, NULL, 0},
    {"begin", required_argument, NULL, 1},
    {"end", required_argument, NULL, 2},
    {"all", no_argument, NULL, 3}
  };

  const option BpInterconnect::BpPhaseCommandOptions::m_PhaseOpts_LS[] = 
  {
    {"list_stop", no_argument, NULL, 0}
  };

  const option BpInterconnect::BpPhaseCommandOptions::m_PhaseOpts_G[] = 
  {
    {"get", no_argument, NULL, 0}
  };

  const option BpInterconnect::BpPhaseCommandOptions::m_PhaseOpts_R[] = 
  {
    {"run", required_argument, NULL, 0},
  };

  const option BpInterconnect::BpPhaseCommandOptions::m_PhaseOpts_H[] = 
  {
    {"h", no_argument, NULL, 0}
  };



  BpInterconnect::BpPhaseCommandOptions::BpPhaseCommandOptions(int& mandatory_variant_selector) : 
    BpCommandOptionsBase(), 
    m_mandatory_variant(mandatory_variant_selector)
  {
    struct { 
      const option *opts;
      const size_t count;
      const char *optstring;
    } variants[] = 
	{
	  { m_PhaseOpts_SA, sizeof(m_PhaseOpts_SA)/sizeof(struct option), ":01:2:3h" }, //-stop_at
	  { m_PhaseOpts_RS, sizeof(m_PhaseOpts_RS)/sizeof(struct option), ":01:2:3h" }, //-remove_stop
	  { m_PhaseOpts_G, sizeof(m_PhaseOpts_G)/sizeof(struct option), ":0h" },        //-get
	  { m_PhaseOpts_LS, sizeof(m_PhaseOpts_LS)/sizeof(struct option), ":0h" },      //-list_stop
	  { m_PhaseOpts_R, sizeof(m_PhaseOpts_R)/sizeof(struct option), ":0:h" },       //-run
	  { NULL, 0, ":h" },                                                            //-h[elp] will be appended
	  { m_PhaseOpts_H, sizeof(m_PhaseOpts_R)/sizeof(struct option), ":h" }          //-h different from -help for proper handling mandatory options
	};
    
      for(unsigned i=0; i < sizeof(variants)/sizeof(variants[0]);i++)
	m_variants.push_back(new OptionsDescriptor(variants[i].opts, 
						   variants[i].count, 
						   &m_matched_option_index, 
						   variants[i].optstring, 
						   (variants[i].opts != m_PhaseOpts_H))); //append -h[elp] for all but -h

  }

  BpInterconnect::BpCommandOptionsBase::match_result BpInterconnect::BpPhaseCommandOptions::MatchMandatoryOption(const string &arguments)
  {
    stringstream ss;
    enum match_result res = MATCH;

    vector<BpInterconnect::OptionsDescriptor*>::iterator it1, it2;
    it1 = find_if(m_variants.begin(), m_variants.end(), LookupOption(arguments));
    if (it1 != m_variants.end())
    {
      it2 = find_if(it1+1, m_variants.end(), LookupOption(arguments));
      if (it2 == m_variants.end())
      {
	m_mandatory_variant = it1 - m_variants.begin();
        if ((m_mandatory_variant == BpCommandPhase::HELP) || (m_mandatory_variant == BpCommandPhase::H))
	  return HELP_OPTION;
	else
	  return MATCH;
      }
      if ((it2 - m_variants.begin() == BpCommandPhase::HELP) || 
	(it2 - m_variants.begin() == BpCommandPhase::H))
	  return HELP_OPTION;

      ss << "single action parameter required. Legal parameters (only 1 is allowed)";
      res = MATCH_CMD_INVALID_OPTIONS;
    }
    else
    {
      ss << "illegal parameter. Legal parameters (only 1 is allowed)";
      res = MATCH_CMD_INVALID_OPTIONS;
    }
    string validList(": ");
    for_each(m_variants.begin(), m_variants.begin() + BpCommandPhase::H, PrintoutOption(validList));
    ss << validList;

    ReportError(ss);
    return res;
  };

  BpInterconnect::BpPhaseCommandOptions::~BpPhaseCommandOptions()
  {
    for_each(m_variants.begin(), m_variants.end(), Destructor());
  }

  bool BpInterconnect::BpPhaseCommandOptions::LookupOption::_FindOptionMatchBounds(const char* descrToken)
  {
    string optionStr = string(" -") + descrToken; //prefix with space and dash
    size_t pos_opt = m_cmd.find(optionStr);
    if (pos_opt == string::npos)
      return false;
    //check if optionStr in m_cmd is terminated at the string end or followed by space separator
    return m_cmd.length() == (pos_opt + optionStr.length()) || m_cmd[pos_opt + optionStr.length()] == ' ';
  }

  void BpInterconnect::BpPhaseCommandOptions::PrintoutOption::operator ()(OptionsDescriptor *descr)
  { 
    if (!m_passed_first)
    {
      m_valid_list += string("-");
      m_passed_first = true;
    }
    else
      m_valid_list += string(", -");
    m_valid_list += string(descr->GetLongOptionsPtr(0)->name);
  };


  const option BpInterconnect::BpTraceRegisterCommandOptions::m_TraceRegisterOpts[] =
    {
      {"on", no_argument, NULL, 0},
      {"off", no_argument, NULL, 1},
    };

  BpInterconnect::BpTraceRegisterCommandOptions::BpTraceRegisterCommandOptions() : m_descr(m_TraceRegisterOpts, sizeof(m_TraceRegisterOpts)/sizeof(option), &m_matched_option_index,":01h")
  {
  }

}// end of namespace Bp
