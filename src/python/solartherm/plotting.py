import matplotlib
# Poor performance
#print(matplotlib.get_backend())
# Default QT5Agg is slow
matplotlib.use('QT4Agg')
#matplotlib.use('GTKAgg')
#matplotlib.use('GTK')
#matplotlib.use('TkAgg')
#matplotlib.use('QT5Agg')
#matplotlib.use('GTKCairo') # fails to draw long paths
import matplotlib.pyplot as plt

from solartherm import simulation

def plot_res(res, fmt, xlim=[], out=None, share=True):
	"""Plot variables from a SimResult.

	The variables to plot and their arrangement on axes and subplots is provided
	fmt.  It is a list of subplots, where each subplot is representated by a
	string with the format:
		
		"var1,var2:var3"
	
	The optional colon separates the names of variables to be plotted on the
	left y-axis, from the variables to be plotted on the right y-axis.  A full
	fmt might look like:

		["var1,var2:var3", "var4:var5", "var6"]
	
	An optional pair that represents bounds on the domain can be provided as
	xlim.

	If a filename is provided to out, then the plot will be saved to that file,
	otherwise the plot will be output to a new window.
	"""

	xlim = [simulation.parse_var_val(x, 's') for x in xlim]

	fig = plt.figure()

	# Colours for our lines
	co = ['b', 'g', 'r', 'c', 'm', 'y', 'k']

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
			for v in v_y.split(','):
				unit = ''
				try:
					unit = res.units[v]
				except:
					pass
				ax[i_ax].plot(res.mat.abscissa(v, valuesOnly=True),
						res.mat.data(v), label=v+' ('+unit+')',
						color=co[v_id%len(co)])
				v_id += 1
			ax[i_ax].legend(loc=pos[i_ax], frameon=False)
		if len(xlim) == 2:
			sp.set_xlim(xlim)
	plt.tight_layout()
	if out is not None:
		fig.savefig(out)
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
