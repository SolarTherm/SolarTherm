import numpy as np
import matplotlib.pyplot as plt
import scipy
import DyMat
import os
import time

# Thermal and transport properties of nitrate salt and sodium (verified)
# Nitrate salt:
#   ZAVOICO, Alexis B. Solar power tower design basis document, revision 0; Topical. Sandia National Labs., 2001.
# Liquid sodium:
#   FINK, J. K.; LEIBOWITZ, L. Thermodynamic and transport properties of sodium liquid and vapor. Argonne National Lab., 1995.

def dynamicViscosity(T, coolant):
	if coolant == 'salt':
		eta = 0.001 * (22.714 - 0.120 * (T - 273.15) + 2.281e-4 * pow((T - 273.15),2) - 1.474e-7 * pow((T - 273.15),3))
	else:
		eta = np.exp(-6.4406 - 0.3958 * np.log(T) + 556.835/T)
	return eta

def thermalConductivity(T, coolant):
	if coolant == 'salt':
		k = 0.443 + 1.9e-4 * (T - 273.15)
	else:
		k = 124.67 - 0.11381 * T + 5.5226e-5 * pow(T,2) - 1.1842e-8 * pow(T,3);
	return k;

def specificHeatCapacityCp(T, coolant):
	if coolant == 'salt':
		C = 1396.0182 + 0.172 * T
	else:
		C = 1000 * (1.6582 - 8.4790e-4 * T + 4.4541e-7 * pow(T,2) - 2992.6 * pow(T,-2))
	return C

def Temperature(coolant, Ri, Ro, m_flow, Tf, Tamb, CG, nt, R_fouling, ab, em, kp, h_ext, debug=False):
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
	ln = np.log(Ro/Ri)                 # Log of Ro/Ri simplification
	sigma = 5.670374419e-8

	# Discretisation parameters
	dt = np.pi/(nt-1)

	# Tube section diameter and area
	d = 2.*Ri                       # Tube inner diameter (m)
	area = 0.25 * np.pi * pow(d,2.)    # Tube flow area (m2)

	Tf,temp = np.meshgrid(np.ones(nt),Tf)
	Tf = Tf*temp

	# HTF thermo-physical properties
	mu = dynamicViscosity(Tf, coolant)        # HTF dynamic viscosity (Pa-s)
	kf = thermalConductivity(Tf, coolant)     # HTF thermal conductivity (W/m-K)
	C = specificHeatCapacityCp(Tf, coolant)   # HTF specific heat capacity (J/kg-K)

	m_flow,temp = np.meshgrid(np.ones(nt),m_flow)
	m_flow = m_flow*temp

	# HTF internal flow variables
	Re = m_flow * d / (area * mu)    # HTF Reynolds number
	Pr = mu * C / kf                 # HTF Prandtl number

	if coolant == 'salt':
		Nu = 0.023 * pow(Re, 0.8) * pow(Pr, 0.4)
	else:
		Nu = 5.6 + 0.0165 * pow(Re*Pr, 0.85) * pow(Pr, 0.01);

	# HTF internal heat transfer coefficient
	if R_fouling==0:
		hf = Nu * kf / d
	else:
		hf = Nu * kf / d / (1. + Nu * kf / d * R_fouling)

	# Calculating heat flux at circumferential nodes
	cosines = np.cos(np.linspace(0.0, np.pi, nt))
	cosinesm,fluxes = np.meshgrid(np.maximum(cosines,np.zeros(nt)),CG)
	qabs = fluxes*cosinesm
	#qabs = CG*np.maximum(cosines,np.zeros(nt))
	a = -((em*(kp + hf*ln*Ri)*Ro*sigma)/((kp + hf*ln*Ri)*Ro*(ab*qabs + em*sigma*pow(Tamb,4)) + hf*kp*Ri*Tf + (kp + hf*ln*Ri)*Ro*Tamb*(h_ext)))
	b = -((hf*kp*Ri + (kp + hf*ln*Ri)*Ro*(h_ext))/((kp + hf*ln*Ri)*Ro*(ab*qabs + em*sigma*pow(Tamb,4)) + hf*kp*Ri*Tf + (kp + hf*ln*Ri)*Ro*Tamb*(h_ext)))
	c1 = 9.*a*pow(b,2.) + np.sqrt(3.)*np.sqrt(-256.*pow(a,3.) + 27.*pow(a,2)*pow(b,4))
	c2 = (4.*pow(2./3.,1./3.))/pow(c1,1./3.) + pow(c1,1./3.)/(pow(2.,1./3.)*pow(3.,2./3.)*a)
	To = -0.5*np.sqrt(c2) + 0.5*np.sqrt((2.*b)/(a*np.sqrt(c2)) - c2)
	Ti = (To + hf*Ri*ln/kp*Tf)/(1 + hf*Ri*ln/kp)
	qnet = hf*(Ti - Tf)
	qnet = np.concatenate((np.flip(qnet[:,1:-1],axis=1),qnet),axis=1)
	Qnet = qnet.sum(axis=1)*Ri*dt
	scipy.io.savemat('st_nash_tube_stress.mat',{
					"mu":mu,
					"Re":Re,
					"Pr":Pr,
					"Tf":Tf,
					"m_flow":m_flow,
					"fluxes":fluxes,
					"cosines":cosinesm,
					"qabs":qabs,
					"To":To,
					"Ti":Ti,
					"qnet":qnet,
					"Qnet":Qnet
					})

	# Debug
	if debug:
		temp = 15
		fig, axes = plt.subplots(2,2,figsize=(11,8))
		axes[0,0].plot(np.linspace(-np.pi, np.pi, 2*nt-2),np.transpose(qnet[temp,:]),label='qnet[%s]'%temp)
		axes[0,0].legend(loc='best', frameon=False)
		axes[0,1].plot(np.linspace(0, np.pi, nt),np.transpose(qabs[temp,:]),label='qabs[%s]'%temp)
		axes[0,1].legend(loc='best', frameon=False)
		axes[1,0].plot(np.linspace(0, np.pi, nt),np.transpose(To[temp,:]-273.15),label='To[%s]'%temp)
		axes[1,0].plot(np.linspace(0, np.pi, nt),np.transpose(Ti[temp,:]-273.15),label='Ti[%s]'%temp)
		axes[1,0].legend(loc='best', frameon=False)
		axes[1,1].plot(Qnet, label='Qnet')
		axes[1,1].legend(loc='best', frameon=False)
		plt.show()

	return Qnet

if __name__=='__main__':
	tinit = time.time()
	coolant = 'salt'
	Ri = 57.93/2000
	Ro = 60.33/2000
	m_flow = 4.20
	T_in = 290+273.15
	T_out = 565+273.15
	Tamb = 25+273.15
	CG = 0.2e6
	nz = 450
	nt = 91
	R_fouling = 0.0
	ab = 0.94
	em = 0.88
	kp = 21.0
	h_ext = 30.0

	# Importing data from Modelica
	folder = os.path.expanduser('~')
	momat = scipy.io.loadmat('%s/solartherm/examples/FlowPathStressSalt_res.mat'%folder)
	modata = np.transpose(momat['data_2'][0:nz+1,:])
	times = modata[:,0]
	CG = modata[:,1:nz+1]
	del modata
	data = DyMat.DyMatFile('%s/solartherm/examples/FlowPathStressSalt_res.mat'%folder)
	m_flow_tb = data.data('m_flow_tb')
	del data
#	fig, axes = plt.subplots(1,1)
#	axes.plot(CG[:,0])
#	axes.plot(CG[:,10])
#	plt.show()

	Tf = T_in*np.ones((times.shape[0],nz+1))
	for k in range(nz):
		Qnet = Temperature(coolant, Ri, Ro, m_flow_tb, Tf[:,k], Tamb, CG[:,k], nt, R_fouling, ab, em, kp, h_ext,debug=False)
		C = specificHeatCapacityCp(Tf[:,k], coolant)*m_flow_tb
		Tf[:,k+1] = Tf[:,k] + np.divide(Qnet,C,out=np.zeros_like(C), where=C!=0)
	scipy.io.savemat('st_nash_tube_stress_vs_nz.mat',{
					"Tf_vs_nz":Tf,
					"CG":CG,
					"m_flow_tb":m_flow_tb
					})

	print('%s'%str((time.time() - tinit)/60))

