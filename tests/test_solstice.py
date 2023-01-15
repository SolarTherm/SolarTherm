import unittest, os
from pathlib import Path
import subprocess as sp
import platform, shutil, sys
import packaging.version as pv

@pytest.mark.dependency(name="solstice")
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
		print("\nSHUTIL.WHICH('%s') ="%(s),p)
		assert p
		print("\nLD_LIBRARY_PATH =",os.environ.get('LD_LIBRARY_PATH'))
		print("PATH =",os.environ.get('PATH'))
		print("\nREADELF")
		sp.run(['/usr/bin/readelf','-d',p])
		print("\nSYSTEMD-PATH")
		sp.run(['/usr/bin/systemd-path'])
		print("\nLDD")
		sp.run(['/usr/bin/ldd',p])
		env1 = os.environ.copy()
		env1['LD_LIBRARY_PATH']='/usr/local/lib'
		print("\nLDD (EXPLICIT ENV)")
		sp.run(['/usr/bin/ldd',p],env=env1)
		print()
	
	call = [s,'--version']
	print("CALL =",call)
	ret = sp.run(call,stdout=sp.PIPE,stderr=sp.PIPE,encoding="utf-8")
	print("RETURNCODE =",ret.returncode)
	print("STDERR =",ret.stderr)
	
	if ret.returncode != 0:
		raise RuntimeError("Running 'solstice --version' returned an error code")
	version = ret.stdout
	assert pv.parse(version.strip().split(" ")[1]) >= pv.parse("0.9")

# vim: ts=4:sw=4:noet:tw=80
