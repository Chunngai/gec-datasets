#!/usr/bin/bash

set -ex

output=$1
gleu="data/ori/jfleg/jfleg-master/eval/gleu.py"
reference="data/ori/jfleg/jfleg-master/test/test.ref[0-3]"
source="data/ori/jfleg/jfleg-master/test/test.src"

python3 $gleu -r $reference \
    -s $source \
    --hyp $output
