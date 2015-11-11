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

import DyMat

def plot_res(res, var, xlim=[], out=None):

	fig = plt.figure()

	co = ['b', 'g', 'r', 'c', 'm', 'y', 'k']

	nsp = len(var)
	for i_sp, v_sp in enumerate(var):
		sp = fig.add_subplot(nsp, 1, i_sp+1)
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
				ax[i_ax].plot(res.mat.abscissa(v, valuesOnly=True),
						res.mat.data(v), label=v, color=co[v_id%len(co)])
				v_id += 1
			ax[i_ax].legend(loc=pos[i_ax])
		if xlim != []:
			sp.set_xlim(xlim)
	plt.tight_layout()
	if not out is None:
		fig.savefig(out)
	else:
		plt.show()

