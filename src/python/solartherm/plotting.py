import matplotlib
# Poor performance
#print(matplotlib.get_backend())
# Default QT5Agg is slow
# preferred:
#matplotlib.use('QT4Agg')
#matplotlib.use('GTKAgg')
#matplotlib.use('GTK')
#matplotlib.use('TkAgg')
#matplotlib.use('QT5Agg')
#matplotlib.use('GTKCairo') # fails to draw long paths

#matplotlib.rcParams['text.usetex'] = True
#matplotlib.rcParams['text.latex.unicode'] = False
#matplotlib.rcParams['font.family'] = 'serif'
#matplotlib.rcParams['font.serif'] = 'Times New Roman'
#matplotlib.rcParams['font.serif'] = 'cmr10'

import matplotlib.pyplot as plt
import re
import math

from solartherm import simulation

def plot_res(res, fmt, xlim=[], xunit='d', eunit='MWh', punit="MW", out=None, share=True, bw=False,
	dpi=600, font=['serif', 'Times New Roman'], usetex=False, ucode=False, fontsize=12):
	"""Plot variables from one or more Result objects.

	The variables to plot and their arrangement on axes and subplots is provided
	in fmt.  It is a list of subplots, where each subplot is representated by a
	string with the format:
		
		"var1,2var2:var3"
	
	The optional colon separates the names of variables to be plotted on the
	left y-axis, from the variables to be plotted on the right y-axis.  An
	optional integer prefix to a name indicates to which results object the
	variable belongs (defaults to the first). A full fmt might look like:

		["var1,1var2:2var3", "var4:2var5", "2var6"]
	
	An optional pair that represents bounds on the domain can be provided as
	xlim.

	An optional unit for the x axis can be provided as
	xunit like: 's', 'm', 'd', or 'y', representing seconds, minutes, days, or years respectively.

	An optional unit for energy and energy rate can be provided as
	eunit and punit like: 'J', 'kJ', 'MJ', or 'GJ' and 'W', 'kW', 'MW', or 'GW' respectively.

	If a filename is provided to out, then the plot will be saved to that file,
	otherwise the plot will be output to a new window.

	An optional setting for matplotlib.rcParams can be provided as
	font, usetetx, and ucode, repsesenting font family, font style, use text rendering With LaTeX and use usetex with unicode.
	"""

	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex
	matplotlib.rcParams['text.latex.unicode'] = ucode

	xlim = [simulation.parse_var_val(x, xunit) for x in xlim]

	fig = plt.figure()

	vre = re.compile('(\d+)?(\S+)')

	# Colours for our lines
	co = ['b', 'g', 'r', 'c', 'm', 'y', 'k']
	ls = ['-']
	if bw:
		co = ['#000000']
		ls = [
			'-',
			['--', [5,5]],
			'-.',
			['--', [1,3]],
			['--', [5,3,1,2,1,10]],
			]

	nsp = len(fmt)
	sharex = None
	for i_sp, v_sp in enumerate(fmt):
		sp = fig.add_subplot(nsp, 1, i_sp+1, sharex=sharex)
		if sharex is None and share:
			sharex = sp
		v_ys = v_sp.split(':')
		v_yss = [] # name of variables on left and potential right axes saved in a 2d list i.e. v_yss
		for n_ys in v_ys:
			v_yss.append(n_ys.split(','))
		n_yx = len(v_yss) # number of y axis
		if n_yx < 2:
			n_v_ys_l = len(v_yss[0]) # number of variables on the left y axis
			n_v_ys_r = 0 # number of variables on the right y axis
		else:
			n_v_ys_l = len(v_yss[0])
			n_v_ys_r = len(v_yss[1])
		assert len(v_ys) < 3, 'Can only utilise at most 2 y-axes per subplot'
		ax = [sp]
		for i in range(1,len(v_ys)):
			ax.append(sp.twinx())
		pos = [0 for i in range(max(2, len(v_ys)))]
		pos[0] = 2
		pos[1] = 1
		v_id = 0
		for i_ax, v_y in enumerate(v_ys): # i_ax is the y axis index and v_y contains the name of variables on each y axis
			v_v_max = [] # a list of maximum value of all variables on each y axis
			ylabel = []
			for var in v_y.split(','):
				vre_res = vre.match(var)
				if vre_res is None:
					raise ValueError('Cannot parse variable name ' + var)
				ri = vre_res.group(1)
				v = vre_res.group(2)
				if ri is None:
					ri = 0
				else:
					ri = int(ri) - 1
				if ri < 0 or ri >= len(res):
					raise ValueError('Result file index out of range (1,...,'
							+ str(len(res)) + ') ' + str(ri + 1))
				unit = ''
				try:
					unit = res[ri].get_unit(v)
					if unit == 'J':
						unit= eunit # changing unit from unit to eunit (e.g. from 'J' to 'kWh')
					if unit == 'W':
						unit = punit  # changing unit from unit to punit (e.g. from 'W' to 'kW')
				except:
					pass

				if '.' in v:
					i_d = v.rfind('.') # index of last dot in v
					v_main = v[i_d+1:].title()
					v_sub = v[:i_d].replace('.', ', ')
				elif '_' in v:
					i_ul = v.find('_') # index of last undeline in v
					v_main = v[:i_ul].title()
					v_sub = v[i_ul+1:].replace('_', ', ')
				else:
					v_main = v.title()
					v_sub = ''

				label = v_main + '$_\mathrm{' + v_sub + '}$' + ' (' + unit + ')'
				ylabel.append(label)
				if len(res) > 1:
					label = str(ri+1) + ': ' + label
				time_old = res[ri].get_time(v) # original time values in seconds
				time_new = simulation.convert_val(time_old, 's', xunit) # new time values in terms fo xunit
				v_v = res[ri].get_values(v)
				if unit==eunit:
					v_v = simulation.convert_val(v_v, 'J', unit)
				if unit==punit:
					v_v = simulation.convert_val(v_v, 'W', unit)
				v_v_max.append(max(v_v))
				ax[i_ax].plot(time_new, v_v,
						label=label, color=co[v_id%len(co)],
						linestyle=ls[v_id%len(ls)],
						#linewidth=2
						)
				v_id += 1
			ylabel = ', '.join(ylabel)
			ax[i_ax].set_ylim(top=max(v_v_max)+0.1*max(v_v_max))
			#ax[i_ax].set_ylim(auto=True)
			ax[i_ax].set_ylabel(ylabel=ylabel)
			if i_ax==0:
				ax[i_ax].legend(bbox_to_anchor=(0.,1.02),loc='lower left', ncol=int(math.ceil(n_v_ys_l/2.0))) #frame flag: frameon=False
			else:
				ax[i_ax].legend(bbox_to_anchor=(1,1.02),loc='lower right', ncol=int(math.ceil(n_v_ys_r/2.0)))
		if len(xlim) == 2:
			sp.set_xlim(xlim)
			#sp.set_xlim(left=xlim[0], right=xlim[1])
			#sp.margins(y=0.05)

	xlabeldic = {'s': 'seconds', 'd': 'minutes', 'h': 'hours', 'd': 'days', 'y': 'years'}
	xlabel ="Time" + " (" + xlabeldic[xunit] + ")"
	sp.set_xlabel(xlabel)

	fig.subplots_adjust(top=0.9,hspace=0.5)
	#plt.tight_layout()
	if out is not None:
		fig.savefig(out,dpi=dpi)
	else:
		plt.show()

def plot_par1(x1, ys, xlabel='', ylabels=[], out=None, dpi=600, font=['serif', 'Times New Roman'],
	usetex=False, ucode=False, fontsize=12):
	"""Plot a list of variables nested in ys list as a function of x1
	e.g.
	#plot_par1(x1=[1, 2, 3], ys=[[10, 100, 1000], [10, 100, 1000]], xlabel='X', ylabels=['Y1', 'Y2'])
	"""
	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex
	matplotlib.rcParams['text.latex.unicode'] = ucode

	fig = plt.figure()

	# Colours for our lines
	co = ['b', 'g', 'r', 'c', 'm', 'y', 'k']

	for j in range(len(ys)):
		sp = fig.add_subplot(len(ys), 1, j+1)
		sp.plot(x1, ys[j], label=ylabels[j], color=co[0%len(co)])
		if ylabels != []:
			sp.set_ylabel(ylabels[j])
		sp.legend(bbox_to_anchor=(0.,1.02),loc='lower left')
	sp.set_xlabel(xlabel)

	fig.subplots_adjust(top=0.9,hspace=0.5)
	#plt.tight_layout()
	if out is not None:
		fig.savefig(out, dpi=dpi)
	else:
		plt.show()

def plot_par2(x1, x2, ys, x1label='', x2label='', ylabels=[], out=None, dpi=600, font=['serif', 'Times New Roman'],
	usetex=False, ucode=False, fontsize=12):
	"""Plot ys as a function of x2 for various x1 values in one graph.
	e.g. plotting lcoe as a function t_storage for various P_names
	like: st_simulate --stop 1y --step 5m --plot lcoe FluidSystem.mo P_name=50000,75000,100000,125000 t_storage=2,3,4,5,6,7,8,9,10,11,12
	"""
	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex
	matplotlib.rcParams['text.latex.unicode'] = ucode

	x1g = []
	ysg = [[] for i in range(len(ys))]
	x1v = []
	x = None
	for i in range(len(x1)):
		if x != x1[i]:
			x1g.append([])
			for j in range(len(ys)):
				ysg[j].append([])
			x = x1[i]
			x1v.append(x)
		x1g[-1].append(x2[i])
		for j in range(len(ys)):
			ysg[j][-1].append(ys[j][i])

	fig = plt.figure()

	# Colours for our lines
	co = ['b', 'g', 'r', 'c', 'm', 'y', 'k']

	for j in range(len(ys)):
		sp = fig.add_subplot(len(ys), 1, j+1)
		for i in range(len(x1v)):
			sp.plot(x1g[i], ysg[j][i], label=(str(x1v[i]) + ' ' + x1label),
					color=co[i%len(co)])

		sp.set_xlabel(x2label)
		if ylabels != []:
			sp.set_ylabel(ylabels[j])
		sp.legend(loc=1, frameon=False)

	plt.tight_layout()
	if out is not None:
		fig.savefig(out, dpi=dpi)
	else:
		plt.show()

def plot_3d(x, y, z, xlabel='', ylabel='', zlabel='', out=None, dpi=600, font=['serif', 'Times New Roman'],
	usetex=False, ucode=False, fontsize=12):
	"""Plot a 3d graph based on variables x, y and z
	e.g.
	plot_3d(x=[1,2,3], y=[1,2,3] , z=[10, 100, 1000], xlabel='X', ylabel='Y', zlabel='Z')
	"""

	from mpl_toolkits.mplot3d import Axes3D

	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex
	matplotlib.rcParams['text.latex.unicode'] = ucode

	fig = plt.figure()

	ax = fig.gca(projection='3d')
	#ax.plot_surface(x, y, z)
	#ax.plot_wireframe(x, y, z)
	ax.scatter(x, y, z, marker='o')

	ax.set_xlabel(xlabel)
	ax.set_ylabel(ylabel)
	ax.set_zlabel(zlabel)

	if out is not None:
		fig.savefig(out, dpi=dpi)
	else:
		plt.show()

def pie_chart1(vals, ex, lbs, co=None, nd=2, sv='pct', lwv=False, pctdistance=0.6, shadow=False,
		labeldistance=1.1, startangle=90, radius=1, frame=False, out=None,
		dpi=600, font=['serif', 'Times New Roman'], usetex=False, ucode=False, fontsize=12):
	"""Plot a single pie chart, where the slices will be ordered and plotted counter-clockwise.
	vals: sizes in pie()
	ex: explode in pie()
	lbs: labels in pie()
	co: colors in pie()
	nd: number of decimal places
	sv: the value shown on each slice (or legend) i.e. pct, abs, or both, representing percentage value, absolute values, or both respectively.
	lwv: true if vales(whether they are absolute, percentage or both) are to be shown in legend (i.e. no values will be shown on the slices)
	e.g.
	pie_chart1(vals=[215.134, 130.445, 245.823, 210.376], ex=(0.05, 0, 0, 0), lbs=['C1', 'C2', 'C3', 'C4'], co=['gold', 'yellowgreen', 'lightcoral', 'lightskyblue'], sv='pct')
	"""
	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex
	matplotlib.rcParams['text.latex.unicode'] = ucode

	def pct_v(pct, nd=nd):
		"Returns percentage values rounded to nd decimal places"
		return '{p:.{nd}f}%'.format(p=pct, nd=nd)

	def abs_v(pct, nd=nd):
		"Returns absolute values rounded to nd decimal places"
		av = vals[abs(vals - pct/100. * sum(vals)).argmin()]
		return '{v:.{nd}f}'.format(v=av, nd=nd)

	def pct_abs_v(pct, nd=nd):
		"Returns percentage and absolute values rounded to nd decimal places"
		av = vals[abs(vals - pct/100. * sum(vals)).argmin()]
		return '{p:.{nd}f}% ({v:.{nd}f})'.format(p=pct, nd=nd, v=av)

	percent = [100. * v / sum(vals) for v in vals] # values in percentage

	if sv == 'pct':
		autopct = pct_v
		labels = ['{l:s} - {p:.{nd}f}%'.format(l=i, nd=nd, p=j) for i,j in zip(lbs, percent)]
	elif sv == 'abs':
		autopct = abs_v
		labels = ['{l:s} - {v:.{nd}f}'.format(l=i, nd=nd, v=j) for i,j in zip(lbs, vals)]
	else: # i.e. 'both'
		autopct = pct_abs_v
		labels = ['{l:s} - {p:.{nd}f}% ({v:.{nd}f})'.format(l=i, nd=nd, p=j, v=k) for i,j, k in zip(lbs, percent, vals)]

	if lwv:
		autopct = None
		labels = labels
	else:
		labels = lbs

	fig, ax = plt.subplots()

	ax.pie(vals, explode=ex, colors=co, autopct=autopct,
		pctdistance=pctdistance, shadow=shadow, labeldistance=labeldistance,
		startangle=startangle, radius=radius, frame=frame)
	ax.axis('equal')

	plt.legend(labels=labels, bbox_to_anchor=(-0.1,0.8),loc='lower left')
	#plt.tight_layout()

	if out is not None:
		fig.savefig(out, dpi=dpi)
	else:
		plt.show()


def pie_chart2(vals, ex, lbs, co=None, nd=2, sv='pct', pctdistance=0.6, shadow=False, labeldistance=1.1,
		startangle=90, radius=1, frame=False, out=None, dpi=600, font=['serif', 'Times New Roman'],
		usetex=False, ucode=False, fontsize=12):
	"""Plot a single or multiple pie charts, where the slices will be ordered and plotted counter-clockwise.
	vals: a 2d lsit of sizes
	ex: a 2d lsit o explode
	lbs: labels in pie()
	co: colors in pie()
	nd: number of decimal places
	sv: the value shown on each slice i.e. pct, abs, or both, representing percentage value, absolute values, or both respectively.
	e.g.
	pie_chart2(vals=[[215.134, 130.445, 245.823, 210.376], [215.134, 130.445, 245.823, 210.376]], ex=[(0.05, 0, 0, 0), (0.05, 0, 0, 0)], lbs=['C1', 'C2', 'C3', 'C4'], co=['gold', 'yellowgreen', 'lightcoral', 'lightskyblue'], sv='pct')
	"""
	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex
	matplotlib.rcParams['text.latex.unicode'] = ucode

	def pct_v(pct, nd=nd):
		"Returns percentage values rounded to nd decimal places"
		return '{p:.{nd}f}%'.format(p=pct, nd=nd)

	def abs_v(pct, nd=nd):
		"Returns absolute values rounded to nd decimal places"
		for vv in vals:
			av = vv[abs(vv - pct/100. * sum(vv)).argmin()]
		return '{v:.{nd}f}'.format(v=av, nd=nd)

	def pct_abs_v(pct, nd=nd):
		"Returns percentage and absolute values rounded to nd decimal places"
		for vv in vals:
			av = vv[abs(vv - pct/100. * sum(vv)).argmin()]
		return '{p:.{nd}f}% ({v:.{nd}f})'.format(p=pct, nd=nd, v=av)

	if sv == 'pct':
		autopct = pct_v
	elif sv == 'abs':
		autopct = abs_v
	else:
		autopct = pct_abs_v

	ng = len(vals) # number of pie graphs
	even = True if ng % 2. == 0 else False # true if ng is even
	if even:
		nc = math.ceil(math.sqrt(ng)) # number of columns of subplots array
		nr = math.ceil(ng/nc) # number of rows of subplots array
	else:
		nc = ng
		nr = math.ceil(ng/nc)

	if ng != 1: # i.e. more than 1 pie chart
		fig, axes = plt.subplots(nrows=int(nr), ncols=int(nc))
		#fig, axes = plt.subplots(nrows=int(nr), ncols=int(nc), figsize=(12, 8))
		if nr != 1: # i.e. more than 1 row
			ii = 0 # vals index
			for r in range(axes.shape[0]):
				for c in range(axes.shape[1]):
					if ii >= ng:
						break
					patches, texts, autotexts = axes[r,c].pie(vals[ii], explode=ex[ii], colors=co, autopct=autopct,
						pctdistance=pctdistance, shadow=shadow, labeldistance=labeldistance,
						startangle=startangle, radius=radius, frame=frame)
					#for t in texts:
						#t.set_size('smaller')
						#t.set_fontsize(12)
					#for t in autotexts:
						#t.set_size('x-small')
						#t.set_fontsize(12)
						#t.set_color('black')
					axes[r,c].axis('equal')
					ii= ii+1 # i.e. go the next element of vals
					#autotexts[0].set_color('y')
			axes[0,0].legend(labels=lbs, bbox_to_anchor=(-0.32,0.52), loc='lower left')
		else: # i.e. only 1 row
			assert nr==1, "The number rows cannot be zero!"
			ii = 0
			for c in range(axes.shape[0]):
				if ii >= ng:
					break
				patches, texts, autotexts = axes[c].pie(vals[ii], explode=ex[ii], colors=co, autopct=autopct,
					pctdistance=pctdistance, shadow=shadow, labeldistance=labeldistance,
					startangle=startangle, radius=radius, frame=frame)
				axes[c].axis('equal')
				ii= ii+1
			axes[0].legend(labels=lbs,loc='best')
			#axes[0].legend(labels=lbs, bbox_to_anchor=(-0.5,-0.35),loc='lower left')
	else: # i.e. only 1 pie chart
		assert ng==1, "The lenght of vals cannot be zero!"
		fig, ax = plt.subplots()
		ax.pie(vals[0], explode=ex[0], colors=co, autopct=autopct,
			pctdistance=pctdistance, shadow=shadow, labeldistance=labeldistance,
			startangle=startangle, radius=radius, frame=frame)
		ax.axis('equal')
		plt.legend(labels=lbs,loc='best')

	#plt.tight_layout()
	if out is not None:
		fig.savefig(out, dpi=dpi)
	else:
		plt.show()

