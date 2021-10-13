import sys

if len(sys.argv) != 3:
    print("[USAGE] %s error_free_contained_src error_free_removed_trg" % sys.argv[0])
    sys.exit()

raw_src = sys.argv[1]
raw_trg = sys.argv[2]
src = raw_src.replace("error-free-contained", "error-free-removed")
trg = raw_trg.replace("error-free-contained", "error-free-removed")

with open(raw_src, "r") as f_raw_src, open(raw_trg, "r") as f_raw_trg, \
        open(src, "w") as f_src, open(trg, "w") as f_trg:
    raw_srcs = f_raw_src.readlines()
    raw_trgs = f_raw_trg.readlines()
    assert len(raw_srcs) == len(raw_trgs)

    for raw_src, raw_trg in zip(raw_srcs, raw_trgs):
        if raw_src != raw_trg:
            f_src.write(raw_src)
            f_trg.write(raw_trg)