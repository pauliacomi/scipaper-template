"""Clean processed folder.

Usage: zip [--output_dir=<output_dir>] [<directory>]
"""

import docopt
import pathlib
import shutil
import os


def main(source_dir):
    if source_dir.exists():
        shutil.rmtree(source_dir)
    zip_path = source_dir.parent / "manuscript.zip"
    if zip_path.exists():
        os.remove(zip_path)


if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    directory = arguments["<directory>"] or (
        pathlib.Path(__file__).parent.parent / 'condensed'
    )
    # output_dir = arguments["--output_dir"] or None
    main(directory)
