# gec-data-utils
Grammatical error correction utilities for data preparation and results evaluation.

## Data Preparation
This section introduces the steps to prepare for GEC parallel data. The datasets considered in this repo is: FCE, NUCLE, Lang-8, Write&Improve+LOCNESS, CoNLL-2014 and JFLEG.

### GEC Datasets
1) First, download the GEC datasets from their websites.
+ FCE, NUCLE, Lang-8 and Write\&Improve+LOCNESS datasets can be downloaded from the [BEA-2019](https://www.cl.cam.ac.uk/research/nl/bea2019st/#eval) website.
+ CoNLL-2014 can be downloaded from the [CoNLL-2014](https://www.comp.nus.edu.sg/~nlp/conll14st.html) website.
+ JFLEG can be downloaded from the [JFLEG](https://github.com/keisks/jfleg) repo.

2) Compress the datasets into `datasets.zip` and place `datasets.zip` in the root directory so that the data preparation script can find it. `datasets.zip` contains:  
   + fce_v2.1.bea19.tar.gz&ensp;&ensp;// FCE dataset tar ball  
   + release3.3.tar.bz2&ensp;&ensp;// NUCLE dataset tar ball  
   + lang8.bea19.tar.gz&ensp;&ensp;// Lang-8 dataset tar ball  
   + wi+locness_v2.1.bea19.tar.gz&ensp;&ensp;// Write\&Improve+LOCNESS dataset tar ball  
   + conll14st-test-data.tar.gz&ensp;&ensp;// CoNLL-2014 dataset tar ball  
   + jfleg.tar.gz&ensp;&ensp;// JFLEG dataset tar ball made by compressing the cloned repo

### Parallel Data Preparation
Run the command below to prepare for the GEC data.  

```bash
sh prepare_data.sh
```

A `data` directory will be generated with three subdirectories: `tar`, `ori` and `raw`.
+ `tar`: contains GEC dataset tar balls unzipped from `datasets.zip`.
+ `ori`: contains what are unzipped from each tar ball in `tar`.
+ `raw`: contains parallel GEC data files which can be tokenized later with specific needs such as model training and testing.

Statistics:
```
    28350 data/raw/fce-train.src
    28350 data/raw/fce-train.trg
    57151 data/raw/nucle.src
    57151 data/raw/nucle.trg
  1037561 data/raw/lang8.src
  1037561 data/raw/lang8.trg
    34308 data/raw/wi_locness-train.src
    34308 data/raw/wi_locness-train.trg
  1157370 data/raw/train.w.err.free.src
  1157370 data/raw/train.w.err.free.trg
   561525 data/raw/train.wo.err.free.src
   561525 data/raw/train.wo.err.free.trg

     4384 data/raw/wi_locness-valid.src
     4384 data/raw/wi_locness-valid.trg
     4384 data/raw/valid.src
     4384 data/raw/valid.trg

     2695 data/raw/fce-test.src
     2695 data/raw/fce-test.trg
     1312 data/raw/conll14.src
     1312 data/raw/conll14.trg
     4477 data/raw/wi_locness-test.src
     747 data/raw/jfleg.src

  5783304 total
```

## Evaluation
This section introduces the steps to evaluate GEC outputs. Note that `m2scorer` is needed for evaluating the FCE-test and CoNLL-2014 outputs. Download [m2scorer](https://www.comp.nus.edu.sg/~nlp/conll14st.html) and place it in the `scorers` directory. 

### FCE Evaluation
```bash
sh test_fce.sh output_samples/fce.out
```

+ Precision   : 0.6129
+ Recall      : 0.4181
+ F_0.5       : 0.5606

### CoNLL-2014 Evaluation
```bash
sh test_conll14.sh output_samples/conll14.out
```

+ Precision   : 0.6835
+ Recall      : 0.4636
+ F_0.5       : 0.6243

### Write\&Improve+LOCNESS Evaluation.
The Write\&Improve+LOCNESS dataset should be evaluated on [Codalab](https://competitions.codalab.org/competitions/20228#participate) by compressing the output into a .zip file and submitting it in "Participate".

+ p_cs:66.40
+ r_cs:61.21
+ f0.5_cs:65.29

### JFLEG Evaluation
```bash
sh test_jfleg.sh output_samples/jfleg.out
```

+ GLEU: 0.614138