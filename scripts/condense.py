"""Condense manuscript into single files, often preferred by journals.

Usage: condense [--output_dir=<output_dir>] [<directory>]
"""

import docopt
import pathlib
import shutil
import re

STYLE_RE = re.compile(r"\\def\\style{\d}\s")  # style statement + newline
INPUT_RE = re.compile(r"\\input{.*}")  # an input statement
ARGUMENT_RE = re.compile(r"(?<={)[\s\S]*(?=})")  # any latex argument
IF_RE = re.compile(r"\\if[\s\S]*?\\fi")  # any if/fi section
ELSE_RE = re.compile(r"\\else[\s\S]*?\\fi")  # any else/fi section
IF_ARG_RE = re.compile(r"(?<=\\if\\style)\d")  # the style if comparator
IF_ARG_STRIP = re.compile(r"\\if\\\w*\s*|\\fi")  # the if/fi edges
ELSE_ARG_STRIP = re.compile(r"\\else|\\fi")  # the else/fi edges
META_RE = re.compile(r"% !TEX .*")  # tex meta commands

style_d = {
    '0': 'pi',
    '1': 'els',
    '2': 'rsc',
    '3': 'acs',
}


def check(directory, filename):
    for path in directory.iterdir():
        if path.name == filename:
            return True
    return False


def get_style(text):
    """Figure out style, then remove from file."""
    style_match = STYLE_RE.search(text)
    if not style_match:
        return None, text
    style = ARGUMENT_RE.search(style_match.group()).group()
    text = STYLE_RE.sub("", text)

    return style, text


def sort_ifs(text, style):
    """Deal with any if/else/fi flags."""
    def repl_ifs(if_section):
        if_text = if_section.group()
        if_style = IF_ARG_RE.search(if_text)
        if not if_style:
            raise Exception
        else_match = ELSE_RE.search(if_text)
        if else_match:
            if_text = if_text[0:else_match.start()]
            else_text = else_match.group()
        if style == if_style.group():
            return IF_ARG_STRIP.sub("", if_text)
        else:
            if else_match:
                return ELSE_ARG_STRIP.sub("", else_text)
            return ""

    return IF_RE.sub(repl_ifs, text)


def expand(text):
    def repl_input(inp_section):

        input_text = inp_section.group()
        filename = ARGUMENT_RE.search(input_text)
        if not filename:
            raise Exception
        filepath = pathlib.Path("./" + filename.group() + '.tex')
        with open(filepath, 'r', encoding="utf-8") as file:
            return file.read()

    return INPUT_RE.subn(repl_input, text)


def clean(text, style):

    # remove meta commands
    text = META_RE.sub("", text)

    # remove superfluous newlines
    text = re.sub(r'\n\s*\n', r'\n\n', text)

    # update references
    text = re.sub(r"(?<=\\bibliography{)refs/biblio(?=})", r'biblio', text)

    if style == '0' or style is None:
        text = re.sub(r"setting/pi/", r'', text)
    elif style == '2':
        text = re.sub(r"setting/rsc/", r'', text)

    return text


def process_tex(target):
    with target.open() as file:

        # file contents
        filetext = file.read()

        # style
        style, filetext = get_style(filetext)

        # if/else processing
        if style:
            filetext = sort_ifs(filetext, style)

        # input expansion
        expansions = 1
        while expansions > 0:
            filetext, expansions = expand(filetext)

        # cleaning
        filetext = clean(filetext, style)

        return filetext, style


def copy_files(source, target, style):
    shutil.copy((source / 'refs' / 'biblio.bib'), (target / 'biblio.bib'))
    shutil.copy((source / 'manuscript-SI.aux'), (target / 'manuscript-SI.aux'))
    shutil.copy((source / 'manuscript-SI.pdf'), (target / 'manuscript-SI.pdf'))
    shutil.copytree((source / 'figs'), (target / 'figs'),
                    ignore=shutil.ignore_patterns('*.md', '*.txt'))
    if style == '0':
        shutil.copy((source / 'setting' / 'pi' / 'pi-article.cls'),
                    (target / 'pi-article.cls'))
        shutil.copy((source / 'setting' / 'pi' / 'pi-bib.bst'),
                    (target / 'pi-bib.bst'))
    elif style == '2':
        shutil.copy((source / 'setting' / 'rsc' / 'rsc.bst'),
                    (target / 'rsc.bst'))
        shutil.copytree((source / 'setting' / 'rsc' / 'head_foot'),
                        (target / 'head_foot'))


def main(source_dir, output_dir='./processed/'):

    source_dir = pathlib.Path(source_dir)
    output_dir = pathlib.Path(output_dir)

    if output_dir.exists():
        shutil.rmtree(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    # style
    man_style = None

    # condense the manuscript files
    files = [
        'manuscript.tex',
        'manuscript-SI.tex',
    ]
    for filename in files:
        if check(source_dir, filename):
            target_in = source_dir / filename
            target_out = output_dir / filename
            processed, style = process_tex(target_in)
            if style:
                man_style = style
            with open(target_out, "w", encoding="utf-8") as file:
                file.write(processed)

    # copy over other required data
    copy_files(source_dir, output_dir, man_style)


if __name__ == "__main__":
    arguments = docopt.docopt(__doc__)
    directory = arguments["<directory>"
                          ] or pathlib.Path(__file__).parent.parent
    # output_dir = arguments["--output_dir"] or None
    main(directory)
