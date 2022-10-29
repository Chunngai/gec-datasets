set -ex

source ./vars.sh

# Unzips datasets.zip.
unzip -o "datasets.zip" -d $DATA
mv $DATA/*gz $DATA/*bz2 $TAR

# tar -> ori.
for dataset in "fce" "nucle" "lang8" "wi_locness" "conll2014" "jfleg"; do
  mkdir -p "$ORI/$dataset"
done
tar xvzf "$TAR/fce_v2.1.bea19.tar.gz" -C "$ORI/fce"
tar xvjf "$TAR/release3.3.tar.bz2" -C "$ORI/nucle"
tar xvzf "$TAR/lang8.bea19.tar.gz" -C "$ORI/lang8"
tar xvzf "$TAR/wi+locness_v2.1.bea19.tar.gz" -C "$ORI/wi_locness"
tar xvzf "$TAR/conll14st-test-data.tar.gz" -C "$ORI/conll2014"
tar xvzf "$TAR/jfleg.tar.gz" -C "$ORI/jfleg"

# ori -> raw.
# Train data.
python3 -u $m2_to_parallel "$ORI/fce/fce/m2/fce.train.gold.bea19.m2" --fsrcs "$RAW/fce-train.src" --ftrgs "$RAW/fce-train.trg" --id 0
python3 -u $m2_to_parallel "$ORI/nucle/release3.3/bea2019/nucle.train.gold.bea19.m2" --fsrcs "$RAW/nucle.src" --ftrgs "$RAW/nucle.trg" --id 0
python3 -u $m2_to_parallel "$ORI/lang8/lang8.train.auto.bea19.m2" --fsrcs "$RAW/lang8.src" --ftrgs "$RAW/lang8.trg" --id 0
python3 -u $m2_to_parallel "$ORI/wi_locness/wi+locness/m2/ABC.train.gold.bea19.m2" --fsrcs "$RAW/wi_locness-train.src" --ftrgs "$RAW/wi_locness-train.trg" --id 0
# Valid data.
python3 -u $m2_to_parallel "$ORI/wi_locness/wi+locness/m2/ABCN.dev.gold.bea19.m2" --fsrcs "$RAW/wi_locness-valid.src" --ftrgs "$RAW/wi_locness-valid.trg" --id 0
# Test data.
python3 -u $m2_to_parallel "$ORI/fce/fce/m2/fce.test.gold.bea19.m2" --fsrcs "$RAW/fce-test.src" --ftrgs "$RAW/fce-test.trg" --id 0
python3 -u $m2_to_parallel "$ORI/conll2014/conll14st-test-data/noalt/official-2014.combined.m2" --fsrcs "$RAW/conll14.src" --ftrgs "$RAW/conll14.trg" --id 0
cp "$ORI/wi_locness/wi+locness/test/ABCN.test.bea19.orig" "$RAW/wi_locness-test.src"
cp "$ORI/jfleg/jfleg-master/test/test.src" "$RAW/jfleg.src"

# [TASK SPECIFIC] Combines for train data.
cat "$RAW/fce-train.src" "$RAW/nucle.src" "$RAW/lang8.src" "$RAW/wi_locness-train.src" > "$RAW/train.w.err-free.src"
cat "$RAW/fce-train.trg" "$RAW/nucle.trg" "$RAW/lang8.trg" "$RAW/wi_locness-train.trg" > "$RAW/train.w.err-free.trg"
# [TASK SPECIFIC] Removes error free pairs.
python3 $rm_err_free "$RAW/train.w.err-free.src" "$RAW/train.w.err-free.trg"

# [TASK SPECIFIC] For valid data.
cp "$RAW/wi_locness-valid.src" "$RAW/valid.src"
cp "$RAW/wi_locness-valid.trg" "$RAW/valid.trg"

# Check.
wc -l $RAW/*

# Test.
bash test/test_output_samples.sh