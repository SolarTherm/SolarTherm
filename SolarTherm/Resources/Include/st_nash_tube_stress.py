import numpy as np
import matplotlib.pyplot as plt
import sys, math, scipy.io, scipy.optimize
import os
import time

# Thermal and transport properties of nitrate salt and sodium (verified)
# Nitrate salt:
#   ZAVOICO, Alexis B. Solar power tower design basis document, revision 0; Topical. Sandia National Labs., 2001.
# Liquid sodium:
#   FINK, J. K.; LEIBOWITZ, L. Thermodynamic and transport properties of sodium liquid and vapor. Argonne National Lab., 1995.

strMatNormal = lambda a: [''.join(s).rstrip() for s in a]
strMatTrans  = lambda a: [''.join(s).rstrip() for s in zip(*a)]
sign = lambda x: math.copysign(1.0, x)

def fourierTheta(theta, a0, *c):
	""" Timoshenko & Goodier equation """
	ret = a0 + np.zeros(len(theta))
	for i in range(len(c)):
		ret += c[i] * np.cos(i * theta)
	return ret

class receiver:
	def __init__(self,coolant = 'salt', Ri = 57.93/2000, Ro = 60.33/2000, T_in = 290, T_out = 565,
			nz = 450, nt = 91, R_fouling = 0.0, ab = 0.94, em = 0.88, kp = 21.0, H_rec = 10.5, D_rec = 8.5,
			nbins = 50, debugfolder = os.path.expanduser('~'), debug = True):
		self.coolant = coolant
		self.Ri = Ri
		self.Ro = Ro
		self.T_in = T_in + 273.15
		self.T_out = T_out + 273.15
		self.nz = nz
		self.nt = nt
		self.R_fouling = R_fouling
		self.ab = ab
		self.em = em
		self.kp = kp
		self.H_rec = H_rec
		self.D_rec = D_rec
		self.dz = H_rec/nbins
		self.debugfolder = debugfolder
		self.debug = debug
		self.sigma = 5.670374419e-8
		# Discretisation parameters
		self.dt = np.pi/(nt-1)
		# Tube section diameter and area
		self.d = 2.*Ri                               # Tube inner diameter (m)
		self.area = 0.25 * np.pi * pow(self.d,2.)    # Tube flow area (m2)
		self.ln = np.log(Ro/Ri)                      # Log of Ro/Ri simplification
		#Auxiliary variables
		cosines = np.cos(np.linspace(0.0, np.pi, nt))
		self.cosines = np.maximum(cosines, np.zeros(nt))
		self.theta = np.linspace(-np.pi, np.pi,self.nt*2-2)
		self.n = 3

	def import_mat(self,fileName):
		mat = scipy.io.loadmat(fileName, chars_as_strings=False)
		names = strMatTrans(mat['name']) # names
		descr = strMatTrans(mat['description']) # descriptions
		self.data = np.transpose(mat['data_2'])

		self._vars = {}
		self._blocks = []
		for i in range(len(names)):
			d = mat['dataInfo'][0][i] # data block
			x = mat['dataInfo'][1][i]
			c = abs(x)-1  # column
			s = sign(x)   # sign
			if c:
				self._vars[names[i]] = (descr[i], d, c, s)
				if not d in self._blocks:
					self._blocks.append(d)
				else:
					absc = (names[i], descr[i])
		del mat

	def dynamicViscosity(self,T):
		if self.coolant == 'salt':
			eta = 0.001 * (22.714 - 0.120 * (T - 273.15) + 2.281e-4 * pow((T - 273.15),2) - 1.474e-7 * pow((T - 273.15),3))
		else:
			eta = np.exp(-6.4406 - 0.3958 * np.log(T) + 556.835/T)
		return eta

	def thermalConductivity(self,T):
		if self.coolant == 'salt':
			k = 0.443 + 1.9e-4 * (T - 273.15)
		else:
			k = 124.67 - 0.11381 * T + 5.5226e-5 * pow(T,2) - 1.1842e-8 * pow(T,3);
		return k;

	def specificHeatCapacityCp(self,T):
		if self.coolant == 'salt':
			C = 1396.0182 + 0.172 * T
		else:
			C = 1000 * (1.6582 - 8.4790e-4 * T + 4.4541e-7 * pow(T,2) - 2992.6 * pow(T,-2))
		return C

	def Temperature(self, m_flow, Tf, Tamb, CG, h_ext, k):
		# Flow and thermal variables
		"""
			hf: Heat transfer coefficient due to internal forced-convection
			mu: HTF dynamic viscosity (Pa-s)
			kf: HTF thermal conductivity (W/m-K)
			C:  HTF specific heat capacity (J/kg-K)
			Re: HTF Reynolds number
			Pr: HTF Prandtl number
			Nu: Nusselt number due to internal forced convection
		"""

		Tf,temp = np.meshgrid(np.ones(self.nt),Tf)
		Tf = Tf*temp

		# HTF thermo-physical properties
		mu = self.dynamicViscosity(Tf)                 # HTF dynamic viscosity (Pa-s)
		kf = self.thermalConductivity(Tf)              # HTF thermal conductivity (W/m-K)
		C = self.specificHeatCapacityCp(Tf)            # HTF specific heat capacity (J/kg-K)

		m_flow,temp = np.meshgrid(np.ones(self.nt), m_flow)
		m_flow = m_flow*temp

		Tamb,temp = np.meshgrid(np.ones(self.nt), Tamb)
		Tamb = Tamb*temp

		h_ext,temp = np.meshgrid(np.ones(self.nt), h_ext)
		h_ext = h_ext*temp

		# HTF internal flow variables
		Re = m_flow * self.d / (self.area * mu)    # HTF Reynolds number
		Pr = mu * C / kf                           # HTF Prandtl number

		if self.coolant == 'salt':
			Nu = 0.023 * pow(Re, 0.8) * pow(Pr, 0.4)
		else:
			Nu = 5.6 + 0.0165 * pow(Re*Pr, 0.85) * pow(Pr, 0.01);

		# HTF internal heat transfer coefficient
		if self.R_fouling==0:
			hf = Nu * kf / self.d
		else:
			hf = Nu * kf / self.d / (1. + Nu * kf / self.d * self.R_fouling)

		# Calculating heat flux at circumferential nodes
		cosinesm,fluxes = np.meshgrid(self.cosines,CG)
		qabs = fluxes*cosinesm 
		a = -((self.em*(self.kp + hf*self.ln*self.Ri)*self.Ro*self.sigma)/((self.kp + hf*self.ln*self.Ri)*self.Ro*(self.ab*qabs + self.em*self.sigma*pow(Tamb,4)) + hf*self.kp*self.Ri*Tf + (self.kp + hf*self.ln*self.Ri)*self.Ro*Tamb*(h_ext)))
		b = -((hf*self.kp*self.Ri + (self.kp + hf*self.ln*self.Ri)*self.Ro*(h_ext))/((self.kp + hf*self.ln*self.Ri)*self.Ro*(self.ab*qabs + self.em*self.sigma*pow(Tamb,4)) + hf*self.kp*self.Ri*Tf + (self.kp + hf*self.ln*self.Ri)*self.Ro*Tamb*(h_ext)))
		c1 = 9.*a*pow(b,2.) + np.sqrt(3.)*np.sqrt(-256.*pow(a,3.) + 27.*pow(a,2)*pow(b,4))
		c2 = (4.*pow(2./3.,1./3.))/pow(c1,1./3.) + pow(c1,1./3.)/(pow(2.,1./3.)*pow(3.,2./3.)*a)
		To = -0.5*np.sqrt(c2) + 0.5*np.sqrt((2.*b)/(a*np.sqrt(c2)) - c2)
		Ti = (To + hf*self.Ri*self.ln/self.kp*Tf)/(1 + hf*self.Ri*self.ln/self.kp)
		qnet = hf*(Ti - Tf)
		To = np.concatenate((np.flip(To[:,1:-1],axis=1),To),axis=1)
		Ti = np.concatenate((np.flip(Ti[:,1:-1],axis=1),Ti),axis=1)
		if k == -1:
			plt.plot(np.linspace(-np.pi,np.pi,2*self.nt-2), To[120,:])
			plt.show()
		Qnet = qnet.sum(axis=1)*self.Ri*self.dt*self.dz

		p0 = [1.0] * (1 + (self.n))
		# Fourier coefficients
		for t in range(Ti.shape[0]):
			# inside:
			popt1, pcov1 = scipy.optimize.curve_fit(fourierTheta, self.theta, Ti[t,:], p0)
			Tbar_i = popt1[0]; BP = popt1[1]; DP = popt1[2];
			# outside:
			popt2, pcov2 = scipy.optimize.curve_fit(fourierTheta, self.theta, To[t,:], p0)
			Tbar_o = popt2[0]; BPP = popt2[1]; DPP = popt2[2];

		return Qnet

if __name__=='__main__':
	tinit = time.time()

	model = receiver()

	# Importing data from Modelica
	fileName = '%s/solartherm/examples/GemasolarSystemOperation_res.mat'%(os.path.expanduser('~'))
	model.import_mat(fileName)
	times = model.data[:,0]
	CG = model.data[:,model._vars['heliostatField.CG[1]'][2]:model._vars['heliostatField.CG[450]'][2]+1]
	m_flow_tb = model.data[:,model._vars['receiver.m_flow_tb'][2]]
	Tamb = model.data[:,model._vars['receiver.Tamb'][2]]
	h_ext = model.data[:,model._vars['receiver.h_conv'][2]]

	Tf = model.T_in*np.ones((times.shape[0],model.nz+1))
	for k in range(model.nz):
		Qnet = model.Temperature(m_flow_tb, Tf[:,k], Tamb, CG[:,k], h_ext, k)
		C = model.specificHeatCapacityCp(Tf[:,k])*m_flow_tb
		Tf[:,k+1] = Tf[:,k] + np.divide(Qnet, C, out=np.zeros_like(C), where=C!=0)
	scipy.io.savemat('%s/solartherm/examples/st_nash_tube_stress_res.mat'%os.path.expanduser('~'),{
					"Tf_vs_nz":Tf,
					"CG":CG,
					"m_flow_tb":m_flow_tb
					})

	print('%s'%str((time.time() - tinit)/60))

