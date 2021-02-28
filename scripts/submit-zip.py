"""Zip manuscript folder.

Usage: zip [--source=<output_dir>] [--dest=<destination_dir>]
"""

import argparse
import pathlib
import shutil

EXCLUDE_EXTS = (
    '*.pdf',
    '*.gz',
    '*.aux',
    '*.bbl',
    '*.blg',
    '*.fdb_latexmk',
    '*.fls',
    '*.log',
    '*.out',
)


def clean(source_dir):

    source_temp = source_dir.parent / 'condensed_temp'
    if source_temp.exists():
        shutil.rmtree(source_temp)

    # create temp files
    shutil.copytree(
        source_dir, source_temp, ignore=shutil.ignore_patterns(*EXCLUDE_EXTS)
    )
    shutil.copy(
        source_dir / "manuscript-SI.aux", source_temp / "manuscript-SI.aux"
    )

    return source_temp


def main(source_dir, output_file='./manuscript'):

    source_dir = pathlib.Path(source_dir)

    # clean from source dir
    cleaned_source_dir = clean(source_dir)

    # archive source dir
    shutil.make_archive(output_file, format='zip', root_dir=cleaned_source_dir)

    # delete temp files
    shutil.rmtree(cleaned_source_dir)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Zip submission files.')
    parser.add_argument(
        '--source',
        type=str,
        default=pathlib.Path(__file__).parent.parent / 'condensed'
    )
    parser.add_argument(
        '--dest',
        type=str,
        default=pathlib.Path(__file__).parent.parent / 'condensed' /
        'manuscript'
    )
    args = parser.parse_args()
    main(args.source, args.dest)
