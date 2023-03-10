set -ex

source ./vars.sh

M2="$DATA/m2.200"
mkdir -p $M2

python3.6 -m venv .errant200
source .errant200/bin/activate

pip3 install -U setuptools wheel
pip3 install errant==2.0.0
if [ ! -f packages/en_core_web_sm-1.2.0.tar.gz ]; then
  wget https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-1.2.0/en_core_web_sm-1.2.0.tar.gz -P packages/
fi
pip3 install packages/en_core_web_sm-1.2.0.tar.gz # Downloaded from https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-1.2.0/en_core_web_sm-1.2.0.tar.gz
python3.6 -m spacy link en_core_web_sm en # Creates a shortcut link.

for dataset in "fce-train" "nucle" "lang8" "wi_locness-train"; do
  if [ ! -f "$M2/$dataset"".m2" ]; then
    errant_parallel -orig "$RAW/$dataset"".src" -cor "$RAW/$dataset"".trg" -out "$M2/$dataset"".m2"
  fi
done
