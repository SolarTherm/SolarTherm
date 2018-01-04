from __future__ import division
import os
import shutil
import warnings
from pipes import quote as sh_quote
import subprocess as sp
import xml.etree.ElementTree as ET
import multiprocessing as mp
import re
import tempfile

# TODO: Add in option for different result file output
# TODO: Need to add in error checking for calls (possibly use in tests)

var_re = re.compile('([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?)(\S+)')
# Assuming all linear relations between units (factor, offset)
unit_conv = {
		'm': {
				's': (60,0),
			},
		'h': {
				's': (60*60,0),
				'm': (60,0),
			},
		'd': {
				's': (24*60*60,0),
				'm': (24*60,0),
				'h': (24,0),
			},
		'y': {
				's': (365*24*60*60,0),
				'm': (365*24*60,0),
				'h': (365*24,0),
				'd': (365,0),
			},
		'kW': {
				'W': (1000,0),
			},
		'kWh': {
				'J': (3.6e6,0),
			},
		}

def convert_val(v1, u1, u2):
	try:
		fac, off = unit_conv[u1][u2]
		return fac*v1 + off
	except KeyError:
		fac, off = unit_conv[u2][u1]
		return (v1 - off)/fac

def move_overwrite(src,dst):
	"""If `src` exists and is a normal file, move it to `dst`, overwiting a file
	that is there already if necessary. Raise exception if `src` is a directory.
	If `dst` is a directory, then place the `src` file in that directory."""
	if not os.access(src,os.R_OK):
		return
	assert not os.path.isdir(src)
	if os.path.isdir(dst):
		dst = os.path.join(dst,os.path.basename(src))
	if os.path.exists(dst):
		assert os.access(dst,os.W_OK) and not os.path.isdir(dst)
		os.unlink(dst)
	print "Moving '%s' to '%s'"%(src,dst)
	shutil.move(src,dst)

def parse_var_val(vstr, unit):
	"""Convert variable value from string with unit to target unit.

	The string valstr must be a number which has an optional suffix:
	
		'<number>[unit]'
	
	Raises an exception if not in the correct format or if there is no known
	conversion between the unit types.
	"""
	# First we assume it has no suffix, and hence already in the target units
	try:
		return float(vstr)
	except ValueError:
		pass

	# Try to get the unit suffix and convert the first part to a number
	res = var_re.match(vstr)
	if res is None:
		raise ValueError('Cannot parse variable value ' + vstr)

	unit_old = res.group(2) # original unit
	val_old = float(res.group(1)) # original value

	if unit == unit_old:
		return val_old

	try:
		return convert_val(val_old, unit_old, unit)
	except KeyError:
		raise ValueError('Can\'t convert from unit ' + unit_old + ' to ' + unit)

UNIONFS = "/usr/bin/unionfs-fuse"
FUSERMOUNT = "/bin/fusermount"

class Simulator(object):
	"""Compilation and simulation of a modelica model."""
	def __init__(self, fn, model=None, suffix=None, fusemount=True, reuse=False):
		"""Constructor. `fn` is a .mo filename, `suffix` is a init file suffix,
		`tempdir` is FIXME the location where temporary files should be stored,
		`True` if a machine-generated temporary location should be generated and
		used, or `None` if the current directory should be used.

		The `suffix` is applied to the init file names written and read by the
		simulator.  This can be changed after construction and thereafter
		changes	calls to `write_init`, `update_pars` and `simulate`.

		`fusemount` instructs Simulator to run its operations inside a 
		unionfs-fuse filesystem, which enables us to segregate and remove all 
		of the temporary files created by OMC. Set False if you want to disable
		this feature. 

		`reuse` instructs Simulator to re-use an earlier-created mount. If
		passes, it should be the tuple returned by Simulator::get_fuse_dirs()

		During cleanup, Simulator will keep the init_out_fn and res_fn (if they
		exist) which are assumed to be the only two important output files from 
		the calculation.
		"""
		self.fn = os.path.abspath(fn)
		if not os.path.exists(fn):
			raise RuntimeError("Model file '%s' does not exist"%fn)

		if fusemount and not reuse:
			if not os.access(UNIONFS,os.X_OK) or not os.access(FUSERMOUNT,os.X_OK):
				warnings.warn("'%s' or '%s are not executable (try st_simulate --nofuse, or sudo apt install unionfs-fuse)"%(UNIONFS,FUSERMOUNT))
				fusemount = 0

		if model is None:
			self.model = os.path.splitext(os.path.split(self.fn)[1])[0]
		else:
			self.model = model

		self.makefile_fn = self.model + '.makefile'
		self.init_in_fn = self.model + '_init.xml'
		self.fusemount = fusemount
		self.enter_fuse(reuse)
		self.suffix = suffix
		self.init_et = None

	def __del__(self):
		if self.fusemount:
			self.leave_fuse()

	@property
	def init_out_fn(self):
		if self.suffix is None:
			return self.init_in_fn
		else:
			return self.model + '_init_' + self.suffix + '.xml'
	
	@property
	def res_fn(self):
		if self.suffix is None:
			return self.model + '_res.mat'
		else:
			return self.model + '_res_' + self.suffix + '.mat'
	
	def enter_fuse(self,reuse=False):
		assert not getattr(self,'entered_fuse',0)
		if reuse:
			self.mountdir = reuse[0]
			self.tempdir = reuse[1]
			self.init_cwd = reuse[2]
			self.reuse = True
		elif self.fusemount:
			self.mountdir = tempfile.mkdtemp(prefix="solartherm-mount-")
			self.tempdir = tempfile.mkdtemp(prefix="solartherm-temp-")
			self.init_cwd = os.getcwd()
			print "Temporary directory '%s'" % self.tempdir
			print "Mount directory '%s'" % self.mountdir
			self.makefile_fn = os.path.join(self.mountdir,self.makefile_fn)
			self.init_in_fn = os.path.join(self.mountdir,self.init_in_fn)
			sp.check_call([UNIONFS,'-o','cow','%s=RW:%s=RO'%(sh_quote(self.tempdir),sh_quote(self.init_cwd)), self.mountdir])
			os.chdir(self.mountdir)
			self.entered_fuse = True
			self.reuse = False

	def leave_fuse(self):		
		os.chdir(self.init_cwd)
		if self.fusemount:
			if not self.reuse:		
				assert getattr(self,'entered_fuse')
				#print "REMOVING FUSE MOUNTPOINT"
				try:
					sp.check_call([FUSERMOUNT,'-uz',self.mountdir])
				except sp.CalledProcessError,e:
					print "UNABLE TO UNMOUNT: %s", str(e)
					print "cwd = ",os.getcwd()
					print "init_cwd =",self.init_cwd
					import psutil
					proc = psutil.Process()
					print proc.open_files()
				self.cleanup_fuse()
			self.entered_fuse = False

	def cleanup_fuse(self):
		assert(self.fusemount)
		if self.reuse:
			print "Copying results files to original directory"
			print "result file: ",self.res_fn
			shutil.move(os.path.join(self.tempdir,self.res_fn),self.init_cwd)
			print "init_out file: ",self.init_out_fn
			shutil.move(os.path.join(self.tempdir,self.init_out_fn),self.init_cwd)
		else:			
			print "Cleaning up tempdir '%s'" % self.tempdir
			move_overwrite(os.path.join(self.tempdir,self.res_fn),self.init_cwd)
			move_overwrite(os.path.join(self.tempdir,self.init_out_fn),self.init_cwd)
			assert(self.tempdir[0:4]=="/tmp") # just being cautious!
			assert(os.path.isdir(self.tempdir))
			shutil.rmtree(self.tempdir)
			os.rmdir(self.mountdir)

	def get_fuse_dirs(self):
		if self.fusemount:
			return (self.mountdir,self.tempdir,self.init_cwd)
		else:
			return None

	def compile_model(self, n_proc=0, libs=['Modelica', 'SolarTherm'], args=[]):
		"""Compile modelica model in .mo file."""
		sp.check_call(['omc', '-s', '-q', '-n='+str(n_proc)]
			+ args
			+ ['-i='+self.model, self.fn]
			+ libs)

	def compile_sim(self, n_jobs=(1 + mp.cpu_count()//2), args=[]):
		"""Compile model source code into a simulation executable."""
		sp.check_call(['make', '-j', str(n_jobs), '-f', self.makefile_fn] 
			+ args)

	def load_init(self):
		"""Load in init XML."""
		self.init_et = ET.parse(self.init_in_fn)

	def write_init(self):
		"""Write new init XML with optional suffix."""
		self.init_et.write(self.init_out_fn)

	def clear_init(self):
		"""Clear init XML."""
		self.init_et = None

	def update_et_pars(self, par_n, par_v):
		"""Update parameter values in internal XML.

		The values of parameters will fail to change in the simulation if they
		are final (protected).  This can happen indirectly if a final parameter
		derives its value from a non-final changed parameter.
		"""
		root = self.init_et.getroot()

		for i, n in enumerate(par_n):
			root.find('*ScalarVariable[@name=\''+n+'\']/*[@start]').attrib['start'] = par_v[i]

	def update_pars(self, par_n, par_v):
		"""Update parameters values in XML and write results to file."""
		if self.init_et is None:
			self.load_init()
		self.update_et_pars(par_n, par_v)
		self.write_init()
	
	def get_unit(self, var_n):
		root = self.init_et.getroot()

		node = root.find('*ScalarVariable[@name=\''+var_n+'\']/*[@unit]')
		return '' if node is None else node.attrib['unit']

	def simulate(self, start='0', stop='86400', step='60', solver='rungekutta', args=[]):
		"""Run simulation.
		
		If running an optimisation then 'optimization' needs to be used as
		solver type.
		"""
		start = str(parse_var_val(start, 's'))
		stop = str(parse_var_val(stop, 's'))
		step = str(parse_var_val(step, 's'))
		sim_args = [
			'-override',
			'startTime='+start+',stopTime='+stop+',stepSize='+step,
			'-s', solver,
			'-f', self.init_out_fn,
			'-r', self.res_fn,
			]
		sp.check_call(['./'+self.model] + sim_args + args)
		# assert also that there must be a result file
		assert os.access(self.res_fn,os.R_OK)

