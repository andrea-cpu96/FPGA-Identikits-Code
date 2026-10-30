"""Regression tests for the source-sync checker; no simulator required."""
import hashlib
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

SPEC = importlib.util.spec_from_file_location('check_book_sync', Path(__file__).resolve().parents[1] / 'scripts/check_book_sync.py')
checker = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(checker)


class BookSyncTests(unittest.TestCase):
    def setUp(self):
        scratch = Path(__file__).resolve().parents[1] / 'build'
        scratch.mkdir(exist_ok=True)
        self.temp = tempfile.TemporaryDirectory(dir=scratch)
        self.addCleanup(self.temp.cleanup)
        base = Path(self.temp.name)
        self.book = base / 'book'
        self.repo = base / 'repo'
        (self.book / 'scripts').mkdir(parents=True)
        (self.book / 'components').mkdir()
        self.folder = self.repo / '01-01-legacy-name/example'
        self.folder.mkdir(parents=True)
        self.code = 'entity example is\nend entity;\n'
        self.sha = hashlib.sha256(self.code.encode()).hexdigest()
        (self.book / 'scripts/chapter_contents.py').write_text(
            "def chapters():\n    return [{'groups': [{'title': 'Current group', 'entries': [('Example', 'components/example')]}]}]\n", encoding='utf-8')
        (self.book / 'components/example.tex').write_text(
            '\\begin{lstlisting}[style=vhdlpanel]\n' + self.code + '\\end{lstlisting}\n', encoding='utf-8')
        self.entry = {'source': 'components/example.tex', 'number': '1.1.1', 'title': 'Example',
                      'slug': 'example', 'entity': 'example', 'folder': '01-01-legacy-name/example',
                      'rtl': 'example.vhd', 'testbench': 'tb_example.vhd', 'sha256': self.sha}
        self.write_manifest([self.entry])
        (self.folder / 'example.vhd').write_text(self.code, encoding='utf-8')
        (self.folder / 'tb_example.vhd').write_text('-- Self-checking tests for identikit 1.1.1: Example.\n', encoding='utf-8')
        (self.folder / 'README.md').write_text(
            f'# 1.1.1 — Example\ngroup **1.1 — Current group**\nBook identikit: **1.1.1**\n`{self.sha}`\n', encoding='utf-8')
        (self.folder.parent / 'README.md').write_text('# 1.1 — Current group\n[1.1.1 — Example](example/)\n', encoding='utf-8')
        (self.repo / 'README.md').write_text('| 1.1 | [Current group](01-01-legacy-name/) | 1 |\n', encoding='utf-8')
        root_patch = patch.object(checker, 'ROOT', self.repo)
        root_patch.start()
        self.addCleanup(root_patch.stop)

    def write_manifest(self, entries):
        (self.repo / 'manifest.json').write_text(json.dumps(entries), encoding='utf-8')

    def errors(self):
        with patch.object(checker.subprocess, 'check_output', return_value='test-revision\n'):
            return checker.check(self.book)['errors']

    def test_current_content_with_legacy_folder_name_passes(self):
        self.assertEqual([], self.errors())

    def test_actual_rtl_drift_is_detected(self):
        (self.folder / 'example.vhd').write_text(self.code + '-- edited\n', encoding='utf-8')
        self.assertTrue(any('RTL differs' in error for error in self.errors()))

    def test_missing_identikit_is_detected(self):
        self.write_manifest([])
        self.assertTrue(any('Missing identikit' in error for error in self.errors()))

    def test_stale_number_is_detected(self):
        self.entry['number'] = '2.1.1'
        self.write_manifest([self.entry])
        self.assertTrue(any('Stale number/title' in error for error in self.errors()))

    def test_stale_testbench_header_is_detected(self):
        (self.folder / 'tb_example.vhd').write_text('-- Self-checking tests for identikit 2.1.1: Example.\n', encoding='utf-8')
        self.assertTrue(any('Stale testbench identification' in error for error in self.errors()))

    def test_stale_navigation_is_detected(self):
        (self.repo / 'README.md').write_text('| 2.1 | [Old group](01-01-legacy-name/) | 1 |\n', encoding='utf-8')
        self.assertTrue(any('Stale root navigation' in error for error in self.errors()))

    def test_unlisted_manuscript_component_is_detected(self):
        (self.book / 'components/unlisted.tex').write_text('unlisted', encoding='utf-8')
        self.assertTrue(any('absent from chapter organization' in error for error in self.errors()))


if __name__ == '__main__':
    unittest.main()
