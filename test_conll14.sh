#!/usr/bin/bash

set -ex

output=$1
m2scorer="scorers/m2scorer/m2scorer"
reference="data/ori/conll2014/conll14st-test-data/noalt/official-2014.combined.m2"

python2.7 $m2scorer $output $reference