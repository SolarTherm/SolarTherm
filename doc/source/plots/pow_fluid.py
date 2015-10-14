from __future__ import division

import matplotlib.pyplot as plt

def proc_csv(fn):
	f = open(fn)

	header = f.readline().strip().split(',')

	vals = [[] for i in range(len(header))]
	for line in f.readlines():
		l = line.strip().split(',')
		for i in range(len(l)):
			vals[i].append(float(l[i]))
	
	return header, vals

hr, vr = proc_csv('pow_fluid.csv')
hl, vl = proc_csv('pow_fluid.log')

nx = 11 # number of x points
nc = len(vl[0])//nx # number of curves
colors = ['blue', 'green', 'orange', 'red']

x = vl[2][:nx]

fig = plt.figure()
ax1 = fig.add_subplot(1,1,1)
for i in range(nc):
	ax1.plot(x, vr[3][(i*nx):((i+1)*nx)], label=vl[1][i*nx], color=colors[i])
ax1.set_ylabel(hr[3])

ax1.set_xlabel('Storage (hours)')

ax1.legend(loc=1)

plt.tight_layout()
plt.show()
