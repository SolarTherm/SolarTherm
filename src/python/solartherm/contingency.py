from __future__ import division, print_function,unicode_literals

import numpy as np
import re
import solartherm.finances as fin
import matplotlib.pyplot as plt
from scipy import interpolate
import DyMat

class Contingency:

	def __init__(self, casedir, var_n_des=[], var_n_perf=[], var_n_cost=[]):

		self.casedir=casedir
		samplefile=self.casedir+'/sample.dat'
		self.var_n_des=var_n_des
		self.var_n_perf=var_n_perf
		self.var_n_cost=var_n_cost
		self.get_sample(samplefile)
		self.get_lcoe_contingency(fn=self.casedir+'/Reference_2_res_3.mat', target_lcoe=None, likelihood=0.7)
		self.plot_sensitivity()
		self.plot_cdfs()
		
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

	
	def get_cdf(self, x, num_bins, name, unit, plot=True, savename=None, color='b', base=None):
		'''
		x: numpy array, the data sample to be analysed/plotted
		num_bins: int, number of bins of the histogram
		xlabel: str, x label on the plot
		color: str, color of the histogram
		savename: str, directory and name of the figure to be saved
		base: float, a specific value that is plotted on the figure to observe the probability
			  or None, if no value is specified
		'''

		n=len(x)
		m=np.mean(x)
		sd=np.sqrt(1/(n-1.)*np.sum((x-m)**2))	
		xmin=np.min(x)
		xmax=np.max(x)
		
		print('')
		print(name)
		print("min", xmin, unit)
		print("max", xmax, unit)
		print("mean", m, unit)
		print("sd", sd, unit)

		bins=np.linspace(xmin, xmax, num_bins)	
		hist, edges=np.histogram(x, bins)
		cdf=np.cumsum(hist)/float(np.sum(hist))

		dx=bins[1]-bins[0]
		xs=np.linspace(xmin+dx/2., xmax-dx/2., num_bins-1)
		
		f_cdf=interpolate.interp1d(xs, cdf)
		# report p30, p50, p90	
		f_xs=interpolate.interp1d(cdf, xs)
		p30=f_xs(0.3)
		p50=f_xs(0.5)
		p90=f_xs(0.9)	
		print('P30', p30, unit)
		print('p50', p50, unit)
		print('p90', p90, unit)		
		
		if plot:
			fts=20
			fig, ax1=plt.subplots()
			ax2=ax1.twinx()
			ax1.hist(x, bins, color=color)
			ax2.plot(xs, cdf, 'r')
			
			print('')
			if base!=None:
				# plot the probability of a specified value	
				p_base=f_cdf(base)
				print(' Base value', base, unit)
				print(' Probability:', p_base)

				# the vertical dash line
				vx=np.ones(100)*base
				vy=np.linspace(0., p_base, 100) 
				# the horizontal dash line
				hx=np.linspace(base, xmax, 100)
				hy=np.ones(100)*p_base

				ax2.plot(vx, vy, 'r--')
				ax2.plot(hx, hy, 'r--')
					
			ax1.tick_params(labelsize=fts)
			ax2.tick_params(labelsize=fts)
			ax1.set_xlabel(str(name+' '+ unit), fontsize=fts)
			ax1.set_xlim([xmin,xmax])
			ax1.set_ylim([0,max(hist)])
			ax1.set_ylabel('Frequency', fontsize=fts)
			ax2.set_ylabel('CDF', fontsize=fts)
			plt.savefig(open(savename, 'wb'), dpi=200, bbox_inches='tight')
			plt.close()
		
		return f_cdf, f_xs
		

	def get_lcoe_contingency(self, fn, target_lcoe=None, likelihood=None):
		'''
		Obtain the rate of contingency with a given targeted LCOE or likelihood
		Arguments:
		fn: str, directory of thethe .mat result file of the reference case 
		    (e.g. the best design with the deterministic parameters)	
		** specify one of the target_lcoe and likelihood, and keep the other as None
		     
		target_lcoe: float, the targeted LCOE (USD/MWhe)
		likelihood: float, the targeted likelihood, (0-1)

		Returns:
		r_contingency: float, rate of the contingency budget over the total equipment cost (0-1)
		C_contingency: float, the amount of contingency budget (MUSD)
		'''
		
		f_cdf, f_xs=self.get_cdf(x=self.lcoe, num_bins=25, name='LCOE', unit='(USD/MWh$\mathrm{_e}$)', plot=False)			
		
		mat = DyMat.DyMatFile(fn)
		
		eng_v = mat.data('E_elec') # Cumulative electricity generated [J]		
		eng_t = mat.abscissa('E_elec', valuesOnly=True) # Time [s]
		dur = eng_t[-1] - eng_t[0] # Time duration [s]
		epy = fin.energy_per_year(dur, eng_v[-1]) # Energy expected in a year [J]				
		cap_v = mat.data('C_cap') # Capital costs [$]		
		om_y_v = mat.data('C_year') # O&M costs per year [$/year]
		om_p_v = mat.data('C_prod') # O&M costs per production per year [$/J/year]
		disc_v = mat.data('r_disc') # Discount rate [-]
		life_v = mat.data('t_life') # Plant lifetime [year]
		cons_v = mat.data('t_cons') # Construction time [year]

		#TODO
		# need to make an agreement of the name of the cost/finacial parameters
		# between all the SolarTherm models
		C_equipment=mat.data('C_cap_dir_tot')[0] # total equipment cost
		#C_equipment=mat.data('C_cap_total')[0] # total equipment cost
		
		#r_contingency_0=mat.data('r_contg')[0]
		#C_contingency_0=r_contingency_0 * C_equipment
		C_contingency_0=mat.data('C_contingency')[0]
		C_cap_0 =cap_v[0]-C_contingency_0

		
		# LCOE of the best case without contingency budget
		#lcoe = fin.lcoe_r(C_cap_0, om_y_v[0] + om_p_v[0]*epy, disc_v[0],
		#					int(life_v[0]), int(cons_v[0]), epy)

		
		if target_lcoe!=None and likelihood==None:
			likelihood=f_cdf(target_lcoe) 
		elif likelihood!=None and target_lcoe==None:	
			target_lcoe=f_xs(likelihood)
		else:
			raise Exception("\n\n  Conflict between 'target_lcoe' and 'likelihood'\n  They cannot be specified simultaneously\n  Select one and keep the other as 'None'\n")

		print('')
		print('Target LCOE ', target_lcoe, ',with likelihood ', likelihood)

		lcoe_update=0.

		i=0
		r_contingency=0.
		#while abs(lcoe-target_lcoe)>1e-2 and r_contingency<=1: 
		while abs(lcoe_update-target_lcoe)>1e-2: 
			C_contingency=C_equipment*r_contingency
			#print target_lcoe, lcoe, c_cap/1e6, r_contingency, f_contg(c_cap/1e6)
			lcoe_update=fin.lcoe_r(
				c_cap=C_cap_0+C_contingency, 
				c_year=om_y_v[0] + om_p_v[0]*epy, 
				r=disc_v[0], 
				t_life=int(life_v[0]), 
				t_cons=int(cons_v[0]), 
				epy=epy)

			lcoe_update=lcoe_update*1e6*3600.
			r_contingency+=0.000001
			
		print('')		
		print('r_contingency,', r_contingency)
		print('C_contingency,', C_contingency)

		return r_contingency, C_contingency/1e6
		
		
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
		
		#print('Intercept: \n', regr.intercept_)
		#print('Coefficients: \n', regr.coef_)

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
		
	def plot_cdfs(self):
	
		self.get_cdf(x=self.lcoe, num_bins=25, name='LCOE', unit='(USD/MWh$\mathrm{_e}$)', savename=self.casedir+'/CDF_lcoe.png', color='green', base=112)		
		
		self.get_cdf(x=self.C_cap, num_bins=25, name='Total capital cost', unit='(M$\cdot$USD)', savename=self.casedir+'/CDF_capital.png', color='blue')

		self.get_cdf(x=self.epy, num_bins=25, name='Energy production per year', unit='(MWh/year)', savename=self.casedir+'/CDF_epy.png', color='orange')	



if __name__=="__main__":
	casedir="../../../examples/demo_sensitivity"
	ct=Contingency(casedir, var_n_des=[], var_n_perf=['eff_blk', 'he_av_design', 'ab_rec', 'rec_fr'], var_n_cost=[])

	
	
