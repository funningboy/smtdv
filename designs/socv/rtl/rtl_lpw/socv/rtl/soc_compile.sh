#!/bin/sh -f


irun -c -mess \
 -f ${UVM_REF_HOME}/designs/socv/rtl/rtl_lpw/socv/topologies/or1k.topology \
 -F ${UVM_REF_HOME}/designs/socv/rtl/rtl_lpw/socv/rtl/socv.irunargs \
 -F ${UVM_REF_HOME}/designs/socv/rtl/rtl_lpw/socv/rtl/socv_or1k.irunargs

