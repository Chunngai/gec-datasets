#!/usr/bin/env python

import sys

if len(sys.argv) != 5:
    print("[USAGE] %s m2_file output_src output_tgt annotator_id" % sys.argv[0])
    sys.exit()

input_path = sys.argv[1]
output_src_path = sys.argv[2]
output_tgt_path = sys.argv[3]
annotator_id = sys.argv[4]

words = []
corrected = []
sid = eid = 0
prev_sid = prev_eid = -1
pos = 0

source_sentence = None
target_sentences = set()
cur_annotator_id = 0

with open(input_path) as input_file, \
        open(output_src_path, 'w') as output_src_file, \
        open(output_tgt_path, 'w') as output_tgt_file:
    for line in input_file:
        line = line.strip()
        if line.startswith('S'):
            # Src.
            source_sentence = line[2:]
            # Trg tokens.
            words = source_sentence.split()
            corrected = ['<S>'] + words[:]
        elif line.startswith('A'):

            annotator_id_of_the_line = int(line.split("|||")[-1])
            if annotator_id == "*":
                if annotator_id_of_the_line != cur_annotator_id:  # The aid changes.
                    target_sentence = ' '.join([word for word in corrected if word != ""])
                    assert target_sentence.startswith('<S>'), '(' + target_sentence + ')'
                    target_sentence = target_sentence[4:]
                    if target_sentence.strip() not in target_sentences:
                        # Save the src.
                        output_src_file.write(source_sentence + '\n')
                        # Save the trg.
                        output_tgt_file.write(target_sentence + '\n')

                        target_sentences.add(target_sentence)

                    # Restore the trg tokens.
                    words = source_sentence.split()
                    corrected = ['<S>'] + words[:]

                    # Update the annotator id.
                    cur_annotator_id += 1

                    prev_sid = -1
                    prev_eid = -1
                    pos = 0
            else:  # The annotator id is specified.
                if int(annotator_id) != annotator_id_of_the_line:
                    continue

            line = line[2:]
            info = line.split("|||")
            sid, eid = info[0].split()
            sid = int(sid) + 1
            eid = int(eid) + 1
            error_type = info[1]
            if error_type == "Um":
                continue
            for idx in range(sid, eid):
                corrected[idx] = ""
            if sid == eid:
                if sid == 0:
                    continue  # Originally index was -1, indicating no op
                if sid != prev_sid or eid != prev_eid:
                    pos = len(corrected[sid - 1].split())
                cur_words = corrected[sid - 1].split()
                cur_words.insert(pos, info[2])
                pos += len(info[2].split())
                corrected[sid - 1] = " ".join(cur_words)
            else:
                corrected[sid] = info[2]
                pos = 0
            prev_sid = sid
            prev_eid = eid
        else:
            target_sentence = ' '.join([word for word in corrected if word != ""])
            assert target_sentence.startswith('<S>'), '(' + target_sentence + ')'
            target_sentence = target_sentence[4:]
            if target_sentence.strip() not in target_sentences:
                # Save the src.
                output_src_file.write(source_sentence + '\n')
                # Save the trg.
                output_tgt_file.write(target_sentence + '\n')

            # Reset the annotator id.
            cur_annotator_id = 0

            prev_sid = -1
            prev_eid = -1
            pos = 0

            target_sentences.clear()
