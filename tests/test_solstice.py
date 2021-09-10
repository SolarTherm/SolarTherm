import unittest

class TestSolsticePy(unittest.TestCase):

	def test_solstive_version(self):
		import solsticepy
		try:
			s = solsticepy.find_prog('solstice')
			assert s
		except Exception as e:
			self.fail("Using solsticepy: could not locate 'solstice'")
		
		import subprocess
		ret = subprocess.run([s,'--version'],capture_output=True,encoding="utf-8")
		if ret.returncode != 0:
			self.fail("Running 'solstice --version' returned an error code")
		version = ret.stdout
		assert version.strip() == "Solstice 0.9.0"

# vim: ts=4:sw=4:noet:tw=80
