set -ex

source ./vars.sh

pip3 install -U pip setuptools wheel

## ERRANT 2.0.0
M2="$DATA/m2.w.errant.2.0.0"
mkdir $M2
python3.6 -m venv .errant-2-0-0
source .errant-2-0-0/bin/activate
pip3 install errant==2.0.0
pip3 install "en_core_web_sm-1.2.0.tar.gz" # Downloaded from https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-1.2.0/en_core_web_sm-1.2.0.tar.gz
python3.6 -m spacy link en_core_web_sm en # Creates a shortcut link.

# ERRANT 2.3.0
#M2="$DATA/m2.w.errant.2.3.0"
#mkdir $M2
#python3.7 -m venv .errant-2-3-0
#source .errant-2-3-0/bin/activate
#pip3 install errant
#pip3 install "en_core_web_sm-2.3.1.tar.gz"  # Downloaded from https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-2.3.1/en_core_web_sm-2.3.1.tar.gz
#python3.7 -m spacy link en_core_web_sm en # Creates a shortcut link.

for dataset in "fce-train" "nucle" "lang8" "wi_locness-train" "wi_locness-valid" "fce-test" "conll14"; do
  errant_parallel -orig "$RAW/$dataset"".src" -cor "$RAW/$dataset"".trg" -out "$M2/$dataset"".m2"
done

for dataset in "train.w.err-free" "train.wo.err-free" "valid"; do
  errant_parallel -orig "$RAW/$dataset"".src" -cor "$RAW/$dataset"".trg" -out "$M2/$dataset"".m2"
done