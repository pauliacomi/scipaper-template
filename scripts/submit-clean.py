"""Clean processed folder.

Usage: clean [--output_dir=<output_dir>] [<directory>]
"""

import argparse
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
    parser = argparse.ArgumentParser(description='Clean processed folder.')
    parser.add_argument(
        '--dir',
        type=str,
        default=pathlib.Path(__file__).parent.parent / 'condensed'
    )
    args = parser.parse_args()
    main(args.dir)
