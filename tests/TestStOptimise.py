#! /bin/env python2

from __future__ import division
import unittest

from solartherm import simulation
import DyMat
import subprocess
from math import pi
import re
import numpy as np

class TestStOptimise(unittest.TestCase):
	'''
	// The Rosenbrock function is applied  
	// to test the single-objective optimisations in st_optimise
	// ref: https://en.wikipedia.org/wiki/Rosenbrock_function
	// 		also DAKOTA users-6.10.0, page 32 
	// The unique optimal point is (x, y)=(1, 1), where f=0, when -2<=x<=2 and -2<=y<=2

	// The Schaffer function is applied 
	// to test the multi-objective optimisations in st_optimise
	// ref: [1] https://en.wikipedia.org/wiki/Test_functions_for_optimization
	//      [2] Schaffer, J. David (1984). 
	//     	    Multiple Objective Optimization with Vector Evaluated Genetic Algorithms.

	'''	
	# TODO each optimisation is running well at the moment, 
	# but how to control the accuracy of each optimisation algorithm?
	# e.g. what is the specific parameter to control the iterations?
	
	def setUp(self):
		# single-objective optimisation
		self.fn = 'TestStOptimise.mo'
		soo_methods=['pso', 'cma', 'ga1', 'ga2', 'Nelder-Mead', 'COBYLA', 'SLSQP']


	def get_res(self, resfile):
		'''
		get results of the single-objective optimisation
		'''
		with open(resfile) as f:
			content= f.read().splitlines()
		f.close()

		params=re.findall("[-+]?[.]?[\d]+(?:,\d\d\d)*[\.]?\d*(?:[eE][-+]?\d+)?", content[0])
		objs=re.findall("[-+]?[.]?[\d]+(?:,\d\d\d)*[\.]?\d*(?:[eE][-+]?\d+)?", content[1])
		obj=float(objs[0])
		x=float(params[0])
		y=float(params[1])

		return obj, x, y

	def get_schaffer_front(self,x):

		y=-0.035968*x**7+0.53225728*x**6-3.17046223*x**5+9.74784352*x**4-16.55293478*x**3+15.71627806*x**2-8.88661535*x+3.68759935
		return y
		
	
	def test_pso(self):
		
		outfile='TestStOptimise_pso_results.txt'
		obj=999
		x=999
		y=999
		i=0
		args='st_optimise --outfile_f %s --start 0 --stop 1 --objective f_rosen --method pso --maxiter 100 --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, self.fn)
		while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
			subprocess.call(args, shell=True)
			obj, x, y=self.get_res(outfile)
			print 'Attempt ', i+1
			i+=1
		print 'Total attempts: ', i

		self.assertTrue(abs(obj)  < 1e-1)
		self.assertTrue(abs(x-1.) < 5e-1)
		self.assertTrue(abs(y-1.) < 5e-1)


	def test_cma(self):
		
		outfile='TestStOptimise_cma_results.txt'
		obj=999
		x=999
		y=999
		i=0
		args='st_optimise --outfile_f %s --start 0 --stop 1 --objective f_rosen --method cma --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, self.fn)
		while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
			subprocess.call(args, shell=True)
			obj, x, y=self.get_res(outfile)
			print 'Attempt ', i+1
			i+=1
		print 'Total attempts: ', i

		self.assertTrue(abs(obj)  < 1e-1)
		self.assertTrue(abs(x-1.) < 5e-1)
		self.assertTrue(abs(y-1.) < 5e-1)

	def test_ga1(self):
		
		outfile='TestStOptimise_ga1_results.txt'
		obj=999
		x=999
		y=999
		i=0
		args='st_optimise --outfile_f %s --start 0 --stop 1 --objective f_rosen --method ga1 --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, self.fn)
		while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
			subprocess.call(args, shell=True)
			obj, x, y=self.get_res(outfile)
			print 'Attempt ', i+1
			i+=1
		print 'Total attempts: ', i

		self.assertTrue(abs(obj)  < 1e-1)
		self.assertTrue(abs(x-1.) < 5e-1)
		self.assertTrue(abs(y-1.) < 5e-1)

	def test_ga2(self):
		
		outfile='TestStOptimise_ga2_results.txt'
		obj=999
		x=999
		y=999
		i=0
		args='st_optimise --outfile_f %s --start 0 --stop 1 --objective f_rosen --method ga2 --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, self.fn)
		while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
			subprocess.call(args, shell=True)
			obj, x, y=self.get_res(outfile)
			print 'Attempt ', i+1
			i+=1
		print 'Total attempts: ', i

		self.assertTrue(abs(obj)  < 1e-1)
		self.assertTrue(abs(x-1.) < 5e-1)
		self.assertTrue(abs(y-1.) < 5e-1)

	def test_Nelder(self):
		
		outfile='TestStOptimise_Nelder-Mead_results.txt'
		obj=999
		x=999
		y=999
		i=0
		args='st_optimise --outfile_f %s --start 0 --stop 1 --maxiter 100 --objective f_rosen --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, self.fn)
		while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
			subprocess.call(args, shell=True)
			obj, x, y=self.get_res(outfile)
			print 'Attempt ', i+1
			i+=1
		print 'Total attempts: ', i

		self.assertTrue(abs(obj)  < 1e-1)
		self.assertTrue(abs(x-1.) < 5e-1)
		self.assertTrue(abs(y-1.) < 5e-1)


	def test_COBYLA(self):
		
		outfile='TestStOptimise_Nelder-Mead_results.txt'
		obj=999
		x=999
		y=999
		i=0
		args='st_optimise --outfile_f %s --start 0 --stop 1 --maxiter 100 --objective f_rosen --method COBYLA --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, self.fn)
		while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
			subprocess.call(args, shell=True)
			obj, x, y=self.get_res(outfile)
			print 'Attempt ', i+1
			i+=1
		print 'Total attempts: ', i

		self.assertTrue(abs(obj)  < 1e-1)
		self.assertTrue(abs(x-1.) < 5e-1)
		self.assertTrue(abs(y-1.) < 5e-1)


	def test_SLSQP(self):
		
		outfile='TestStOptimise_Nelder-Mead_results.txt'
		obj=999
		x=999
		y=999
		i=0
		args='st_optimise --outfile_f %s --start 0 --stop 1 --maxiter 100 --objective f_rosen --method SLSQP --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, self.fn)
		while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
			subprocess.call(args, shell=True)
			obj, x, y=self.get_res(outfile)
			print 'Attempt ', i+1
			i+=1
		print 'Total attempts: ', i

		self.assertTrue(abs(obj)  < 1e-1)
		self.assertTrue(abs(x-1.) < 5e-1)
		self.assertTrue(abs(y-1.) < 5e-1)

	def test_nsga2(self):
		
		outfile='TestStOptimise_nsga2_results.txt'
		front='TestStOptimise_nsga2_pareto_front.txt'
		figfile='TestStOptimise_nsga2_pareto_front.png'
		args='st_optimise --outfile_f %s --outfile_p %s --outfig %s --start 0 --stop 1 --objective f_schaffer1,f_schaffer2 --method nsga2 --test %s x2=-100,100,2'%(outfile, front, figfile, self.fn)
		subprocess.call(args, shell=True)

		with open(front) as f:
			content= f.read().splitlines()
		f.close()

		names=content[0].split(' ')
		names=names[:-1]

		summary={}
		for n in names:
			summary[n]=np.array([])

		t=len(content)
		for i in xrange(1,t):
			c=content[i]
			l=c.split(" ")
			for j in range(len(names)):
				summary[names[j]]=np.append(summary[names[j]], float(l[j]))

		f_schaffer1=summary['f_schaffer1']
		f_schaffer2=summary['f_schaffer2']
		
		idx=[10, 20, 50, 70]
		for i in idx:
			f1=f_schaffer1[i]
			f2=f_schaffer2[i]
			self.assertTrue(abs((f2-self.get_schaffer_front(f1))/f2)< 0.1)

	def test_dakota_moga(self):
		figfile='TestStOptimise_moga_pareto_front.png'
		args='st_optimise --start 0 --stop 1 --objective f_schaffer1,f_schaffer2 --method dakota_moga --outfig %s --test %s x2=-1,1,0.1'%(figfile, self.fn)
		subprocess.call(args, shell=True)

		f_out='finaldata1.dat'
		with open(f_out) as f:
			content= f.read().splitlines()
		f.close()
	
		obj_n=['f_schaffer1', 'f_schaffer2']
		summary={}
		for i in range(2):
			summary[obj_n[i]]=np.array([])

		t=len(content)
		for i in xrange(t):
			c=content[i]
			l=c.split("\t")
			for p in range(2):
				summary[obj_n[p]]=np.append(summary[obj_n[p]], float(l[1+p]))	

		f_schaffer1=summary['f_schaffer1']
		f_schaffer2=summary['f_schaffer2']
		
		idx=[10, 20, 50, 70]
		for i in idx:
			f1=f_schaffer1[i]
			f2=f_schaffer2[i]
			self.assertTrue(abs((f2-self.get_schaffer_front(f1))/f2)< 0.1)






if __name__ == '__main__':
	unittest.main()





