#! /bin/env python
import pytest
import subprocess as sp
import sys

def test_numpy():
	print("IMPORTING NUMPY...")
	import numpy
	print("TESTING NUMPY IN SUBPROCESS...")
	sp.run([sys.executable,"-c","import numpy;print(numpy.__version__)"])

if __name__=='__main__':
	test_numpy()
