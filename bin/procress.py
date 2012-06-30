#!/usr/bin/python
# Requires: python 2.7+; Mock & nose for testing
DESCRIPTION = """Attaches to a running process with strace and shows you the
number of bytes being read/written.
"""

from argparse import ArgumentParser
import mock
from io import BytesIO
import subprocess
import sys
import re
import time
import unittest

def prettysize(num, time=None):
    """Returns a "pretty" string of *num* bytes, converting to KB, MB, etc.
    with units.
    If *time* is given, treats it as number of seconds and returns
    the number of bytes per second as a formatted string.

    >>> procress.prettysize(5000)
    '4.88KB'
    >>> procress.prettysize(5000, time=2)
    '2.44KB/s'
    """
    suffix = ""
    if time is not None:
        if time != 0:
            num /= time
        suffix = '/s'

    for x in ['bytes','KB','MB','GB']:
        if num < 1024.0:
            return '%3.2f%s%s' % (num, x, suffix)
        num /= 1024.0
    return '%3.3f%s%s' % (num, 'TB', suffix)

class Procress:
    def __init__(self, pid):
        self._pid = pid
        # only used in run(), but need to start timing when the proc starts:
        self._times = { 'start': time.time(), 'last_output': 0.0 }
        self._proc = subprocess.Popen(
            ('strace', '-q', '-e', 'trace=read,write', '-p', str(self._pid)),
            bufsize=1, stderr=subprocess.PIPE, close_fds=True)
        self._stream = self._proc.stderr

    def analyze(self, interval=0.25):
        # TODO: strace supports multiple -p options; this would be a nice feature
        counters = { 'read': 0, 'write': 0 }
        for line in self._stream:
            matches = re.match(r'(\w*)\(.*\) = (\d+)',
                               line.decode('ascii').rstrip('\n'))
            try:
                counters[matches.group(1)] += int(matches.group(2))
            except Exception as e:
                # FIXME: this doesn't seem to work; add test
                e.message += "unrecognized line: " + str(line)
                raise

            current_time = time.time()
            elapsed_time = current_time - self._times['start']
            # we don't need to output progress for every input line,
            # just every *interval* seconds.
            if current_time - self._times['last_output'] >= interval:
                self._times['last_output'] = current_time
                yield 'read: {0} ({1}); write: {2} ({3})'.format(
                        prettysize(counters['read']),
                        prettysize(counters['read'], time=elapsed_time),
                        prettysize(counters['write']),
                        prettysize(counters['write'], time=elapsed_time))

def main(argv=sys.argv):
    parser = ArgumentParser(description=DESCRIPTION)
    # require a -p opt for forwards-compatibility if we want to support commands
    parser.add_argument('-p', '--pid', dest='pid', type=int, required=True,
            help='Attach to the given process ID (e.g. from the ps command)')
    args = parser.parse_args(argv[1:])

    try:
        # use ljust to clear the line before overwriting it with \r;
        # this writelines only seems to work in python 3
        #sys.stdout.writelines(line.ljust(80) + '\r'
        #                      for line in progress(opts.pid))
        for line in Procress(args.pid).analyze():
            sys.stdout.write(line.ljust(80) + '\r')
    except KeyboardInterrupt:
        print # so the last line written doesn't get lost
    except Exception:
        print
        raise


class TestProcress(unittest.TestCase):
    @mock.patch('subprocess.Popen')
    @mock.patch('time.time', return_value=1.0)
    def test_analyze(self, mock_time, mock_subprocess):
        proc = Procress(1)
        proc._stream = BytesIO('write(1, "foo", 3) = 3'.encode('ascii'))
        self.assertEqual(next(proc.analyze(interval=0.0)),
                'read: 0.00bytes (0.00bytes/s); write: 3.00bytes (3.00bytes/s)')
        with self.assertRaises(StopIteration):
            next(proc.analyze(interval=0.0))

    @mock.patch('subprocess.Popen')
    @mock.patch('time.time', return_value=1.0)
    def test_analyze_invalid(self, mock_time, mock_subprocess):
        proc = Procress(1)
        proc._stream = BytesIO('attach: ptrace(PTRACE_ATTACH, ...): No such process'
                               .encode('ascii'))
        with self.assertRaisesRegexp(AttributeError, 'unrecognized line'):
            next(proc.analyze(interval=0.0))

if __name__ == '__main__':
    sys.exit(main())
