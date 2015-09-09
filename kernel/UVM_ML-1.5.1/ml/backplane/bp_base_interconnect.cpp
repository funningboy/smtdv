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
#include <string.h>
#include <algorithm>
#include <functional>
#include <dlfcn.h>

#include "bp_utils.h"
#include "bp_interconnect.h"
#include "bp_top_descriptor.h"
#include "bp_framework_proxy.h"

using namespace std;

namespace Bp 
{

bp_serror_t  *                        BpInterconnect::m_serror = 0;

bp_api_struct                         BpInterconnect::m_c_api_tray;

vector< FrameworkProxyClass * >       *BpInterconnect::m_framework_registry_p = 0;

vector< BpConnectionClass * >         BpInterconnect::m_port_registry;

vector< BpTopDescriptorClass * >      BpInterconnect::m_top_level_registry;

vector< BpChildProxyClass * >         BpInterconnect::m_child_proxy_registry;

map<string, vector< FrameworkProxyClass * > * > *BpInterconnect::m_frameworks_by_ind_p = 0;

BpTopDescriptorClass *                BpInterconnect::m_test_component = NULL;

int                                   BpInterconnect::m_trace_mode = 0;

bool                                  BpInterconnect::m_preInitial_cb_registered = false;

bool                                  BpInterconnect::m_elaboration_passed = false;

string                                BpInterconnect::m_test_instance_name = "uvm_test_top"; // Default

map <string, uvm_ml_type_id_t>        BpInterconnect::m_unregistered_types;

map <uvm_ml_type_id_t, string>        BpInterconnect::m_unregistered_type_names;

vector <BpTypeMapEntryClass *>        BpInterconnect::m_registered_types;

vector< BpTopDescriptorBaseClass *>   BpInterconnect::m_top_arguments;

frmw_srv_provider_struct              BpInterconnect::m_srv_providers;


FrameworkProxyClass *                 BpInterconnect::m_common_frmw;

vector<string>                        BpInterconnect::m_cmd_line_tops;

vector<string>                        BpInterconnect::m_cmd_line_tests;


bool                                  BpInterconnect::m_first_time_prerun_cleanup_invocation = true;
unsigned                              BpInterconnect::m_top_level_registry_static_size = 0;


vector< FrameworkProxyClass * >& BpInterconnect::GetFrameworkRegistry()
{
    if (m_framework_registry_p == 0) 
    {
        m_framework_registry_p = new vector< FrameworkProxyClass * >;
    }
    return *m_framework_registry_p;
}
map<string, vector< FrameworkProxyClass * > * >& BpInterconnect::GetFrameworksByInd()
{
    if (m_frameworks_by_ind_p == 0) 
    {
        m_frameworks_by_ind_p = new map<string, vector< FrameworkProxyClass * > * >;
    }
    return *m_frameworks_by_ind_p;
}


///////////////////////////////////////////////////////////////////////
// Implementation variables - we localize them in the .cpp file
// to separate between interface and implementation

BpInterconnect::BpInterconnect() 
{
}

BpInterconnect::~BpInterconnect() 
{
}

void BpInterconnect::ProcessTopsAndTests(vector<string> & tops, vector<string> & tests) 
{
     if (m_elaboration_passed ) 
     {
         // TODO : issue a warning here
         ErrorMsg("ProcessTopsAndTests called after elaboration");
         return;
     }

     if (tests.size() > 1) 
     {
         SERROR(MLUVM03, string("Multiple -uvmtest arguments")); // Only one test argument is legal
         throw 0;
     } 
     else if (tests.size() == 1)
     {
         identifyTestComponent(tests[0]);
     }

     if (tops.size() > 0)
         std::for_each(tops.begin(), tops.end(), identifyTopComponent);

}
    // FIXME - eventually remove this altogether; invoke process_tops_and_tests_wrapper directly from bp_cdns.c
bp_api_struct * BpInterconnect::Bootstrap(vector<string>  & tops,
                                          vector<string>  & tests,
                                          bp_serror_t *     errorF)
{
    m_serror = errorF;

    fillCApiTray();

    // Save command line arguments to retain them upon reset
    m_cmd_line_tops = tops;
    m_cmd_line_tests = tests;

    // Do not process if empty
    if (tops.size() > 0 || tests.size() > 0) {
        try 
        {
            ProcessTopsAndTests(tops, tests);
        }
        catch (int ) 
        {
            // TODO: Add a message arguments parsing failed
	    ErrorMsg("Command line argument parsing failed");
            return (bp_api_struct * ) 0;
        }
    }

    return &m_c_api_tray; // return function tray

}   // Bootstrap

///
void BpInterconnect::identifyTestComponent(const string & arg)
{
    string frameworkIdentifier;
    string compIdentifier;
    string instanceName;

    //assert (m_top_arguments.size() == 0); // Internal Error if it's not empty
    if (m_top_arguments.size() != 0) {
      ErrorMsg("cannot define %s as the test component because the test component is already defined", arg.c_str());
      throw 0;
    }

    ParseArgument(arg, frameworkIdentifier, compIdentifier, instanceName);

    if (compIdentifier.empty()) 
    {
        SERROR(MLUVM16, string ("Empty test component name in the -uvmtest command line argument"));
        throw 0;
    }
    if (frameworkIdentifier.empty()) 
    {
        SERROR(MLUVM16, string ("Empty language identifier in the -uvmtest command line argument"));
        throw 0;
    }
    if (instanceName.empty() == false && instanceName != m_test_instance_name)
    {
      cout << string("Backplane ERROR: uvmtest argument instance name identifier '") << instanceName << "' is not allowed.\n                 The only supported test instance name is uvm_test_top" << endl;
      ErrorMsg("uvmtest argument instance name identifier '%s' is not allowed. The only supported test instance name is uvm_test_top", instanceName.c_str());
        throw 0;
    }  
    m_top_arguments.push_back(new BpTopDescriptorBaseClass(frameworkIdentifier, compIdentifier, m_test_instance_name, true));
}

///
void BpInterconnect::identifyTopComponent(const string & arg)
{
    string frameworkIdentifier;
    string compIdentifier;
    string instanceName;

    ParseArgument(arg, frameworkIdentifier, compIdentifier, instanceName);

    if (compIdentifier.empty())
        SERROR(MLUVM16, "Empty top component name in the -uvmtop command line argument");

    if (frameworkIdentifier.empty())
        SERROR(MLUVM16, "Empty language identifier in the -uvmtop command line argument");

    if (instanceName == "")
        instanceName = compIdentifier;

    // Search for already existing name in list of -tops 
    if (std::find_if(m_top_arguments.begin(), m_top_arguments.end(), 
                     BpTopDescriptorBaseClass::InstanceNameComparer(instanceName)) != m_top_arguments.end())
        SERROR(MLUVM02, string("Multiple -uvmtop arguments with the same name: '") + instanceName + string("'"));

    m_top_arguments.push_back(new BpTopDescriptorBaseClass(frameworkIdentifier, compIdentifier, instanceName, instanceName == m_test_instance_name));
}

void BpInterconnect::ParseArgument(const string & arg, string & frameworkIndicator, string & compIdentifier, string &instanceName)
{
    size_t indicatorDelim = arg.find_first_of(":");

    //assert (indicatorDelim != string::npos) ; // TODO: add proper error message no framework indicator
    if (indicatorDelim == string::npos) {
      ErrorMsg("colon delimiter missing in %s", arg.c_str());
      throw 0;
    }

    frameworkIndicator = arg.substr(0, indicatorDelim);
    std::transform(frameworkIndicator.begin(),frameworkIndicator.end(),frameworkIndicator.begin(),::tolower);
    size_t instanceNameDelim = arg.find_first_of(":", indicatorDelim + 1);
    if (instanceNameDelim == string::npos) {
        compIdentifier = arg.substr(indicatorDelim + 1); // Till the end of the string
        instanceName = "";
    }
    else {
      compIdentifier = arg.substr(indicatorDelim + 1, instanceNameDelim - indicatorDelim - 1);
      instanceName = arg.substr(instanceNameDelim + 1); 
    }
}

void BpInterconnect::ParseTypeName(const string & arg, string & frameworkIndicator, string & typeName)
{
    size_t indicatorDelim = arg.find_first_of(":");

    if (indicatorDelim == string::npos) {
      ErrorMsg("colon delimiter missing in %s", arg.c_str());
    }
    assert (indicatorDelim != string::npos) ; // TODO: add proper error message no framework indicator

    frameworkIndicator = arg.substr(0, indicatorDelim);
    std::transform(frameworkIndicator.begin(),frameworkIndicator.end(),frameworkIndicator.begin(),::tolower);
    typeName = arg.substr(indicatorDelim + 1); // Till the end of the string
}

int BpInterconnect::RegisterFramework( const string &         frameworkName,
                                       vector<string> &       frameworkIndicators,
                                       bp_frmw_c_api_struct * requiredApi)
{
    if (requiredApi == NULL) 
    {
        // TODO:    SERROR(MLUVM17, string("Framework ") + FrameworkIndicator + " API tray pointer is null");
        cout << string("Framework ") + frameworkName + "Required API tray pointer is null" << endl;
        return (-1);
    }
    FrameworkProxyClass * frmw = GetFrameworkProxyByName(frameworkName);

    if (frmw != NULL)
        return frmw->GetFrameworkId();
    else {
        FrameworkProxyClass *frmw = addFramework(frameworkName, frameworkIndicators, requiredApi);
        frmw->BacklogCommands(BpDebugClass::GetBacklogCommands());
        return frmw->GetFrameworkId();
    }
}  

FrameworkProxyClass * BpInterconnect::addFramework( const string &         frameworkName, 
                                  vector<string> &       frameworkIndicators,
                                  bp_frmw_c_api_struct * requiredApi)
{
    int id = GetFrameworkRegistry().size();
    FrameworkProxyClass * newFrmw = new FrameworkProxyClass(id, frameworkName, frameworkIndicators, requiredApi);
    GetFrameworkRegistry().push_back(newFrmw);

    return newFrmw;
}

FrameworkProxyClass * BpInterconnect::GetFramework(int frameworkId)
{
    return GetFrameworkRegistry()[frameworkId];
}

void BpInterconnect::AddFrmwIndicator(const string & indicator, FrameworkProxyClass * frmw)
{
    string indicator_normalized = indicator;
    // The argument indicator is passed by copy intentionally
    std::transform(indicator_normalized.begin(),indicator_normalized.end(),indicator_normalized.begin(),::tolower);

    map<string, vector< FrameworkProxyClass * > *>::iterator it = GetFrameworksByInd().find(indicator_normalized);
 
    vector< FrameworkProxyClass * > * frmws;

    if (it == GetFrameworksByInd().end()) {
 
        frmws = new vector< FrameworkProxyClass * >;
        GetFrameworksByInd()[indicator_normalized] = frmws;
    }
    else
        frmws = GetFrameworksByInd()[indicator_normalized];

    frmws->push_back(frmw);
}

int BpInterconnect::AddRootNode (int            frameworkId, 
                                 int            topComponentId,
                                 const string & compIdentifier,
                                 const string & instanceName)
{
    FrameworkProxyClass * frmw = GetFrameworkRegistry()[frameworkId];

    vector< BpTopDescriptorClass * >::iterator it = 
        std::find_if(m_top_level_registry.begin(), m_top_level_registry.end(), BpTopDescriptorClass::InstanceNameComparer(instanceName));

    if (it != m_top_level_registry.end()) 
    {
        if ((*it)->GetFrmw() == frmw)
        {
            return 0; // already registered
        }
        else 
        {
	    SERROR3(MLUVM01, "UVM-ML Bp Error: Id = %d, multiple top levels with the same name in different languages: top name is '%s', first language is '%s', second language is '%s'\n", instanceName, frmw->GetName().c_str(), (*it)->GetFrmw()->GetName().c_str());
            return (-1);
        }
    }
    
    BpTopDescriptorClass * comp = new BpTopDescriptorClass(frmw, topComponentId, compIdentifier, instanceName, instanceName == m_test_instance_name);
    
    frmw->PushTopLevel(comp);
    AddTopLevel(comp);
    
    return 1;
}

void BpInterconnect::AddTopLevel (BpTopDescriptorClass * topComponent) 
{ 
    m_top_level_registry.push_back(topComponent); 
    if (topComponent->IsTest()) 
    {
        if (m_test_component != NULL) {
	  ErrorMsg("Test component was not registered as test");
        }
        assert (m_test_component == NULL); // TODO: make it a proper error
        m_test_component = topComponent;
    }
};

FrameworkProxyClass * BpInterconnect::GetFrameworkProxyByName(const string & frameworkName)
{
    vector< FrameworkProxyClass * >::iterator it = std::find_if(GetFrameworkRegistry().begin(), 
                                                                GetFrameworkRegistry().end(), 
                                                                FrameworkProxyClass::FrameworkNameComparer(frameworkName));

    return ((it == GetFrameworkRegistry().end()) ? NULL : *it);
}

FrameworkProxyClass * BpInterconnect::GetFrameworkProxyByInd(const string & frameworkIndicator)
{ 
    string indicator_normalized = frameworkIndicator;
    // The argument indicator is passed by copy intentionally
    std::transform(indicator_normalized.begin(), indicator_normalized.end(), indicator_normalized.begin(),::tolower);

    map<string, vector< FrameworkProxyClass * > *>::iterator it = GetFrameworksByInd().find(indicator_normalized);
    if (it == GetFrameworksByInd().end()) // legitimate (for example, for type match settings
        return NULL;
        
    vector< FrameworkProxyClass * > * frmws = GetFrameworksByInd()[indicator_normalized];
    if (frmws == NULL) {
      ErrorMsg("Cannot locate framework because the list is empty");
      return NULL;
    }
    //assert (frmws != NULL);

    if (frmws->size() > 1) {
        cout << string("Backplane ERROR: There are more than one registered framework that matches the indicator '") << frameworkIndicator << "': " << endl; // TODO: Make it a proper error message
        cout << string("              ");
        for (unsigned int j = 0; j < frmws->size(); j++) {
	    cout << (*frmws)[j]->GetName();
           if (j < (frmws->size() - 1))
               cout << string(", ");
	   else
	       cout << endl;
	}
        exit(-1);
    } else
        return (*frmws)[0];
}

void BpInterconnect::SERROR(int msgId, const string & msg)
{
    if (m_serror)
    {
        (*m_serror)(msgId, msg.c_str());
    }
    else 
    {
        printf("UVM-ML Bp Error: Id = %d, msg = %s\n", msgId, msg.c_str());
    }
}

void BpInterconnect::SERROR2(int msgId, const char* fmt, const string & msg, const string & msg1)
{
    if (m_serror)
    {
      (*m_serror)(msgId, msg.c_str(), msg1.c_str());
    }
    else 
    {
      //printf("UVM-ML Bp Error: Id = %d, msg = %s\n", msgId, msg.c_str());
      printf(fmt, msgId, msg.c_str(), msg1.c_str());
    }
}

void BpInterconnect::SERROR3(int msgId, const char* fmt, const string & msg, const string & msg1, const string & msg2)
{
    if (m_serror)
    {
      (*m_serror)(msgId, msg.c_str(), msg1.c_str(), msg2.c_str());
    }
    else 
    {
       printf(fmt, msgId, msg.c_str(), msg1.c_str(), msg2.c_str());
    }
}

void BpInterconnect::SetTraceMode(int mode)
{
    m_trace_mode = mode;
    std::for_each(GetFrameworkRegistry().begin(), GetFrameworkRegistry().end(), std::bind2nd(std::mem_fun(&FrameworkProxyClass::SetTraceMode), m_trace_mode));
}

//==============================================================================
// ---- PHASING
//==============================================================================

//------------------------------------------------------------------------------
/*! Called at the end of Elaborate() to start phasing the frameworks.
 * 
 */
void BpInterconnect::StartPhasing()
{
    if (m_srv_providers.phase_srv_provider)
    {
        DebugTrace("BpInterconnect::StartPhasing Phase Master =  %s\n", m_srv_providers.phase_srv_provider->GetName().c_str());
        m_srv_providers.phase_srv_provider->StartPhasing();
    }
    else
    {
        ErrorMsg("BpInterconnect::StartPhasing() - No phase service registered.");
    }
}

//------------------------------------------------------------------------------
/*! Called by the phase master to notify a non-runtime phase (phase that 
 *  doesn't consume time).
 * 
 *  Backplane will notify each registered framework of the phase and then
 *  notify each registered top of the phase.
 *
 *  Some frameworks have phases that applied to the entire framework and 
 *  are not hierarchical, therefore the backplane splits the notify_phase()
 *  called by the master phase controller into two calls.  One to the 
 *  framework (notify_phase), so it can executed any framework specific
 *  phasing and then to the top components (transmit_phase) to do 
 *  hierachical phasing.
 * 
 */
int BpInterconnect::NotifyPhase
(
    unsigned int        frameworkId,
    const char *        phaseGroup,
    const char *        phaseName,
    uvm_ml_phase_action phaseAction
)
{
    int result = 1;

    if(!m_first_phase) {
        m_first_phase = 1;
	// Check pending stop requests
        for_each(BpInterconnect::BpStopRequestClass::m_requests.begin(), BpInterconnect::BpStopRequestClass::m_requests.end(), BpInterconnect::BpStopRequestClass::CheckPhaseName);
    }

    // Check repository for pending stop request
    if(m_debug_requests.CheckStopRequest(phaseName, phaseAction)) {
        BpInterconnect::m_current_phase_name = phaseName;
        StopPhase(); // Call stopper service
    }
 
    // Check the connection before the start of simulation phase
    // -> at the end of end_of_elaboration
    if (strcmp(phaseName, "start_of_simulation") == 0)
    {
        checkAllConnections();
    }

    if (phaseAction == UVM_ML_PHASE_STARTED || phaseAction == UVM_ML_PHASE_EXECUTING) {
        for (unsigned int i = 0; i < GetFrameworkRegistry().size(); i++) {
            FrameworkProxyClass * frmw = GetFrameworkRegistry()[i];
            result = frmw->NotifyPhase(phaseGroup, phaseName, phaseAction);
            if (result == 0) // failed
	    {
                ErrorMsg("BpInterconnect::NotifyPhase(): framework = %s[%0d] returned with error.", frmw->GetName().c_str(), frmw->GetFrameworkId());
                return result;
            }
        }
    }

    for (unsigned int i = 0; i < m_top_level_registry.size(); i++)
    {
        BpTopDescriptorClass * it = m_top_level_registry[i];
        result = it->TransmitPhase(phaseGroup, phaseName, phaseAction);
        if (result == 0) // failed
        {
            ErrorMsg("BpInterconnect::NotifyPhase(): top = %s[%s] returned with error.", it->GetInstanceName().c_str(), it->GetFrameworkIndicator().c_str());
            return result;
	}
    }

    if (phaseAction == UVM_ML_PHASE_READY_TO_END || phaseAction == UVM_ML_PHASE_ENDED) {
        for (unsigned int i = 0; i < GetFrameworkRegistry().size(); i++) {
            FrameworkProxyClass * frmw = GetFrameworkRegistry()[i];
            result = frmw->NotifyPhase(phaseGroup, phaseName, phaseAction);
            if (result == 0) // failed
	    {
                ErrorMsg("BpInterconnect::NotifyPhase(): framework = %s[%0d] returned with error.", frmw->GetName().c_str(), frmw->GetFrameworkId());
                return result;
	    }
        }
    }
    return result;
}

//------------------------------------------------------------------------------
/*! Called by hierachical parent to notify child of a phase.
 * 
 *  In a unified hierarchy, a child proxy is created for a component that
 *  is in another framework. This child proxy is connected through the
 *  backplane to a parent proxy.  All non-time consuming phase notification
 *  the child proxy receieves is passed to the parent proxy through
 *  the bp_transmit_phase() called.  Runtime (time consuming) phases are
 *  non-hierarchical, and are phased by the framework when it recevies
 *  notification.
 */
int BpInterconnect::TransmitPhase
(
    unsigned int        frameworkId,
    const string &      target_frmw_ind,
    int                 targetId,
    const char *        phaseGroup,
    const char *        phaseName,
    uvm_ml_phase_action phaseAction
)
{
    int          result = 0;


    FrameworkProxyClass *frmw = GetFrameworkProxyByInd(target_frmw_ind);
    //assert (frmw != NULL);
    if(frmw == NULL) {
      ErrorMsg("No framework with name '%s' has been registered", target_frmw_ind.c_str());
      return 0;
    };

    result = frmw->TransmitPhase(targetId, phaseGroup, phaseName, phaseAction);
    if (result == 0) 
        ErrorMsg("BpInterconnect::TransmitPhase(): %s[%0d] framework returned with error for target_id = %0d.", frmw->GetName().c_str(), frmw->GetFrameworkId(), targetId);

    return result;
}

//------------------------------------------------------------------------------
/*! Called by the phase master to notify a runtime phase (phase that consumes time).
 * 
 *  Runtime phases are not hierachical so they are only passed on to each 
 *  framework and not the tops.
 */
int BpInterconnect::NotifyRuntimePhase
(
    unsigned int        frameworkId,
    const char *        phaseGroup,
    const char *        phaseName,
    uvm_ml_phase_action phaseAction,
    uvm_ml_time_unit    timeUnit,
    double              timeValue,
    unsigned int *      participate
)
{
    unsigned int participateCount = 0;
    unsigned int participateTotal = 0;
    int          result = 0;

    BpInterconnect::m_current_phase_name = phaseName;

    // Check repository for pending stop request
    if(m_debug_requests.CheckStopRequest(phaseName, phaseAction)) {
        BpInterconnect::m_current_phase_name = phaseName;
        StopPhase(); // Call stopper service
    }

    for (unsigned int i = 0; i < GetFrameworkRegistry().size(); i++)
    {
        participateCount = 0;
        result = GetFrameworkRegistry()[i]->NotifyRuntimePhase(phaseGroup, phaseName, phaseAction, timeUnit, timeValue, &participateCount);
        participateTotal += participateCount;
    }

    (*participate) = participateTotal;

    return result;
}

//------------------------------------------------------------------------------
/*! Register a common services framework with the backplane.
 *  
 *  Common service framework is a special framework.  It is not in the framework
 *  registry.  This framework only provides serivces and does not participate
 *  in phasing/synchronization/transaction ...
 * 
 */
void BpInterconnect::RegisterCommonSrvFrmw(FrameworkProxyClass * frmw)
{
    m_common_frmw = frmw;
}  

//------------------------------------------------------------------------------
/*! Register which framework will provide which service.
 */
void BpInterconnect::RegisterSrvProviders(unsigned int frameworkId, bp_srv_provider_struct *srv_providers)
{
    FrameworkProxyClass *frmw = NULL;

    // phase service
    if (( srv_providers->phase_srv_provider != NULL ) && (strcmp(srv_providers->phase_srv_provider, "") > 0))
    {
        frmw = findServiceFrmw(srv_providers->phase_srv_provider);
        if (frmw)
        {
            DebugTrace("BpInterconnect Registering Phase Master =  %s\n", frmw->GetName().c_str());
            m_srv_providers.phase_srv_provider = frmw;
        }
        else
        {
            WarningMsg("BpInterconnect::RegisterSrvProviders() Phase service framework not found : %s", srv_providers->phase_srv_provider);
        }
    }


    if ( srv_providers->wakeup_srv_provider != NULL && strcmp(srv_providers->wakeup_srv_provider,"") > 0) {
    	frmw = findServiceFrmw(srv_providers->wakeup_srv_provider);
    	if (frmw) {
    	    m_srv_providers.wakeup_srv_provider = frmw;
    	}
    }

    // find stopper service provider
    if ( srv_providers->stopper_srv_provider != NULL && strcmp(srv_providers->stopper_srv_provider,"") > 0) {
        frmw = findServiceFrmw(srv_providers->stopper_srv_provider);
      	if (frmw) {
      	    m_srv_providers.stopper_srv_provider = frmw;
     	}
     }

    // find print service provider
    if ( srv_providers->print_srv_provider != NULL && strcmp(srv_providers->print_srv_provider,"") > 0) {
        frmw = findServiceFrmw(srv_providers->print_srv_provider);
      	if (frmw) {
      	    m_srv_providers.print_srv_provider = frmw;
     	}
     }

}

//------------------------------------------------------------------------------
/*! Helper function that finds pointer to the service provider framework.
 * 
 *  Common service framework is a special framework.  It is not in the framework
 *  registry.  This framework only provides services and does not participate
 *  in phasing/synchronization/transaction ...
 *  
 */
FrameworkProxyClass * BpInterconnect::findServiceFrmw(const char * name)
{
    FrameworkProxyClass *frmw = NULL;

    if (strcmp(name, m_common_frmw->GetName().c_str()) == 0)
        frmw = m_common_frmw;
    else
        frmw = GetFrameworkProxyByName(name);

    return frmw;
}

//------------------------------------------------------------------------------
/*! Called by the framework and passed to the phase master to notify that
 *  the framework is ready to exit the phase.
 */
void BpInterconnect::PhaseSrvNotifyPhaseDone
(
    unsigned int      frameworkId,
    const char *      phaseGroup,
    const char *      phaseName,
    uvm_ml_time_unit  timeUnit,
    double            timeValue
)
{
    if (m_srv_providers.phase_srv_provider)
    {
        m_srv_providers.phase_srv_provider->PhaseSrvNotifyPhaseDone(frameworkId, phaseGroup, phaseName, timeUnit, timeValue);
    }
    else
    {
        ErrorMsg("BpInterconnect::PhaseSrvNotifyPhaseDone() - No phase service registered.");
    }
}

int BpInterconnect::PhaseSrvCheckPhase
(
    const char *      phaseName
)
{
    if (m_srv_providers.phase_srv_provider)
    {
        return m_srv_providers.phase_srv_provider->PhaseSrvCheckPhase(phaseName);
    }
    else
    {
        ErrorMsg("BpInterconnect::PhaseSrvCheckPhase no service provider phase = %s", phaseName);
        return 0;
    }
}

int BpInterconnect::PhaseSrvCheckFuturePhase
(
    const char *        phaseName,
    uvm_ml_phase_action phaseAction
)
{
    if (m_srv_providers.phase_srv_provider)
    {
        return m_srv_providers.phase_srv_provider->PhaseSrvCheckFuturePhase(phaseName, phaseAction);
    }
    else
    {
        ErrorMsg("BpInterconnect::PhaseSrvCheckFuturePhase no service provider phase = %s", phaseName);
        return 0;
    }
}

void BpInterconnect::instantiateTop(BpTopDescriptorClass * top)
{
    if (top->Instantiate() < 0)
        throw 0; // The framework adapter is responsible to issue the error message. This function allows to stop further phasing
}

int BpInterconnect::Elaborate(void *cbInfo)
{

    if (m_elaboration_passed) {
        WarningMsg("BpInterconnect::Elaborate() - Elaborate called after elaboration time has passed.");
        return 0;
    }

    
    if (cbInfo && (m_top_arguments.size() == 0))
      // if (m_top_arguments.size() == 0)
        return 0; // If Elaborate() is invoked as a bootstrap callback and there were no root nodes specified on the command line
                  // let them to be passed procedurally via bp_run_test()
    m_elaboration_passed = true;

    if (getenv("UVM_ML_DEBUG_MODE"))
        SetTraceMode(1);

    setComponentFrameworks(); // At this point all framework proxies and top components shall be registered 

    try 
    {
        std::for_each(GetFrameworkRegistry().begin(), GetFrameworkRegistry().end(), std::mem_fun(&FrameworkProxyClass::Startup));
    }
    catch (int)
    {
	ErrorMsg("Elaborate failed");
        return 0;
    }

    // std::for_each(m_top_level_registry.begin(), m_top_level_registry.end(), std::mem_fun(&BpTopDescriptorClass::Instantiate));

    try 
    {
        std::for_each(m_top_level_registry.begin(), m_top_level_registry.end(), instantiateTop);
    }
    catch (int)
    {
        return 0;
    }
    // -- Phasing
    StartPhasing();

    return 1;
}

void BpInterconnect::setComponentFrameworks()
{
    std::for_each(m_top_arguments.begin(), m_top_arguments.end(), (std::mem_fun(&BpTopDescriptorBaseClass::SetFrameworkTopLevelComponent)));
}

BpChildProxyClass * BpInterconnect::findChildProxyforPath(const string & path)
{
    BpChildProxyClass * result = NULL;

    BpChildProxyClass * c_proxy = NULL;
    size_t longest_match_length = 0;

    for (unsigned int j = 0; j < m_child_proxy_registry.size(); j++) {
        // Looking for the longest match among the child proxies
        c_proxy = m_child_proxy_registry[j];
   
        const string & proxy_full_name = c_proxy->GetName();
        unsigned int prefix_len = proxy_full_name.length();

        if ((prefix_len > longest_match_length) && 
            BpPrefixCompare(proxy_full_name, path)) {
            // longest match found
	    longest_match_length = prefix_len;
            result = c_proxy;        
	}
    }
    return result;
}

FrameworkProxyClass * BpInterconnect::findFrameworkForPath(const string &path, bool checkConnector)
{
    assert (checkConnector == true); // Currently this method serves only connection paths

    FrameworkProxyClass * frmw = NULL;

    // Looking for the matching prefix first among the child proxies
    // and if not found - among the root nodes

    BpChildProxyClass * c_proxy = findChildProxyforPath(path);

    if (c_proxy != NULL)
    {
        frmw = GetFramework(c_proxy->GetTargetFrameworkId());

	int bind_key = frmw-> GetConnectionBindKey(path);
        if (bind_key == (-1)) { // Check if there is a port in a user-defined proxy on the parent side
	    frmw = GetFramework(c_proxy->GetParentFrameworkId());
            bind_key = frmw->GetConnectionBindKey(path);
            if (bind_key == (-1)) {
	        ErrorMsg("Could not find a UVM-ML framework for connection name '%s' specified in UVM-ML connection function.", path.c_str());
                frmw = NULL;
            }
        }
        return frmw;
    }

    if (BpPrefixCompare(m_test_instance_name, path))
    {
        if(m_test_component == NULL) {
	  ErrorMsg("The instance name 'uvm_test_top' cannot be used in absence of a test component");
	  return NULL;
	};
        //assert (m_test_component != NULL); // TODO: add an error message
                                           // saying that the instance name 
                                           // "uvm_test_top" cannot be used 
                                           // in absence of a test component
        return m_test_component->GetFrmw();
    }
    vector< BpTopDescriptorClass * >::iterator it = 
        std::find_if(m_top_level_registry.begin(),m_top_level_registry.end(), 
                     BpTopDescriptorClass::PrefixComparer(path));

    if (it != m_top_level_registry.end())
    {
        return ((*it)->GetFrmw());
    }
    else {
        ErrorMsg("Could not find a UVM-ML framework for connection name '%s' specified in UVM-ML connection function.", path.c_str());
        return ((FrameworkProxyClass *)0);
    }
}

BpConnectionClass *  BpInterconnect::AddConnection(const string & path)
{
  FrameworkProxyClass * frmw = findFrameworkForPath(path, true);
    if (frmw == NULL)
        return NULL;

    int bind_key = frmw->GetConnectionBindKey(path);
    if (bind_key == (-1)) 
    {
        ErrorMsg("Path %s specified as argument to ML UVM connection function does not exist or has not been registered.", path.c_str());
        return NULL;
    }

    BpConnectionClass * result = new BpConnectionClass(frmw, bind_key, path, frmw->GetConnectionIntfName(bind_key), frmw->GetConnectionKind(bind_key));

    m_port_registry.push_back(result);

    frmw->AddConnection(result, bind_key);

    return result;
}

bool BpConnectionClass::CheckInRange(const string & root_name)
{
    string path = m_connector_descriptor->GetPath(); 
    if(path.substr(0,root_name.length()) == root_name && // prefix match
       (root_name.length() == path.size() ||             // full match
	path.substr(root_name.length(),1) == ".")) {
      return true;
    }
    return false;
}

string BpConnectionClass::GetTypeName() {
    return " [" + m_connector_descriptor->GetFrmw()->GetComponentTypeName(m_connector_descriptor->GetPath()) + "]";
}

BpConnectionClass * BpInterconnect::FindConnectionByName(const string & path)
{
    vector< BpConnectionClass * >::iterator it = std::find_if(m_port_registry.begin(), m_port_registry.end(), 
            BpConnectionClass::PathComparer(path));
    return (it == m_port_registry.end() ? NULL : *it);
}

bool BpInterconnect::checkAllConnections()
{
    bool result = true;
    vector< BpConnectionClass * >::iterator it;
    for (it = m_port_registry.begin(); it != m_port_registry.end(); it++)
    {
        result = result && ((*it)->CheckCompatibility());
    }

    return result;
}

uvm_ml_type_id_t BpInterconnect::GetTypeIdByTypeName(int            frameworkId,
                                                     const string & typeName)
{
    return (uvm_ml_type_id_t) GetFramework(frameworkId)->GetTypeId(typeName);
}

const string & BpInterconnect::GetTypeNameByTypeId(int              frameworkId,
                                                   uvm_ml_type_id_t typeId,
                                                   bool             getBaseName)
{
    return GetFramework(frameworkId)->GetTypeName(typeId, getBaseName);
}

// /////////////////////////////////////////////////
// registerNewTypeMatch() is a private member function
// It is invoked from RegisterTypeMatch() if both types are
// new to the bp
// /////////////////////////////////////////////////

void BpInterconnect::registerNewTypeMatch(FrameworkProxyClass * t1Frmw, 
                                          const string &        t1Name, 
                                          FrameworkProxyClass * t2Frmw, 
                                          const string &        t2Name)
{
    BpTypeMapEntryClass * entry = new BpTypeMapEntryClass(GetNextTypeId());

    entry->AddFrmwEntry(new FrameworkTypeEntryClass(t1Frmw, t1Name));
    entry->AddFrmwEntry(new FrameworkTypeEntryClass(t2Frmw, t2Name));

    t1Frmw->AddRegisteredTypeEntry(t1Name, entry);
    t2Frmw->AddRegisteredTypeEntry(t2Name, entry);
}

bool BpInterconnect::RegisterTypeMatch(BpLangTypeName & type1,
                                       BpLangTypeName & type2)
{
    FrameworkProxyClass * t1_frmw = GetFrameworkProxyByInd(type1.GetLangIndicator());
    if (t1_frmw == NULL)
        return false; // It is legal to call RegisterTypeMatch for a framework which is currently not active

    FrameworkProxyClass * t2_frmw = GetFrameworkProxyByInd(type2.GetLangIndicator());
    if (t2_frmw == NULL)
        return false; // It is legal to call RegisterTypeMatch for a framework which is currently not active

    if(t1_frmw == t2_frmw) {
      ErrorMsg("Cannot associate two type names for the same framework");
    };
    assert (t1_frmw != t2_frmw); // TODO: Otherwise issue a proper error message
    // "Cannot associate two type names for the same framework"

    // Look if those type names already appeared (either in a previous explicit type match (registered)
    // or at runtime as an actual transaction type
    uvm_ml_type_id_t t1_id = t1_frmw->FindTypeId(type1.GetTypeName());
    uvm_ml_type_id_t t2_id = t2_frmw->FindTypeId(type2.GetTypeName());

    if ((t1_id == (uvm_ml_type_id_t)(-1)) && (t2_id == (uvm_ml_type_id_t)(-1)))
    {
      registerNewTypeMatch(t1_frmw, type1.GetTypeName(), t2_frmw, type2.GetTypeName());
    }
    else if (t2_id == (uvm_ml_type_id_t)(-1)) 
    {
        BpTypeMapEntryClass * t1_map_entry = t1_frmw->FindRegisteredTypeEntry(t1_id);
	if(t1_map_entry == NULL) {
	  ErrorMsg("RegisterTypeMatch() was called late, after an object of unregistered Type1 appeared in a transaction");
	};
        assert (t1_map_entry != NULL); // TODO: Otherwise issue a proper error 
        // that RegisterTypeMatch() was called late - 
        // after an object of unregistered Type1 appeared in a transaction
        t1_map_entry->AddFrmwTypeEntry(t2_frmw, type2.GetTypeName());
        t2_frmw->AddRegisteredTypeEntry(type2.GetTypeName(), t1_map_entry);
    } 
    else if (t1_id == (uvm_ml_type_id_t)(-1)) 
    {
        BpTypeMapEntryClass * t2_map_entry = t2_frmw->FindRegisteredTypeEntry(t2_id);
	if(t2_map_entry == NULL) {
	  ErrorMsg("RegisterTypeMatch() was called late, after an object of unregistered Type2 appeared in a transaction");
	};
        assert (t2_map_entry != NULL); // TODO: Otherwise issue a proper error 
        // that RegisterTypeMatch() was called late - 
        // after an object of unregistered Type2 appeared in a transaction
        t2_map_entry->AddFrmwTypeEntry(t1_frmw, type1.GetTypeName());
        t1_frmw->AddRegisteredTypeEntry(type1.GetTypeName(), t2_map_entry);
    } 
    else if (t1_id != t2_id) 
    {
        BpTypeMapEntryClass * t1_map_entry = t1_frmw->FindRegisteredTypeEntry(t1_id);
	if(t1_map_entry == NULL) {
	  ErrorMsg("RegisterTypeMatch() was called late, after an object of unregistered Type1 appeared in a transaction");
	};
        assert (t1_map_entry != NULL); // TODO: Otherwise issue a proper error 
        // that RegisterTypeMatch() was called late - 
        // after an object of unregistered Type1 appeared in a transaction
        BpTypeMapEntryClass * t2_map_entry = t2_frmw->FindRegisteredTypeEntry(t2_id);
	if(t2_map_entry == NULL) {
	  ErrorMsg("RegisterTypeMatch() was called late, after an object of unregistered Type2 appeared in a transaction");
	};
        assert (t2_map_entry != NULL); // TODO: Otherwise issue a proper error 
        // that RegisterTypeMatch() was called late - 
        // after an object of unregistered Type2 appeared in a transaction
        mergeTypeEntries(t1_map_entry, t2_map_entry);
    } // else this pair of types was already registered before and nothing shall be done
    return true;
}

void BpInterconnect::mergeTypeEntries(BpTypeMapEntryClass * entry1, 
                                      BpTypeMapEntryClass * entry2)
{
    ErrorMsg("mergeTypeEntries not supported");
    assert (false); // TODO
}

uvm_ml_type_id_t BpInterconnect::GetUnregisteredTypeId(const string & typeName)
{
    map<string, uvm_ml_type_id_t>::iterator it = m_unregistered_types.find(typeName);
    if (it != m_unregistered_types.end())
        return it->second;

    uvm_ml_type_id_t type_id = GetNextTypeId();
    m_unregistered_types[typeName] = type_id;
    m_unregistered_type_names[type_id] = typeName;
    return type_id;    
}

const string & BpInterconnect::FindUnregisteredTypeName(uvm_ml_type_id_t typeId)
{
    map<uvm_ml_type_id_t, string>::iterator it = m_unregistered_type_names.find(typeId);

    if(it == m_unregistered_type_names.end()) {
      ErrorMsg("FindUnregisteredTypeName: type was not found");
    };
    assert (it != m_unregistered_type_names.end()); // TODO: Issue a proper internal error message
    // about a wrong TypeId
    return it->second;
}

void BpInterconnect::AddRegisteredTypeEntry(BpTypeMapEntryClass * entry)
{
    m_registered_types.push_back(entry);
}

uvm_ml_type_id_t BpInterconnect::GetNextTypeId()
{
    static uvm_ml_type_id_t next_id = 0; // TODO make it a class member - in order to enable reset
    return next_id++;
}

void BpInterconnect::Synchronize(int              frameworkId,
                                 uvm_ml_time_unit timeUnit,
                                 double           timeValue)
{
    for (unsigned int j = 0; j < GetFrameworkRegistry().size(); j++)
        if (GetFrameworkRegistry()[j]->GetFrameworkId() != frameworkId)
	  GetFrameworkRegistry()[j]->Synchronize(timeUnit, timeValue);
}

int BpInterconnect::GetConnectorSize(int frameworkId, int connector_id)
{
    FrameworkProxyClass *frmw = GetFramework(frameworkId);
    if(frmw == NULL) {
      ErrorMsg("Framework was not found, ID is %d", frameworkId);
      return -1;
    };
    //assert (frmw != NULL);
    BpConnectionClass * con = frmw->GetConnection(connector_id);
    if (con != NULL) 
    {
        return con->GetSize();
    }
    else 
    {
        return 0; // Legal situation if an export (or "imp") remained unbound
    }
}

void BpInterconnect::NotifyConfig(int              frameworkId,
                                  const char *     cntxt,
                                  const char *     instanceName,
                                  const char *     field_name,
                                  unsigned int     stream_size,
                                  uvm_ml_stream_t  stream,
                                  uvm_ml_time_unit timeUnit, 
                                  double           timeValue)
{
    for (unsigned int i = 0; i < GetFrameworkRegistry().size(); i++)
    {
        FrameworkProxyClass * frmw = GetFrameworkRegistry()[i];
        if (frmw->GetFrameworkId() != frameworkId)
            frmw->NotifyConfig(cntxt, instanceName, field_name, stream_size, stream, timeUnit, timeValue);
    }    
}

uvm_ml_handle BpInterconnect::RegisterTimeCallback(int              frameworkId,
                                                   uvm_ml_time_unit timeUnit,
                                                   double           timeValue,
                                                   void *           cbData)
{
    FrameworkProxyClass *frmw = m_srv_providers.wakeup_srv_provider;

    if ( frmw != NULL )
    {
        DebugTrace("Registering the time callback for target framework %d via service provider %d",
                  frameworkId, frmw->GetFrameworkId());
        return frmw->RegisterTimeCallback(frameworkId, timeUnit, timeValue, cbData);
    }
    else
    {
        ErrorMsg("Unable to find any wake-up service provider\n");
    }
    return 0; // fail by default
}

int BpInterconnect::RemoveTimeCallback(int           frameworkId,
                                       uvm_ml_handle cb_handle)
{
    FrameworkProxyClass *frmw = m_srv_providers.wakeup_srv_provider;

    if ( frmw != NULL )
    {
        DebugTrace("Removing the time callback %ld for target framework %d via service provider %d",
                  cb_handle, frameworkId, frmw->GetFrameworkId() );
        return frmw->RemoveTimeCallback(cb_handle);
    }
    else
    {
        ErrorMsg("Unable to find any wake-up service provider\n");
    }
    return 0; // fail by default
}

void BpInterconnect::NotifyTimeCallback(int              frameworkId,
                                        int              targetFrameworkId,
                                        uvm_ml_time_unit timeUnit,
                                        double           timeValue,
                                        void *           cbData)
{
    FrameworkProxyClass *frmw = GetFramework(targetFrameworkId);

    if ( frmw != NULL)
    {
        DebugTrace("Notifying framework %s of a time-based callback for time %f %s\n", 
                  frmw->GetName().c_str(), timeValue, BpUtils::convert_uvm_ml_time_unit_to_c_str(timeUnit));
        frmw->NotifyTimeCallback(timeUnit, timeValue, cbData);
    }
    else
    {
        ErrorMsg("Unable to find a framework with id %d\n", targetFrameworkId);
    }
}

void BpInterconnect::NotifyEvent( int                            framework_id,
                                  const char *                   scope_name,
                                  const char *                   event_name,
                                  uvm_ml_event_notify_action     action,
                                  unsigned int                   stream_size,
                                  uvm_ml_stream_t                stream,
                                  uvm_ml_time_unit               time_unit,
                                  double                         time_value)
{
    for (unsigned int i = 0; i < GetFrameworkRegistry().size(); i++)
    {
        FrameworkProxyClass * frmw = GetFrameworkRegistry()[i];
        if (frmw->GetFrameworkId() != framework_id)
            frmw->NotifyEvent(scope_name, event_name, action, stream_size, stream, time_unit, time_value);
    }
}

void BpInterconnect::NotifyBarrier( int                            framework_id,
                                    const char *                   scope_name,
                                    const char *                   barrier_name,
                                    uvm_ml_barrier_notify_action   action,
                                    int                            count,
                                    uvm_ml_time_unit               time_unit,
                                    double                         time_value)
{
    for (unsigned int i = 0; i < GetFrameworkRegistry().size(); i++)
    {
        FrameworkProxyClass * frmw = GetFrameworkRegistry()[i];
        if (frmw->GetFrameworkId() != framework_id)
            frmw->NotifyBarrier(scope_name, barrier_name, action, count, time_unit, time_value);
    }
}

const string & BpInterconnect::GetVersion() 
{
    static string s = UVM_ML_VERSION;
    return s;
}

void BpInterconnect::print_format_va_list(int level, const char * caller_name, const char *fstring, va_list & args) {
    string msg;
    char msg1[1024]; 
    if (level != UVM_ML_INFO)
    {
      msg = "UVM-ML ";
      msg += caller_name;
      switch(level)
      {
	case UVM_ML_ERROR:
	    msg += " ERROR >> ";
	    break;
	case UVM_ML_WARNING:
	    msg += " WARNING >> ";
	    break;
	case UVM_ML_DEBUG:
	    msg += " DEBUG >> ";
	    break;
      };
    }
    vsprintf (msg1, fstring, args);
    msg += msg1;
    if (level != UVM_ML_INFO)
        msg += "\n";
    PrintMessage(msg);
} 

void BpInterconnect::PrintMessage(const char *formatString, ...) {
    va_list args;
    va_start (args, formatString);
    print_format_va_list(UVM_ML_INFO, "", formatString, args);
} 

void BpInterconnect::DebugTrace(const char *formatString, ...)
{
    if (GetTraceMode()) {
        va_list args;
        va_start (args, formatString);
        //BpUtils::print_format_va_list(UVM_ML_DEBUG, "BP", formatString, args);
        print_format_va_list(UVM_ML_DEBUG, "BP", formatString, args);
        va_end(args);
    }
}

void BpInterconnect::ErrorMsg(const char *formatString, ...)
{
    va_list args;
    va_start (args, formatString);
    //BpUtils::print_format_va_list(UVM_ML_ERROR, "BP", formatString, args);
    print_format_va_list(UVM_ML_ERROR, "BP", formatString, args);
    va_end(args);
}

void BpInterconnect::WarningMsg(const char *formatString, ...)
{
    va_list args;
    va_start (args, formatString);
    //BpUtils::print_format_va_list(UVM_ML_WARNING, "BP", formatString, args);
    print_format_va_list(UVM_ML_WARNING, "BP", formatString, args);
    va_end(args);
}

// /////////////////////////////////////////////////
// Phase debug code
// Call the stopper service 
// /////////////////////////////////////////////////

void BpInterconnect::StopPhase()
{
    FrameworkProxyClass *frmw = m_srv_providers.stopper_srv_provider;

    if ( frmw != NULL)
    {
        DebugTrace("Calling stopper service");
        frmw->StopSrvRequest();
    }
    else
    {
        ErrorMsg("Unable to find any stopper service provider\n");
    }
}

// /////////////////////////////////////////////////
// Print service code
// Call the print service 
// /////////////////////////////////////////////////

void BpInterconnect::PrintMessage(const string & message)
{
    FrameworkProxyClass *frmw = m_srv_providers.print_srv_provider;

    if ( frmw != NULL)
    {
        frmw->PrintSrvRequest(message);
    }
    else
    {
        ErrorMsg("Unable to find any print service provider\n");
    }
}

void BpInterconnect::PreRunCleanup() {

    m_port_registry.clear();
    m_child_proxy_registry.clear();
    m_elaboration_passed = false;

    if (m_first_time_prerun_cleanup_invocation == true) {
        m_top_level_registry_static_size = m_top_level_registry.size();
        m_first_time_prerun_cleanup_invocation = false;
    }
    else if (m_top_level_registry_static_size != 0)
        m_top_level_registry.resize(m_top_level_registry_static_size);
    else
        m_top_level_registry.clear();

    m_test_component = NULL;
    m_test_instance_name = "uvm_test_top"; // Default
    m_top_arguments.clear();

    if (m_cmd_line_tops.size() > 0 || m_cmd_line_tests.size() > 0) {
        try 
        {
            ProcessTopsAndTests(m_cmd_line_tops, m_cmd_line_tests);
        }
        catch (int ) 
        {
            // TODO: Add a message arguments parsing failed
	    ErrorMsg("Command line argument parsing failed during reset");
        }
    }
}

void BpInterconnect::Reset()
{
    if (m_framework_registry_p) {
        m_framework_registry_p->clear();
    }
    if ( m_frameworks_by_ind_p ) { 
        m_frameworks_by_ind_p->clear();
    }
    
    m_cmd_line_tops.clear();
    m_cmd_line_tests.clear();


    PreRunCleanup();
    BpDebugClass::Reset();

    m_first_time_prerun_cleanup_invocation = true;
    m_top_level_registry_static_size = 0;
    m_top_level_registry.clear();    
}

int BpInterconnect::GetTraceMode()
{
    return m_trace_mode;
}

} // end namespace Bp
