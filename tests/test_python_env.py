#! /bin/env python

import unittest

def test_local_module():
	import mymodule
	assert 13 == mymodule.add7(6)
	
def test_run():
	import subprocess, sys
	n = 6
	res = subprocess.run([sys.executable, '-c',"import mymodule;print(mymodule.add7(%d))"%(n,)],capture_output=True,check=True)
	assert res.returncode == 0
	v = int(res.stdout.strip())
	assert v == 13

def test_run_input():
	import subprocess, sys
	n = 6
	res = subprocess.run([sys.executable],input="import mymodule;print(mymodule.add7(%d))"%(n,),capture_output=True,check=True,encoding='utf-8')
	assert res.returncode == 0
	v = int(res.stdout.strip())
	assert v == 13

def test_run_shell():
	import subprocess, sys, shlex, platform
	n = 6
	def q(s):
		"""quote the string differently on Windows vs Linux..."""
		if platform.system()=="Windows":
			return "\"%s\""%(s,)
		import shlex; return shlex.quote(s)
	call = "%s -c %s" % (sys.executable, q("import mymodule;print(mymodule.add7(%d))"%(n,)))
	#call = ['echo HELLO']
	print("CALL=",call)
	res = subprocess.run(call,capture_output=True,check=True,shell=True,encoding='utf-8')
	assert res.returncode == 0
	print("OUTPUT =",res.stdout)
	v = int(res.stdout.strip())
	assert v == 13

# vim: ts=4:sw=4:noet:
