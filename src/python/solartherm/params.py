#!/usr/bin/env python3
# vim: set fileencoding=utf-8 :
from __future__ import print_function
#from __future__ import unicode_literals

from openpyxl import Workbook, load_workbook

# from the modelica code, we will figure out what parameters are available
# for use to set...

class Tree(object):
	""" Tree structure, for storing available parameters.
	
	We will use this tree structure to save the names of the allowable 
	parameters from our Modelica code. Then we will read the parameter values
	from an Excel file, and pass them to Modelica when initialising our model.

	>>> T = Tree()
	>>> r = T.add_child('recv')	
	>>> r.add_value('H',10)
	>>> r.add_value('W',20)
	>>> r.add_value('type','billboard')
	>>> T
	/
	  recv
	    H = 10
	    W = 20
	    type = 'billboard'
	>>> T.insert('recv.t',3)
	>>> T
	/
	  recv
	    H = 10
	    W = 20
	    t = 3
	    type = 'billboard'
	>>> T.insert('field.helio.W',10)
	>>> T
	/
	  field
	    helio
	      W = 10
	  recv
	    H = 10
	    W = 20
	    t = 3
	    type = 'billboard'
	>>> assert T.exists('field.helio')
	>>> assert not T.exists('field.foo')
	>>> assert not T.exists('foo.bar')
	>>> T.get('recv.type')
	'billboard'
	>>> T.update('recv.W',25)
	>>> T
	/
	  field
	    helio
	      W = 10
	  recv
	    H = 10
	    W = 25
	    t = 3
	    type = 'billboard'
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
	Load allowable values from an Excel spreadsheet. Currently this just uses
	the sheet name and values in column B to create values eg 'recv.H'.

	FIXME we should also use column A, and perhaps it should be optional
	to use multiple sheets, somehow.
	Also, nothing done yet for values with uncertainty. Need some way of
	identifying whether or not a value has an uncertainty (eg via the presence
	of data in column D...?)

	FIXME as much as possible, we want to allow comments and annotaions in these
	Excel files.

	FIXME currently no way to set field.helio.W using this system.

	FIXME do the parameter names correspond to Modelica variable names? How do we
	define groupings of parameters? Or is that just a user choice in the layout
	of the Excel spreadsheet.

	>>> T = Tree()
	>>> T.insert('recv.H',None)
	>>> T.insert('recv.W',None)
	>>> T.insert('recv.t',3)
	>>> T.insert('field.helio.W',10)
	>>> load_values_from_excel('parameters1.xlsx',T)
	/
	  field
	    helio
	      W = 10
	  recv
	    H = 30
	    W = 25
	    t = 2
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


