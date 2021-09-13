from __future__ import division, print_function,unicode_literals

import numpy as np
import re
import solartherm.finances as fin
import matplotlib.pyplot as plt
from scipy import interpolate
import DyMat
from scipy.spatial import ConvexHull
import time

class Contingency:

	def __init__(self, casedir, var_n_des=[], var_n_perf=[], var_n_cost=[]):

		self.casedir=casedir
		samplefile=self.casedir+'/sample.dat'
		self.var_n_des=var_n_des
		self.var_n_perf=var_n_perf
		self.var_n_cost=var_n_cost
		self.get_sample(samplefile, summaryfile=self.casedir+'/summary_all.csv')
		self.get_front()
		#self.get_lcoe_contingency(fn='/media/yewang/Software/program/solartherm-contingency/examples/demo_sensitivity'+'/Reference_2_res_3.mat', target_lcoe=None, likelihood=0.7)
		#self.plot_cdfs()
		#self.plot_sensitivity()

		
	def get_sample(self, samplefile, summaryfile=None):
		try:
			with open(samplefile) as f:
				content= f.read().splitlines()
			f.close()	
		except:
			print("Simulation not finished (sample.dat not found)")

		num_total_sample=len(content)-1
		self.sample={}

		if summaryfile==None:
		
			for i in range(1, num_total_sample+1):
				try:
					data=np.loadtxt(casedir+'/summary_report_%s.csv'%i, delimiter=',', dtype=str, skiprows=1)
					for i in range(len(data)):
						for j in range(len(data[0])):
							data[i,j]=data[i,j].replace('"','')						
					for l in data:
						if l[0] in self.sample.keys():
							self.sample[l[0]]=np.append(self.sample[l[0]], float(l[1]))
						else:
							self.sample[l[0]]=np.array([l[1]]).astype(float)
				except:
					print("summary_report_%s.csv not available"%i)

		else:
			data=np.loadtxt(summaryfile, delimiter=',', dtype=str)
			for i in range(len(data)):
				for j in range(len(data[0])):
					data[i,j]=data[i,j].replace('"','')			
			
			idx= (np.sum(data[1:].astype(float), axis=1)!=0)			
			nn=len(data[0])

			for i in range(1, nn):
				self.sample[data[0,i]]=data[1:][idx, i].astype(float)

		
		self.num_sample = len(self.sample['lcoe'])

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
				print('Design parameter:', n)
				self.var_v_des.append(self.sample[n])
		for n in self.var_n_perf:
			if n in self.sample.keys():
				print('Performance parameter:', n)
				self.var_v_perf.append(self.sample[n])
		for n in self.var_n_cost:
			if n in self.sample.keys():
				print('Cost parameter:', n)
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
				points=np.append(points, (v-np.min(v))/(np.max(v)-np.min(v)))	
				
			points=np.append(points,  (self.lcoe-np.min(self.lcoe))/(np.max(self.lcoe)-np.min(self.lcoe)))
			points=points.reshape(num_par+1, self.num_sample) # (3,n)
			points=points.T # (n, 3)
			hull = ConvexHull(points)
			
			#print('min lcoe', np.min(self.lcoe))
			#idp=np.argmin(self.lcoe)
			#for i in range(len(self.var_n_perf)):				
			#	print(self.var_n_perf[i], self.var_v_perf[i][idp])
			
			t0=time.time()	
			norms, idx=get_bottom_hull(points.T, indicies=hull.simplices)
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
			raise('\nNot yet available for number of uncertain parameters is larger than 2\nComing in the next stage\n')
				
		
		return indices
	
	def interp_tri_2d(self, A, B, C, P):
		'''
		A, B, C: each is a (3,1) array, e.g. (x, y, z),  they are the verticies of the triangle element
		P: P(x, y) the position to be interpolated
		return zp
		
		Method
		# interpolation by area (simplex interpolation method)
		# ref: https://www.hpl.hp.com/techreports/2002/HPL-2002-320.pdf
		'''
		
		ABC=cal_area(A[:2],B[:2],C[:2])
		ABP=cal_area(A[:2],B[:2],P)
		ACP=cal_area(A[:2],C[:2],P)
		BCP=cal_area(B[:2],C[:2],P)
		
		print(ABC==ABP+ACP+BCP)
		print(ABC)
		print(ABP+ACP+BCP)
		
		zp=(A[2]*BCP+B[2]*ACP+C[2]*ABP)/ABC
		
		return zp
		
	
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
	
		self.get_cdf(x=self.lcoe, num_bins=25, name='LCOE', unit='(USD/MWh$\mathrm{_e}$)', savename=self.casedir+'/CDF_lcoe.png', color='green')		#base=112
		
		self.get_cdf(x=self.C_cap, num_bins=25, name='Total capital cost', unit='(M$\cdot$USD)', savename=self.casedir+'/CDF_capital.png', color='blue')

		self.get_cdf(x=self.epy, num_bins=25, name='Energy production per year', unit='(MWh/year)', savename=self.casedir+'/CDF_epy.png', color='orange')	


        
def get_bottom_hull(points, indicies):
	'''
	points is (3, n) array
	indicies is (m,3) array, indicies of triangular mesh element
	'''
	num_tri=len(indicies)
	triangle=points[:, indicies]

	P1=triangle[:,:,0].T # (n, 3)
	P2=triangle[:,:,1].T
	P3=triangle[:,:,2].T
	#center=(P1+P2+P3)/3. # (n, 3) : (n-triangles, xyz) center of each mesh element

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
			
			if zp>0.5:
				idx0=False
			else:
			
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
						a=P1[j]
						b=P2[j]
						c=P3[j]

						if not (np.array_equal(a,p) or np.array_equal(b,p) or np.array_equal(c,p)):
						
							A=np.ones((n_low, 3))
							A[:,0]=a[0]
							A[:,1]=a[1]				
							A[:,2]=a[2]
							
							B=np.ones((n_low, 3))
							B[:,0]=b[0]
							B[:,1]=b[1]				
							B[:,2]=b[2]
							
							C=np.ones((n_low, 3))
							C[:,0]=c[0]
							C[:,1]=c[1]				
							C[:,2]=c[2]				
											
							#if a point P is inside a triangle ABC on the plane of ABC
							#then APB+APC+BPC=360 deg				
							area1=cal_area(A, B, pi)
							area2=cal_area(A, C, pi)
							area3=cal_area(B, C, pi)
							area=area1+area2+area3
							area_0=cal_area(A, B, C)
							
							#print(np.min(abs(area-area_0)), np.max(abs(area-area_0)))
							if np.min(abs(area-area_0))<1e-5:
								#print("point %s/%s is on the plane of tri %s"%(i, t, j))			
								idx0=False

		idx=np.append(idx, idx0)
		
	print('Number of triangles (bottom/all) %.0f/%.0f'%(np.sum(idx),num_tri))
	idx=idx.astype(bool)
					
	return norms, idx
    
def cal_area(A, B, P):
	'''
	if point P is inside a triangle ABC on the plane of ABC
	then the area APB+APC+BPC=ABC
	
	this is a function to return the area of any three points
	
	'''  
	V_PA=A-P
	V_PB=B-P
	
	norm=np.cross(V_PA, V_PB)
	if norm.ndim==1 :	
		ln=np.linalg.norm(norm, axis=1)
	else:
		ln=np.linalg.norm(norm)
	area=0.5*ln					
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
    centers - (n,3), he center of each mesh element
    norms - (n, 3), normal vector of each mesh element
    '''
    import pylab as pl
    fig = pl.figure()  
    ax = fig.add_subplot(111, projection = '3d')
    #ax.scatter(points[0], points[1], points[2], marker='o', s=1)
    ax.plot_trisurf(points[0], points[1], points[2], triangles=tri, color=(0,0,0,0), edgecolors='blue')
    ax.quiver(centers[:,0],centers[:,1],centers[:,2],norms[:,0],norms[:,1],norms[:,2],length=1., arrow_length_ratio=0.2)
    plt.show()  	
        
if __name__=="__main__":
	t0=time.time()
	#casedir="../../../examples/demo_sensitivity"
	#casedir='/media/yewang/Data/Research/yewang/contingency/sample-reference2/moga-2var/nci'
	casedir='/media/yewang/Data/Research/yewang/contingency/sample-reference2/samples/2D/uniform_1000'
	#ct=Contingency(casedir, var_n_des=[], var_n_perf=['eff_blk', 'he_av_design', 'ab_rec', 'rec_fr'], var_n_cost=[])
	ct=Contingency(casedir, var_n_des=['t_storage', 'tank_ar'], var_n_perf=['ab_rec', 'alpha'], var_n_cost=[])

	t1=time.time()
	print('Time (total) %.2f s'%(t1-t0))
	
