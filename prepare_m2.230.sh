set -ex

source ./vars.sh

M2="$DATA/m2.230"
mkdir -p $M2

python3.7 -m venv .errant230
source .errant230/bin/activate

pip3 install -U pip setuptools wheel
pip3 install errant==2.3.0
if [ ! -f packages/en_core_web_sm-2.3.1.tar.gz ]; then
  wget https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-2.3.1/en_core_web_sm-2.3.1.tar.gz -P packages/
fi
pip3 install packages/"en_core_web_sm-2.3.1.tar.gz"  # Downloaded from https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-2.3.1/en_core_web_sm-2.3.1.tar.gz
python3.7 -m spacy link --force en_core_web_sm en # Creates a shortcut link.

for dataset in "fce-train" "nucle" "lang8" "wi_locness-train" "wi_locness-valid"; do
  if [ ! -f "$M2/$dataset"".m2" ]; then
    errant_parallel -orig "$RAW/$dataset"".src" -cor "$RAW/$dataset"".trg" -out "$M2/$dataset"".m2"
  fi
done

for dataset in "valid" "train.w.err-free" "train.wo.err-free"; do
  if [ ! -f "$M2/$dataset"".m2" ]; then
    errant_parallel -orig "$RAW/$dataset"".src" -cor "$RAW/$dataset"".trg" -out "$M2/$dataset"".m2"
  fi
done
