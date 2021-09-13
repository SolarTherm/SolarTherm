from __future__ import division
import unittest
import subprocess as sp
import os

# this test is for probing sys.path issues with Python and 'locally installed' packages on GHA

class TestSubPython(unittest.TestCase):
	def test_check_output(self):
		import DyMat
		v = DyMat.__version__
		print("version = '%s'"%(v,))
		out = sp.check_output(["python3","-c","import DyMat;print(DyMat.__version__)"],encoding="utf-8")
		print("out=",out)
		assert out.strip() == v

	def test_check_output2(self):
		import DyMat
		v = DyMat.__version__
		print("version = '%s'"%(v,))
		out = sp.check_output(["python3"],input="import DyMat;print(DyMat.__version__)",encoding="utf-8")
		print("out=",out)
		assert out.strip() == v

	def test_subprocess_run(self):
		import DyMat
		v = DyMat.__version__
		print("version = '%s'"%(v,))
		res = sp.run(['python3'],input="import DyMat;print(DyMat.__version__);exit",stdout=sp.PIPE,stderr=sp.PIPE,encoding="utf-8")
		print("out = '%s'"%(res.stdout.strip(),))
		print("stderr=",res.stderr)
		assert res.stdout.strip() == v

class TestStEnv(unittest.TestCase):

	def setUp(self):
		import platform, shutil,sys, os
		from pathlib import Path
		if platform.system()=="Windows":
			st1 = Path(os.environ.get('HOME'))/".local"/"bin"/"st"
			assert st1.exists()
			self.st = [sys.executable,st1]
		else:
			self.st = ['st']

	def test_st_help(self):
		res = sp.run(self.st+['--help'],check=True,stdout=sp.PIPE,stderr=sp.PIPE)
		print("stdout=",res.stdout)
	
	def test_st_invalidx(self):
		try:
			sp.run(self.st+['invalidx'],check=True,stdout=sp.PIPE,stderr=sp.PIPE)
		except sp.CalledProcessError as e:
			return
		self.fail("Invalid st command was note caught")
		
	@unittest.skipIf(os.environ.get('SOLARTHERM_SHELL'),"already inside 'st env'")
	def test_st_env_exit(self):
		res = sp.run(self.st+['env'],input="exit",stdout=sp.PIPE,stderr=sp.PIPE,encoding="utf-8")
		print("stdout=",res.stdout)
		print("stderr=",res.stderr)
		assert res.returncode == 0

	@unittest.skipIf(os.environ.get('SOLARTHERM_SHELL'),"already inside 'st env'")
	def test_st_env_basherror(self):
		print("PATH =",os.environ.get('PATH'))
		call = self.st+['env']
		print("CALL =",call)
		res = sp.run(call,input="exit 25",stdout=sp.PIPE,stderr=sp.PIPE,encoding="utf-8")
		print("stdout=",res.stdout)
		print("stderr=",res.stderr)
		assert res.returncode == 25

	def test_st_python_undef(self):
		res = sp.run(self.st + ['python'],input="print(undefinedxxx)",stdout=sp.PIPE,stderr=sp.PIPE,encoding="utf-8")
		assert res.returncode != 0

	def test_st_python_add(self):
		res = sp.run(self.st+['python','-c','print(2+2)'],stdout=sp.PIPE,stderr=sp.PIPE,encoding="utf-8")
		assert res.returncode == 0
		assert int(res.stdout.strip()) == 4

	def test_DyMat(self):
		import DyMat

	def test_st_DyMat(self):
		import DyMat,sys
		v = DyMat.__version__
		print("version = '%s'"%(v,))
		res = sp.check_output([sys.executable],input="import DyMat;print(DyMat.__version__);exit",encoding="utf-8")

	def test_st_DyMat(self):
		import DyMat,sys
		v = DyMat.__version__
		print("version = '%s'"%(v,))
		res = sp.check_output([sys.executable],input="import DyMat;print(DyMat.__version__);exit",encoding="utf-8")
		#print("stdout=",res.stdout)
		#print("stderr=",res.stderr)
		#print("ret=",res.returncode)
		#assert res.returncode == 0


	def test_st_python_DyMat(self):
		import DyMat
		v = DyMat.__version__
		out = sp.check_output(self.st+['python','-c','import DyMat;print(DyMat.__version__)'],encoding="utf-8")
		assert v == out.strip()

	def test_st_python(self):
		"""Check that our sys.path is 'the same as' the sys.path of Python in a subprocess."""
		import sys, os
		from pathlib import Path
		def pr(p):
			return Path(p).resolve()
		print("sys.path=",sys.path)
		l = sys.path
		p = set(map(pr,l))
		res = sp.run([sys.executable,'-c','import sys;print(sys.path)'],stdout=sp.PIPE,stderr=sp.PIPE,encoding="utf-8",env=os.environ.copy())
		assert res.returncode == 0
		l1 = eval(res.stdout.strip())
		p1 = set(map(pr,l1))
		assert p1 == p
		#assert l == int(res.stdout)



# vim: ts=4:sw=4:noet:syntax=python

