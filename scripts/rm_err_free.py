import sys

if len(sys.argv) != 3:
    print("[USAGE] %s src_with_err_free trg_with_err_free" % sys.argv[0])
    sys.exit()

fp_src_w_err_free = sys.argv[1]
fp_trg_w_err_free = sys.argv[2]
fp_src_wo_err_free = fp_src_w_err_free.replace("w.err.free", "wo.err.free")
fp_trg_wo_err_free = fp_trg_w_err_free.replace("w.err.free", "wo.err.free")

with open(fp_src_w_err_free, "r") as f_src_w_err_free, open(fp_trg_w_err_free, "r") as f_trg_w_err_free, \
        open(fp_src_wo_err_free, "w") as f_src_wo_err_free, open(fp_trg_wo_err_free, "w") as f_trg_wo_err_free:
    srcs = f_src_w_err_free.readlines()
    trgs = f_trg_w_err_free.readlines()
    assert len(srcs) == len(trgs)

    for src, trg in zip(srcs, trgs):
        if src != trg:
            f_src_wo_err_free.write(src)
            f_trg_wo_err_free.write(trg)
