from __future__ import division
import os
import subprocess as sp
import xml.etree.ElementTree as ET
import multiprocessing as mp
import re

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

class Simulator(object):
	"""Compilation and simulation of a modelica model.

	The suffix is applied to the init file names written and read by the
	simulator.  This can be changed after construction and thereafter changes
	calls to `write_init`, `update_pars` and `simulate`.
	"""
	def __init__(self, fn, model=None, suffix=None):
		self.fn = fn
		if model is None:
			self.model = os.path.splitext(os.path.split(self.fn)[1])[0]
		else:
			self.model = model
		self.suffix = suffix
		self.makefile_fn = self.model + '.makefile'
		self.init_fn = self.model + '_init.xml'
		self.init_et = None
	
	def get_init_out_fn(self):
		if self.suffix is None:
			return self.init_fn
		else:
			return self.model + '_init_' + self.suffix + '.xml'
	
	def compile_model(self, n_proc=0, libs=['Modelica', 'SolarTherm'], args=[]):
		"""Compile modelica model in .mo file."""
		sp.call(['omc', '-s', '-q', '-n='+str(n_proc)]
			+ args
			+ ['-i='+self.model, self.fn]
			+ libs)

	def compile_sim(self, n_jobs=(1 + mp.cpu_count()//2), args=[]):
		"""Compile model source code into a simulation executable."""
		sp.call(['make', '-j', str(n_jobs), '-f', self.makefile_fn] + args)

	def load_init(self):
		"""Load in init XML."""
		self.init_et = ET.parse(self.init_fn)

	def write_init(self):
		"""Write new init XML with optional suffix."""
		self.init_et.write(self.get_init_out_fn())

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
			'-f', self.get_init_out_fn(),
			]
		sp.call(['./'+self.model] + sim_args + args)
