import unittest, os
from pathlib import Path
import subprocess

def test_solstice_version():
	try:
		import solsticepy
		s = Path(solsticepy.find_prog('solstice'))
		assert s
		assert s.exists()
	except Exception as e:
		self.fail("Using solsticepy: could not locate 'solstice'")
	
	call = [s,'--version']
	print("CALL =",call)
	ret = subprocess.run(call,capture_output=True,encoding="utf-8")
	if ret.returncode != 0:
		self.fail("Running 'solstice --version' returned an error code")
	version = ret.stdout
	assert version.strip() == "Solstice 0.9.0"

# vim: ts=4:sw=4:noet:tw=80
