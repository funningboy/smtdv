//----------------------------------------------------------------------
//	 Copyright 2012 Cadence Design Systems, Inc.
//	 Copyright 2012-2013 Advanced Micro Devices Inc.
//	 All Rights Reserved Worldwide
//
//	 Licensed under the Apache License, Version 2.0 (the
//	 "License"); you may not use this file except in
//	 compliance with the License.  You may obtain a copy of
//	 the License at
//
//			 http://www.apache.org/licenses/LICENSE-2.0
//
//	 Unless required by applicable law or agreed to in
//	 writing, software distributed under the License is
//	 distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//	 CONDITIONS OF ANY KIND, either express or implied.  See
//	 the License for the specific language governing
//	 permissions and limitations under the License.
//----------------------------------------------------------------------

/*! @file bp_debug.h
 *
 *	Backplane Debug module header File
 * 
 *	Original Author: Gabi Leshem, Cadence Design Systems, Inc.
 */

#ifndef BP_DEBUG_H
#define BP_DEBUG_H



typedef enum {UVM_ML_UNRECOGNIZED_COMMAND=-1, 
	      UVM_ML_COMMAND_FAILURE=0,
	      UVM_ML_COMMAND_SUCCESS=1} exec_status;

///////////////////////////////////////////////////////////////////////////////
// Stop/Breakpoint Request API (encapsulated in class BpStopRequestClass)
///////////////////////////////////////////////////////////////////////////////
class BpStopRequestClass {
  class bp_stop_request_struct
  {
  public:
    int	                 id;
    string               phase_name;
    uvm_ml_phase_action	 phase_action;
    bool                 checked;
    bp_stop_request_struct(const char * nm, uvm_ml_phase_action a, bool c): phase_name(nm), phase_action(a), checked(c) 
    { 
      id = ++m_last_id;
      checked = c; 
    };
  }; // class bp_stop_request_struct
  static unsigned int m_last_id; 

public:

  BpStopRequestClass ();
  ~BpStopRequestClass();
  
  bool CheckStopRequest(const char * phase_name, uvm_ml_phase_action phase_action);
  static void PrintStop(bp_stop_request_struct * i); 
  static void CheckPhaseName(bp_stop_request_struct * i); 
  static void DeleteStopRequest(const char * index);
  static void ListStopRequests();
  static void CancelStopPhase(const char *phase_name, 
				     uvm_ml_phase_action phase_action);
  static bool RequestStopPhase(const char *phase_name, 
				      uvm_ml_phase_action phase_action);
  static void GetPhaseRequest();
  static void CancelPhaseRequests();
  // Note: preserve m_requests when reset
  static vector<bp_stop_request_struct*> m_requests; 
}; // class BpStopRequestClass


///////////////////////////////////////////////////////////////////////////////
// Print tree API (encapsulated in class BpPrintTreeClass)
///////////////////////////////////////////////////////////////////////////////

class BpDebugClass 
{

private:
  static vector<string> m_command_backlog;

public:

  BpDebugClass () {};
  ~BpDebugClass() {};

  static int ExecuteCommand(int frameworkId, const string & command_with_arguments, bp_output_cb_t * outputCb, uvm_ml_time_unit timeUnit, double timeValue);
  static const vector<string> & GetBacklogCommands() { return m_command_backlog; }
  static void AddBacklogCommand( const string command) { m_command_backlog.push_back(command); }	
  static void Reset();

private:
  //processes command line and returns predefined command handlers if matches
  static BpPredefinedCommand* GetCommand(const string &command_with_arguments);
  static bool GenericCmdHelpRequired(const string &command_with_arguments);
}; // class BpDebugClass */


//------------------------------------------------------------------------------
//! Abstract base @class BpCommandBase defines the interfaces, 
/*! common functions/utils/data members and other API for the 
 *	specific debug command class'es to derive from it
 */
class BpCommandBase
{
public:
  // constructor/destructor
  BpCommandBase() {}
  virtual ~BpCommandBase() {};

  virtual void ResetAndInit(const string & command_with_arguments, int frameworkId)
  { 
    m_execute_err.clear();
  }
  //interface virtual functions for getting parser and command execution - to be overriden and implemented in sub-classess for specific commands
  //! 
  /*! interface of the method to either broadcast the command to all the frameworks (for internal commands)
   *  or to execute it directly (for internal commands)
   *
   *  @param frameworkId - the framework the command was originated from (-1 - interactively)
   *
   *  @param  command_with_arguments - full command-line (without uvm_ml(_) prefix)
   *
   *  @param outputCb - additional stream to print output to
   *
   *  @param timeUnit        - current simulation time units enum (TIME_UNIT_UNDEFINED 
   *                           if the framework does not have an ability to advance time)
   *  @param timeValue       - numeric value of current simulation time scaled 
   *                           according to timeUnit
   *  @return UVM_ML_COMMAND_SUCCESS - 
   *          UVM_ML_COMMAND_FAILURE -
   *          UVM_ML_UNRECOGNIZED_COMMAND - 
   *
   */
  virtual exec_status Execute(bp_output_cb_t * outputCb,
			      uvm_ml_time_unit timeUnit,
			      double timeValue)=0;
  virtual void TraceExecute(int frameworkId)=0;
  virtual void TraceResult(exec_status result)=0;
  //
  void SetExternalCommand(string external_cmd_line) { m_external_cmd_line = external_cmd_line; }
  string &GetExternalCommand() { return m_external_cmd_line; }
  //
  //trace before either execute or broacast
  //void TraceOnInvoke(bool isExecute, int frameworkId, const string & command_with_arguments);

protected:
  string CommandOriginated(int frameworkId);
  exec_status DoBroadcastCommand(bp_output_cb_t * outputCb,
				 uvm_ml_time_unit timeUnit,
				 double timeValue,
				 bool addBacklog=true);
  //! 
  string m_external_cmd_line; //for both BpExternalCommand and BpCustomCommand
  //! 
  //these string to be reset before each Broadcast/Execute
  string m_execute_err;//save the error message of execution or broadcast
};

class BpPredefinedCommand : public BpCommandBase
{
public:
  BpPredefinedCommand() {}
  virtual ~BpPredefinedCommand() {}
  //-----------------------------------------------------------------------------
  //
  //UVM-ML Generic command support - API of matching/handling the predefined command
  //
  //-----------------------------------------------------------------------------
  //! 
  //! fetching predefined command object and resolving sub-command 
  virtual bool MatchCommand(const string &command_with_arguments);
  enum BpCommandOptionsBase::match_result GetMatchResult() { return m_match_result; }
  
  virtual void ResetAndInit(const string & command_with_arguments, int frameworkId)
  { 
    BpCommandBase::ResetAndInit(command_with_arguments, frameworkId);
    SetDefaultsAll();
  }
  //
  //! print the help for the specific predefined command
  void PrintCmdHelp();
  //
  //!the name of the command for info/error messages and help (including length's variants if any) 
  virtual string Name() { return string("uvm_ml ") + m_command; }

  //!gets the parser object for predefined command (implemented in sub-classes)
  virtual BpCommandOptionsBase* GetParser()=0;
  //
  virtual exec_status Execute(bp_output_cb_t * outputCb,
			      uvm_ml_time_unit timeUnit,
			      double timeValue)=0;
  //DEBUG trace for execution flow
  virtual void TraceExecute(int frameworkId)=0; //before executing command
  virtual void TraceResult(exec_status result)=0; //after execution with the result and verbose info about the call/broadcast context
  //
  //! virtual functions for handing command-line options and arguments - implementation in sub-classess for specific commands
  //
  //-----------------------------------------------------------------------------
  //! resets flag values to defaults before starting to parse new command line
  virtual void SetDefaultsAll()=0; 
  //-----------------------------------------------------------------------------
  //! 
  //!  API called by parser to pass per-option result with no argument
  virtual bool SetTheOption(int optIndex)=0;
  //	
  //-----------------------------------------------------------------------------
  //!  API called by parser to pass per-option result with argument
  virtual bool SetOptionArgument(int optIndex, const char *argumentPtr)=0;
  //   API called by parser to handle case of missing mandatory argument for an option
  virtual bool MissedArgumentError(int optIndex, const char *argumentPtr)=0;
  //
  //-----------------------------------------------------------------------------
  //! parse post-processing: check for errors (i.e. mandatory flags and/or arguments that were not supplied);
  //! also checking for contradicting flags and appends missed (implied) default parameter/value 
  virtual bool QueryOptionsConsistency()=0; 
  
  //common implemetation for 1-word command that has no abbreiation forms
  bool MatchesCommandName(const string & command_with_arguments) 
  { return	BpPrefixCompare(m_command, command_with_arguments, " "); }

protected:
  //variables of the command properties
  string m_command; //command basename
  vector<string> m_cmd_help;
  BpCommandOptionsBase::match_result m_match_result;

private:
  friend class BpDebugClass; //to get access to next two private members
  //!initialization procedure for pre-defined commands 
  static void Init();
  //
  static void PrintGenericCommandHelp();
  //
  //!container for all the pre-defined commands (as singleton instances)
  static vector<BpPredefinedCommand *> m_predef_commands;
  //
  //!get specific command instance
  template<typename IMP>
  static BpPredefinedCommand* GetInstance()
  {
    if (IMP::m_the_instance == NULL)
      IMP::m_the_instance = new IMP();
    return IMP::m_the_instance;//static_cast<A *>(IMP::m_the_instance);
  };
};

class BpInternalCommand : virtual public BpPredefinedCommand
{
public:
  BpInternalCommand() {}
  virtual ~BpInternalCommand() {}

  virtual BpCommandOptionsBase* GetParser()=0;
  virtual exec_status Execute(bp_output_cb_t * outputCb,
			      uvm_ml_time_unit timeUnit,
			      double timeValue)=0;
  virtual void TraceExecute(int frameworkId);
  virtual void TraceResult(exec_status result);
  virtual void SetDefaultsAll()=0; 
  virtual bool SetTheOption(int optIndex)=0;
  virtual bool SetOptionArgument(int optIndex, const char *argumentPtr)=0;
  virtual bool MissedArgumentError(int optIndex, const char *argumentPtr)=0;
  virtual bool QueryOptionsConsistency()=0; 
};

class BpExternalCommand : virtual public BpPredefinedCommand
{
public:
  virtual void ResetAndInit(const string & command_with_arguments, int frameworkId)
  { 
    BpPredefinedCommand::ResetAndInit(command_with_arguments, frameworkId);
    SetExternalCommand(command_with_arguments);
  }

  virtual BpCommandOptionsBase* GetParser()=0;
  virtual exec_status Execute(bp_output_cb_t * outputCb,
			      uvm_ml_time_unit timeUnit,
			      double timeValue)=0;
  virtual void TraceExecute(int frameworkId);
  virtual void TraceResult(exec_status result);
  //! virtual functions for handing command-line options and arguments - implementation in sub-classess for specific commands
  //
  //-----------------------------------------------------------------------------
  //! resets flag values to defaults before starting to parse new command line
  virtual void SetDefaultsAll()=0; 
  //-----------------------------------------------------------------------------
  //! 
  //!  API called by parser to pass per-option result with no argument
  virtual bool SetTheOption(int optIndex)=0;
  //	
  //-----------------------------------------------------------------------------
  //!  API called by parser to pass per-option result with argument
  virtual bool SetOptionArgument(int optIndex, const char *argumentPtr)=0;

  virtual bool MissedArgumentError(int optIndex, const char *argumentPtr)=0;
  //
  //-----------------------------------------------------------------------------
  //! parse post-processing: check for errors (i.e. mandatory flags and/or arguments that were not supplied);
  //! also checking for contradicting flags and appends missed (implied) default parameter/value 
  virtual bool QueryOptionsConsistency()=0; 
};

//class to handle uvm_ml print_tree command
class BpCommandPrintTree : virtual public BpInternalCommand
{

private:
  BpCommandPrintTree(); //the singleton instance is created by static get_instance()

public:
  virtual ~BpCommandPrintTree() {}

  virtual BpCommandOptionsBase* GetParser() { return (BpCommandOptionsBase*)(&m_options); }
  virtual exec_status Execute(bp_output_cb_t * outputCb,
			      uvm_ml_time_unit timeUnit,
			      double timeValue);
  virtual void SetDefaultsAll(); 
  
  virtual bool SetTheOption(int optIndex);
  virtual bool SetOptionArgument(int optIndex, const char *argumentPtr);
  
  virtual bool MissedArgumentError(int optIndex, const char *argumentPtr);
  virtual bool QueryOptionsConsistency() { return true; }
  
  enum options_descr { DEPTH=0, FULL_PATH, PORTS, TYPE, ROOT };
private:
  bool PrintSubtree(const string &, FrameworkProxyClass *, string, string, int, int, bool, int);
  bool IsChildProxy(const string & current_name, string & target_name, int *target_ind);
  int  count_dots(string name);
  bool IsComponentToTraverse(FrameworkProxyClass * frmw, const string & child_name);
  bool HasChildrenToTraverse(FrameworkProxyClass *frmw, const string & current_name);

  BpPrintTreeCommandOptions m_options;
  friend class BpPredefinedCommand;
  static BpPredefinedCommand *m_the_instance;
  
  struct _option_values
  {
    int	    depth;  
    bool    show_full_path;
    bool    show_port;
    bool    show_type;
    string  root_name;
  };
  _option_values m_val;
  const static _option_values m_defaults;
  bool m_components_unshown_by_depth;
};


//class to handle uvm_ml print_connectoins command
class BpCommandPrintConnections : public BpInternalCommand
{

private: 
  BpCommandPrintConnections(); //the singleton instance is created by static get_instance()

public:
  virtual ~BpCommandPrintConnections() {}

  virtual BpCommandOptionsBase* GetParser() { return &m_options; }
  virtual exec_status Execute(bp_output_cb_t * outputCb, 
			      uvm_ml_time_unit timeUnit,
			      double timeValue);
  virtual void SetDefaultsAll();

  virtual bool SetTheOption(int optIndex);
  virtual bool SetOptionArgument(int optIndex, const char *argumentPtr);

  virtual bool MissedArgumentError(int optIndex, const char *argumentPtr);
  virtual bool QueryOptionsConsistency() { return true; }

  enum options_descr { TYPE=0, ROOT };
private:
  void PrintPair(BpConnectionClass * it, BpConnectionClass * ot, const string &arrow, bool show_type);

  BpPrintConnectionsCommandOptions m_options;
  friend class BpPredefinedCommand;
  static BpPredefinedCommand *m_the_instance;

  struct _option_values
  {
    bool	 show_type;
    string       root_name;
  };
  _option_values m_val;
  const static _option_values m_defaults;
  bool m_item_is_printed;
};


//class to handle uvm_ml phase command with all its sub-commands
class BpCommandPhase : public BpInternalCommand
{

private: 
  BpCommandPhase(); //the singleton instance is created by static get_instance()

public:
  enum mandatory_options { UNKNOWN = -1, STOP_AT = 0, REMOVE_STOP, GET, LIST_STOP, RUN, HELP, H, SUBOPT_COUNT };
  virtual ~BpCommandPhase() {}
  virtual bool MatchCommand(const string &command_with_arguments);
  virtual void ResetAndInit(const string & command_with_arguments, int frameworkId)
  { 
    BpCommandBase::ResetAndInit(command_with_arguments, frameworkId);
    SetDefaultsAll();
    m_orignated_framework_id = frameworkId;
  }

  //
  //! 
  //! 
  virtual void SetMandatoryOptionVariant(int selector);
  const static int NO_MANDATORY_VARIANT; //reset to -1 (UNKNOWN) when not resolved

  virtual BpCommandOptionsBase* GetParser() { return (BpCommandOptionsBase*)(&m_options); }
  virtual exec_status Execute(bp_output_cb_t * outputCb,
			      uvm_ml_time_unit timeUnit,
			      double timeValue);

  virtual void SetDefaultsAll();

  virtual bool SetTheOption(int optIndex);
  virtual bool SetOptionArgument(int optIndex, const char *argumentPtr);

  virtual bool MissedArgumentError(int optIndex, const char *argumentPtr);
  virtual bool QueryOptionsConsistency();

private:
  bool AmbiguousPhaseParameter();
  int m_mandatory_variant_selector; //the command "uvm_ml phase" supports 5 different sub-commands that are mutually exclusive
  BpPhaseCommandOptions m_options;
  friend class BpPredefinedCommand;
  static BpPredefinedCommand *m_the_instance;
  int m_orignated_framework_id;

  enum BeginOrEnd { unknown, begin=0, end} ;
  struct _option_values
  {
    bool	   mandatory_option;
    string	   act_phase;
    BeginOrEnd     which_end;
    bool  	   all_stops;
  };
  _option_values m_val;
  const static _option_values m_defaults;
  enum options_descr { MANDATORY_OPTION=0, BEGIN, END};
};


//class to handle uvm_ml trace_register[_tlm] command
class BpCommandTraceRegister : public BpExternalCommand
{

private:
  BpCommandTraceRegister(); //the singleton instance is created by static get_instance()

public:
  virtual ~BpCommandTraceRegister() {}
  virtual string Name(); //override default in	BpCommandBase
  virtual bool MatchCommand(const string & command_with_arguments); //override default in  BpCommandBase

  virtual BpCommandOptionsBase* GetParser() { return &m_options; }
  virtual exec_status Execute(bp_output_cb_t * outputCb,
			      uvm_ml_time_unit timeUnit,
			      double timeValue);
  
  virtual void SetDefaultsAll();

  virtual bool SetTheOption(int optIndex);
  virtual bool SetOptionArgument(int optIndex, const char *argumentPtr);

  virtual bool MissedArgumentError(int optIndex, const char *argumentPtr) { return true; } //no any mandatory arguments for the command
  virtual bool QueryOptionsConsistency();

private:
  BpTraceRegisterCommandOptions m_options;
  friend class BpPredefinedCommand;
  static BpPredefinedCommand *m_the_instance;

  enum options_descr { ON=0, OFF, UNKNOWN };  
  struct _option_values
  {
     enum options_descr trace_switch;
  };
  _option_values m_val;
  const static _option_values m_defaults;
  set<unsigned char> m_command_lens;
};


class BpCustomCommand : public BpCommandBase
{
private:
  static BpCustomCommand *m_the_instance;
  BpCustomCommand() {}

public:
  static BpCustomCommand *GetInstance() 
  {
    if (!m_the_instance)
      m_the_instance = new BpCustomCommand();
    return m_the_instance;
  }
  virtual ~BpCustomCommand() {}

  virtual void ResetAndInit(const string & command_with_arguments, int frameworkId)
  { 
    BpCommandBase::ResetAndInit(command_with_arguments, frameworkId);
    SetExternalCommand(command_with_arguments);
  }

  virtual exec_status Execute(bp_output_cb_t * outputCb,
			      uvm_ml_time_unit timeUnit,
			      double timeValue);
  virtual void TraceExecute(int frameworkId);
  virtual void TraceResult(exec_status result);
};


#endif /* BP_DEBUG_H */
