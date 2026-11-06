# Copyright © 2026 Model Based Innovation LLC. All rights reserved. BSD 2-Clause, see LICENSE.
"""Load SysML files into the OMG pilot implementation's Jupyter kernel and report what it says.

    python tools/pilot_check.py A.sysml B.sysml [--export Pkg --out DIR] [--magic "%help"]

Files load in the order given, each as one cell, so a file's dependencies come first. The exit
code is the number of failures. `--export` writes the JSON of a named package with the kernel's
%export, the normative API & Services serialization.
"""
import argparse
import base64
import base64
import queue
import re
import re
import sys
from pathlib import Path

from jupyter_client.manager import start_new_kernel


def run_cell(client, code: str, timeout: float = 1500.0) -> tuple[str, str]:
    """Execute a cell; (stdout and results, stderr and errors) of it."""
    msg_id = client.execute(code, store_history=False)
    out, err = [], []
    while True:
        try:
            msg = client.get_iopub_msg(timeout=timeout)
        except queue.Empty:
            err.append(f"timeout after {timeout} s")
            break
        if msg["parent_header"].get("msg_id") != msg_id:
            continue
        t, c = msg["msg_type"], msg["content"]
        if t == "stream":
            (err if c.get("name") == "stderr" else out).append(c["text"])
        elif t in ("execute_result", "display_data"):
            out.append(c["data"].get("text/plain") or "".join(str(v) for v in c["data"].values()))
        elif t == "error":
            err.append("\n".join(c.get("traceback") or [c.get("evalue", "")]))
        elif t == "status" and c.get("execution_state") == "idle":
            break
    return "".join(out), "".join(err)


def main(argv=None) -> int:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("files", nargs="*", type=Path)
    p.add_argument("--export", action="append", default=[], help="package to export as JSON (repeatable)")
    p.add_argument("--magic", action="append", default=[], help="a kernel command to run after the files")
    p.add_argument("--out", type=Path, default=Path("pilot-export"))
    a = p.parse_args(argv)
    km, client = start_new_kernel(kernel_name="sysml", startup_timeout=300)
    failures = 0
    try:
        for f in a.files:
            out, err = run_cell(client, f.read_text(encoding="utf-8"))
            ok = not err.strip() and "ERROR" not in out
            print(f"{'ok  ' if ok else 'FAIL'} {f}" + ("" if ok else f"\n{err}{out}"), flush=True)
            failures += not ok
        for m in a.magic:
            out, err = run_cell(client, m)
            print(f"--- {m}\n{out}{err}", flush=True)
        a.out.mkdir(parents=True, exist_ok=True)
        for name in a.export:
            out, err = run_cell(client, f"%export {name}")
            # the kernel returns the file as a download link: <a download="X.json" href="data:...;base64,...">
            m = re.search(r'download="([^"]+)"\s+href="data:[^;]+;base64,([^"]+)"', out)
            if m:
                (a.out / m.group(1)).write_bytes(base64.b64decode(m.group(2)))
                print(f"exported {name} -> {a.out / m.group(1)}", flush=True)
            else:
                print(f"FAIL %export {name}\n{out[-600:]}{err[:2000]}", flush=True)
                failures += 1
    finally:
        client.stop_channels()
        km.shutdown_kernel(now=True)
    print(f"pilot: {failures} failure(s)")
    return failures


if __name__ == "__main__":
    sys.exit(main())
