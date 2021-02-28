"""Condense manuscript into single files, often preferred by journals.

Usage: condense [--output_dir=<output_dir>] [<directory>]
"""

import argparse
import pathlib
import shutil
import re

STYLE_RE = re.compile(r"\\def\\style{\d}\s")  # style statement + newline
INPUT_RE = re.compile(r"\\input{.*}")  # an input statement
ARGUMENT_RE = re.compile(r"(?<={)[\s\S]*(?=})")  # any latex argument
IF_RE = re.compile(r"\\if[^def][\s\S]*?\\fi")  # any if/fi section not ifdef
ELSE_RE = re.compile(r"\\else[\s\S]*?\\fi")  # any else/fi section
IF_ARG_RE = re.compile(r"(?<=\\if\\style)\d")  # the style if comparator
IF_ARG_STRIP = re.compile(r"\\if\\\w*\s*|\\fi")  # the if/fi edges
ELSE_ARG_STRIP = re.compile(r"\\else|\\fi")  # the else/fi edges
META_RE = re.compile(r"% !TEX .*")  # tex meta commands

IFDEF_RE = re.compile(r"\\ifdef")  # any ifdefined/fi section
NEWCOMM_RE = re.compile(r"\\newcommand")  # any ifdefined/fi section

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


def find_close_bracket(string):
    """finds the closing of a scope, taking into account nesting"""
    nest = 1
    for ind, char in enumerate(string):
        if char == '{':
            nest += 1
        elif char == '}':
            nest -= 1
        if nest == 0:
            return ind


def sort_style_ifs(text, style):
    r"""
    Deal with any if/else/fi flags.
    The if/else types to replace are only '\if\style'
    """
    def repl_ifs(if_section):
        if_text = if_section.group()
        if_style = IF_ARG_RE.search(if_text)  # find if in group
        if not if_style:
            raise Exception(if_text)
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


def sort_other_ifs(text):
    r"""
    Deal with other if flags.
    # The types to replace are either \ifdef or \if@switch
    """
    def repl_ifswitch(if_section):
        if_text = if_section.group()
        if if_text.startswith("\\if@switch"):
            if text.startswith("% Master SI"):
                return ""
            else_match = ELSE_RE.search(if_text)
            if_text = if_text[0:else_match.start()]
            else_text = else_match.group()
            return ELSE_ARG_STRIP.sub("", else_text)
        else:
            raise Exception

    text = IF_RE.sub(repl_ifswitch, text)

    hit = IFDEF_RE.search(text)
    while hit:
        arg1_o = hit.end() + 1
        arg1_e = arg1_o + find_close_bracket(text[arg1_o:])
        arg2_o = arg1_e + 2
        arg2_e = arg2_o + find_close_bracket(text[arg2_o:])
        arg3_o = arg2_e + 2
        arg3_e = arg3_o + find_close_bracket(text[arg3_o:])

        if text.find(f"\\newcommand{{{text[arg1_o:arg1_e]}}}") != -1:
            text = text[:hit.start()] + text[arg2_o:arg2_e] + text[arg3_e + 1:]
        else:
            text = text[:hit.start()] + text[arg3_o:arg3_e] + text[arg3_e + 1:]
        hit = IFDEF_RE.search(text)

    return text


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


def expand_meta(text):

    replaced = [
        r'\pubauth',
        r'\pubaffil',
        r'\pubaddr',
        r'\orcid',
        r'\pubkeywords',
        r'\pubSI',
        r'\pubtitle',
        r'\dg',
        r'\eqcontrib',
        r'\authemail',
        r'\pubemail',
    ]

    for r in replaced:
        replaced_vals = []
        for hit in NEWCOMM_RE.finditer(text):
            arg1_o = hit.end() + 1
            arg1_e = arg1_o + find_close_bracket(text[arg1_o:])
            if text[arg1_e + 1] == "{":
                arg2_o = arg1_e + 2
                arg2_e = arg2_o + find_close_bracket(text[arg2_o:])

            command = text[arg1_o:arg1_e]
            value = text[arg2_o:arg2_e]

            if command.startswith(r):
                replaced_vals.append([command, value, hit.start(), arg2_e + 1])

        text = ''.join([
            chr for idx, chr in enumerate(text, 1) if not any(
                strt_idx <= idx <= end_idx
                for _, _, strt_idx, end_idx in replaced_vals
            )
        ])
        for val in replaced_vals:
            text = text.replace(val[0], val[1])

    return text


def clean(text, style):

    # remove meta commands
    text = META_RE.sub("", text)

    # remove advanced tex lines
    text = re.sub(r"\\makeatletter", r'', text)
    text = re.sub(r"\\makeatother", r'', text)

    # pandoc unnecessary commands
    text = text.replace(
        r"\newenvironment{widefigure}{\begin{figure*}}{\end{figure*}}", ""
    )
    text = text.replace("widefigure", "figure*")
    text = text.replace(
        r"\newenvironment{widetable}{\begin{table*}}{\end{table*}}", ""
    )
    text = text.replace("widetable", "table*")

    # remove comment lines
    text = re.sub(r'(?<!\\)%.*', r'', text)

    # remove superfluous newlines
    text = re.sub(r'\n\s*\n', r'\n\n', text)

    # update references
    text = re.sub(r"(?<=\\bibliography{)refs/biblio(?=})", r'biblio', text)

    if style == '0' or style is None:
        text = re.sub(r"templates/pi/", r'', text)
    elif style == '2':
        text = re.sub(r"templates/rsc/", r'', text)

    return text


def process_tex(target):
    """Process a tex file to return it to a simple 'one file' format."""
    with target.open() as file:

        # get file contents
        filetext = file.read()

        # get style
        style, filetext = get_style(filetext)

        # style if/else processing
        if style:
            filetext = sort_style_ifs(filetext, style)

        # input expansion
        expansions = 1
        while expansions > 0:
            filetext, expansions = expand(filetext)

        # second if/else processing
        filetext = sort_other_ifs(filetext)

        # replace metadata commands
        filetext = expand_meta(filetext)

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
        shutil.copy((source / 'templates' / 'pi' / 'pi-article.cls'),
                    (target / 'pi-article.cls'))
        shutil.copy((source / 'templates' / 'pi' / 'pi-bib.bst'),
                    (target / 'pi-bib.bst'))
    elif style == '2':
        shutil.copy((source / 'templates' / 'rsc' / 'rsc.bst'),
                    (target / 'rsc.bst'))
        shutil.copytree((source / 'templates' / 'rsc' / 'head_foot'),
                        (target / 'head_foot'))


def main(source_dir, output_dir='./condensed/'):

    # define source and output dirs
    source_dir = pathlib.Path(source_dir)
    output_dir = pathlib.Path(output_dir)

    # create and clean output dir
    if output_dir.exists():
        shutil.rmtree(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    # the manuscript style (own, RCS, etc)
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
    parser = argparse.ArgumentParser(
        description='Condense manuscript to a single file.'
    )
    parser.add_argument(
        '--source', type=str, default=pathlib.Path(__file__).parent.parent
    )
    parser.add_argument(
        '--dest',
        type=str,
        default=pathlib.Path(__file__).parent.parent / 'condensed'
    )
    args = parser.parse_args()
    main(args.source, args.dest)
