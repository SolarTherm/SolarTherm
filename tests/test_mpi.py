#! /bin/env python

from __future__ import division
import unittest
import cleantest
import os, platform, subprocess
import multiprocessing as mp	

class TestMPI(unittest.TestCase):
	def setUp(self):
		subprocess.call("mpicc test_mpi.c -o hello_world", shell=True)
		
		mpirun = os.environ.get('ST_MPIRUN','mpirun')
		
		if platform.system()=='Windows':
			mpirun_call = [mpirun,"./hello_world>hello_world.txt"]
			subprocess.call(mpirun_call, shell=True)			
		
		else:
			import distro
			system=distro.linux_distribution()
			if system[1]=='20.04':
				os.system(mpirun+' --use-hwthread-cpus ./hello_world >hello_world.txt')
			else:
				os.system(mpirun+' ./hello_world >hello_world.txt')
	def test_mpi(self):
		with open('hello_world.txt') as f:
		    lines = f.readlines()
		f.close()
		n_mpi=len(lines)	
		n_cpu=mp.cpu_count()		
		print('number of cpus', n_cpu)
		print('number of pros run by mpi', n_mpi)	
		self.assertTrue(n_mpi==n_cpu)
		if platform.system()=='Windows':
			os.unlink('hello_world.exe')
		else:
			os.unlink('hello_world')
		os.unlink('hello_world.txt')
		
if __name__ == '__main__':
	unittest.main()
