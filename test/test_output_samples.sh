#!/usr/bin/bash

set -ex

bash test_fce.sh output_samples/fce.out
bash test_conll14.sh output_samples/conll14.out
bash test_jfleg.sh output_samples/jfleg.out