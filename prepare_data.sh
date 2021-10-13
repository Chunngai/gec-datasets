set -ex

convert_m2_to_parallel="scripts/convert_m2_to_parallel.py"
remove_unchanged_pairs="scripts/remove_unchanged_pairs.py"
DATA="data"
TAR="$DATA/tar"
ORI="$DATA/ori"
RAW="$DATA/raw"

# Preparation.
mkdir -p $DATA $TAR $ORI $RAW
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
python3 -u $convert_m2_to_parallel "$ORI/fce/fce/m2/fce.train.gold.bea19.m2" "$RAW/fce-train.src" "$RAW/fce-train.trg"
python3 -u $convert_m2_to_parallel "$ORI/nucle/release3.3/bea2019/nucle.train.gold.bea19.m2" "$RAW/nucle.src" "$RAW/nucle.trg"
python3 -u $convert_m2_to_parallel "$ORI/lang8/lang8.train.auto.bea19.m2" "$RAW/lang8.src" "$RAW/lang8.trg"
python3 -u $convert_m2_to_parallel "$ORI/wi_locness/wi+locness/m2/ABC.train.gold.bea19.m2" "$RAW/wi_locness-train.src" "$RAW/wi_locness-train.trg"
cat "$RAW/fce-train.src" "$RAW/nucle.src" "$RAW/lang8.src" "$RAW/wi_locness-train.src" > "$RAW/train-error-free-contained.src"
cat "$RAW/fce-train.trg" "$RAW/nucle.trg" "$RAW/lang8.trg" "$RAW/wi_locness-train.trg" > "$RAW/train-error-free-contained.trg"
python3 $remove_unchanged_pairs "$RAW/train-error-free-contained.src" "$RAW/train-error-free-contained.trg"
#rm $RAW/train-raw.src $RAW/train-raw.trg
# Valid data.
python3 -u $convert_m2_to_parallel "$ORI/wi_locness/wi+locness/m2/ABCN.dev.gold.bea19.m2" "$RAW/wi_locness-valid.src" "$RAW/wi_locness-valid.trg"
#cp "$RAW/wi_locness-valid.src" "$RAW/valid.src"
#cp "$RAW/wi_locness-valid.trg" "$RAW/valid.trg"
# Test data.
python3 -u $convert_m2_to_parallel "$ORI/fce/fce/m2/fce.test.gold.bea19.m2" "$RAW/fce-test.src" "$RAW/fce-test.trg"
python3 -u $convert_m2_to_parallel "$ORI/conll2014/conll14st-test-data/noalt/official-2014.combined.m2" "$RAW/conll14.src" "$RAW/conll14.trg"
cp "$ORI/jfleg/jfleg-master/test/test.src" "$RAW/jfleg.src"
cp "$ORI/wi_locness/wi+locness/test/ABCN.test.bea19.orig" "$RAW/wi_locness-test.src"

# Check.
wc -l $RAW/*