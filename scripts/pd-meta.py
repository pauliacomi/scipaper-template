import argparse
import pathlib
import re

NEWCOMAND_RE = re.compile(r"\\newcommand{[^}]*}{[^}]*}")  # a user new command
ARGUMENT_RE = re.compile(r"(?<={)[^}]*(?=})")  # latex arguments

meta_types = {
    r"\pubtitle": "title",
    r"\pubauth": "author",
    r"\eqcontrib": "contribution",
    r"\pubaffil": "affil",
    r"\authemail": "email",
    r"\orcid": "orcid",
    r"\pubaddr": "institute",
    r"\pubemail": "contact",
}


def repl_input(inp_section):

    input_text = inp_section.group()
    filename = ARGUMENT_RE.search(input_text)
    print(filename)


def read_meta(metafile):

    metadata = {t: {} for t in meta_types.values()}
    metadata['contact'] = []

    with open(metafile, encoding="utf8") as f:
        lines = f.readlines()

    lines = [l.strip() for l in lines]
    lines = [l for l in lines if l and not l.startswith("%")]
    text = "".join(lines).replace("%", "")

    for meta in NEWCOMAND_RE.findall(text):

        m_typeno, m_val = ARGUMENT_RE.findall(meta)
        m_type = next(
            iter(t for t in meta_types if m_typeno.startswith(t)), None
        )
        if not m_type:
            continue
        elif m_type in [r"\pubemail", r"\contribution"]:
            metadata[meta_types[m_type]].append(m_val[-1].lower())
        elif m_type == r"\pubtitle":
            metadata[meta_types[m_type]] = m_val
        elif m_type == r"\pubaffil":
            metadata[meta_types[m_type]][m_no] = m_val.replace(" ",
                                                               "").split(",")
        else:
            m_no = m_typeno[-1].lower()
            metadata[meta_types[m_type]][m_no] = m_val

    return metadata


def write_meta(meta, metafile):

    with open("templates/pandoc/meta-base.yaml", encoding="utf8") as f:
        base = f.read()

    with open(metafile, 'w', encoding='utf8') as f:
        f.write("---\n")
        f.write(f"title: \"{meta['title']}\"\n")
        f.write("author:\n")
        for a in meta['author']:
            f.write(f"  - {meta['author'][a]}:\n")
            f.write("      institute:\n")
            for aff in meta['affil'][a]:
                f.write(f"        - {aff}\n")
            if meta['orcid'].get(a, None):
                f.write(f"      orcid: {meta['orcid'][a]}\n")
            if meta['email'].get(a, None):
                f.write(f"      email: {meta['email'][a]}\n")
            if a in meta['contact']:
                f.write("      correspondence: \"yes\"\n")
            if a in meta['contribution']:
                f.write("      equal_contributor: \"yes\"\n")

        f.write("institute:\n")
        for i in meta['institute']:
            f.write(f"  - {i}:\n")
            f.write(f"      name: {meta['institute'][i]}\n")
        f.write(base)
        f.write("\n---\n")


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Write metadata files.')
    parser.add_argument(
        '--tex',
        type=str,
        default=pathlib.Path(__file__).parent.parent / 'templates' /
        'metadata.tex'
    )
    parser.add_argument(
        '--yaml',
        type=str,
        default=pathlib.Path(__file__).parent.parent / 'templates' /
        'metadata-pd.yaml'
    )
    args = parser.parse_args()
    meta = read_meta(args.tex)
    write_meta(meta, args.yaml)
