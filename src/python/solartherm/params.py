#!/usr/bin/env python3
# vim: set fileencoding=utf-8 :
from __future__ import print_function
from __future__ import unicode_literals

from openpyxl import Workbook, load_workbook

# from the modelica code, we will figure out what parameters are available
# for use to set...

class Tree(object):
	""" Tree structure, for storing available parameters.
	
	We will use this tree structure to save the names of the allowable 
	parameters from our Modelica code. Then we will read the information of the 		
	parameters from an Excel file. The information includes:
	1) nominal value
	2) unit
	3) type, i.e. 0-certain constant, 1-uncertain constant, 2-variable
	4) distribution
	5) boundary 1&2
 	The information will be passed to st_DAKOTA for sampling, and the sampled values 
	will be passed to Modelica when initialising our model. Alternatively, the nominal 
	values can be passed directly to Modelica when initilising our model.

	>>> T = Tree()
	>>> r = T.add_child('SM')	
	>>> r.add_value('type',2)
	>>> r.add_value('nominal',2.5)
	>>> r.add_value('unit',None)


	>>> T
	/
	  SM
		nominal = 2.5
		type = 2
		unit = None

	>>> T.insert('SM.distribution','uniform')
	>>> T.insert('SM.boundary1',1)
	>>> T.insert('SM.boundary2',5)

	>>> T
	/
	  SM
		boundary1 = 1
		boundary2 = 5
		distribution = 'uniform'
		nominal = 2.5
		type = 2
		unit = None

	>>> assert T.exists('SM.distribution')
	>>> assert not T.exists('field.foo')
	>>> assert not T.exists('foo.bar')

	>>> T.get('SM.nominal')
	2.5
	>>> T.update('SM.nominal',6)
	>>> T
	/
	  SM
		boundary1 = 1
		boundary2 = 5
		distribution = 'uniform'
		nominal = 6
		type = 2
		unit = None

	"""
	def __init__(self):
		self.children = {}
	def add_value(self,name,value,replace=False):
		assert replace is True or name not in self.children, "Child '%s' already exists"%(name,)
		self.children[name] = ValueNode(name,value)
	def add_child(self,name,replace=False):	
		assert replace is True or name not in self.children, "Child '%s' already exists"%(name,)
		self.children[name] = Tree()
		return self.children[name]
	def __repr__(self,prefix="",name="/"):
		if len(self.children) == 0:
			s = prefix + name + " {empty}\n"
		else:
			s = prefix + name + "\n"
			nextprefix = prefix + "  "
			for c in sorted(self.children):
				s += self.children[c].__repr__(nextprefix,c)
		if prefix == "":
			s = s.rstrip()
		return s
	def insert(self,ref,value,replace=False):
		#print("inserting",ref)
		if isinstance(ref,str):
			ref = ref.split(".")
		if ref[0] not in self.children:
			if len(ref)==1:
				#print("adding '%s' with value"%(ref[0],),value)
				self.add_value(ref[0],value,replace=replace)
			else:
				self.add_child(ref[0]).insert(ref[1:],value,replace=replace)
		else:
			self.children[ref[0]].insert(ref[1:],value,replace=replace)
	def exists(self,ref):
		try:
			self.get(ref,raise_missing=True)
		except:
			return False
		return True
	def get(self,ref,raise_missing=False):
		#print("checking for",ref)
		if isinstance(ref,str):
			ref = ref.split(".")
		if ref[0] not in self.children:
			#print("missing '%s'" % ref[0])
			if raise_missing:
				raise IndexError
			else:
				return None
		if len(ref) == 1:
			if isinstance(self.children[ref[0]],Tree):
				return True
			else:
				return self.children[ref[0]].value
		else:
			assert isinstance(self.children[ref[0]],Tree),"should be tree node"
			return self.children[ref[0]].get(ref[1:],raise_missing)
	def update(self,ref,value):
		if isinstance(ref,str):
			ref = ref.split(".")
		assert ref[0] in self.children, "Child '%s' not found" % (ref[0],)
		if isinstance(self.children[ref[0]],ValueNode):
			self.children[ref[0]].value = value
		else:
			self.children[ref[0]].update(ref[1:],value)

class ValueNode(object):
	def __init__(self,name,value):
		self.value = value
	def __repr__(self,prefix="",name="{unnamed}"):
		return prefix + name + " = " + repr(self.value) + "\n"

def load_values_from_excel(filename,tree):
	"""
	Load allowable values from an Excel spreadsheet. 
	The template of the Excel spreadsheet is in the examples folder.
		Column A: classification
		Column B: symbol, should correspond to the names in Modelica
		Column C: nominal value
		Column D: unit
		Column E: name (description)
		Column F: type (0-certain constant, 1-uncertain constant, 2-variable)
				  type 1 is for uncertainty analysis
				  type 2 is for optimisation or parametric study 
		Column G: distribution of sampling, e.g. normal, uniform, pert-beta
		Column H: boundary1 (lower boundary or standard deviation)
		Column I: boundary2 (upper boundary if needed)
		Column J: description
		Column K: source or reference

	>>> T = Tree()
	>>> T.insert('SM.nominal',None)
	>>> T.insert('SM.distribution',None)
	>>> T.insert('rcv_H',None)
	>>> load_values_from_excel('Reference_2_params.xlsx',T)
	/
	  SM
		boundary1 = None
		boundary2 = None
		distribution = None
		nominal = 2.5
		type = 2
		unit = None
	  eff_blk
		boundary1 = 0.05
		boundary2 = None
		distribution = 'normal'
		nominal = 0.3774
		type = 1
		unit = None
	  he_av_design
		boundary1 = 0.985
		boundary2 = 0.995
		distribution = 'uniform'
		nominal = 0.99
		type = 1
		unit = None
	  rec_fr
		boundary1 = 0.01
		boundary2 = 0.09
		distribution = 'pert'
		nominal = 0.05
		type = 1
		unit = None
	  rcv_H
	"""
	wb = load_workbook(filename)

	for wsname in wb.sheetnames:
		ws = wb[wsname]
		for col in ws.iter_cols(min_col=2,max_col=2,min_row=ws.min_row, max_row=ws.max_row): # look at cells in column 
			#print("col =",col)
			for c in col:
				if c.value is not None: # name is there
					study = ws.cell(c.row,6).value
					if study in [0,1,2]:
						r=tree.add_child(c.value)
						v = ws.cell(c.row,3).value
						assert v is not None, "No value next to label '%s'"%(c.value,)
						r.add_value('type', study)
						r.add_value('nominal', v)
						r.add_value('unit', ws.cell(c.row,4).value)
						r.add_value('distribution', ws.cell(c.row,7).value)
						r.add_value('boundary1', ws.cell(c.row,8).value)	
						r.add_value('boundary2', ws.cell(c.row,9).value)						

	return tree

# FIXME need to implement a way for the allowable parameter list to be
# loaded from Modelica. There is stuff for this in the Simulation class, as
# I recall.
# -- parameters from xml
# -- update values from spreadsheet
# -- update the xml file


# TODO need to revise the tree structure
# there is only one tab in the spreadsheet

# TODO need a function to filter different type of parameters, e.g. 0, 1, 2

# TODO a new class to specify different distributions for uncertainty analysis
# e.g. uniform, normal, pert-beta distributions


# TODO this script is working with Python3, only? Can it also work for Python2?



if __name__ == "__main__":
	excel='/home/yewang/solartherm-master/examples/Reference_2_params.xlsx'

	T = Tree()
	load_values_from_excel(excel,T)
	print(T)


