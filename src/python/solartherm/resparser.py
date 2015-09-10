from __future__ import division
import scipy.io

class Matv4(object):
	"""
	Class for loading OM mat-file (level 4) results.
	Primary class method used is read(fn).
	Found out that the storage structure is more complicated (some vars
	point to same data).  Going to use DyMat instead:
	https://bitbucket.org/jraedler/dymat/overview
	"""
	@classmethod
	def read(cls, fn):
		"""
		Read variables from mat-file results returning labels and data.
		Uses the scipy mat-file loader.
		Unfortunately OM has a different string representation which scipy mangles,
		so applying a work around.
		"""
		mat = scipy.io.loadmat(fn, chars_as_strings=False)

		# Use scipy to load data
		data = mat['data_2']
		name = mat['name']
		# 'description' contains variable descriptions

		labels = [str(''.join(name[:,j])) for j in range(name.shape[1])]

		return labels, data

class Matv4Manual(object):
	"""
	Class for loading OM mat-file results.
	Primary class method used is read(fn).
	The level 4 format specs are here: http://au.mathworks.com/help/pdf_doc/matlab/matfile_format.pdf
	See OMCompiler/SimulationRuntime/c/util/{read,write}_matlab4.{h,c} for more
	details of what is stored.
	This is a more manual approach written before relising different scipy option.
	Keeping it to document the file format.
	"""

	p_bytes = [8, 4, 4, 2, 2, 1]

	@classmethod
	def read_mat_header(cls, f):
		import struct
		# Each matrix contains a 20 byte header consisting of 5 uint32_t
		tp = struct.unpack('i', f.read(4))[0] # type
		nr = struct.unpack('i', f.read(4))[0] # number of matrix rows
		nc = struct.unpack('i', f.read(4))[0] # number of matric cols
		im = struct.unpack('i', f.read(4))[0] # imaginary numbers (0=real, 1=imaginary)
		ln = struct.unpack('i', f.read(4))[0] # name length (name contains null character)

		# From spec
		m = tp//1000 # numeric format (0=IEEE LE, 1=IEEE BE, 2=VAX D-float, 3=VAX G-float, 4=Cray)
		o = (tp%1000)//100 # always zero
		p = (tp%100)//10 # data format (0=float64, 1=float32, 2=int32, 3=int16, 4=uint16, 5=uint8)
		t = (tp%10) # matrix type (0=numeric, 1=text, 2=sparse)

		return m, p, t, nr, nc, im, ln

	@classmethod
	def read(cls, fn):
		"""
		Use the scipy mat-file loader.
		Unfortunately scipy mangles the output from OM, so have to work around it.
		It appears that the spec suggests text matrices to be encoded as floating
		point numbers with values between 0 and 255 to represent ASCII characters.
		OM instead encodes them as 8bit unsigned integers, with a row for each
		character, and a column for each string.  So the number of rows is the
		max length of any string (+1 for null char).
		See https://bitbucket.org/jraedler/dymat/overview for another implementation.
		"""
		mat = scipy.io.loadmat(fn)

		# Use scipy to load data
		data = mat['data_2']

		# Labels are garbage, so reloading file and a parsing labels ourselves
		#labels = mat['name']

		f = open(fn, 'r')

		# The column labels are in the second matrix of the file.
		# Need to process the first matrix header so that we can jump to second
		# matrix.
		
		m, p, t, nr, nc, im, ln = cls.read_mat_header(f)
		assert t < 2, "Can't handle sparse matrices"

		# Next comes the matrix name, then the matrix for the real part and finally
		# the matrix for the imaginary part

		body_bytes = ln + nr*nc*cls.p_bytes[p]*(1 + im)

		f.seek(body_bytes, 1) # relative to current position

		m, p, t, nr, nc, im, ln = cls.read_mat_header(f)
		#print((m, p, t, nr, nc, im, ln))
		assert m == 0, 'Can only handle IEEE LE'
		assert p == 5, 'Expect OM string format for labels'
		assert t == 1, 'Expect text matrix for labels'

		mname = f.read(ln).rstrip('\0')
		assert mname == 'name', 'Expected "name" matrix'

		labels = []
		for j in range(nc):
			labels.append(f.read(nr).rstrip('\0'))

		return labels, data

if __name__ == '__main__':
	lab, dat = Matv4.read('EnergySystem_res.mat')
	print(lab)
	print(dat)
