import pytest
import subprocess as sp
import shutil, platform, os
from pathlib import Path

def test_run():
	"""
	This simply runs the C-langage tests in testmotab.c, which is checking out little routines for loading
	a .motab file in C.
	"""
	exe = './testmotab'
	env = None
	if platform.system()=="Linux":
		env = os.environ
		env['LD_LIBRARY_PATH']='../src/modelica'
	proc = sp.run([exe],env=env)#stdout=sp.PIPE,stderr=sp.PIPE,env=env)
	assert(proc.returncode==0)

