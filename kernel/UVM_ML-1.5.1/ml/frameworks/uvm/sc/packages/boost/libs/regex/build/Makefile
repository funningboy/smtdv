# copyright John Maddock 2006-7
# Distributed under the Boost Software License, Version 1.0. 
# (See accompanying file LICENSE_1_0.txt or copy at 
# http://www.boost.org/LICENSE_1_0.txt.
#
# auto generated makefile for gcc compiler
#
# usage:
# make
#   brings libraries up to date
# make clean
#   deletes temporary object files (but not archives).
#

#
# the following environment variables are recognised:
# ICU_PATH= Path to ICU installation.
# CXXFLAGS= extra compiler options - note applies to all build variants
# INCLUDES= additional include directories
# LDFLAGS=  additional linker options
# LIBS=     additional library files

# compiler:
CXX = $(UVM_ML_CC)
LINKER ?= $(UVM_ML_LD) -shared
#
# compiler options for release build:
#
C1=-c -O2 -I../../.. $(BIT_CXXFLAGS) -I../../../../..
#
# compiler options for debug build:
#
C2=-c -g -I../../.. $(BIT_CXXFLAGS) -I../../../../..

ifeq "$(ICU_PATH)" ""
$(warning "Building Boost.Regex without ICU / Unicode support:")
$(warning "Hint: set ICU_PATH on the nmake command line to point ")
$(warning "to your ICU installation if you have one.")
else
ICU_CXXFLAGS= -DBOOST_HAS_ICU=1 -I$(ICU_PATH)/include
ICU_LDFLAGS= -L$(ICU_PATH)/lib
ICU_LIBS= -licui18n -licuuc
$(warning "Building Boost.Regex with ICU in $(ICU_PATH)")
endif


OBJEXT ?= o
LIB_DIR ?= .
#LIB_NAME ?= libboost_regex-gcc-1_47.${UVM_ML_COMPILER_VERSION}.so
LIB_NAME ?= libboost_regex-gcc-1_47.${UVM_ML_COMPILER_VERSION}.a

ALL_HEADER= ../../../include/regex/config.hpp \
			../../../include/regex/icu.hpp \
			../../../include/regex/pattern_except.hpp \
			../../../include/regex/regex_traits.hpp \
			../../../include/regex/user.hpp \
			../../../include/regex/v4/basic_regex.hpp \
			../../../include/regex/v4/basic_regex_creator.hpp \
			../../../include/regex/v4/basic_regex_parser.hpp \
			../../../include/regex/v4/c_regex_traits.hpp \
			../../../include/regex/v4/char_regex_traits.hpp \
			../../../include/regex/v4/cpp_regex_traits.hpp \
			../../../include/regex/v4/cregex.hpp \
			../../../include/regex/v4/error_type.hpp \
			../../../include/regex/v4/fileiter.hpp \
			../../../include/regex/v4/instances.hpp \
			../../../include/regex/v4/iterator_category.hpp \
			../../../include/regex/v4/iterator_traits.hpp \
			../../../include/regex/v4/match_flags.hpp \
			../../../include/regex/v4/match_results.hpp \
			../../../include/regex/v4/mem_block_cache.hpp \
			../../../include/regex/v4/perl_matcher.hpp \
			../../../include/regex/v4/perl_matcher_common.hpp \
			../../../include/regex/v4/perl_matcher_non_recursive.hpp \
			../../../include/regex/v4/perl_matcher_recursive.hpp \
			../../../include/regex/v4/primary_transform.hpp \
			../../../include/regex/v4/protected_call.hpp \
			../../../include/regex/v4/regbase.hpp \
			../../../include/regex/v4/regex.hpp \
			../../../include/regex/v4/regex_format.hpp \
			../../../include/regex/v4/regex_fwd.hpp \
			../../../include/regex/v4/regex_grep.hpp \
			../../../include/regex/v4/regex_iterator.hpp \
			../../../include/regex/v4/regex_match.hpp \
			../../../include/regex/v4/regex_merge.hpp \
			../../../include/regex/v4/regex_raw_buffer.hpp \
			../../../include/regex/v4/regex_replace.hpp \
			../../../include/regex/v4/regex_search.hpp \
			../../../include/regex/v4/regex_split.hpp \
			../../../include/regex/v4/regex_token_iterator.hpp \
			../../../include/regex/v4/regex_traits.hpp \
			../../../include/regex/v4/regex_traits_defaults.hpp \
			../../../include/regex/v4/regex_workaround.hpp \
			../../../include/regex/v4/states.hpp \
			../../../include/regex/v4/sub_match.hpp \
			../../../include/regex/v4/syntax_type.hpp \
			../../../include/regex/v4/u32regex_iterator.hpp \
			../../../include/regex/v4/u32regex_token_iterator.hpp \
			../../../include/regex/v4/w32_regex_traits.hpp \
			../../../include/regex/config/borland.hpp \
			../../../include/regex/config/cwchar.hpp

all : boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}  lns

clean :  boost_regex-gcc-1_47_clean boost_regex-gcc-d-1_47_clean 
	-rm -f $(CURDIR)/$(LIB_NAME) $(LIB_DIR)/libuvmscboost_regex.a

install : all

lns: $(LIB_NAME)
	mkdir -p $(LIB_DIR)
	ln -sf $(CURDIR)/$(LIB_NAME) $(LIB_DIR)/libuvmscboost_regex.a

########################################################
#
# section for libboost_regex-gcc-1_47.a
#
########################################################

OBJDIR=boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}

${OBJDIR}/%.$(OBJEXT) : ../src/%.cpp $(ALL_HEADER) 
	$(CXX) $(INCLUDES) -o $@ $(C1) $(CXXFLAGS)  $(ICU_CXXFLAGS) $<



boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION} : 
	mkdir -p boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}

boost_regex-gcc-1_47_clean :
	rm -rf boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}
.PHONY: boost_regex-gcc-d-1_47_clean
boost_regex-gcc-d-1_47_clean: 
	@/bin/true
$(LIB_NAME) : boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/c_regex_traits.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/cpp_regex_traits.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/cregex.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/fileiter.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/icu.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/instances.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/posix_api.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/regex.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/regex_debug.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/regex_raw_buffer.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/regex_traits_defaults.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/static_mutex.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/usinstances.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/w32_regex_traits.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/wc_regex_traits.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/wide_posix_api.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/winstances.$(OBJEXT)
	ar rc $@   boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/c_regex_traits.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/cpp_regex_traits.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/cregex.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/fileiter.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/icu.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/instances.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/posix_api.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/regex.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/regex_debug.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/regex_raw_buffer.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/regex_traits_defaults.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/static_mutex.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/usinstances.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/w32_regex_traits.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/wc_regex_traits.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/wide_posix_api.$(OBJEXT) boost_regex-gcc-1_47_shared/${UVM_ML_COMPILER_VERSION}/winstances.$(OBJEXT) 

