"""Check companion RTL and navigation against a current manuscript checkout.

No PDF rebuild or simulator is needed. The manuscript's chapter parser supplies
the input order; RTL is extracted directly from its current component sources.
"""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def plain(text):
    return text.replace(r'\&', '&').replace(r'\_', '_').replace('---', '—')


def check(book):
    spec = importlib.util.spec_from_file_location('book_chapters', book / 'scripts/chapter_contents.py')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    manifest = json.loads((ROOT / 'manifest.json').read_text(encoding='utf-8'))
    errors = []
    by_source = {}
    for entry in manifest:
        if entry['source'] in by_source:
            errors.append('Duplicate manifest source: ' + entry['source'])
        by_source[entry['source']] = entry
    expected = set()
    evidence = []
    groups = 0
    root_readme = (ROOT / 'README.md').read_text(encoding='utf-8')
    for ci, chapter in enumerate(module.chapters(), 1):
        for gi, group in enumerate(chapter['groups'], 1):
            groups += 1
            group_number = f'{ci}.{gi}'
            group_title = plain(group['title'])
            for ei, (title, source) in enumerate(group['entries'], 1):
                source += '.tex'
                expected.add(source)
                number = f'{group_number}.{ei}'
                entry = by_source.get(source)
                if entry is None:
                    errors.append('Missing identikit: ' + source)
                    continue
                folder = ROOT / entry['folder']
                title = plain(title)
                if (entry['number'], entry['title']) != (number, title):
                    errors.append('Stale number/title: ' + entry['slug'])
                code = (book / source).read_text(encoding='utf-8')
                listings = re.findall(r'\\begin\{lstlisting\}(?:\[[^\]]*\])?\s*\n(.*?)\\end\{lstlisting\}', code, re.S)
                if len(listings) != 1:
                    errors.append('Expected one VHDL listing: ' + source)
                    continue
                sha = hashlib.sha256(listings[0].encode()).hexdigest()
                for name in (entry['rtl'], entry['testbench'], 'README.md'):
                    if not (folder / name).is_file():
                        errors.append('Missing companion file: ' + str(folder / name))
                if not all((folder / name).is_file() for name in (entry['rtl'], entry['testbench'], 'README.md')):
                    continue
                rtl = (folder / entry['rtl']).read_text(encoding='utf-8')
                if hashlib.sha256(rtl.encode()).hexdigest() != sha or entry['sha256'] != sha:
                    errors.append('RTL differs from manuscript: ' + entry['slug'])
                entity = re.search(r'\bentity\s+(\w+)\s+is', rtl, re.I)
                if not entity or entity[1] != entry['entity']:
                    errors.append('Wrong entity: ' + entry['slug'])
                readme = (folder / 'README.md').read_text(encoding='utf-8')
                for marker in (f'# {number} — {title}', f'group **{group_number} — {group_title}**', f'Book identikit: **{number}**', f'`{sha}`'):
                    if marker not in readme:
                        errors.append('Stale README metadata: ' + entry['slug'] + ': ' + marker)
                first_line = (folder / entry['testbench']).read_text(encoding='utf-8').splitlines()[0]
                if f'identikit {number}: {title}.' not in first_line:
                    errors.append('Stale testbench identification: ' + entry['slug'])
                group_readme = (folder.parent / 'README.md').read_text(encoding='utf-8')
                if not group_readme.startswith(f'# {group_number} — {group_title}\n') or f'[{number} — {title}]({entry["slug"]}/)' not in group_readme:
                    errors.append('Stale group navigation: ' + entry['slug'])
                row = f'| {group_number} | [{group_title}]({folder.parent.name}/) | {len(group["entries"])} |'
                if row not in root_readme:
                    errors.append('Stale root navigation: ' + group_number)
                evidence.append({'number': number, 'title': title, 'source': source, 'folder': entry['folder'], 'rtl_sha256': sha})
    component_sources = {p.relative_to(book).as_posix() for p in (book / 'components').glob('*.tex')}
    for source in sorted(component_sources - expected):
        errors.append('Component absent from chapter organization: ' + source)
    for source in sorted(by_source.keys() - expected):
        errors.append('Obsolete companion identikit: ' + source)
    actual_rtl = {p.relative_to(ROOT).as_posix() for p in ROOT.glob('*/*/*.vhd') if not p.name.startswith('tb_')}
    expected_rtl = {entry['folder'] + '/' + entry['rtl'] for entry in manifest}
    if actual_rtl != expected_rtl:
        errors.append('Manifest does not cover all standalone RTL files')
    try:
        revision = subprocess.check_output(['git', '-C', str(book), 'rev-parse', 'HEAD'], text=True).strip()
    except subprocess.CalledProcessError:
        revision = None
    return {'book_commit': revision, 'identikits': len(expected), 'groups': groups,
            'errors': sorted(set(errors)), 'results': evidence,
            'scope': 'Current source RTL and navigation; not prose equivalence or hardware verification. Stable legacy folder names are allowed.'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--book', required=True, type=Path)
    parser.add_argument('--report', type=Path, help='Optional JSON report path')
    args = parser.parse_args()
    report = check(args.book.resolve())
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print(f"Checked {report['identikits']} identikits in {report['groups']} groups")
    for error in report['errors']:
        print('ERROR', error)
    return bool(report['errors'])


if __name__ == '__main__':
    raise SystemExit(main())
