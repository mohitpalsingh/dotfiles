#!/usr/bin/env python3
"""Merge the captured Terminal appearance profiles into this Mac's preferences."""
import pathlib
import plistlib
import subprocess
import sys
import tempfile

repo = pathlib.Path(__file__).resolve().parent.parent
backup = pathlib.Path(sys.argv[1])
result = subprocess.run(["defaults", "export", "com.apple.Terminal", "-"], capture_output=True)
current = plistlib.loads(result.stdout) if result.returncode == 0 else {}
captured = plistlib.loads((repo / "terminal/profiles.plist").read_bytes())
if result.returncode == 0:
    backup.mkdir(parents=True, exist_ok=True)
    (backup / "Terminal.plist").write_bytes(result.stdout)
current.setdefault("Window Settings", {}).update(captured["Window Settings"])
for key in ("Default Window Settings", "Startup Window Settings"):
    current[key] = captured[key]
with tempfile.NamedTemporaryFile(suffix=".plist") as output:
    plistlib.dump(current, output)
    output.flush()
    subprocess.run(["defaults", "import", "com.apple.Terminal", output.name], check=True)
print("Terminal profiles restored. Reopen Terminal.app to load them.")
