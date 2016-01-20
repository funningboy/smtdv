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
.PHONY: default loader32 loader64 debug32 debug64 optimize32 optimize64 clean
default: loader32 loader64


loader32 debug32 optimize32: BITS=32
loader64 debug64 optimize64: BITS=64

optimize64 optimize32 : UVM_ML_DEBUG_FLAGS=


loader32 loader64 debug32 optimize32 debug64 optimize64: 
	$(MAKE) -f Makefile.ncsim BITS=${BITS} UVM_ML_DEBUG_FLAGS="${UVM_ML_DEBUG_FLAGS}"
clean:
	$(MAKE) -f Makefile.ncsim clean BITS=64
	$(MAKE) -f Makefile.ncsim clean BITS=32
