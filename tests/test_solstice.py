import unittest

class TestSolsticePy(unittest.TestCase):

	def test_solstive_version(self):
		import solsticepy
		s = solsticepy.find_prog('solstice')
		
		import subprocess
		ret = subprocess.run([s,'--version'],check=True,capture_output=True,encoding="utf-8")
		version = ret.stdout
		assert version.strip() == "Solstice 0.9.0"

# vim: ts=4:sw=4:noet:tw=80
