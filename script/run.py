#!/usr/bin/python

from ConfigParser import ConfigParser
from collections import OrderedDict
import subprocess
import argparse
import re, os
import sys, traceback

CORELOAD_RE = re.compile(r"\/?(?P<core>(\w)+)\.core")
INTERPOLATION_RE = re.compile(r"\$\{(?:(?P<section>[^:]+):)?(?P<key>[^}]+)\}")
MTI_K = ['mti']
IUS_K = ['ius']
FILE_T = ['src_files', 'include_files', 'include_dirs']

def proc_sharedlib(simulator, files):
  rets = []
  if simulator in MTI_K:
    for it in files.split(','):
      if it:
        rets.append('-gblso ' + it)
  if simulator in IUS_K:
    for it in files.split(','):
      if it:
        rets.append('-sv_lib ' + it)
  return ' '.join(rets)

def proc_srcfile(simulator, files):
  rets = []
  if simulator in MTI_K:
    for it in files.split(','):
      if it:
        rets.append(it)
  if simulator in IUS_K:
    for it in files.split(','):
      if it:
        rets.append(it)
  return ' '.join(rets)

def proc_incfile(simulator, files):
  rets = []
  if simulator in MTI_K:
    for it in files.split(','):
      if it:
        rets.append(it)
  if simulator in IUS_K:
    for it in files.split(','):
      if it:
        rets.append(it)
  return ' '.join(rets)

def proc_incdir(simulator, dirs):
  rets = []
  if simulator in MTI_K:
    for it in dirs.split(','):
      if it:
        rets.append('+incdir+' + it)
  if simulator in IUS_K:
    for it in dirs.split(','):
      if it:
        rets.append('+incdir+' + it)
  return ' '.join(rets)

def load_main(cp, section='main'):
  eval_cp(cp, section)
  interpolate_cp(cp, section)

def load_files(cp, section):
  eval_cp(cp, section)
  interpolate_cp(cp, section)
  for option in FILE_T:
    try:
      cmds = split_str(cp, section, option)
      cp.set(section, option, ','.join(cmds))
    except:
      pass

def load_systemverilog(cp, section='systemverilog'):
  load_files(cp, section)

def load_systemc(cp, section='systemc'):
  load_files(cp, section)

def load_verilog(cp, section='verilog'):
  load_files(cp, section)

def load_shardlib(cp, section='sharedlib'):
   load_files(cp, section)

def call_syscall(cp, section, option, comb=False):
  cmds = split_str(cp, section, option)
  if comb:
    cmds = [' \\'.join(cmds)]
  for cmd in cmds:
    if cp.getboolean('main', 'debug'):
      print cmd
    try:
      if cp.getboolean('main', 'spawn'):
        proc = subprocess.Popen(cmd, shell=True, stderr=None, stdout=None)
        id(proc)
        proc.wait()
        for line in proc.stdout:
          line = line.rstrip()
          print line
    except:
      pass

def run_makefile(cp, section='Makefile'):
  eval_cp(cp, section)
  interpolate_cp(cp, section)
  for option in ['exec', 'clean']:
    call_syscall(cp, section, option, False)

def run_mti(cp, section='mti'):
  try:
    if cp.get('main', 'simulator') in MTI_K:
      eval_cp(cp, section)
      interpolate_cp(cp, section)
      for cmd in ['vlib', 'vlog', 'vsim']:
        call_syscall(cp, section, cmd, True)
      call_syscall(cp, section, 'clean', False)
  except:
    pass

def run_ius(cp, section='ius'):
  try:
    if cp.get('main', 'simulator') in IUS_K:
      eval_cp(cp, section)
      interpolate_cp(cp, section)
      call_syscall(cp, section, 'irun', True)
      call_syscall(cp, section, 'clean', False)
  except:
    pass

def split_str(cp, section, option):
  rets = []
  for it in cp.get(section, option).replace('\\', '').split('\n'):
    if it:
      try:
        rst = eval(it)
        if rst:
          rets.append(str(rst))
      except:
        rets.append(it)
        pass
  return rets

def load_cores(cp, section='cores', cls=[]):
  eval_cp(cp, section)
  interpolate_cp(cp, section)
  for file in split_str(cp, section, 'import_files'):
    if cp.getboolean('main', 'debug'):
      print file
    m = re.search(CORELOAD_RE, file)
    if not m:
      continue
    cls.append(m.groupdict().get('core'))
    config = ConfigParser(allow_no_value=True)
    config.read(file)
    # flat eval and interpolate
    for section in config.sections():
      task = TASKS[section][0]
      if task:
        task(config, section)
      cls_section = '.'.join(cls[-1:]+[section])
      cp.add_section(cls_section)
      for opt in config.options(section):
        cp.set(cls_section, opt, config.get(section, opt))
    if cls:
      cls.pop();
  # update when new section added
  interpolate_cp(cp, section)

def eval_cp(cp, section):
  for option in cp.options(section):
    try:
      cp.set(section, option, eval(cp.get(section, option)))
    except:
      pass

def interpolate_cp(cp, section):
    result = []
    def interpolate_func(match):
      d = match.groupdict()
      sect = d.get('section', section)
      key = d.get('key')
      return cp.get(sect, key)
    for k, v in cp.items(section):
      try:
        v = re.sub(INTERPOLATION_RE, interpolate_func, v)
        result.append((k, v))
      except:
        pass
    for it in result:
      cp.set(section, it[0], it[1])

# decode setcion to its task
TASKS = OrderedDict({
  'main':           (load_main,           'load main section as root'),
  'cores':          (load_cores,          'load/import depency *.cores as lib'),
  'systemverilog':  (load_systemverilog,  'load systemverilog/UVM as bench'),
  'systemc':        (load_systemc,        'load systemc as modeling'),
  'sharedlib':      (load_shardlib,       'load shared lib as *.so'),
  'verilog':        (load_verilog,        'load verilog as design'),
  'Makefile':       (run_makefile,        'call Makefile'),
  'ius':            (run_ius,             'run ncverilog simulator'),
  'mti':            (run_mti,             'run Questa simulator'),
  'provider':       (None,                'version')
})


def run_core(args):
  config = ConfigParser(allow_no_value=True)
  config.read(args.file)
  print "running {0}".format(args.file)

  for section in config.sections():
    task = TASKS[section][0]
    if (task):
      task(config, section)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='run .core file')
    parser.add_argument('--file', dest='file', action='store', default=False, help='run .core file')
    args = parser.parse_args()
    try:
      run_core(args)
    except:
      traceback.print_exc()
      print "run {0} fail".format(args.file)
