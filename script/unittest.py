#!/usr/bin/python

# use nosetest as python unittest framework
# use run.py as base ctrl task

from ConfigParser import ConfigParser
from collections import OrderedDict
from multiprocessing import Pool
import subprocess
import argparse
import re, os
import sys, traceback
import shutil
import time
import timeit

CFG = {
    'MAXJOBS': 10,
    'TIMEOUT': 3*60*60,
    'CLEAN': False,
    'SIMULATOR': 'mti'
}
WAITQ = []
RUNQ = []
PASSTOKEN = ["FW PASSED", "TEST PASSED", "PASS"]
FAILTOKEN = ["FW FAILED", "TEST FAILED", "FAIL"]

def make_path(test):
    if os.path.exists(test):
        shutil.rmtree(test)
    os.makedirs(test)
    return test

def export_core(cp, path, test):
    cp.set('main', 'test', test)
    cp.set('main', 'debug', 'FALSE')
    cp.set('main', 'spawn', 'TRUE')
    cp.set('main', 'unittest', 'TRUE')
    cp.set('main', 'simulator', CFG['SIMULATOR'])
    cp.set('ius', 'clean', '')
    cp.set('mti', 'clean', '')
    with open("{0}/{1}.core".format(path, test), 'wb') as configfile:
        cp.write(configfile)

def cp_tcl(cp, path, test):
    cmd = ["cp", "simvision.tcl", "{0}/simvision.tcl".format(path)]
    try:
        proc = subprocess.call(cmd, shell=False)
        id(proc)
    except:
        traceback.print_exc()
        print "err: {0}".format(cmd)

def call_runpy(cp, path, test):
    os.chdir(path)
    cmd = ["python", "{0}/script/run.py".format(os.environ['SMTDV_HOME']), "--file", "{0}.core".format(test)]
    if cp.getboolean('main', 'debug'):
        print cmd
    try:
        proc = subprocess.call(cmd, shell=False)
        id(proc)
    except:
        traceback.print_exc()
        print "run {0} fail".format(args.file)



def check_rst(test, status, time, cb=report_rst):
    "check sim rst with pass/fail tokens"
    cmd = ["python"]
    #if cb:
    #    cb()

def spawn_runpy(cp, wait=60, cb=check_rst):
    "as decorator to run job"
    global WAITQ, RUNQ, CFG
    pool = Pool(processes=CFG['MAXJOBS'])
    while len(WAITQ) > 0 or len(RUNQ) > 0:
        if len(RUNQ) <= CFG['MAXJOBS'] and len(WAITQ) > 0:
            path, test = WAITQ.pop()
            rst = pool.apply_async(call_runpy, (cp, path, test,))
            RUNQ.append((rst, test, timeit.default_timer()))
        else:
            for r in RUNQ:
                usec = float("%.2f" %(timeit.default_timer()-r[2]))
                if r[0].successful:
                    print "[{0}] success used {1} usec".format(r[1], usec)
                    RUNQ.remove(r)
                    if cb:
                        cb(r[1], 'pass', usec)
                else:
                    if usec > CFG['TIMEOUT']:
                        print "[{0}] unsuccess used timeout {1} usec".format(r[1], usec)
                        r[0].terminate()
                        if cb:
                            cb(r[1], 'fail', usec)

        time.sleep(float(wait))

def run_unittest(cp, section='main', cb=spawn_runpy):
    for test in cp.get(section, 'tests').replace('\\','').split('\n'):
        if test:
            path = make_path(test)
            export_core(cp, path, test)
            cp_tcl(cp, path, test)
            WAITQ.append((path,test))
    if cb:
        cb(cp)

def run_report():
    pass

def run_main(cp, section='main'):
    if cp.getboolean('main', 'unittest'):
        run_unittest(cp, section)
    else:
        print "please set [main].unittest = TRUE at *.core"
        run_report()

# method call
TASKS = OrderedDict({
  'main': (run_main,   'run main section has unittest to run'),
  })

def run_assign(args):
    global CFG
    CFG = {
        'MAXJOBS': args.maxjobs,
        'TIMEOUT': args.timeout,
        'CLEAN': args.clean,
        'SIMULATOR': args.simulator
    }

def run_regress(args):
    config = ConfigParser(allow_no_value=True)
    config.read(args.file)
    print "running {0}".format(args.file)

    for section in TASKS.keys():
        task = TASKS[section][0]
        if (task):
            task(config, section)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='regress .core file')
    parser.add_argument('--file', dest='file', action='store', default=False, help='regress .core file')
    parser.add_argument('--maxjobs', dest='maxjobs', type=int, action='store', default=10, help='maxjobs')
    parser.add_argument('--timeout', dest='timeout', type=int, action='store', default=3*60*60, help='timeout')
    parser.add_argument('--clean', dest='clean', action='store', default=False, help='clean all')
    parser.add_argument('--simulator', dest='simulator', action='store', default='mti', help='pick up simulator')
    args = parser.parse_args()
    try:
        run_assign(args)
        run_regress(args)
    except:
        traceback.print_exc()
        print "run {0} fail".format(args.file)

