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
import matplotlib.pyplot as plt
plt.rcParams['font.family'] = 'Times New Roman'
import re

from solartherm import simulation

def plot_res(res, fmt, xlim=[], xunit='s', out=None, share=True, bw=False, dpi=600):
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

	If a filename is provided to out, then the plot will be saved to that file,
	otherwise the plot will be output to a new window.
	"""

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
		assert len(v_ys) < 3, 'Can only utilise at most 2 y-axes per subplot'
		ax = [sp]
		for i in range(1,len(v_ys)):
			ax.append(sp.twinx())
		pos = [0 for i in range(max(2, len(v_ys)))]
		pos[0] = 2
		pos[1] = 1
		v_id = 0
		for i_ax, v_y in enumerate(v_ys):
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
				label = v + ' (' + unit + ')'
				if len(res) > 1:
					label = str(ri+1) + ': ' + label
				time_old = res[ri].get_time(v) # original time values in seconds
				time_new = simulation.convert_val(time_old, 's', xunit) # new time values in terms fo xunit
				ax[i_ax].plot(time_new, res[ri].get_values(v),
						label=label, color=co[v_id%len(co)],
						linestyle=ls[v_id%len(ls)],
						#linewidth=2
						)
				ylabel = v + ' (' + unit + ')'
				ax[i_ax].set_ylabel(ylabel)
				v_v_max = max(res[ri].get_values(v))
				ax[i_ax].set_ylim(top=v_v_max+0.1*v_v_max)
				v_id += 1
			ax[i_ax].legend(loc=pos[i_ax], frameon=False)
		if len(xlim) == 2:
			sp.set_xlim(xlim)
			#sp.set_xlim(left=xlim[0], right=xlim[1])
			#sp.margins(y=0.05)
			xlabels = {'s': 'seconds', 'd': 'minutes', 'h': 'hours', 'd': 'days', 'y': 'years'}
			xlabel ="Time" + " (" + xlabels[xunit] + ")" 
			sp.set_xlabel(xlabel)
	plt.tight_layout()
	if out is not None:
		fig.savefig(out,dpi=dpi)
	else:
		plt.show()

def plot_par1(x1, ys, xlabel='', ylabels=[], out=None):
	fig = plt.figure()

	# Colours for our lines
	co = ['b', 'g', 'r', 'c', 'm', 'y', 'k']

	for j in range(len(ys)):
		sp = fig.add_subplot(len(ys), 1, j+1)
		sp.plot(x1, ys[j], color=co[0%len(co)])
		sp.set_xlabel(xlabel)
		if ylabels != []:
			sp.set_ylabel(ylabels[j])

	plt.tight_layout()
	if out is not None:
		fig.savefig(out)
	else:
		plt.show()

def plot_par2(x1, x2, ys, x1label='', x2label='', ylabels=[], out=None):
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
		fig.savefig(out)
	else:
		plt.show()

def plot_3d(x, y, z, xlabel='', ylabel='', zlabel='', out=None):
	from mpl_toolkits.mplot3d import Axes3D
	fig = plt.figure()

	ax = fig.gca(projection='3d')
	#ax.plot_surface(x, y, z)
	#ax.plot_wireframe(x, y, z)
	ax.scatter(x, y, z, marker='o')

	ax.set_xlabel(xlabel)
	ax.set_ylabel(ylabel)
	ax.set_zlabel(zlabel)

	if out is not None:
		fig.savefig(out)
	else:
		plt.show()
