import unittest, os
from pathlib import Path
import subprocess as sp
import platform, shutil, sys

def test_solstice_version():
	print("SYS.PATH =",sys.path)
	import solsticepy
	s = solsticepy.find_prog('solstice')
	assert s
	if platform.system()=="Windows":
		assert Path(s).exists()
	else:
		# on Linux, we just get 'solstice' which should be in our PATH:
		p = shutil.which(s)
		print("SHUTIL.WHICH('%s') = ",s,p)
		assert p
		print("LD_LIBRARY_PATH =",os.environ.get('LD_LIBRARY_PATH'))
		print("PATH =",os.environ.get('PATH'))
	
	call = [s,'--version']
	print("CALL =",call)
	ret = sp.run(call,stdout=sp.PIPE,stderr=sp.PIPE,encoding="utf-8")
	print("RETURNCODE =",ret.returncode)
	print("STDERR =",ret.stderr)
	
	if ret.returncode != 0:
		raise RuntimeError("Running 'solstice --version' returned an error code")
	version = ret.stdout
	assert version.strip() == "Solstice 0.9.0"

# vim: ts=4:sw=4:noet:tw=80
