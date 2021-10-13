# gec-data-utils
Grammatical error correction utilities for data preparation and results evaluation.

## GEC Data Preparation
### GEC Datasets Preparation
Note that the GEC datasets should be prepared in advanced and zipped into `datasets.zip`. Place `datasets.zip` in the root directory so that the script can find it. The structure of `datasets.zip` is like:  

datasets.zip -|  
&ensp;&ensp;&ensp;&ensp;|- fce_v2.1.bea19.tar.gz&ensp;&ensp;// FCE dataset tar ball  
&ensp;&ensp;&ensp;&ensp;|- release3.3.tar.bz2&ensp;&ensp;// NUCLE dataset tar ball  
&ensp;&ensp;&ensp;&ensp;|- lang8.bea19.tar.gz&ensp;&ensp;// Lang-8 dataset tar ball  
&ensp;&ensp;&ensp;&ensp;|- wi+locness_v2.1.bea19.tar.gz&ensp;&ensp;// Write\&Improve+LOCNESS dataset tar ball  
&ensp;&ensp;&ensp;&ensp;|- conll14st-test-data.tar.gz&ensp;&ensp;// Conll-2014 dataset tar ball  
&ensp;&ensp;&ensp;&ensp;|- jfleg.tar.gz&ensp;&ensp;// JFLEG dataset tar ball  

+ The download method for FCE, NUCLE, Lang-8 and Write\&Improve+LOCNESS datasets can be found on the [BEA-2019 website](https://www.cl.cam.ac.uk/research/nl/bea2019st/#eval).
+ CoNLL-2014 can be downloaded from its [website](https://www.comp.nus.edu.sg/~nlp/conll14st.html).
+ The JFLEG tar ball is made by cloning the [JFLEG repo](https://github.com/keisks/jfleg) and compressing it.

### Parallel Data Generation
Run the command below to prepare for the GEC data.  

```bash
sh prepare_data.sh
```

The command will generate a `data` directory with three sub-directories inside: `tar`, `ori` and `raw`.
+ `tar`: contains files (GEC dataset tar balls) unzipped from `datasets.zip`.
+ `ori`: contains what are unziped from each tar ball in `tar`.
+ `raw`: contains parallel GEC data.

## Evaluation
Note that m2scorer is needed for the FCE and CoNLL-2014 evaluation. Place it in the `scorers` directory. It can be downloaded [here](https://www.comp.nus.edu.sg/~nlp/conll14st.html).

### FCE Evaluation
```bash
sh test_fce.sh SYSTEM_LINE_BY_LINE_OUTPUT
```

### CoNLL-2014 Evaluation
```bash
sh test_conll14.sh SYSTEM_LINE_BY_LINE_OUTPUT
```

### JFLEG Evaluation
```bash
sh test_jfleg.sh SYSTEM_LINE_BY_LINE_OUTPUT
```

### Write\&Improve+LOCNESS Evaluation.
This dataset should be evaluated on [Codalab](https://competitions.codalab.org/competitions/20228#participate).
