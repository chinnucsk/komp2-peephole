#! /bin/sh

#============================================================================
echo "------------------------------------------------------------------------"
echo "---                  Running native_tests/test.sh                    ---"
echo "------------------------------------------------------------------------"

HIPE=$1
COMP_FLAGS=$2
ERL_FLAGS=$3

testfiles="const_size_test.erl load_n_times.erl no_inline_fp.erl"

testdir="native_tests"

#============================================================================

. ../test_common.sh

#============================================================================