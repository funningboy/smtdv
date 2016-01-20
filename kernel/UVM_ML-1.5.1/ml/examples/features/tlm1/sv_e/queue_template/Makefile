## 
## -------------------------------------------------------------
##    Copyright 2010 Cadence.
##    All Rights Reserved Worldwide
## 
##    Licensed under the Apache License, Version 2.0 (the
##    "License"); you may not use this file except in
##    compliance with the License.  You may obtain a copy of
##    the License at
## 
##        http://www.apache.org/licenses/LICENSE-2.0
## 
##    Unless required by applicable law or agreed to in
##    writing, software distributed under the License is
##    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
##    CONDITIONS OF ANY KIND, either express or implied.  See
##    the License for the specific language governing
##    permissions and limitations under the License.
## -------------------------------------------------------------
## 

include ${UVM_ML_HOME}/ml/example_utils/Makefile.location

.PHONY: default ies ies_proc ies_ncsc_cl ies_ncsc_proc ies_osci ies_osci_proc vcs gui clean distclean questa questa_osci_proc questa_sc ies_osci_cl_multistep ies_ncsc_cl_multistep ies_osci_proc_multistep ies_ncsc_proc_multistep 
default ies ies_proc ies_ncsc_cl ies_ncsc_proc:
	$(MAKE) -C ${UVM_ML_TEST_RUN_DIR} -f ${UVM_ML_TEST_SRC_DIR}/Makefile.ies $@
gui:
	$(MAKE) -C ${UVM_ML_TEST_RUN_DIR} -f ${UVM_ML_TEST_SRC_DIR}/Makefile.ies ies_proc EXIT_OPT="" GUI_OPT="-gui"
ies_osci ies_osci_proc ies_osci_cl ies_osci_cl_multistep ies_osci_proc_multistep questa_sc ies_ncsc_cl_multistep ies_ncsc_proc_multistep: 
	@echo $@ is not applicable
	@/bin/true
vcs:
	$(MAKE) -C ${UVM_ML_TEST_RUN_DIR} -f ${UVM_ML_TEST_SRC_DIR}/Makefile.vcs run
questa questa_osci_proc: 
	$(MAKE) -C ${UVM_ML_TEST_RUN_DIR} -f ${UVM_ML_TEST_SRC_DIR}/Makefile.questa run
clean:
	$(MAKE) -C ${UVM_ML_TEST_RUN_DIR} -f ${UVM_ML_TEST_SRC_DIR}/Makefile.ies $@
	$(MAKE) -C ${UVM_ML_TEST_RUN_DIR} -f ${UVM_ML_TEST_SRC_DIR}/Makefile.vcs $@
	$(MAKE) -C ${UVM_ML_TEST_RUN_DIR} -f ${UVM_ML_TEST_SRC_DIR}/Makefile.questa distclean

