import numpy as np
import matplotlib.pyplot as plt
import os, sys, math, scipy.io
import time, ctypes, argparse
from numpy.ctypeslib import ndpointer
from neml import uniaxial, block
from srlife import receiver, solverparams, library, thermal, structural, system, damage, managers
from tqdm import tqdm

# Thermal and transport properties of nitrate salt and sodium (verified)
# Nitrate salt:
#   ZAVOICO, Alexis B. Solar power tower design basis document, revision 0; Topical. Sandia National Labs., 2001.
# Liquid sodium:
#   FINK, J. K.; LEIBOWITZ, L. Thermodynamic and transport properties of sodium liquid and vapor. Argonne National Lab., 1995.

strMatNormal = lambda a: [''.join(s).rstrip() for s in a]
strMatTrans  = lambda a: [''.join(s).rstrip() for s in zip(*a)]
sign = lambda x: math.copysign(1.0, x)

class receiver_cyl:
	def __init__(self,coolant = 'salt', Ri = 57.93/2000, Ro = 60.33/2000, T_in = 290, T_out = 565,
                      nz = 450, nt = 46, R_fouling = 0.0, ab = 0.94, em = 0.88, kp = 16.57, H_rec = 10.5, D_rec = 8.5,
                      nbins = 50, alpha = 15.6e-6, Young = 186e9, poisson = 0.31,
                      debugfolder = os.path.expanduser('~'), debug = False, verification = False):
		self.coolant = coolant
		self.Ri = Ri
		self.Ro = Ro
		self.thickness = Ro - Ri
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
		self.nbins=nbins
		self.debugfolder = debugfolder
		self.debug = debug
		self.verification = verification
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
		self.l = alpha
		self.E = Young
		self.nu = poisson
		l = self.E*self.nu/((1+self.nu)*(1-2*self.nu));
		m = 0.5*self.E/(1+self.nu);
		props = l*np.ones((3,3)) + 2*m*np.identity(3)
		self.invprops = np.linalg.inv(props)
		# Loading dynamic library
		so_file = "%s/solartherm/SolarTherm/Resources/Include/stress/stress.so"%os.path.expanduser('~')
		stress = ctypes.CDLL(so_file)
		self.fun = stress.curve_fit
		self.fun.argtypes = [ctypes.c_int,
						ctypes.c_double,
						ndpointer(ctypes.c_double, flags="C_CONTIGUOUS"),
						ndpointer(ctypes.c_double, flags="C_CONTIGUOUS")]

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

	def density(self,T):
		if self.coolant == 'salt':
			d = 2090.0 - 0.636 * (T - 273.15)
		else:
			d = 219.0 + 275.32 * (1.0 - T / 2503.7) + 511.58 * np.sqrt(1.0 - T / 2503.7)
		return d

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

	def htfs(self, v_flow, Tf):
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

		# HTF thermo-physical properties
		mu = self.dynamicViscosity(Tf)                 # HTF dynamic viscosity (Pa-s)
		kf = self.thermalConductivity(Tf)              # HTF thermal conductivity (W/m-K)
		C = self.specificHeatCapacityCp(Tf)            # HTF specific heat capacity (J/kg-K)
		rho = self.density(Tf)                         # HTF specific heat capacity (J/kg-K)

		# HTF internal flow variables
		Re = rho * v_flow * self.d/ mu                 # HTF Reynolds number
		Pr = mu * C / kf                               # HTF Prandtl number

		if self.coolant == 'salt':
			Nu = 0.023 * pow(Re, 0.8) * pow(Pr, 0.4)
		else:
			Nu = 5.6 + 0.0165 * pow(Re*Pr, 0.85) * pow(Pr, 0.01);

		# HTF internal heat transfer coefficient
		if self.R_fouling==0:
			hf = Nu * kf / self.d
		else:
			hf = Nu * kf / self.d / (1. + Nu * kf / self.d * self.R_fouling)

		return hf

	def Temperature(self, m_flow, Tf, Tamb, CG, h_ext):
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
		Qnet = qnet.sum(axis=1)*self.Ri*self.dt*self.dz
		net_zero = np.where(Qnet<0)[0]
		Qnet[net_zero] = 0.0
		_qnet = np.concatenate((qnet[:,1:],qnet[:,::-1]),axis=1)
		_qnet[net_zero,:] = 0.0
		self.qnet = _qnet

		for t in range(Ti.shape[0]):
			BDp = self.Fourier(Ti[t,:])

		# Fourier coefficients
		#self.s, self.e = self.stress(Ti,To)
		self.s, self.e = self.StressStrain3D(Ti,To)
		self.Tcrown = To[:,0]
		return Qnet

	def Fourier(self,T):
		coefs = np.empty(21)
		self.fun(self.nt, self.dt, T, coefs)
		return coefs

	def StressStrain3D(self, Ti, To):
		stress = np.zeros((Ti.shape[0],3,3))
		strain = np.zeros((Ti.shape[0],3,3))
		for t in range(Ti.shape[0]):
			BDp = self.Fourier(Ti[t,:])
			BDpp = self.Fourier(To[t,:])
			stress[t,:,:], strain[t,:,:] = self.arrayThermoelastic(To[t,0], self.Ro, 0., BDp, BDpp)
		return stress,strain

	def arrayThermoelastic(self, T, r, theta, BDp, BDpp):
		Tbar_i = BDp[0]; BP = BDp[1]; DP = BDp[2];
		Tbar_o = BDpp[0]; BPP = BDpp[1]; DPP = BDpp[2];
		a = self.Ri; b = self.Ro; a2 = a*a; b2 = b*b; r2 = r*r; r4 = pow(r,4);
		C = self.l*self.E/(2.*(1. - self.nu));
		D = 1./(2.*(1. + self.nu));
		kappa = (Tbar_i - Tbar_o)/np.log(b/a);
		kappa_theta = r*a*b/(b2 - a2)*((BP*b - BPP*a)/(b2 + a2)*np.cos(theta) + (DP*b - DPP*a)/(b2 + a2)*np.sin(theta));
		kappa_tau   = r*a*b/(b2 - a2)*((BP*b - BPP*a)/(b2 + a2)*np.sin(theta) - (DP*b - DPP*a)/(b2 + a2)*np.cos(theta));
		T_theta = T - ((Tbar_i - Tbar_o) * np.log(b/r)/np.log(b/a)) - Tbar_o;
		Qr = kappa*C*(0 -np.log(b/r) -a2/(b2 - a2)*(1 -b2/r2)*np.log(b/a) ) \
					+ kappa_theta*C*(1 - a2/r2)*(1 - b2/r2);
		Qtheta = kappa*C*(1 -np.log(b/r) -a2/(b2 - a2)*(1 +b2/r2)*np.log(b/a) ) \
					+ kappa_theta*C*(3 -(a2 +b2)/r2 -a2*b2/r4);
		Qz = kappa*self.nu*C*(1 -2*np.log(b/r) -2*a2/(b2 - a2)*np.log(b/a) ) \
					+ kappa_theta*2*self.nu*C*(2 -(a2 + b2)/r2) -self.l*self.E*T_theta;
		Qrtheta = kappa_tau*C*(1 -a2/r2)*(1 -b2/r2);
		s = np.zeros((3,3))
		e = np.zeros((3,3))
		# Thermoelastic stress
		s[0,0] = Qr
		s[1,1] = Qtheta
		s[2,2] = Qz
		# Mechanical elastic strain
		e[0,0] = 1/self.E*(Qr - self.nu*(Qtheta + Qz))
		e[1,1] = 1/self.E*(Qtheta - self.nu*(Qr + Qz))
		return s,e

	def stress(self, Ti, To):
		stress = np.zeros(Ti.shape[0])
		strain = np.zeros(Ti.shape[0])
		for t in range(Ti.shape[0]):
			BDp = self.Fourier(Ti[t,:])
			BDpp = self.Fourier(To[t,:])
			stress[t], strain[t] = self.Thermoelastic(To[t,0], self.Ro, 0., BDp, BDpp)
		stress = np.array(stress)
		strain = np.array(strain)
		return stress,strain

	def Thermoelastic(self, T, r, theta, BDp, BDpp):
		Tbar_i = BDp[0]; BP = BDp[1]; DP = BDp[2];
		Tbar_o = BDpp[0]; BPP = BDpp[1]; DPP = BDpp[2];
		a = self.Ri; b = self.Ro; a2 = a*a; b2 = b*b; r2 = r*r; r4 = pow(r,4);

		C = self.l*self.E/(2.*(1. - self.nu));
		D = 1./(2.*(1. + self.nu));
		kappa = (Tbar_i - Tbar_o)/np.log(b/a);
		kappa_theta = r*a*b/(b2 - a2)*((BP*b - BPP*a)/(b2 + a2)*np.cos(theta) + (DP*b - DPP*a)/(b2 + a2)*np.sin(theta));
		kappa_tau   = r*a*b/(b2 - a2)*((BP*b - BPP*a)/(b2 + a2)*np.sin(theta) - (DP*b - DPP*a)/(b2 + a2)*np.cos(theta));

		T_theta = T - ((Tbar_i - Tbar_o) * np.log(b/r)/np.log(b/a)) - Tbar_o;

		Qr = kappa*C*(0 -np.log(b/r) -a2/(b2 - a2)*(1 -b2/r2)*np.log(b/a) ) \
					+ kappa_theta*C*(1 - a2/r2)*(1 - b2/r2);
		Qtheta = kappa*C*(1 -np.log(b/r) -a2/(b2 - a2)*(1 +b2/r2)*np.log(b/a) ) \
					+ kappa_theta*C*(3 -(a2 +b2)/r2 -a2*b2/r4);
		Qz = kappa*self.nu*C*(1 -2*np.log(b/r) -2*a2/(b2 - a2)*np.log(b/a) ) \
					+ kappa_theta*2*self.nu*C*(2 -(a2 + b2)/r2) -self.l*self.E*T_theta;
		Qrtheta = kappa_tau*C*(1 -a2/r2)*(1 -b2/r2);

		Q_Eq = np.sqrt(0.5*(pow(Qr -Qtheta,2) + pow(Qr -Qz,2) + pow(Qz -Qtheta,2)) + 6*pow(Qrtheta,2));
		Q = np.zeros(3)
		Q[0] = Qr; Q[1] = Qtheta; Q[2] = Qz;
		#e = np.dot(self.invprops, Q)
		e = np.zeros(3)
		e[0] = 1/self.E*(Qr - self.nu*(Qtheta + Qz))
		e[1] = 1/self.E*(Qtheta - self.nu*(Qr + Qz))
		e_Eq = np.sqrt(2.)*D*np.sqrt(pow(e[0] - e[1],2) + pow(e[0] - e[2],2) + pow(e[2] - e[1],2));

		if self.verification:
			print("=============== NPS Sch. 5S 1\" S31609 at 450degC ===============")
			print("Biharmonic coefficients:")
			print("Tbar_i [K]:      749.6892       %4.4f"%Tbar_i)
			print("  B'_1 [K]:      45.1191        %4.4f"%BP)
			print("  D'_1 [K]:      -0.0000        %4.4f"%DP)
			print("Tbar_o [K]:      769.7119       %4.4f"%Tbar_o)
			print(" B''_1 [K]:      79.4518        %4.4f"%BPP)
			print(" D''_1 [K]:      0.0000         %4.4f\n"%DPP)
			print("Stress at outside tube crown:")
			print("Q_r [MPa]:       0.0000         %4.4f"%(Qr/1e6))
			print("Q_rTheta [MPa]:  0.0000         %4.4f"%(Qrtheta/1e6))
			print("Q_theta [MPa]:  -101.0056       %4.4f"%(Qtheta/1e6))
			print("Q_z [MPa]:      -389.5197       %4.4f"%(Qz/1e6))
			print("Q_Eq [MPa]:      350.1201       %4.4f"%(Q_Eq/1e6))

		return Q_Eq,e_Eq
		#return Q,e

def uniaxial_neml(strain, stress, Tcrown, times):
	deformation_mat = library.load_deformation("A230", "base")
	neml_model = deformation_mat.get_neml_model()
	umodel = uniaxial.UniaxialModel(neml_model, verbose = False)

	hn = umodel.init_store()
	en = strain[0]; sn = stress[0]; Tn = Tcrown[0]; tn = times[0]
	un = 0.0; pn = 0.0;
	es = [en]; ss = [sn]

	for enp1, Tnp1, tnp1 in zip(strain[1:],Tcrown[1:],times[1:]):
		snp1, hnp1, Anp1, unp1, pnp1 = umodel.update(enp1, en, Tnp1, Tn, tnp1, tn, sn, hn, un, pn)
		es.append(enp1)
		ss.append(snp1)

		sn = snp1
		hn = np.copy(hnp1)
		en = enp1
		Tn = Tnp1
		tn = tnp1
		un = unp1
		pn = pnp1

	return es, ss

def blockEvaluate(strain, stress, Tcrown, times):
	deformation_mat = library.load_deformation("A230", "base")
	neml_model = deformation_mat.get_neml_model()

	e_np1 = np.zeros((1,3,3))
	e_n = np.zeros((1,3,3))
	T_np1 = np.zeros((1,))
	T_n = np.zeros((1,))
	T_n[0] = Tcrown[0]
	s_np1 = np.zeros((1,3,3))
	s_n = np.zeros((1,3,3))
	t_np1 = times[1]
	t_n = times[0]
	h_np1 = np.zeros((1, neml_model.nstore))
	h_n = np.zeros((1, neml_model.nstore))
	A_np1 = np.zeros((1,3,3,3,3))
	u_np1 = np.zeros((1,))
	u_n = np.zeros((1,))
	p_np1 = np.zeros((1,))
	p_n = np.zeros((1,))
	v_m = np.zeros((times.shape[0],10))

	for i,tnp1 in enumerate(times[1:]):
		e_np1[0,:,:] = strain[i+1,:,:]
		T_np1[0] = Tcrown[i+1]
		t_np1 = tnp1
		block.block_evaluate(
			neml_model,
			e_np1, e_n, 
			T_np1, T_n, 
			t_np1, t_n, 
			s_np1, s_n, 
			h_np1, h_n,
			A_np1, 
			u_np1, u_n, 
			p_np1, p_n)

		vm = np.sqrt(0.5*(pow(s_np1[0,0,0] -s_np1[0,1,1],2) \
			+ pow(s_np1[0,0,0] -s_np1[0,2,2],2) \
			+ pow(s_np1[0,1,1] -s_np1[0,2,2],2))
			)
		v_m[i+1,0:9] = s_np1[0,:,:].reshape((9,))
		v_m[i+1,9] = vm

		s_n = np.copy(s_np1)
		h_n = np.copy(h_np1)
		e_n = np.copy(e_np1)
		T_n = np.copy(T_np1)
		t_n = np.copy(t_np1)
		u_n = np.copy(u_np1)
		p_n = np.copy(p_np1)

	return v_m

def run_gemasolar(panel,position,days,clearSky):
	# Instantiating receiver model
	model = receiver_cyl(Ri = 20.0/2000, Ro = 22.4/2000)

	# Importing data from Modelica
	fileName = '%s/solartherm/examples/GemasolarSystemOperationCS_res.mat'%(os.path.expanduser('~'))
	model.import_mat(fileName)
	times = model.data[:,0]

	# Filtering times
	index = []
	_times = []
	time_lb = days[0]*86400
	time_ub = days[1]*86400+3600
	for i in range(len(times)):
		if times[i]%1800.==0 and times[i] not in _times and time_lb<=times[i] and times[i]<time_ub:
			index.append(i)
			_times.append(times[i])

	# Importing flux
	CG = model.data[:,model._vars['heliostatField.CG[1]'][2]:model._vars['heliostatField.CG[450]'][2]+1]
	m_flow_tb = model.data[:,model._vars['heliostatField.m_flow_tb'][2]]
	Tamb = model.data[:,model._vars['receiver.Tamb'][2]]
	h_ext = model.data[:,model._vars['receiver.h_conv'][2]]

	# Getting inputs based on filtered times
	times = times[index]/3600.
	times = times.flatten()
	CG = CG[index,:]
	m_flow_tb = m_flow_tb[index]
	Tamb = Tamb[index]
	h_ext = h_ext[index]

	stress = np.zeros((times.shape[0],model.nz,3,3))
	Tf = model.T_in*np.ones((times.shape[0],model.nz+1))
	strain = np.zeros((times.shape[0],model.nz,3,3))
	Tcrown = np.zeros((times.shape[0],model.nz))

	for k in tqdm(range(model.nz)):
		Qnet = model.Temperature(m_flow_tb, Tf[:,k], Tamb, CG[:,k], h_ext)
		C = model.specificHeatCapacityCp(Tf[:,k])*m_flow_tb
		Tf[:,k+1] = Tf[:,k] + np.divide(Qnet, C, out=np.zeros_like(C), where=C!=0)
		stress[:,k,:,:] = model.s/1e6
		Tcrown[:,k] = model.Tcrown
		strain[:,k,:,:] = model.e
		Tcrown[:,k] = model.Tcrown

	lb = model.nbins*(panel-1) + int(position)
	#es, ss = uniaxial_neml(strain[:,lb], stress[:,lb], Tcrown[:,lb], times)
	vm_block = blockEvaluate(strain[:,lb,:,:], stress[:,lb,:,:], Tcrown[:,lb], times)
	np.savetxt('vm_block.csv',vm_block,delimiter=',')

	scipy.io.savemat('results.mat',{
					"Tf_vs_nz":Tf,
					"CG":CG,
					"m_flow_tb":m_flow_tb
					})

	vm = np.sqrt(0.5*(pow(stress[:,lb,0,0] -stress[:,lb,1,1],2) \
		+ pow(stress[:,lb,0,0] -stress[:,lb,2,2],2) \
		+ pow(stress[:,lb,1,1] -stress[:,lb,2,2],2))
		)
	fig, axes = plt.subplots(2,2, figsize=(11,8))
	# HTF temperature at several locations
	axes[0,0].plot(times,Tf[:,lb])
	axes[0,0].set_ylabel('HTF temperature (K)')
	axes[0,0].set_xlabel('Time [h]')
	# Mass flow rate
	axes[0,1].plot(times,m_flow_tb)
	axes[0,1].set_ylabel('Mass flow rate (kg/s)')
	axes[0,1].set_xlabel('Time [h]')
	# Concentrated solar fluxes
	axes[1,0].plot(times,CG[:,lb])
	axes[1,0].set_ylabel('CG (W/m2)')
	axes[1,0].set_xlabel('Time [h]')
	# Equivalent stress
	axes[1,1].plot(times,vm)
	axes[1,1].set_ylabel('Equivalent stress [MPa]')
	axes[1,1].set_xlabel('Time [h]')
	# Show
	plt.savefig('results.png')

#	fig, axes = plt.subplots()
#	axes.plot(es, ss, 'r-')
#	axes.set_ylabel('Stress [MPa]')
#	axes.set_xlabel('Strain [mm/mm]')
#	plt.savefig('uniaxial_neml.png')

def run_verification():
	model = receiver(Ri = 30.098/2e3, Ro = 33.4/2e3, T_in = 290, T_out = 565, nz = 450, nt = 91,
                     R_fouling = 0.0, ab = 0.968, em = 0.870, kp = 21.0, H_rec = 10.5, D_rec = 8.5,
                     nbins = 50, alpha = 20e-6, Young = 165e9, poisson = 0.31, verification = True)

	# Importing data from Modelica
	m_flow_tb = 5.
	CG = 0.85e6
	h_ext = 30.
	Tamb = 293.15
	Tf = 723.15
	Qnet = model.Temperature(m_flow_tb, Tf, Tamb, CG, h_ext)

if __name__=='__main__':
	parser = argparse.ArgumentParser(description='Estimates average damage of a representative tube in a receiver panel')
	parser.add_argument('--panel', type=int, default=1, help='Panel to be simulated. Default=1')
	parser.add_argument('--position', type=float, default=1, help='Panel position to be simulated. Default=1')
	parser.add_argument('--days', nargs=2, type=int, default=[0,1], help='domain of days to simulate')
	parser.add_argument('--clearSky', type=bool, default=False, help='Run clear sky DNI (requires to have the solartherm results)')
	args = parser.parse_args()

	tinit = time.time()
	run_gemasolar(args.panel,args.position,args.days,args.clearSky)
	#run_verification()
	seconds = time.time() - tinit
	m, s = divmod(seconds, 60)
	h, m = divmod(m, 60)
	print('Simulation time: {:d}:{:02d}:{:02d}'.format(int(h), int(m), int(s)))

