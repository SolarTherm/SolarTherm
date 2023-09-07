from __future__ import division, print_function,unicode_literals
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
	dpi=600, font=['serif', 'Times New Roman'], usetex=False, fontsize=12):
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
	font, and usetex, representing font family, font style, and use text rendering With LaTeX.
	"""

	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex

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
				except:
					pass

				if unit == 'J':
					unit = eunit # changing unit from unit to eunit (e.g. from 'J' to 'kWh')
				elif unit == 'W':
					unit = punit  # changing unit from unit to punit (e.g. from 'W' to 'kW')
				else:
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
				elif unit==punit:
					v_v = simulation.convert_val(v_v, 'W', unit)
				else:
					pass
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
			#ax[i_ax].set_ylabel(ylabel=ylabel, fontsize=10)
			if i_ax==0:
				ax[i_ax].legend(bbox_to_anchor=(0.,1.02),loc='lower left', ncol=int(math.ceil(n_v_ys_l/2.0)), fontsize=10) #frame flag: frameon=False
			else:
				ax[i_ax].legend(bbox_to_anchor=(1,1.02),loc='lower right', ncol=int(math.ceil(n_v_ys_r/2.0)), fontsize=10)
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
	usetex=False, fontsize=12):
	"""Plot a list of variables nested in ys list as a function of x1
	e.g.
	#plot_par1(x1=[1, 2, 3], ys=[[10, 100, 1000], [10, 100, 1000]], xlabel='X', ylabels=['Y1', 'Y2'])
	"""
	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex

	fig = plt.figure()

	# Colours for our lines
	co = ['b', 'g', 'r', 'c', 'm', 'y', 'k']

	for j in range(len(ys)):
		sp = fig.add_subplot(len(ys), 1, j+1)
		sp.plot(x1, ys[j], label=ylabels[j], color=co[0%len(co)])
		if ylabels != []:
			sp.set_ylabel(ylabels[j])
		sp.legend(bbox_to_anchor=(0.,1.02),loc='lower left', fontsize=10)
	sp.set_xlabel(xlabel)

	fig.subplots_adjust(top=0.9,hspace=0.5)
	#plt.tight_layout()
	if out is not None:
		fig.savefig(out, dpi=dpi)
	else:
		plt.show()

def plot_par2(x1, x2, ys, x1label='', x2label='', ylabels=[], out=None, dpi=600, font=['serif', 'Times New Roman'],
	usetex=False, fontsize=12):
	"""Plot ys as a function of x2 for various x1 values in one graph.
	e.g. plotting lcoe as a function t_storage for various P_names
	like: st_simulate --stop 1y --step 5m --plot lcoe FluidSystem.mo P_name=50000,75000,100000,125000 t_storage=2,3,4,5,6,7,8,9,10,11,12
	"""
	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex

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
		sp.legend(loc=1, frameon=False, fontsize=10)

	plt.tight_layout()
	if out is not None:
		fig.savefig(out, dpi=dpi)
	else:
		plt.show()

def plot_3d(x, y, z, xlabel='', ylabel='', zlabel='', out=None, dpi=600, font=['serif', 'Times New Roman'],
	usetex=False, fontsize=12):
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

def pie_chart1(vals, ex, lbs, title='', co=None, nd=2, sv='pct', lwv=False, pctdistance=0.6, shadow=False,
		labeldistance=1.1, startangle=90, radius=1, frame=False, out=None,
		dpi=600, font=['serif', 'Times New Roman'], usetex=False, fontsize=12):
	"""Plot a single pie chart, where the slices will be ordered and plotted counter-clockwise.
	vals: sizes in pie()
	ex: explode in pie()
	lbs: labels in pie()
	co: colors in pie()
	nd: number of decimal places
	sv: the value shown on each slice (or legend) i.e. pct, abs, or both, representing percentage value, absolute values, or both respectively.
	lwv: true if vales(whether they are absolute, percentage or both) are to be shown in legend (i.e. no values will be shown on the slices)
	e.g.
	pie_chart1(vals=[215.134, 130.445, 245.823, 210.376], ex=(0.05, 0, 0, 0), lbs=['C1', 'C2', 'C3', 'C4'],
		co=['gold', 'yellowgreen', 'lightcoral', 'lightskyblue'], sv='pct')
	"""
	import numpy as np

	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex

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

	if co==None:
		co = plt.cm.Pastel1(np.linspace(0, 0.5, len(vals))) # Get some shades for the colors

	ax.pie(vals, explode=ex, colors=co, autopct=autopct,
		pctdistance=pctdistance, shadow=shadow, labeldistance=labeldistance,
		startangle=startangle, radius=radius, frame=frame)
	ax.axis('equal')

	plt.legend(labels=labels, bbox_to_anchor=(-0.1,0.0),loc='lower left', fontsize=10)
	#plt.tight_layout()

	if title != '':
		plt.title(title, fontweight="bold", fontsize=16)

	if out is not None:
		fig.savefig(out, dpi=dpi)
	else:
		plt.show()


def pie_chart2(vals, ex, lbs, title='', co=None, nd=2, sv='pct', pctdistance=0.6, shadow=False, labeldistance=1.1,
		startangle=90, radius=1, frame=False, out=None, dpi=600, font=['serif', 'Times New Roman'],
		usetex=False, fontsize=12):
	"""Plot a single or multiple pie charts, where the slices will be ordered and plotted counter-clockwise.
	vals: a 2d lsit of sizes
	ex: a 2d lsit o explode
	lbs: labels in pie()
	co: colors in pie()
	nd: number of decimal places
	sv: the value shown on each slice i.e. pct, abs, or both, representing percentage value, absolute values, or both respectively.
	e.g.
	pie_chart2(vals=[[215.134, 130.445, 245.823, 210.376], [215.134, 130.445, 245.823, 210.376]],
		ex=[(0.05, 0, 0, 0), (0.05, 0, 0, 0)], lbs=['C1', 'C2', 'C3', 'C4'],
		co=['gold', 'yellowgreen', 'lightcoral', 'lightskyblue'], sv='pct')
	"""
	import numpy as np

	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex

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

	if co==None:
		co = plt.cm.Pastel1(np.linspace(0, 0.5, len(lbs))) # Get some shades for the colors

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
			axes[0,0].legend(labels=lbs, bbox_to_anchor=(-0.32,0.52), loc='lower left', fontsize=10)
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
			axes[0].legend(labels=lbs,loc='best', fontsize=10)
			#axes[0].legend(labels=lbs, bbox_to_anchor=(-0.5,-0.35),loc='lower left')
	else: # i.e. only 1 pie chart
		assert ng==1, "The lenght of vals cannot be zero!"
		fig, ax = plt.subplots()
		ax.pie(vals[0], explode=ex[0], colors=co, autopct=autopct,
			pctdistance=pctdistance, shadow=shadow, labeldistance=labeldistance,
			startangle=startangle, radius=radius, frame=frame)
		ax.axis('equal')
		plt.legend(labels=lbs,loc='best', fontsize=10)

	if title != '':
		plt.title(title, fontweight="bold", fontsize=16)

	#plt.tight_layout()
	if out is not None:
		fig.savefig(out, dpi=dpi)
	else:
		plt.show()

def bar_chart1(y, xlabel, ylabel, tlabels, title='', yerr=None, ecolor=None,
width=0.5, align='center', co='y', edgecolor='None', out=None, dpi=600,
font=['serif', 'Times New Roman'], usetex=False, fontsize=12):
	"""
	Plot a simple bar chart with a single bar for each tick on the x axis.
	y: a list of y values
	tlabels: tick labels on x axis
	yerr: y axis error bars
	e.g.
	bar_chart1(y=[0.15, 2.5, 5.5, 20], xlabel = 'Component', ylabel = 'Cost (M$)',
		tlabels = ('Water', 'Electrolyzer', 'Elec', 'Algae'), title='Cost breakdown')
	"""
	import numpy as np

	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex

	N = len(tlabels)
	x = np.arange(N) # the x locations for the groups

	fig, ax = plt.subplots()

	plt.bar(x, y, width=width, align=align, color=co, edgecolor=edgecolor, yerr=yerr, ecolor=ecolor)

	plt.xticks(x, tlabels)

	if title != '':
		plt.title(title, fontweight="bold", fontsize=16)

	ax.tick_params(axis='x', which='major', pad=10)
	#ax.tick_params(axis='both', which='major', pad=10)
	ax.set_xlabel(xlabel=xlabel, fontweight="bold")
	ax.set_ylabel(ylabel=ylabel, fontweight="bold")
	ax.set_ylim(top=max(y)+0.1*max(y))

	#plt.tight_layout()
	if out is not None:
		fig.savefig(out, dpi=dpi)
	else:
		plt.show()

def bar_chart2(y, xlabel, ylabel, tlabels, labels, co=None, title='', yerr=None, ecolor=None,
width=0.5, align='center', edgecolor='None', out=None, dpi=600,
font=['serif', 'Times New Roman'], usetex=False, fontsize=12):
	"""
	Plot a bar chart with a single or multiple bars for each tick on the x axis.
	y: a list of y values
	tlabels: tick labels on x axis
	labels: legend labels
	yerr: y axis error bars
	e.g.
	bar_chart2(y=[[0.15, 2.5, 5.5, 20], [1.5, 5.5, 1.5, 55]], xlabel = 'Component', ylabel = 'Cost (M$)',
		tlabels = ('Water', 'Electrolyzer', 'Elec', 'Algae'), labels=['Config1', 'Config2'],
		co=['gold','yellowgreen'], title='Cost breakdown', width = 0.3)
	"""
	import numpy as np

	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex

	N = len(tlabels)
	x = np.arange(N) # the x locations for the groups

	if co == None:
		co = plt.cm.Pastel1(np.linspace(0, 0.5, len(y))) # Get some shades for the colors

	fig, ax = plt.subplots()
	w = 0
	for i in range(len(y)):
		plt.bar(x+w, y[i], width=width, align=align, color=co[i], edgecolor=edgecolor, yerr=yerr, ecolor=ecolor)
		w = w + width

	v_max = []
	for v in y:
		v_max.append(max(v))
	y_max = max(v_max)

	plt.xticks(x, tlabels)

	if title != '':
		plt.title(title, fontweight="bold", fontsize=16)


	ax.set_xticks(x + width / 2)
	ax.tick_params(axis='x', which='major', pad=10)
	#ax.tick_params(axis='both', which='major', pad=10)
	ax.set_xlabel(xlabel=xlabel, fontweight="bold")
	ax.set_ylabel(ylabel=ylabel, fontweight="bold")
	ax.set_ylim(top=y_max+0.1*y_max)
	if labels != None:
		plt.legend(labels, loc=2, fontsize=10)

	#plt.tight_layout()
	if out is not None:
		fig.savefig(out, dpi=dpi)
	else:
		plt.show()

def stacked_bar_chart(y, xlabel, ylabel, tlabels, labels, co=None, title='', table=False, yerr=None, ecolor=None,
	width=0.5, align='center', edgecolor='None', out=None, dpi=600,
	font=['serif', 'Times New Roman'], usetex=False, fontsize=12):
	"""
	Plot a stacked bar chart with a single bar for each tick on the x axis.
	y: a list of y values
	tlabels: tick labels on x axis
	labels: legend labels
	table: true if a table is to be added at the bottom of the x axis
	yerr: y axis error bars
	e.g.
	stacked_bar_chart(y=[[20, 35, 30, 35, 27], [25, 32, 34, 20, 25], [25, 32, 34, 20, 25]],
		xlabel='t_storage', ylabel='Cost (M$)', tlabels=('Sim1', 'Sim2', 'Sim3', 'Sim4', 'Sim5'),
		labels=('Algae', 'Elec', 'Cap'), table=False)
	"""
	import numpy as np

	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex

	if co == None:
		co = plt.cm.Pastel1(np.linspace(0, 0.5, len(labels))) # Get some shades for the colors

	n_s = len(y) # number of stacks

	N = len(tlabels) # number of x axis tick labels
	x = np.arange(N) # the x locations for the groups
	#x = np.arange(N) + 0.3 # to align the tick labels in the table with the bars

	fig, ax = plt.subplots()

	y_offset = np.array([0.0] * N) # initialize the vertical offset for the stacked bar chart.

	# Plot bars and create text labels for the table
	cell_text = []
	for i in range(n_s):
		plt.bar(x, y[i], width=width, align=align, bottom=y_offset, color=co[i], edgecolor=edgecolor, yerr=yerr, ecolor=ecolor)
		y_offset = y_offset + y[i]
		cell_text.append(['%1.1f' % j for j in y_offset])
	# Reverse colors and text labels to display the last value at the top.
	co = co[::-1]
	cell_text.reverse()

	v_sum = []
	for i in range(len(y[0])):
		v_sum.append(sum(s[i] for s in y))
	y_max = max(v_sum)

	if title != '':
		plt.title(title, fontweight="bold", fontsize=16)

	if table:
		the_table = plt.table(cellText=cell_text,
			cellLoc='center',
			rowLabels=labels,
			rowColours=co,
			colLabels=tlabels,
			loc='bottom')

		the_table.scale(1, 1.5)

		plt.xticks([])
		ax.set_xlabel(xlabel=xlabel, fontweight="bold", labelpad=10*(n_s+4))

		plt.subplots_adjust(left=0.3, bottom=0.3) # adjust layout to make room for the table
	else:
		plt.xticks(x, tlabels)
		ax.set_xlabel(xlabel=xlabel, fontweight="bold")
		ax.tick_params(axis='x', which='major', pad=10)
		plt.legend(labels, loc=2, fontsize=10)

	ax.set_ylabel(ylabel=ylabel, fontweight="bold")
	ax.set_ylim(top=y_max+0.2*y_max)

	#plt.tight_layout()
	if out is not None:
		fig.savefig(out, dpi=dpi)
	else:
		plt.show()

def tornado(v_low, v_high, v_base, weights, v_names, xlabel, ylabel, title='', co=['gold', 'lightskyblue'],
	out=None, dpi=600, font=['serif', 'Times New Roman'], usetex=False, fontsize=12):
	"""
	Plot a tornado graph to show the sensitivity of a variable (objective) to a set of parameters deacreasing and increasing.
	v_low: values of objective (e.g. LCOF) when a set of parameters are reduced by x% (e.g. -60%).
	v_high: values of objective (e.g. LCOF) when a set of parameters are increased by x% (e.g. +60%).
	v_base: base value of the objective.
	weights: weight of distribution of parameters between the low and high parts of the graph (default is 2.).
	v_names: name of parameters whose change are investigated.
	e.g.
	tornado(v_low=[4.58, 4.94, 5.27, 5.34, 5.38, 5.38], v_high=[6.78, 6.54, 6.09, 6.02, 5.99, 5.98],
		v_base=5.68, weights=[2., 2., 2., 2., 2., 2., 2., 2.],
		v_names=['Algae cost', 'Discount rate', 'Hydroc', 'H2 from PV', 'Syngas ST', 'Solar field'],
		xlabel='LCOF($/L)', ylabel='Parameter', title="Sensitivity analysis (-60% to +60%)", co=['gold', 'lightskyblue'])
	"""
	import numpy as np

	font_family= font[0]
	font_style = font[1]
	matplotlib.rcParams['font.family'] = font_family
	matplotlib.rcParams['font.'+font_family] = font_style
	matplotlib.rcParams['text.usetex'] = usetex

	values = np.array(v_high) - np.array(v_low) # difference in high and low values
	lows = np.array([v_base-v/w for v, w in zip(values,weights)]) # i.e. bas-values/weights for each parameter

	ys = range(len(values))[::-1]  # the y position for each variable top to bottom

	fig, ax = plt.subplots()

	for y, low, value in zip(ys, lows, values): # plot the bars, one by one
		low_width = v_base - low # the width of the 'low' pieces
		high_width = low + value - v_base # the width of the 'high' pieces 

		ax.broken_barh(
			[(low, low_width), (v_base, high_width)],
			(y - 0.4, 0.8),
			facecolors=[co[0], co[1]],
			edgecolors=['black', 'black'],
			linewidth=1) # each bar is a "broken" horizontal bar chart

		# Display the value as text. It should be positioned in the center of
		# the 'high' bar, except if there isn't any room there, then it should be
		# next to bar instead.
		x = v_base + high_width / 2
		if x <= v_base + 50:
			x = v_base + high_width + 50

		ax.text(x, y, str(value), va='center', ha='center')

	ax.axvline(v_base, color='black') # draw a vertical line down the middle

	if title != '':
		plt.title(title, fontweight="bold", fontsize=16, y=1.02)

	ax.set_xlabel(xlabel, fontweight="bold", labelpad=10)
	ax.tick_params(axis='x', which='major', pad=5)
	ax.set_ylabel(ylabel, fontweight="bold")

	plt.yticks(ys, v_names) # make the y-axis display the variables names

	axes = plt.gca()  # gca means get current axes
	axes.spines['top'].set_visible(False) # hide all the top spine
	axes.spines['left'].set_visible(False) # hide all the left spine
	axes.spines['right'].set_visible(False) # hide all the right spine

	axes.xaxis.set_ticks_position('bottom') # position the x axis ticks on the bottom
	axes.xaxis.set_label_position('bottom') # position the x axis label on the bottom

	#plt.xlim(v_base - 1000, v_base + 1000) # set x axis limits
	#plt.ylim(-1, len(v_names)) # set y axis limits

	plt.subplots_adjust(left=0.2, bottom=0.1) # adjust layout to make room for the variables names
	#plt.tight_layout()
	if out is not None:
		fig.savefig(out, dpi=dpi)
	else:
		plt.show()

