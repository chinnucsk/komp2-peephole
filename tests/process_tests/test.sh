#! /bin/sh

#============================================================================
echo "------------------------------------------------------------------------"
echo "---                  Running process_tests/test.sh                   ---"
echo "------------------------------------------------------------------------"

HIPE=$1
COMP_FLAGS=$2
ERL_FLAGS=$3

#============================================================================

testfiles="simpl_send_rec?.erl proc_test?.erl link_test?.erl live_var_bug.erl"

testdir="process_tests"

#============================================================================

. ../test_common.sh

#============================================================================
