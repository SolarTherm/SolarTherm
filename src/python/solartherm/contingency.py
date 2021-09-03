from __future__ import division, print_function,unicode_literals

import numpy as np
import re
import solartherm.finances as fin
import matplotlib.pyplot as plt
from scipy import interpolate

class Contingency:

	def __init__(self, casedir, var_n_des=[], var_n_perf=[], var_n_cost=[]):

		self.casedir=casedir
		samplefile=self.casedir+'/sample.dat'
		self.var_n_des=var_n_des
		self.var_n_perf=var_n_perf
		self.var_n_cost=var_n_cost
		self.get_sample(samplefile)
		#exself.get_lcoe()
		#self.get_capital()
		#self.get_epy()
		self.plot_sensitivity()
		
	def get_sample(self, samplefile):
		try:
			with open(samplefile) as f:
				content= f.read().splitlines()
			f.close()	
		except:
			print("Simulation not finished (sample.dat not found)")

		self.num_sample=len(content)-1
		self.sample={}
		for i in range(1, self.num_sample+1):
			data=np.loadtxt(casedir+'/summary_report_%s.csv'%i, delimiter=',', dtype=str, skiprows=1)
			for l in data:
				if l[0] in self.sample.keys():
					self.sample[l[0]]=np.append(self.sample[l[0]], float(l[1]))
				else:
					self.sample[l[0]]=np.array([l[1]]).astype(float)

		self.epy=self.sample['epy'].astype(float) #MWh/year
		self.C_cap=self.sample['C_cap'].astype(float)-self.sample['C_contingency'].astype(float) #mUSD
		self.C_contingency=self.sample['C_contingency'].astype(float) # mUSD, the initially estimated contingency in the system model, e.g. ~10% capital
		self.OM_tot=self.sample['OM_total'].astype(float) #mUSD
		self.r_discount=self.sample['r_discount'].astype(float)
		self.t_life=self.sample['t_life'].astype(int)
		self.t_cons=self.sample['t_cons'].astype(int)

		# update LCOE to be 
		# LCOE without the pre-estimated contingency in the system model
		self.lcoe = fin.lcoe_r(
				c_cap=self.C_cap*1.e6, 
				c_year=self.OM_tot*1.e6, 
				r=self.r_discount, 
				t_life=self.t_life[0], 
				t_cons=self.t_cons[0], 
				epy=self.epy)

		self.var_v_des=[]
		self.var_v_perf=[]
		self.var_v_cost=[]		
		for n in self.var_n_des:
			if n in self.sample.keys():
				self.var_v_des.append(self.sample[n])
		for n in self.var_n_perf:
			if n in self.sample.keys():
				self.var_v_perf.append(self.sample[n])
		for n in self.var_n_cost:
			if n in self.sample.keys():
				self.var_v_cost.append(self.sample[n])	

	def get_lcoe(self):
		'''
		Get the statistics of lcoe
		'''
		n=len(self.lcoe)
		m=np.mean(self.lcoe)
		sd=np.sqrt(1/(n-1.)*np.sum((self.lcoe-m)**2))	
		lmin=np.min(self.lcoe)
		lmax=np.max(self.lcoe)

		print('')
		print("LCOE min", lmin)
		print("LCOE max", lmax)
		print("LCOE mean", m)
		print("LCOE sd", sd)

		plot_cdf(x=self.lcoe, num_bins=25, xlabel='LCOE (USD/MWh$\mathrm{_e}$)', color='green', savename=self.casedir+'/CDF_lcoe.png', base=112)

	def get_capital(self):
		'''
		Get the statistics of total captial cost (without contingency)
		'''
		n=len(self.C_cap)
		m=np.mean(self.C_cap)
		sd=np.sqrt(1/(n-1.)*np.sum((self.C_cap-m)**2))	
		lmin=np.min(self.C_cap)
		lmax=np.max(self.C_cap)

		print('')
		print("C_cap min", lmin)
		print("C_cap max", lmax)
		print("C_cap mean", m)
		print("C_cap sd", sd)

		plot_cdf(x=self.C_cap, num_bins=25, xlabel='Total capital cost (M$\cdot$USD)', color='blue', savename=self.casedir+'/CDF_capital.png')

	def get_epy(self):
		'''
		Get the statistics of the electricity production per year
		'''
		n=len(self.epy)
		m=np.mean(self.epy)
		sd=np.sqrt(1/(n-1.)*np.sum((self.epy-m)**2))	
		lmin=np.min(self.epy)
		lmax=np.max(self.epy)

		print('')
		print("epy min", lmin)
		print("epy max", lmax)
		print("epy mean", m)
		print("epy sd", sd)

		plot_cdf(x=self.epy, num_bins=25, xlabel='Energy production per year (MWh/year)', color='orange', savename=self.casedir+'/CDF_epy.png')


	def plot_sensitivity(self):
		'''
		Rank of impact
		'''
				
		names=self.var_n_perf+self.var_n_cost
		values=self.var_v_perf+self.var_v_cost
		num_par=len(names)
		
		# satandardise the parameters
		V_sd=np.array([])
		key=np.array([])
		for i in range(num_par):
			v=values[i]	
			mean=np.mean(v)
			n=float(len(v))
			sd=np.sqrt(1/(n-1.)*np.sum((v-mean)**2))
		
			v_sd=(v-mean)/sd
			V_sd=np.append(V_sd,v_sd)
			key=np.append(key, names[i])

		V_sd=V_sd.reshape(num_par, self.num_sample)
		V_sd=V_sd.T

		# get the regression coefficient
		from sklearn import linear_model
		regr = linear_model.LinearRegression()
		regr.fit(V_sd, self.lcoe)
		regr_coef=regr.coef_
		
		print('Intercept: \n', regr.intercept_)
		print('Coefficients: \n', regr.coef_)

		idx=abs(regr_coef).argsort()
		idx=idx[::-1]
		regr_coef=regr_coef[idx]
		key=key[idx] 

		# make the Legend on the figure
		#
		# TODO link variable name with the description and range in spreadsheet
		# a dictionary
		# key is the varable name
		# value is the description
		description={}
		ranges={}
		for k in key:
			description[k]=k
			ranges[k]='TBD..'		

		tks=np.array([])
		labels=np.array([])
		for k in key:
			tks=np.append(tks, description[k])
			labels=np.append(labels, ranges[k])


		# drawing the figure
		#
		base = 0.
		# The y position for each variable
		ys = range(len(regr_coef))[::-1]  # top to bottom

		fts=20
		plt.figure(figsize=(20,16))
		# Plot the bars, one by one
		i=0
		for y, value in zip(ys, regr_coef):
			# The width of the 'low' and 'high' pieces
			# Each bar is a "broken" horizontal bar chart
			plt.broken_barh(
				[(base, value)],
				(y - 0.4, 0.8),
				facecolors=['white', 'white'],  # Try different colors if you like
				edgecolors=['black', 'black'],
				linewidth=1,
			)

			# Display the value as text. It should be positioned in the center of
			# the 'high' bar, except if there isn't any room there, then it should be
			# next to bar instead.
			#x = base + value / 2
			if value>0:
				x=-1.8
			else:
				x=0.2
			#if x <= base + 50:
			#    x = base + high_width + 50
			plt.text(x, y, labels[i], va='center', ha='left',fontsize=fts-2)
			i+=1
		# Draw a vertical line down the middle
		plt.axvline(base, color='black')

		# Position the x-axis on the top, hide all the other spines (=axis lines)
		axes = plt.gca()  # (gca = get current axes)
		axes.spines['left'].set_visible(False)
		axes.spines['right'].set_visible(False)
		axes.spines['bottom'].set_visible(False)
		axes.xaxis.set_ticks_position('top')
		axes.set_xlabel("Standardised Regression Coefficient ($\\beta$)", fontsize=fts)
		axes.xaxis.set_label_position('top') 

		# Make the y-axis display the variables
		plt.yticks(ys, tks, fontsize=fts)
		plt.xticks(fontsize=fts)
		# Set the portion of the x- and y-axes to show
		#plt.xlim(base - 1000, base + 1000)
		#plt.ylim(-1, len(key))
		plt.savefig(open(self.casedir+'/sensitivity.png', 'wb'), dpi=300, bbox_inches='tight')
		#plt.show()
		plt.close()		


	def get_lcoe_contingency(self):
		'''
		Rate of contingency and likelihood of lcoe
		
		in development
		'''
		fn='.mat' #TODO the best case result .mat file
		mat = DyMat.DyMatFile(fn)
		eng_t = mat.abscissa('E_elec', valuesOnly=True) # Time [s]
		eng_v = mat.data('E_elec') # Cumulative electricity generated [J]
		cap_v = mat.data('C_cap') # Capital costs [$]
		om_y_v = mat.data('C_year') # O&M costs per year [$/year]
		om_p_v = mat.data('C_prod') # O&M costs per production per year [$/J/year]
		disc_v = mat.data('r_disc') # Discount rate [-]
		life_v = mat.data('t_life') # Plant lifetime [year]
		cons_v = mat.data('t_cons') # Construction time [year]
		dur = eng_t[-1] - eng_t[0] # Time duration [s]
		epy = fin.energy_per_year(dur, eng_v[-1]) # Energy expected in a year [J]
		lcoe = fin.lcoe_r(cap_v[0], om_y_v[0] + om_p_v[0]*epy, disc_v[0],
							int(life_v[0]), int(cons_v[0]), epy)

		C_equipment=mat.data('C_cap_total')[0]# total equipment cost
		C_land=mat.data('C_land')[0]
		r_cons=mat.data('r_cons')[0]
		r_contingency=mat.data('r_contg')[0]
		C_direct = (1 + r_contingency) * C_equipment
		C_indirect = r_cons * C_direct + C_land
		C_cap = C_direct + C_indirect # total captical cost
		C_contingency=C_direct-C_equipment


		if target_lcoe!=None:
			likelihood=f_lcoe1(target_lcoe) 
		elif likelihood!=None:	
			target_lcoe=f_lcoe2(likelihood)

		print('')
		print('Target LCOE ', target_lcoe, ',with likelihood ', likelihood)

		lcoe=0.

		i=0
		r_contingency=0.
		#while abs(lcoe-target_lcoe)>1e-2 and r_contingency<=1: 
		while abs(lcoe-target_lcoe)>1e-2: 
			#print target_lcoe, lcoe, c_cap/1e6, r_contingency, f_contg(c_cap/1e6)
			lcoe=finances.lcoe_r(capital*1e6+C_equipment*r_contingency, om_y_v[0] + om_p_v[0]*epy, disc_v[0],
							int(life_v[0]), int(cons_v[0]), epy)
			lcoe=lcoe*1e6*3600.
			r_contingency+=0.000001

		print('')		
		print('r_contingency,', r_contingency)
		#print 'Capital prob,', c_cap/1e6, f_contg(c_cap/1e6)

		return r_contingency




def plot_cdf(x, num_bins, xlabel, color, savename, base=None):
	'''
	x: numpy array, the data sample to be plotted
	num_bins: int, number of bins of the histogram
	xlabel: str, x label on the plot
	color: str, color of the histogram
	savename: str, directory and name of the figure to be saved
	base: float, a specific value that is plotted on the figure to observe the probability
		  or None, if no value is specified
	'''

	xmin=np.min(x)
	xmax=np.max(x)
	bins=np.linspace(xmin, xmax, num_bins)	
	hist, edges=np.histogram(x, bins)
	cdf=np.cumsum(hist)/float(np.sum(hist))

	dx=bins[1]-bins[0]
	xs=np.linspace(xmin+dx/2., xmax-dx/2., num_bins-1)
	
	fts=20
	fig, ax1=plt.subplots()
	ax2=ax1.twinx()
	ax1.hist(x, bins, color=color)
	ax2.plot(xs, cdf, 'r')
	
	print('')
	print('CDF', xlabel)
	if base!=None:
		# plot the probability of a specified value	
		f=interpolate.interp1d(xs, cdf)
		p_base=f(base)
		print('Base value  :', base)
		print(' Probability:', p_base )

		# the vertical dash line
		vx=np.ones(100)*base
		vy=np.linspace(0., p_base, 100) 
		# the horizontal dash line
		hx=np.linspace(base, xmax, 100)
		hy=np.ones(100)*p_base

		ax2.plot(vx, vy, 'r--')
		ax2.plot(hx, hy, 'r--')

	# report p30, p50, p90	
	f1=interpolate.interp1d(cdf, xs)
	p30=f1(0.3)
	p50=f1(0.5)
	p90=f1(0.9)	
	print('P30', p30)
	print('p50', p50)
	print('p90', p90)
			
	ax1.tick_params(labelsize=fts)
	ax2.tick_params(labelsize=fts)
	ax1.set_xlabel(str(xlabel), fontsize=fts)
	ax1.set_xlim([xmin,xmax])
	ax1.set_ylim([0,max(hist)])
	ax1.set_ylabel('Frequency', fontsize=fts)
	ax2.set_ylabel('CDF', fontsize=fts)
	plt.savefig(open(savename, 'wb'), dpi=200, bbox_inches='tight')
	plt.close()				


if __name__=="__main__":
	casedir="../../../examples/demo_sensitivity"
	ct=Contingency(casedir, var_n_des=[], var_n_perf=['eff_blk', 'he_av_design', 'ab_rec', 'rec_fr'], var_n_cost=[])
