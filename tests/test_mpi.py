#! /bin/env python

from __future__ import division
import unittest
import cleantest
import os
import multiprocessing as mp	

class TestMPI(unittest.TestCase):
	def setUp(self):
		
		os.system("mpicc test_mpi.c -o hello_world")
		os.system("mpirun --use-hwthread-cpus ./hello_world >hello_world.txt")
		
	def test_mpi(self):
		with open('hello_world.txt') as f:
		    lines = f.readlines()
		f.close()
		n_mpi=len(lines)	
		n_cpu=mp.cpu_count()			
		self.assertTrue(n_mpi==n_cpu)
		os.unlink('hello_world')
		os.unlink('hello_world.txt')
		
if __name__ == '__main__':
	unittest.main()
