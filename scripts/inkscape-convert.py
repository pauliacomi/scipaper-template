import os
import pathlib
import sys
import subprocess

inkscape = None

if os.name == 'nt':
    # Possible paths to check for the installation
    inkscapePaths = [
        r"C:\Program Files\Inkscape\bin\inkscape.exe",
        r"C:\Program Files\Inkscape\inkscape.exe",
        r"C:\Program Files (x86)\Inkscape\bin\inkscape.exe",
        r"C:\Program Files (x86)\Inkscape\inkscape.exe",
    ]
    for path in inkscapePaths:
        if pathlib.Path(path).exists():
            inkscape = path
    if not inkscape:
        print("Can't find Inkscape installation, aborting.")
        sys.exit()

elif os.name == 'posix':
    inkscape = 'inkscape'

print("Conversion started")

for f in sys.argv[1:]:
    fullpath = pathlib.Path(f)
    if fullpath.exists() and fullpath.suffix == '.svg':
        print(f"Converting {fullpath} to PNG")
        p = subprocess.run([
            inkscape,
            "--export-background-opacity=1",
            "--export-type=png",
            "--export-dpi=400",
            f"--export-filename={fullpath.with_suffix('.png')}",
            fullpath,
        ],
                           stdin=subprocess.PIPE,
                           stdout=subprocess.PIPE,
                           stderr=subprocess.STDOUT,
                           universal_newlines=True)

        print(f"Converting {fullpath} to PDF")
        subprocess.run([
            inkscape,
            "-T",
            "--export-background-opacity=1",
            "--export-type=pdf",
            "--export-dpi=400",
            f"--export-filename={fullpath.with_suffix('.pdf')}",
            fullpath,
        ],
                       stdin=subprocess.PIPE,
                       stdout=subprocess.PIPE,
                       stderr=subprocess.STDOUT,
                       universal_newlines=True)
    else:
        print(f"Path {f} does not exist")

print("Complete")
