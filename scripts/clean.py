"""Clean processed folder.

Usage: zip [--output_dir=<output_dir>] [<directory>]
"""

import docopt
import pathlib
import shutil


def main(source_dir):
    if source_dir.exists():
        shutil.rmtree(source_dir)


if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    directory = arguments["<directory>"] or (pathlib.Path(
        __file__).parent.parent / 'processed')
    # output_dir = arguments["--output_dir"] or None
    main(directory)
