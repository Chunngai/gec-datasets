import argparse


# Apply the edits of a single annotator to generate the corrected sentences.
def main(args):
    m2 = open(args.m2_file).read().strip().split("\n\n")
    f_srcs = open(args.fsrcs, "w")
    f_trgs = open(args.ftrgs, "w")
    # Do not apply edits with these error types
    skip = {"noop", "UNK", "Um"}

    for sent in m2:
        sent = sent.split("\n")
        ori_sent = sent[0].split()[1:]  # Ignore "S "
        cor_sent = sent[0].split()[1:]  # Ignore "S "
        edits = sent[1:]
        offset = 0
        for edit in edits:
            edit = edit.split("|||")
            if edit[1] in skip: continue  # Ignore certain edits
            coder = int(edit[-1])
            if coder != args.id: continue  # Ignore other coders
            span = edit[0].split()[1:]  # Ignore "A "
            start = int(span[0])
            end = int(span[1])
            cor = edit[2].split()
            cor_sent[start + offset:end + offset] = cor
            offset = offset - (end - start) + len(cor)
        f_srcs.write(" ".join(ori_sent) + "\n")
        f_trgs.write(" ".join(cor_sent) + "\n")


if __name__ == "__main__":
    # Modified from https://www.cl.cam.ac.uk/research/nl/bea2019st/data/corr_from_m2.py

    # Define and parse program input
    parser = argparse.ArgumentParser()
    parser.add_argument("m2_file", help="The path to an input m2 file.")
    parser.add_argument("--fsrcs", help="A path to where we save the output original text file.", required=True)
    parser.add_argument("--ftrgs", help="A path to where we save the output corrected text file.", required=True)
    parser.add_argument("--id", help="The id of the target annotator in the m2 file.", type=int, default=0)
    args = parser.parse_args()
    main(args)