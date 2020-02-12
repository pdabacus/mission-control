#!/usr/bin/env python3

"""
 @file test_fn/main.py
 @author Pavan Dayal
"""

import os
import sys
import re
from test_file import check_prgm_output as check
from test_file import check_prgm_output as check

test = "test_fn"
exe = "valgrind -v --track-fds=yes --leak-check=full "
exe = ""
exe += "./"
exe += "a.out" if len(sys.argv) == 1 else sys.argv[1]

files = set(os.listdir(test))
files -= {f for f in files if ".py" in f}

ins = {f for f in files if "in" in f}
files -= ins

args = {f for f in files if "arg" in f}
files -= args

outs = {f for f in files if "exp" in f or "out" in f}
files -= outs

errs = {f for f in files if "err" in f}
files -= errs

rets = {f for f in files if "ret" in f}

ins = list(ins)
ins.sort()

getn = re.compile("[0-9]+")
nums = list()
for i in ins:
    n = getn.search(i)
    if n:
        nums += [n.group(0)]

passed = 0
total = len(nums)
i = 1
for num in nums:
    arg = [f for f in args if num in f]
    arg = "" if len(arg) != 1 else test+"/"+arg[0]
    inp = [f for f in ins if num in f]
    inp = "" if len(inp) != 1 else test+"/"+inp[0]
    out = [f for f in outs if num in f]
    out = "" if len(out) != 1 else test+"/"+out[0]
    err = [f for f in errs if num in f]
    err = "" if len(err) != 1 else test+"/"+err[0]
    ret = [f for f in rets if num in f]
    ret = "" if len(ret) != 1 else test+"/"+ret[0]
    cmd = exe
    if arg:
        cmd += " $(cat %s)" % arg
    if inp:
        cmd += " < %s" % inp
    if ret:
        f = open(ret)
        ret = int(f.read())
        f.close()
    else:
        ret = 0

    print(" * test %2d: %-60s" % (i, cmd), end="", flush=True)
    if check(cmd, "", out, err, ret, showErr=True):
        passed += 1
    i += 1

print("passed (%d/%d): %.2f%%" % (passed, total, 100.0*passed/total))
