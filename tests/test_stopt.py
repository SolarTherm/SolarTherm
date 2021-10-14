#! /bin/env python
from __future__ import division

import pytest
import os, platform, re, glob, subprocess, shutil, sys
from math import pi
import DyMat
import numpy as np
from pathlib import Path

import cleantest
from solartherm import simulation

MODELICAFILE = 'TestStOptimise.mo'
"""
The Rosenbrock function is applied to test the single-objective optimisations 
in st_optimise. See refs:
     [1] https://en.wikipedia.org/wiki/Rosenbrock_function
     [2] DAKOTA users-6.10.0, page 32 
The unique optimal point is (x, y)=(1, 1), where f=0, when -2<=x<=2 and -2<=y<=2

For multi-objective optimisation, the Schaffer function is used. See:
     [1] https://en.wikipedia.org/wiki/Test_functions_for_optimization
     [2] Schaffer, J. David (1984). 
         Multiple Objective Optimization with Vector Evaluated Genetic Algorithms.
"""

#------------------ SUPPORT FUNCTIONS ------------------

def get_res(resfile):
	"""
	Get results of the single-objective optimisation
	"""
	with open(resfile) as f:
		content= f.read().splitlines()
	f.close()

	params=re.findall(r"[-+]?[.]?[\d]+(?:,\d\d\d)*[\.]?\d*(?:[eE][-+]?\d+)?", content[0])
	objs=re.findall(r"[-+]?[.]?[\d]+(?:,\d\d\d)*[\.]?\d*(?:[eE][-+]?\d+)?", content[1])
	obj=float(objs[0])
	x=float(params[0])
	y=float(params[1])

	return obj, x, y

def get_schaffer_front(x):
	y=-0.035968*x**7+0.53225728*x**6-3.17046223*x**5+9.74784352*x**4-16.55293478*x**3+15.71627806*x**2-8.88661535*x+3.68759935
	return y

def st(scriptname):
	"""
	On Windows, we can't so easily run our 'st' script from Python, because
	the script doesn't have a .py suffix, and Windows doesn't know how to run it.
	Hence, we explicitly run it using the right version of Python (=sys.executable).
	"""
	if platform.system()=="Windows":
		st1 = Path(os.environ.get('HOME'))/".local"/"bin"/"st"
		assert st1.exists()
		return [sys.executable,st1,scriptname]
	else:
		return ['st',scriptname]

#------------------ TESTS ------------------

# TODO each optimisation is running well at the moment, 
# but how to control the accuracy of each optimisation algorithm?
# e.g. what is the specific parameter to control the iterations?



@pytest.mark.skip
def test_pso():
	outfile='TestStOptimise_pso_results.txt'
	obj=999
	x=999
	y=999
	i=0
	args='st_optimise --outfile_f %s --start 0 --stop 1 --objective f_rosen --method pso --maxiter 100 --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, MODELICAFILE)
	while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
		subprocess.call(args, shell=True)
		obj, x, y=get_res(outfile)
		print('Attempt ', i+1)
		i+=1
	print('Total attempts: ', i)

	assert abs(obj)  < 1e-1
	assert abs(x-1.) < 5e-1
	assert abs(y-1.) < 5e-1
	map(os.unlink, glob.glob(outfile))
	cleantest.clean('TestStOptimise')

@pytest.mark.skip
def test_cma():
	outfile='TestStOptimise_cma_results.txt'
	obj=999
	x=999
	y=999
	i=0
	args='st_optimise --outfile_f %s --start 0 --stop 1 --objective f_rosen --method cma --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, MODELICAFILE)
	while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
		subprocess.call(args, shell=True)
		obj, x, y=get_res(outfile)
		print('Attempt ', i+1)
		i+=1
	print('Total attempts: ', i)

	assert abs(obj)  < 1e-1
	assert abs(x-1.) < 5e-1
	assert abs(y-1.) < 5e-1
	map(os.unlink, glob.glob(outfile))	
	os.system('rm -r outcmaes')	
	cleantest.clean('TestStOptimise')

@pytest.mark.skip
def test_ga1():
	outfile='TestStOptimise_ga1_results.txt'
	obj=999
	x=999
	y=999
	i=0
	args='st_optimise --outfile_f %s --start 0 --stop 1 --objective f_rosen --method ga1 --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, MODELICAFILE)
	while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
		subprocess.call(args, shell=True)
		obj, x, y=get_res(outfile)
		print('Attempt ', i+1)
		i+=1
	print('Total attempts: ', i)

	assert abs(obj)  < 1e-1
	assert abs(x-1.) < 5e-1
	assert abs(y-1.) < 5e-1
	map(os.unlink, glob.glob(outfile))
	cleantest.clean('TestStOptimise')

@pytest.mark.skip
def test_ga2():
	outfile='TestStOptimise_ga2_results.txt'
	obj=999
	x=999
	y=999
	i=0
	args='st_optimise --outfile_f %s --start 0 --stop 1 --objective f_rosen --method ga2 --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, MODELICAFILE)
	while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
		subprocess.call(args, shell=True)
		obj, x, y=get_res(outfile)
		print('Attempt ', i+1)
		i+=1
	print('Total attempts: ', i)

	assert (abs(obj)  < 1e-1)
	assert (abs(x-1.) < 5e-1)
	assert (abs(y-1.) < 5e-1)
	map(os.unlink, glob.glob(outfile))	
	cleantest.clean('TestStOptimise')

@pytest.mark.skipif(platform.system()=="Windows",reason="Test is not adapted for Windows yet")
def test_Nelder():
	
	outfile='TestStOptimise_Nelder-Mead_results.txt'
	obj=999
	x=999
	y=999
	i=0
	args='st_optimise --outfile_f %s --start 0 --stop 1 --maxiter 100 --objective f_rosen --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, MODELICAFILE)
	while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
		subprocess.call(args, shell=True)
		obj, x, y=get_res(outfile)
		print('Attempt ', i+1)
		i+=1
	print('Total attempts: ', i)

	assert (abs(obj)  < 1e-1)
	assert (abs(x-1.) < 5e-1)
	assert (abs(y-1.) < 5e-1)
	map(os.unlink, glob.glob(outfile))	
	cleantest.clean('TestStOptimise')

@pytest.mark.skipif(platform.system()=="Windows",reason="Test is not adapted for Windows yet")
def test_COBYLA():
	
	outfile='TestStOptimise_Nelder-Mead_results.txt'
	obj=999
	x=999
	y=999
	i=0
	args='st_optimise --outfile_f %s --start 0 --stop 1 --maxiter 100 --objective f_rosen --method COBYLA --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, MODELICAFILE)
	while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
		subprocess.call(args, shell=True)
		obj, x, y=get_res(outfile)
		print('Attempt ', i+1)
		i+=1
	print('Total attempts: ', i)

	assert (abs(obj)  < 1e-1)
	assert (abs(x-1.) < 5e-1)
	assert (abs(y-1.) < 5e-1)
	map(os.unlink, glob.glob(outfile))	
	cleantest.clean('TestStOptimise')

@pytest.mark.skipif(platform.system()=="Windows",reason="Test is not adapted for Windows yet")
def test_SLSQP():
	
	outfile='TestStOptimise_SLSQP_results.txt'
	obj=999
	x=999
	y=999
	i=0
	args='st_optimise --outfile_f %s --start 0 --stop 1 --maxiter 100 --objective f_rosen --method SLSQP --test %s x1=-2,2,1 y1=-2,2,-1.5'%(outfile, MODELICAFILE)
	while obj>0.1 or abs(x-1.)>0.5 or abs(y-1.)>0.5:
		subprocess.call(args, shell=True)
		obj, x, y=get_res(outfile)
		print('Attempt ', i+1)
		i+=1
	print('Total attempts: ', i)

	assert (abs(obj)  < 1e-1)
	assert (abs(x-1.) < 5e-1)
	assert (abs(y-1.) < 5e-1)

	map(os.unlink, glob.glob(outfile))	
	cleantest.clean('TestStOptimise')

@pytest.mark.skip
def test_nsga2():
	
	outfile='TestStOptimise_nsga2_results.txt'
	front='TestStOptimise_nsga2_pareto_front.txt'
	figfile='TestStOptimise_nsga2_pareto_front.png'
	args='st_optimise --outfile_f %s --outfile_p %s --outfig %s --start 0 --stop 1 --objective f_schaffer1,f_schaffer2 --method nsga2 --test %s x2=-100,100,2'%(outfile, front, figfile, MODELICAFILE)
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
	for i in range(1,t):
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
		assert (abs((f2-get_schaffer_front(f1))/f2)< 0.1)
	map(os.unlink, glob.glob(outfile))
	map(os.unlink, glob.glob(figfile))
	map(os.unlink, glob.glob(front))
	cleantest.clean('TestStOptimise')

@pytest.mark.skipif(platform.system()=="Windows",reason="MSYS2 support is still incomplete")
def test_dakota_moga():
	print("\n\nTESTING DAKOTA_MOGA")
	# first check that we have 'dakota' in our PATH...
	cmd = "where" if platform.system() == "Windows" else "which"
	dakota = subprocess.check_output([cmd, 'dakota'])

	figfile='TestStOptimise_moga_pareto_front.png'
	
	args=st('optimise') + [
		'--start','0'
		,'--stop','1'
		,'--objective','f_schaffer1,f_schaffer2'
		,'--method','dakota_moga'
		,'--wd','test_moga'
		,'--outfig',figfile
		,'--test'
		,MODELICAFILE
		,'x2=-1,1,0.1'
	]
	subprocess.run(args,check=1)

	f_out='./test_moga/finaldata1.dat'
	with open(f_out) as f:
		content= f.read().splitlines()
	f.close()

	obj_n=['f_schaffer1', 'f_schaffer2']
	summary={}
	for i in range(2):
		summary[obj_n[i]]=np.array([])

	t=len(content)
	for i in range(t):
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
		assert (abs((f2-get_schaffer_front(f1))/f2)< 0.1)

	os.system('rm -rf test_moga')
	map(os.unlink, glob.glob(figfile))	

@pytest.mark.skipif(platform.system()=="Windows",reason="MSYS2 support is still incomplete")
def test_dakota_soga():
	# first check that we have 'dakota' in our PATH...
	print("\n\nTESTING DAKOTA_SOGA")
	cmd = "where" if platform.system() == "Windows" else "which"
	dakota = subprocess.check_output([cmd, 'dakota'])

	args=st('optimise') + [
		'--start','0'
		,'--stop','1'
		,'--maxiter','100'
		,'--objective','f_rosen'
		,'--method','dakota_soga'
		,'--wd=test_soga'
		,'--test',MODELICAFILE
		,'x1=-2,2,1'
		,'y1=-2,2,-1.5'
	]

	subprocess.run(args, check=1)

	f_out='./test_soga/finaldata1.dat'
	with open(f_out) as f:
		content= f.read().splitlines()
	f.close()		
	c=content[0]
	l=c.split("\t")

	x=float(l[0])
	y=float(l[1])
	obj=float(l[-1])
	assert (abs(obj)  < 1e-1)
	assert (abs(x-1.) < 5e-1)
	assert (abs(y-1.) < 5e-1)
	
	os.system('rm -rf test_soga')

# vim: ts=4:sw=4:noet:tw=80
