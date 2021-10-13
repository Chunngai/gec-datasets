#!/usr/bin/bash

set -ex

output=$1
m2scorer="scorers/m2scorer/m2scorer"
reference="data/ori/fce/fce/m2/fce.test.gold.bea19.m2"

python2.7 $m2scorer $output $reference