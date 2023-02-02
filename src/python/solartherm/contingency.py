from __future__ import division, print_function,unicode_literals

import numpy as np
import re
import solartherm.finances as fin
import matplotlib.pyplot as plt
from scipy import interpolate
import DyMat
from scipy.spatial import ConvexHull, Delaunay
import time
import sys

class Contingency:

	def __init__(self, casedir, num_total_sample, var_n_des=[], var_n_perf=[], var_n_cost=[], summaryfile=None, process_lcoe=False):

		self.casedir=casedir
		self.var_n_des=var_n_des
		self.var_n_perf=var_n_perf
		self.var_n_cost=var_n_cost
		self.get_sample(num_total_sample, summaryfile, process_lcoe)
	
	
	def get_sample(self, num_total_sample, summaryfile=None, process_lcoe=False):

		self.sample={}

		if summaryfile==None:
		
			for i in range(1, num_total_sample+1):
				#try:
				data=np.loadtxt(self.casedir+'/summary_report_%s.csv'%i, delimiter=',', dtype=str, skiprows=1)
				for i in range(len(data)):
					for j in range(len(data[0])):
						data[i,j]=data[i,j].replace('"','')						
				for l in data:
					if l[0] in self.sample.keys():
						self.sample[l[0]]=np.append(self.sample[l[0]], float(l[1]))
					else:
						self.sample[l[0]]=np.array([l[1]]).astype(float)
			#except:
			#	print("summary_report_%s.csv not available"%i)

		else:
			data=np.loadtxt(summaryfile, delimiter=',', dtype=str)
			for i in range(len(data)):
				for j in range(len(data[0])):
					data[i,j]=data[i,j].replace('"','')			
			
			idx= (np.sum(data[1:].astype(float), axis=1)!=0)			
			nn=len(data[0])

			for i in range(1, nn):
				self.sample[data[0,i]]=data[1:][idx, i].astype(float)

		#FIXME C_contingency variable was not in the system model
		# such that it could not be extracted
		# need to make consistent naming structure in system models
		# especially for the costs
		self.sample['C_contingency']=(self.sample['C_field'].astype(float)+self.sample['C_receiver'].astype(float)+self.sample['C_storage'].astype(float)+self.sample['C_PB'].astype(float)+self.sample['C_BOP'].astype(float)+self.sample['C_field'].astype(float)*10./75.)*0.1

		self.num_sample = len(self.sample['lcoe'])
		self.epy=self.sample['epy'].astype(float) #MWh/year
		self.C_cap=self.sample['C_cap'].astype(float)-self.sample['C_contingency'].astype(float) #mUSD
		self.OM_tot=self.sample['OM_total'].astype(float) #mUSD
		self.r_discount=self.sample['r_discount'].astype(float)
		self.t_life=self.sample['t_life'].astype(int)
		self.t_cons=self.sample['t_cons'].astype(int)
					
		if process_lcoe:
			# update LCOE to be 
			# LCOE without the pre-estimated contingency in the system model
			self.C_contingency=self.sample['C_contingency'].astype(float) # mUSD, the initially estimated contingency in the system model, e.g. ~10% capital
			
			self.lcoe = fin.lcoe_r(
					c_cap=self.C_cap*1.e6, 
					c_year=self.OM_tot*1.e6, 
					r=self.r_discount, 
					t_life=self.t_life[0], 
					t_cons=self.t_cons[0], 
					epy=self.epy)
		else:
			self.lcoe=self.sample['lcoe']
			
		self.var_v_des=[]
		self.var_v_perf=[]
		self.var_v_cost=[]		
		for n in self.var_n_des:
			if n in self.sample.keys():
				print('	Design parameter:', n)
				self.var_v_des.append(self.sample[n])
		for n in self.var_n_perf:
			if n in self.sample.keys():
				print('	Performance parameter:', n)
				self.var_v_perf.append(self.sample[n])
		for n in self.var_n_cost:
			if n in self.sample.keys():
				print('	Cost parameter:', n)
				self.var_v_cost.append(self.sample[n])
					
	def get_front(self, plot=False):
		'''
		Get the Pareto front of LCOE VS the uncertain parameters
		-- if one uncertain parameter, the Pareto front is a 2D curve
		-- if two uncertain parameters, the Pareto front is a 3D surface	
		'''	
		names=self.var_n_perf+self.var_n_cost
		values=self.var_v_perf+self.var_v_cost
		num_par=len(names)
		print('')
		print(num_par, 'uncertain parameters')
		if num_par==1:
			print('Creating Pareto front (a 2D curve)')
			
		elif num_par==2:
			print('Creating Pareto front (a 3D triangular mesh surface)')
			# normalised the points to 0-1
			points=np.array([])
			for i in range(num_par):
				v=values[i]
				#points=np.append(points, (v-np.min(v))/(np.max(v)-np.min(v)))		
				points=np.append(points, v)						
			#points=np.append(points,  (self.lcoe-np.min(self.lcoe))/(np.max(self.lcoe)-np.min(self.lcoe)))
			points=np.append(points, self.lcoe)
			
			points=points.reshape(num_par+1, self.num_sample) # (3,n)
			points=points.T # (n, 3)
			hull = ConvexHull(points)
			
			#print('min lcoe', np.min(self.lcoe))
			#idp=np.argmin(self.lcoe)
			#for i in range(len(self.var_n_perf)):				
			#	print(self.var_n_perf[i], self.var_v_perf[i][idp])
			
			t0=time.time()	
			norms, idx=get_bottom_hull_2d(points.T, indicies=hull.simplices)
			t1=time.time()
			print('')
			print('Time (bottom hull) %.2f s'%(t1-t0))
			indices=hull.simplices[idx]
			f_lcoe=np.sum(self.lcoe[indices], axis=1)/3. # front lcoe in each triangle

			if plot:
				gen_vtk(savedir=self.casedir+'/front_lcoe.vtk', points=points.T, indices=indices, norms=norms, colormap=True, num=np.r_[0], DATA={"lcoe": f_lcoe})
				
				fts=14
				plt2,ax=plt.subplots()
				cm = plt.cm.get_cmap('jet')
				vmax=np.max(self.lcoe[indices])
				vmin=np.min(self.lcoe[indices])
				#plt.triplot(values[0], values[1], indices) 
				plt.tripcolor(values[0], values[1], indices, facecolors=f_lcoe, cmap=cm, vmax=vmax, vmin=vmin)  	
				cs=ax.scatter(values[0][indices], values[1][indices], c=self.lcoe[indices] , cmap=cm,s=40, marker='o',edgecolors='black', vmax=vmax, vmin=vmin)

				clb=plt.colorbar(cs)
				clb.ax.set_title(' LCOE \n USD/MWh$_\mathrm{e}$',y=1.,fontsize=fts)
				plt.xlabel(names[0],fontsize=fts)
				plt.ylabel(names[1],fontsize=fts)
				plt.xticks(fontsize=fts)
				plt.yticks(fontsize=fts)
				clb.ax.tick_params(labelsize=fts)
				#plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
				#plt.legend(loc='lower left',fontsize=fts)
				plt.savefig(open(self.casedir+'/front_lcoe.png','wb'), bbox_inches='tight', dpi=300)
				plt.show()
				plt.close()
			
					
		else:
			raise('\nNot yet available when the number of uncertain parameters is larger than 2\n Future work\n')
				
		
		return indices, f_lcoe
	
	def front_tri(self):

		names=self.var_n_perf+self.var_n_cost
		values=self.var_v_perf+self.var_v_cost
		num_par=len(names)	
	
		fn=self.casedir+'/front.csv'
		front=np.loadtxt(fn, dtype=str, delimiter=',')
		lcoe=front[1:,0].astype(float)
		num_front=len(lcoe)
		idx=np.zeros(self.num_sample)
		for i in range(num_front):
			fl=lcoe[i]
			for j in range(self.num_sample):
				l=self.lcoe[j]
				if abs(l-fl)<1e-9:
					#idx=np.append(idx, j)
					idx[j]=1
		indices=idx.astype(bool)

		points=np.array([])
		for i in range(num_par):
			v=values[i]
			points=np.append(points, v[indices])
		points=points.reshape(num_par, int(len(points)/num_par)) # (2,n)
		points=points.T # (n, 2)
		
		#points[:,0]=(points[:,0]-np.min(points[:,0]))/(np.max(points[:,0])-np.min(points[:,0]))
		#points[:,1]=(points[:,1]-np.min(points[:,1]))/(np.max(points[:,1])-np.min(points[:,1]))
		
		tri = Delaunay(points)
		tri_idx=tri.simplices

		f_lcoe=np.sum(self.lcoe[indices][tri_idx], axis=1)/3. # front lcoe in each triangle
		
		return indices, tri_idx, f_lcoe
		
	def get_assessment(self, indices, f_lcoe, newsample, tri_idx=None,  plot=False):
		'''
		Arguments:
		(1) indices: (n, 3) array, the indices of triangular mesh elements on the convex hull
		(2) f_lcoe: (n, 1) array, the average lcoe value of each triangular mesh element (center point color)
		(3) newsample: (n, num_par) array, the new sample of uncertain parameters
			    n is the number of samples for each parameter
			    num_par is the number of uncertain parameters
		Return:
		(1) the optimal lcoe for each corresponding uncertain parameter
		(2) the optimal design parameters for each corresponding uncertain parameter
		'''
		# the training sample
		names=self.var_n_perf+self.var_n_cost
		values=self.var_v_perf+self.var_v_cost
		num_par=len(names)						
		points=np.vstack((values[0], values[1])) #(2, n)
		points=points.T #(n, 2)		

		# the new sample
		num_des=len(self.var_n_des)
		num_ns=len(newsample)
		ns_lcoe=np.zeros(num_ns) # optimal lcoe of the new sample
		ns_des={} # design of the new sample
		ns_cap=np.zeros(num_ns) # total captical cost of the new sample
		ns_epy=np.zeros(num_ns) # epy of the new sample		
		for i in range(num_des):
			ns_des[self.var_n_des[i]]=np.zeros(num_ns)
		
		if tri_idx is None:
		
			num_tri=len(indices)
			for i in range(num_tri):

				A=points[indices[i,0]]
				B=points[indices[i,1]]
				C=points[indices[i,2]]
				
				idx, ka, kb, kc, k=self.interp_tri_2d( A, B, C, newsample)
				if np.sum(idx)!=0:
					ns_lcoe[idx]=(ka*self.lcoe[indices[i,0]]+kb*self.lcoe[indices[i,1]]+kc*self.lcoe[indices[i,2]])/k
					ns_cap[idx]=(ka*self.C_cap[indices[i,0]]+kb*self.C_cap[indices[i,1]]+kc*self.C_cap[indices[i,2]])/k
					ns_epy[idx]=(ka*self.epy[indices[i,0]]+kb*self.epy[indices[i,1]]+kc*self.epy[indices[i,2]])/k					
					
					for i in range(num_des):
						name=self.var_n_des[i]
						value=self.var_v_des[i]
						ns_des[name][idx]=(ka*value[indices[i,0]]+kb*value[indices[i,1]]+kc*value[indices[i,2]])/k
				#print('tri ', i, np.sum(idx))	
				
			idx=(ns_lcoe!=0)
			
			if plot:
				fts=14
				plt2,ax=plt.subplots()
				cm = plt.cm.get_cmap('jet')
				vmax=np.max(self.lcoe[indices])
				vmin=np.min(self.lcoe[indices])
				#plt.triplot(values[0], values[1], indices) 
				plt.tripcolor(values[0], values[1], indices, facecolors=f_lcoe, cmap=cm, vmax=160, vmin=140)  	
				cs=ax.scatter(values[0][indices], values[1][indices], c=self.lcoe[indices] , cmap=cm,s=60, marker='o',edgecolors='black', vmax=160, vmin=140)			
				cs=ax.scatter(newsample[idx, 0], newsample[idx, 1], c=ns_lcoe[idx] , cmap=cm,s=80, marker='o',edgecolors='red', vmax=160, vmin=140)	

					
				clb=plt.colorbar(cs)
				clb.ax.set_title(' LCOE \n USD/MWh$_\mathrm{e}$',y=1.,fontsize=fts)
				plt.xlabel(names[0],fontsize=fts)
				plt.ylabel(names[1],fontsize=fts)
				plt.xticks(fontsize=fts)
				plt.yticks(fontsize=fts)
				clb.ax.tick_params(labelsize=fts)
				#plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
				#plt.legend(loc='lower left',fontsize=fts)
				#plt.savefig(open(self.casedir+'/front_lcoe.png','wb'), bbox_inches='tight', dpi=300)
				plt.show()
				plt.close()
		else:

			num_tri=len(tri_idx)
			for i in range(num_tri):

				A=points[indices][tri_idx[i,0]]
				B=points[indices][tri_idx[i,1]]
				C=points[indices][tri_idx[i,2]]
				
				idx, ka, kb, kc, k=self.interp_tri_2d( A, B, C, newsample)
				if np.sum(idx)!=0:
					ns_lcoe[idx]=(ka*self.lcoe[indices][tri_idx[i,0]]+kb*self.lcoe[indices][tri_idx[i,1]]+kc*self.lcoe[indices][tri_idx[i,2]])/k
					ns_cap[idx]=(ka*self.C_cap[indices][tri_idx[i,0]]+kb*self.C_cap[indices][tri_idx[i,1]]+kc*self.C_cap[indices][tri_idx[i,2]])/k
					ns_epy[idx]=(ka*self.epy[indices][tri_idx[i,0]]+kb*self.epy[indices][tri_idx[i,1]]+kc*self.epy[indices][tri_idx[i,2]])/k
										
					for i in range(num_des):
						name=self.var_n_des[i]
						value=self.var_v_des[i]
						ns_des[name][idx]=(ka*value[indices][tri_idx[i,0]]+kb*value[indices][tri_idx[i,1]]+kc*value[indices][tri_idx[i,2]])/k
				#print('tri ', i, np.sum(idx))	
				
			idx=(ns_lcoe!=0)
			if plot:
				fts=14
				plt2,ax=plt.subplots()
				cm = plt.cm.get_cmap('jet')
				vmax=np.max(self.lcoe[indices][tri_idx])
				vmin=np.min(self.lcoe[indices][tri_idx])
				#plt.triplot(values[0], values[1], indices) 
				plt.tripcolor(values[0][indices], values[1][indices], tri_idx, facecolors=f_lcoe, cmap=cm, vmax=160, vmin=140)  	
				cs=ax.scatter(values[0][indices][tri_idx], values[1][indices][tri_idx], c=self.lcoe[indices][tri_idx], cmap=cm,s=60, marker='o',edgecolors='black', vmax=160, vmin=140)			
				cs=ax.scatter(newsample[idx, 0], newsample[idx, 1], c=ns_lcoe[idx] , cmap=cm,s=80, marker='o',edgecolors='red', vmax=160, vmin=140)	

					
				clb=plt.colorbar(cs)
				clb.ax.set_title(' LCOE \n USD/MWh$_\mathrm{e}$',y=1.,fontsize=fts)
				plt.xlabel(names[0],fontsize=fts)
				plt.ylabel(names[1],fontsize=fts)
				plt.xticks(fontsize=fts)
				plt.yticks(fontsize=fts)
				clb.ax.tick_params(labelsize=fts)
				#plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
				#plt.legend(loc='lower left',fontsize=fts)
				#plt.savefig(open(self.casedir+'/front_lcoe.png','wb'), bbox_inches='tight', dpi=300)
				plt.show()
				plt.close()				
	
		return ns_lcoe, ns_des, ns_epy, ns_cap

			
					
	def interp_tri_2d(self, A, B, C, P):
		'''
		Arguments:
		A, B, C: each is a (2,1) array, e.g. (x, y),  they are the verticies of the triangle element
		P: P(x, y) the position to be interpolated
		
		Return:
		(1) idx, The idx of point P that is inside this triangle element ABC
		(2) The coefficients of the interpolation:
			zp=(ka*za+kb*zb+kc*zc)/k  
		
		Method
		# interpolation by area (simplex interpolation method)
		# ref: https://www.hpl.hp.com/techreports/2002/HPL-2002-320.pdf
		'''

		ABC=cal_area_2d(A[:2],B[:2],C[:2])
		ABP=cal_area_2d(A[:2],B[:2],P)
		ACP=cal_area_2d(A[:2],C[:2],P)
		BCP=cal_area_2d(B[:2],C[:2],P)				

		AREA=abs(ABP+ACP+BCP-ABC)

		idx=(AREA<1e-9)
		
		'''
		if np.sum(idx)==0:
			zp=None
		else:
			zp=(A[2]*BCP[idx]+B[2]*ACP[idx]+C[2]*ABP[idx])/ABC
		'''
		ka=BCP[idx]
		kb=ACP[idx]
		kc=ABP[idx]
		k=ABC
		
		return idx, ka, kb, kc, k
		
	
	def get_cdf(self, x, num_bins, name, unit, plot=True, savename=None, color='b', base=None, verbose=False):
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
	
		if verbose:
			print('')
			print(name, '(%s)'%unit)
			print("	min %.4f"%xmin)
			print("	max %.4f"%xmax)
			print("	mean %.4f"%m)
			print("	sd %.4f"%sd)		
			print('	P30 %.4f'%p30)
			print('	p50 %.4f'%p50)
			print('	p90 %.4f'%p90)		
		
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
			plt.show()
			plt.close()
		
		return f_cdf, f_xs
		

	def get_lcoe_contingency(self, f_cdf, f_xs, fn, target_lcoe=None, likelihood=None):
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
		
		#f_cdf, f_xs=self.get_cdf(x=self.lcoe, num_bins=25, name='LCOE', unit='(USD/MWh$\mathrm{_e}$)', plot=False)			
		
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
		try:
			C_equipment=mat.data('C_cap_total')[0] # total equipment cost
		except:
			C_equipment=mat.data('C_cap_dir_tot')[0] # total equipment cost	
		
		try:
			# if there was default contingency added in the system model		
			r_contingency_0=mat.data('r_contg')[0]
			C_contingency_0=r_contingency_0 * C_equipment
			#C_contingency_0=mat.data('C_contingency')[0]
		except:
			C_contingency_0=0.
		C_cap_0 =cap_v[0]-C_contingency_0
		print('')
		print('The initially allocated contingency:%.2f MUSD '%(C_contingency_0/1e6))
		
		# LCOE of the best case without contingency budget
		lcoe = fin.lcoe_r(C_cap_0, om_y_v[0] + om_p_v[0]*epy, disc_v[0],
							int(life_v[0]), int(cons_v[0]), epy)
		print('The default LCOE (without contingency): %.2f USD/MWhe '% (lcoe*1e6*3600.))
		
		if target_lcoe!=None and likelihood==None:
			likelihood=f_cdf(target_lcoe) 
		elif likelihood!=None and target_lcoe==None:	
			target_lcoe=f_xs(likelihood)
		else:
			raise Exception("\n\n  Conflict between 'target_lcoe' and 'likelihood'\n  They cannot be specified simultaneously\n  Select one and keep the other as 'None'\n")

		print('')
		print('Target LCOE %.4f'%target_lcoe, ',likelihood %.2f%%'%(likelihood*100.))

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
			if i==0:
				if lcoe_update>target_lcoe:
					raise ValueError("\n The target LCOE is lower than the LCOE of the default optimal design\n Either the LCOE default is too high (e.g. system not optimised) \n Or the target LCOE is set too low\n No additional contingency budget is required to be added")
			i+=1
			
						
		print('	Contingency cost %.4f MUSD'%(C_contingency/1e6))
		print('	Rate of contingency over total capital %.2f%%'%(r_contingency*100))
		
		return r_contingency, C_contingency/1e6
		
		
	def plot_sensitivity(self, names, values, lcoe):
		'''
		Rank of impact
		'''
				
		#names=self.var_n_perf+self.var_n_cost
		#values=self.var_v_perf+self.var_v_cost
		num_par=len(names)
		num_sample=len(lcoe)

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

		V_sd=V_sd.reshape(num_par, num_sample)
		V_sd=V_sd.T

		# get the regression coefficient
		from sklearn import linear_model
		regr = linear_model.LinearRegression()
		regr.fit(V_sd, lcoe)
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
		plt.show()
		plt.close()	
		
	def plot_cdfs(self, lcoe, C_cap, epy):
		print('')
		print('Some Statistics')
		self.get_cdf(x=lcoe, num_bins=25, name='LCOE', unit='(USD/MWh$\mathrm{_e}$)', savename=self.casedir+'/CDF_lcoe.png', color='green', verbose=True)		#base=112
		
		self.get_cdf(x=C_cap, num_bins=25, name='Total capital cost', unit='(M$\cdot$USD)', savename=self.casedir+'/CDF_capital.png', color='blue', verbose=True)

		self.get_cdf(x=epy, num_bins=25, name='Energy production per year', unit='(MWh/year)', savename=self.casedir+'/CDF_epy.png', color='orange', verbose=True)	


        
def get_bottom_hull_2d(points, indicies):
	'''
	points is (3, n) array
	indicies is (m,3) array, indicies of triangular mesh element
	'''
	num_tri=len(indicies)
	triangle=points[:, indicies]

	P1=triangle[:,:,0].T # (n, 3)
	P2=triangle[:,:,1].T
	P3=triangle[:,:,2].T
	center=(P1+P2+P3)/3. # (n, 3) : (n-triangles, xyz) center of each mesh element

	# Normal vector of each element
	V12=P2-P1
	V13=P3-P1
	norms=np.cross(V12, V13)	
	#plot_3dmesh(points, tri=indicies, centers=center, norms=norms)		
		
	# the plane of each mesh element is
	# n_x * x + n_y * y + n_z * z = d
	# d is a constant
	D=np.array([])
	for i in range(num_tri):
		p0=P1[i]
		norm=norms[i]
		d=np.sum(p0*norm)
		D=np.append(D, d)

	idx=np.array([])
	for i in range(num_tri):
		idx0=True	
		for t in range(3):
			P=triangle[:,:,t].T		
			p=P[i]
			xp=P[i,0]
			yp=P[i,1]
			zp=P[i,2]

			#if zp>160.:
			#if zp>np.max(self.lcoe)-np.min(self.lcoe)
			#	idx0=False
			#else:
			
			# draw a vertical line through point p (xp, yp, zp)
			# the intersection points of the line with the triangle planes are
			# (xp, yp, Z)
			# where Z is obtained below
			Z=(D-norms[:,0]*xp-norms[:,1]*yp)/norms[:,2]
			#
			#
			# if there is any intersection point below zp is inside a triangle element
			# then p is not on the bottom hull, idx0=False
			# else, idx0=True 	
			#
			# 
			id_low=(Z<zp)*(Z>0)
			n_low=np.sum(id_low)
			
			pi=np.ones((n_low, 3)) 
			pi[:, 0]=xp
			pi[:, 1]=yp
			pi[:, 2]=Z[id_low]
			
			if n_low>0:
				for j in range(num_tri):
					A=P1[j]
					B=P2[j]
					C=P3[j]

					if not (np.array_equal(A,p) or np.array_equal(B,p) or np.array_equal(C,p)):
									
						#if a point P is inside a triangle ABC on the plane of ABC
						#then are APB+APC+BPC=ABC				
						area1=cal_area_3d(A, B, pi)
						area2=cal_area_3d(A, C, pi)
						area3=cal_area_3d(B, C, pi)
						area=area1+area2+area3
						area_0=cal_area_3d(A, B, C)
						#print(np.min(abs(area-area_0)), np.max(abs(area-area_0)))
						if np.min(abs(area-area_0))<1e-5:
							#print("point %s/%s is on the plane of tri %s"%(i, t, j))			
							idx0=False

		idx=np.append(idx, idx0)
		
	print('Number of triangles (bottom/all) %.0f/%.0f'%(np.sum(idx),num_tri))
	idx=idx.astype(bool)
					
	return norms, idx
    
def cal_area_3d(A, B, C):
	'''
	A, B, C are three points in a 3D coordinate system
	This function returns the area of the triangle ABC
	
	'''  

	V_CA=A-C
	V_CB=B-C
	norm=np.cross(V_CA, V_CB)
	if V_CA.ndim==1:
		ln=np.linalg.norm(norm)
	else:	
		ln=np.linalg.norm(norm, axis=1)
	area=0.5*ln
						
	return area
	
def cal_area_2d(A, B, C):
	'''
	A, B, C are three points in a 2D coordinate system
	This function returns the area of the triangle ABC
	
	'''  
	if A.ndim==1:
		xa=A[0]
		ya=A[1]
	else:
		xa=A[:,0]
		ya=A[:,1]
		

	if B.ndim==1:
		xb=B[0]
		yb=B[1]
	else:
		xb=B[:,0]
		yb=B[:,1]
		
	if C.ndim==1:
		xc=C[0]
		yc=C[1]
	else:
		xc=C[:,0]
		yc=C[:,1]

	area=abs(0.5*(xa*(yb - yc) + xb*(yc - ya) + xc*(ya - yb)))
						
	return area
		
	
def gen_vtk(savedir, points, indices, norms, colormap=True, num=np.r_[1], DATA=None):
    '''
    points - x, y, z
    indices - vertices of the triangle mesh
    DATA - dic, key is the i-th direction (0 is total), value is the radiosity from that direction
    num - number of cell data 

    reference:
     vtk file format: https://vtk.org/wp-content/uploads/2015/04/file-formats.pdf
    '''
    num_points=len(points.T)
    num_tri=len(indices)
    f=open(savedir, 'w')
    f.write('# vtk DataFile Version 2.0\n')
    f.write('test\n')
    f.write('ASCII\n')
    f.write('DATASET POLYDATA\n')

    # point data
    f.write('POINTS %s double\n'%num_points)
    for i in range(num_points):
        x=points[0,i]
        y=points[1,i]
        z=points[2,i]
        f.write('%.8f %.8f %.8f\n'%(x, y, z))
    f.write('POLYGONS %s %s\n'%(num_tri, num_tri*4))
    for i in range(num_tri):
        id1=indices[i,0]
        id2=indices[i,1]
        id3=indices[i,2]
        f.write('3 %.0f %.0f %.0f\n'%(id1, id2, id3))  

    # cell data
    f.write('CELL_DATA %s\n'%(num_tri))
    f.write('NORMALS cell_normals float\n')
    m_norms=np.linalg.norm(norms, axis=1)
    for i in range(num_tri):
        norm_norms=norms[i]/m_norms[i]
        nx=norm_norms[0]
        ny=norm_norms[1]
        nz=norm_norms[2]
        
        f.write('%.8f %.8f %.8f\n'%(nx, ny, nz))  
        

    if colormap:    
        totalnum=len(num)*len(DATA)                   

        f.write('FIELD PrimaryData %s\n'%(totalnum))
        interest=DATA.keys()
        for m in interest:
            f.write('%s 1 %s double\n'%(m, num_tri))
            for i in range(num_tri):
                f.write('%.8f\n'%(DATA[m][i]))            

               
        f.close()
        
        	
def plot_3dmesh(points, tri, centers, norms):
    '''
    points - (3, n) array
    tri - (n,3) array, the indices of the triangle mesh
    centers - (n,3), the center of each mesh element
    norms - (n, 3), normal vector of each mesh element
    '''
    import pylab as pl
    fig = pl.figure()  
    ax = fig.add_subplot(111, projection = '3d')
    #ax.scatter(points[0], points[1], points[2], marker='o', s=1)
    ax.plot_trisurf(points[0], points[1], points[2], triangles=tri, color=(0,0,0,0), edgecolors='blue')
    ax.quiver(centers[:,0],centers[:,1],centers[:,2],norms[:,0],norms[:,1],norms[:,2],length=1., arrow_length_ratio=0.2)
    plt.show()  	
        

def pert_distribution(a, b, c, size, lamb=4):
	'''
	a is the lower bound
	b is the nominal
	c is the upper bound
	size is the number of samles
	'''
	r = c - a
	alpha = 1 + lamb * (b - a) / r
	beta = 1 + lamb * (c - b) / r
	return a + np.random.beta(alpha, beta, size=size) * r

def generate_lhs(UB,LB, num_inputs, numdata, dist='uniform', Nominal=None):
	import pyDOE
	LHS = pyDOE.lhs(num_inputs,samples=numdata)
	
	if dist=='uniform':
		for i in range(LHS.shape[0]):
			for j in range(LHS.shape[1]):
				val = LHS[i,j]
				ub = UB[j]*0.99
				lb = LB[j]*1.01
				real_val = val * (ub - lb) + lb
				LHS[i,j] = real_val
				
	elif dist=='pert':
		# FIXME the pert distribution lhs is not available yet
		pass
		#LHS = lhs(num_inputs,samples=numdata)
		
		#alpha=1.+4.*(Nominal-LB)
		#beta=1.+4.*(UB-Nominal)
		#r=UB-LB
		#LHS=beta(alpha, beta)
		#LHS=norm(loc=0, scale=1).ppf(LHS)
	return LHS

 
        
if __name__=="__main__":

	pass

	'''
	import matplotlib.pyplot as plt
	fts=14
	a=1.
	c=3.
	b=2.
	size=5000
	s=pert_distribution(a, b, c, size, lamb=4)

	n, bins, patches = plt.hist(x=s, bins='auto', color='#0504aa',
                            alpha=0.7, rwidth=0.85)	
	plt.ylabel('Frequence of occurence', fontsize=fts)
	plt.xticks(fontsize=fts)
	plt.yticks(fontsize=fts)
	plt.savefig(open('sample.png', 'wb'), dpi=300, bbox_inches='tight')
	plt.close()
	'''		