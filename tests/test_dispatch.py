import pytest
import subprocess as sp
import shutil, platform, os
from pathlib import Path

def append_path(env,var,add):
	val = (env[var].split(os.pathsep) if var in env else []) + [str(add)]
	env[var] = os.pathsep.join(val)

def test_append():
	env = os.environ.copy()
	var = 'XXXXUNDEFINED_'
	assert var not in env
	append_path(env,var,'HELLO')
	assert env[var] == "HELLO"
	
	env['AAA'] = os.pathsep.join(["A","B"])
	append_path(env,'AAA',"C")
	assert env['AAA'] == os.pathsep.join(['A','B','C'])

	env['VVV'] = os.pathsep.join(["A"])
	append_path(env,'VVV',"C")
	assert env['VVV'] == os.pathsep.join(['A','C'])

def test_1():
	exe = './testdispatch'
	env = None
	if platform.system()=="Linux":
		env = os.environ.copy()
		append_path(env,'LD_LIBRARY_PATH',Path('../src/modelica'))
	fdni = Path("../SolarTherm/Data/Weather/Mildura_Real2010_Created20130430.motab")
	fprice = Path("../SolarTherm/Data/Prices/aemo_vic_2014_hourly_manipulated.motab")
	t = 180.0
	proc = sp.run([exe,str(fdni),str(fprice),str(t)],env=env)#stdout=sp.PIPE,stderr=sp.PIPE,env=env)
	assert(proc.returncode==0)

def test_2():
	exe = './testdispatch2'
	env = None
	if platform.system()=="Linux":
		env = os.environ.copy()
		append_path(env,'LD_LIBRARY_PATH',Path('../src/modelica'))

	proc = sp.run([exe],env=env)
	assert(proc.returncode==0)

