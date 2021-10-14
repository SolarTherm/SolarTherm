#! /bin/env python

from __future__ import division
import unittest
import cleantest
import os, platform, subprocess
import multiprocessing as mp	



def test_cmpi():
	'''
	Use mpirun to run a pre-compiled C program (testmpi.c)
	to check if the number of processors are equal to the number of available CPUs
		
	'''
	mpirun = os.environ.get('ST_MPIRUN','mpirun')		
	
	if platform.system()=='Windows':
		mpirun_call = [mpirun,"./testmpi>hello_world.txt"]
		subprocess.call(mpirun_call, shell=True)				
	else:
		os.system(mpirun+' --use-hwthread-cpus ./testmpi >hello_world.txt')

	with open('hello_world.txt') as f:
	    lines = f.readlines()
	f.close()
	i=0
	for l in lines:
		if 'Hello world' in l:
			i+=1
	n_mpi=i	
	n_cpu=mp.cpu_count()		
	print('number of cpus', n_cpu)
	print('number of pros run by mpi', n_mpi)
	#print(lines)
		
	assert n_mpi==n_cpu
	os.unlink('hello_world.txt')
		
if __name__ == '__main__':
	unittest.main()
