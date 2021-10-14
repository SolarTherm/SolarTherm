#! /bin/env python

import unittest
import subprocess as sp
import sys, shlex, platform

def test_local_module():
	import mymodule
	assert 13 == mymodule.add7(6)
	
def test_run():
	n = 6
	res = sp.run([sys.executable, '-c',"import mymodule;print(mymodule.add7(%d))"%(n,)],stdout=sp.PIPE,stderr=sp.PIPE,check=True)
	assert res.returncode == 0
	v = int(res.stdout.strip())
	assert v == 13

def test_run_input():
	n = 6
	res = sp.run([sys.executable],input="import mymodule;print(mymodule.add7(%d))"%(n,),stdout=sp.PIPE,stderr=sp.PIPE,check=True,encoding='utf-8')
	assert res.returncode == 0
	v = int(res.stdout.strip())
	assert v == 13

def test_run_shell():
	n = 6
	def q(s):
		"""quote the string differently on Windows vs Linux..."""
		if platform.system()=="Windows":
			return "\"%s\""%(s,)
		import shlex; return shlex.quote(s)
	call = "%s -c %s" % (sys.executable, q("import mymodule;print(mymodule.add7(%d))"%(n,)))
	#call = ['echo HELLO']
	print("CALL=",call)
	res = sp.run(call,stdout=sp.PIPE,stderr=sp.PIPE,check=True,shell=True,encoding='utf-8')
	assert res.returncode == 0
	print("OUTPUT =",res.stdout)
	v = int(res.stdout.strip())
	assert v == 13

# vim: ts=4:sw=4:noet:
