"""Refuses bridge code or bridge files in this repository (it is public; the bridge never comes here)."""
import os
import re
import sys

BAD = re.compile(rb"tic_dcs|tic_loader|tic_bridge|tic_fnc_|callExtension|net\.dostring_in|socket\.udp|Scripts[\\/]+Hooks", re.I)
NAMES = re.compile(r"\.biprivatekey$|\.miz$|\.sqm$|(^|/)@tic/|tic_bridge|tic_dcs|tic_loader", re.I)
bad = []
for base, dirs, files in os.walk("."):
    dirs[:] = [d for d in dirs if d != ".git"]
    for f in files:
        p = os.path.join(base, f).replace(os.sep, "/")
        if p.startswith("./.github/"):
            continue
        if NAMES.search(p):
            bad.append("not allowed here: " + p)
        elif BAD.search(open(p, "rb").read()):
            bad.append("bridge code in " + p)
for b in bad:
    print(b)
print("%d problem(s)" % len(bad))
sys.exit(1 if bad else 0)
