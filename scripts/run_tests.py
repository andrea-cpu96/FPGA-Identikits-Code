"""Run standalone identikits with ModelSim/Questa or GHDL (VHDL-2008).

Python 3.9+; simulator executables must be on PATH. No third-party Python
packages are required. Each identikit gets a separate work library.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def command(args, cwd, logfile, timeout=120):
    result = subprocess.run(args, cwd=cwd, capture_output=True, text=True,
                            errors='replace', timeout=timeout)
    text = result.stdout + result.stderr
    logfile.write_text(text, encoding='utf-8')
    if result.returncode:
        raise RuntimeError(f'Command failed ({result.returncode}): {args[0]}; see {logfile}')
    return text


def run(entry, simulator):
    folder = ROOT / entry['folder']
    build = ROOT / 'build' / entry['slug']
    build.mkdir(parents=True, exist_ok=True)
    rtl = folder / entry['rtl']
    tb = folder / entry['testbench']
    # Normalize CRLF so Windows checkouts have the same source fingerprint.
    sha = hashlib.sha256(rtl.read_text(encoding='utf-8').encode()).hexdigest()
    if sha != entry['sha256']:
        print(f"NOTE {entry['slug']}: RTL differs from the book snapshot")
    if simulator == 'modelsim':
        if not (build / 'work').exists():
            command(['vlib', 'work'], build, build / 'library.log')
        for name, source in [('rtl', rtl), ('tb', tb)]:
            command(['vcom', '-2008', str(source)], build, build / f'{name}-compile.log')
        macro = build / 'run.do'
        macro.write_text('onerror {quit -code 2}\nonbreak {quit -code 3}\n'
                         'run 21 ms\nquit -code 4\n', encoding='utf-8')
        # std.env.finish exits successfully; reaching the final quit is timeout.
        log = command(['vsim', '-c', '-t', '1ps', '-onfinish', 'exit',
                       'work.' + entry['top'], '-do', str(macro)], build, build / 'simulation.log')
    else:
        for name, source in [('rtl', rtl), ('tb', tb)]:
            command(['ghdl', '-a', '--std=08', str(source)], build, build / f'{name}-compile.log')
        command(['ghdl', '-e', '--std=08', entry['top']], build, build / 'elaboration.log')
        log = command(['ghdl', '-r', '--std=08', entry['top'], '--assert-level=error',
                       '--stop-time=21ms'], build, build / 'simulation.log')
    if ('PASS ' + entry['top']) not in log and not (entry['entity'] == 'pulse_stretcher' and 'PASS: all pulse stretcher cases' in log):
        raise RuntimeError('Missing completion marker: ' + str(build / 'simulation.log'))
    if '** Failure' in log or '** Error' in log:
        raise RuntimeError('Simulator reported a failure: ' + str(build / 'simulation.log'))
    return {'identikit': entry['slug'], 'passed': True, 'rtl_sha256': sha,
            'testbench_sha256': hashlib.sha256(tb.read_text(encoding='utf-8').encode()).hexdigest()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--identikit', help='One identikit folder name; default: all')
    parser.add_argument('--group', help='Group folder name; default: all')
    parser.add_argument('--simulator', choices=['modelsim', 'ghdl'], default='modelsim')
    args = parser.parse_args()
    entries = json.loads((ROOT / 'manifest.json').read_text(encoding='utf-8'))
    entries = [e for e in entries if (not args.identikit or e['slug'] == args.identikit)
               and (not args.group or e['folder'].split('/')[0] == args.group)]
    if not entries:
        parser.error('No identikit matches the selection')
    needed = ['vlib', 'vcom', 'vsim'] if args.simulator == 'modelsim' else ['ghdl']
    if any(not shutil.which(tool) for tool in needed):
        parser.error('Add simulator executables to PATH: ' + ', '.join(needed))
    results = []
    for entry in entries:
        try:
            result = run(entry, args.simulator)
            print('PASS', entry['number'], entry['slug'], flush=True)
        except (RuntimeError, subprocess.TimeoutExpired) as error:
            result = {'identikit': entry['slug'], 'passed': False, 'error': str(error)}
            print('FAIL', entry['number'], entry['slug'], str(error), flush=True)
        results.append(result)
    report = {'simulator': args.simulator, 'total': len(results),
              'passed': sum(r['passed'] for r in results), 'results': results}
    (ROOT / 'build').mkdir(exist_ok=True)
    (ROOT / 'build' / 'results.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
    print(f"{report['passed']}/{report['total']} identikits passed")
    return 0 if report['passed'] == report['total'] else 1


if __name__ == '__main__':
    sys.exit(main())
