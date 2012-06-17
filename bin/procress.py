#!/usr/bin/python
# Attaches to a running process with strace and shows you the number of bytes
# being read/written to each filehandle.

import time
import re
import subprocess
import sys

def prettysize(num):
    for x in ['bytes','KB','MB','GB']:
        if num < 1024.0:
            return "%3.2f%s" % (num, x)
        num /= 1024.0
    return "%3.3f%s" % (num, 'TB')

def progress(pid, interval=0.25):
    # TODO: strace supports multiple -p options; this would be a nice feature
    times = { 'start': time.time(), 'last_output': 0.0 }
    proc = subprocess.Popen(('strace', '-q', '-e', 'trace=read,write',
                             '-p', str(pid)),
                            bufsize=1, stderr=subprocess.PIPE,
                            close_fds=True)
    counters = { 'read': 0, 'write': 0 }
    for line in proc.stderr:
        matches = re.match(r'(\w*)\(.*\) = (\d+)',
                           line.decode('ascii').rstrip('\n'))
        try:
            counters[matches.group(1)] += int(matches.group(2))
        except:
            sys.stderr.write("unrecognized line: " + str(line))
            raise

        current_time = time.time()
        elapsed_time = current_time - times['start']
        # we don't need to output progress for every input line,
        # just every *interval* seconds.
        if current_time - times['last_output'] >= interval:
            times['last_output'] = current_time
            yield "read: {} ({}/s); write: {} ({}/s)".format(
                    prettysize(counters['read']),
                    prettysize(counters['read'] / elapsed_time),
                    prettysize(counters['write']),
                    prettysize(counters['write'] / elapsed_time))

if __name__ == '__main__':
    try:
        # use ljust to clear the line before overwriting it with \r;
        # this writelines only seems to work in python 3
        #sys.stdout.writelines(line.ljust(80) + '\r'
        #                      for line in progress(sys.argv[1]))
        for line in progress(sys.argv[1]):
            sys.stdout.write(line.ljust(80) + '\r')
    except:
        print # so the last line written doesn't get lost
        raise
