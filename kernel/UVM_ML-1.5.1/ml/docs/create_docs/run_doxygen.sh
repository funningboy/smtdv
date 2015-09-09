#!/bin/sh
doxygen adapters.doxyfile
doxygen framework.doxyfile
doxygen backplane_required.doxyfile
doxygen backplane_provided.doxyfile
doxygen backplane_interconnect_debug.doxyfile

