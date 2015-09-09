# ----------------------------------------------------------------------
#    Copyright 2012 Cadence Design Systems, Inc.
#    All Rights Reserved Worldwide
# 
#    Licensed under the Apache License, Version 2.0 (the
#    "License"); you may not use this file except in
#    compliance with the License.  You may obtain a copy of
#    the License at
# 
#        http://www.apache.org/licenses/LICENSE-2.0
# 
#    Unless required by applicable law or agreed to in
#    writing, software distributed under the License is
#    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#    CONDITIONS OF ANY KIND, either express or implied.  See
#    the License for the specific language governing
#    permissions and limitations under the License.
# ----------------------------------------------------------------------
ARCH = lnx86


.PHONY: default nodebug64 debug64 nodebug32 debug32 nodebug debug clean optimize optimize32 optimize64
 
default : debug32

debug32 nodebug32 optimize32: BITS=32
debug64 nodebug64 optimize64: BITS=64

nodebug32 optimize32 nodebug64 optimize64 : UVM_ML_DEBUG_FLAGS=

nodebug64 optimize64 debug64 debug32 nodebug32 optimize32:
	$(MAKE) -f Makefile.uvm ARCH=$(ARCH) BITS=${BITS} UVM_ML_DEBUG_FLAGS="${UVM_ML_DEBUG_FLAGS}"


nodebug optimize: nodebug64 nodebug32
debug :  debug64 debug32

clean:
	$(MAKE) -f Makefile.uvm ARCH=$(ARCH) clean BITS=32
	$(MAKE) -f Makefile.uvm ARCH=$(ARCH) clean BITS=64


