#! /bin/sh

#============================================================================
echo "------------------------------------------------------------------------"
echo "---                  Running memory_tests/test.sh --                 ---"
echo "------------------------------------------------------------------------"

HIPE=$1
COMP_FLAGS=$2
ERL_FLAGS=$3

#============================================================================

testfiles="*.erl"

testdir="memory_tests"

#============================================================================

. ../test_common.sh

#============================================================================
