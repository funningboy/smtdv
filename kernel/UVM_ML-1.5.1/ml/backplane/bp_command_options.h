//----------------------------------------------------------------------
//   Copyright 2015 Cadence Design Systems, Inc.
//   Copyright 2012-2015 Advanced Micro Devices Inc.
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

/*! @file bp_command_options.h
 *
 *  Backplane command-line options handling module header File
 * 
 *  Original Author: Alex Koltyar, Cadence Design Systems, Inc.
 */
#ifndef BP_COMMAND_OPTIONS_H
#define BP_COMMAND_OPTIONS_H

//container for all the possible variants of command-line flags' lengths for a command
typedef vector<set<unsigned char> > legal_abbreviation_lengths_type;

class BpPredefinedCommand; //forward declaration

class OptionsDescriptorBase
{
public:
  virtual ~OptionsDescriptorBase() {}
  virtual const struct option *GetLongOptionsPtr(size_t offset)=0;
  virtual const size_t Size()=0;
  virtual const char *GetShortOptionsString()=0;
  virtual const bool IsLegalAbbreviation(int option_index, string& abbreviatedOption)=0;
};

class OptionsDescriptor : public OptionsDescriptorBase
{
public:
  //constructors/destructor
  OptionsDescriptor();
  OptionsDescriptor(const option opts[], size_t num_opts, int *flag_ptr, const char *optstring, bool appendHelp=true);
  OptionsDescriptor(const OptionsDescriptor &other);
  virtual ~OptionsDescriptor() { }
  //data access methods
  virtual const struct option *GetLongOptionsPtr(size_t offset) { return m_options.data() + offset; }
  virtual const size_t Size() { return m_options.size() - 1; } //the last is NULL terminator
  virtual const char *GetShortOptionsString() { return m_short_options.c_str(); }
  //validate the abbreviated form of the option is legal (ex. -d for d[epth])
  virtual const bool IsLegalAbbreviation(int option_index, string& abbreviatedOption);

  //initialization helpers
  void AddLegalLength(int index, size_t length) 
  {  m_legal_lengths[index].insert((unsigned char)length); }

private:
  vector<option>m_options;
  const string m_short_options;
  legal_abbreviation_lengths_type m_legal_lengths;

  //common descriptions appended to options arrays of all of the commands
  static option m_HelpOption; //-h[elp] handling
  static option m_NULL; //structs array terminator
};



class BpCommandOptionsBase
{
public:
  BpCommandOptionsBase();
  virtual ~BpCommandOptionsBase() {}


public:
  //return values for command matching results
  enum match_result { MISMATCH, MATCH_CMD_INVALID_OPTIONS, HELP_OPTION, MATCH };
  //return values for parsing result
  typedef enum {ASKED_FOR_HELP=-1, PARSE_FAILURE=0, SUCCESS = 1} parse_status;
  //
  //Public Interface
  //
  void SetCommand(BpPredefinedCommand *pCommand) { m_command = pCommand; };
  //
  virtual parse_status ParseCheckSyntax(const string& command_with_arguments);
  bool IsSupplied(unsigned option_index);
  //reporting parsing errors
  void ReportError(stringstream& ss);
  void ReportError(string& msg);
  void ReportError(const char *cstr_msg);
  //
  //util for tokenization
  static void GetTokens(const string &command_with_argument, vector<string> &tokens_out);

protected:
  virtual  OptionsDescriptorBase *GetOptions()=0;
  BpPredefinedCommand *m_command;
  int m_matched_option_index; //store for the index of the matched option

private:
  //
  //Parsing mechanism implementation: internal API
  enum opt_retval_type { ERROR_WITH_OPTION=-3, 
			 DUPLICATED_OPTION=-2, 
			 NON_OPTION_OR_ALL_TOKENS_DONE=-1, 
			 PARSED_OK=0, 
			 HELP = 'h',
			 UNKNOWN_OPTION = '?',
			 MISSED_REQUIRED_ARGUMENT = ':'
  };		 
  parse_status    HandleParseEndCondition(int opt);//gets int parameter, which significant values complient with enum opt_retval_type
  int             DoParseLoop();
  int             InitializeGetopt(char* const* argv,  OptionsDescriptorBase *options);
  bool            HandleTheOption(int has_arg);
  void            _ParsingError(const char* err, const char* err2=NULL);
  string          _ParsingErrorMessage(const char* err);
  void            _PrintSyntaxOptions(const char*, bool hasArgOnly);   //syntax error msg on either unknown option or parameter
  bool            AllTokensDone() { return m_last_pos == m_tokens.size(); }
  vector<string>  m_tokens;
  vector<bool>    m_supplied_options; //the options supplied in command line, if not - parameter by default
  unsigned        m_last_pos; //keeping track of last token (index) processed in command line
};




class BpPrintTreeCommandOptions : public BpCommandOptionsBase
{
public:
  BpPrintTreeCommandOptions();
  virtual ~BpPrintTreeCommandOptions();

protected:
  virtual  OptionsDescriptorBase *GetOptions() { return &m_descr; }
private:
  OptionsDescriptor m_descr;
  static const option m_PrintTreeOpts[];
};


class BpPrintConnectionsCommandOptions : public BpCommandOptionsBase
{
public:
  BpPrintConnectionsCommandOptions();
  virtual ~BpPrintConnectionsCommandOptions();

protected:
  virtual  OptionsDescriptorBase *GetOptions() { return &m_descr; }
private:
  OptionsDescriptor m_descr;
  static const option m_PrintConnOpts[];
};



class BpPhaseCommandOptions : public BpCommandOptionsBase
{
public:
  BpPhaseCommandOptions(int& mandatory_variant_selector);
  virtual ~BpPhaseCommandOptions();
  enum match_result MatchMandatoryOption(const string &arguments);

protected:
  virtual  OptionsDescriptorBase *GetOptions() { return m_variants[m_mandatory_variant]; }

private:
  int &m_mandatory_variant;
  vector<OptionsDescriptor*> m_variants;

  static const option m_PhaseOpts_SA[];
  static const option m_PhaseOpts_RS[];
  static const option m_PhaseOpts_G[];
  static const option m_PhaseOpts_LS[];
  static const option m_PhaseOpts_R[];
  static const option m_PhaseOpts_H[];

  struct LookupOption
  {
    LookupOption(string cmd) : m_cmd(cmd) {};
    bool operator ()(OptionsDescriptor *descr)
    { 
      return _FindOptionMatchBounds(descr->GetLongOptionsPtr(0)->name);
    };
private:
    bool _FindOptionMatchBounds(const char* descrToken);
    string m_cmd;
  };
  struct PrintoutOption
  {
    PrintoutOption(string &validList) : m_valid_list(validList), m_passed_first(false) {};
    void operator ()(OptionsDescriptor *descr);
private:
    string &m_valid_list;
    bool m_passed_first;
  };
  struct Destructor
  {
    Destructor() {};
    void operator ()(OptionsDescriptor *variant)
    {
      delete variant;
    };
  };
};

class BpTraceRegisterCommandOptions : public BpCommandOptionsBase
{
public:
  BpTraceRegisterCommandOptions();
  virtual ~BpTraceRegisterCommandOptions() {}
protected:
  virtual  OptionsDescriptorBase *GetOptions() { return &m_descr; }
private:
  OptionsDescriptor m_descr;
  static const option m_TraceRegisterOpts[];
};


#endif //BP_COMMAND_OPTIONS_H
