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

hr, vr = proc_csv('storage_fluid.csv')
hl, vl = proc_csv('storage_fluid.log')

x = vl[1]

fig = plt.figure()
ax1 = fig.add_subplot(2,1,1)
ax2 = ax1.twinx()
ax1.plot(x, vr[3], label=hr[3], color='blue')
ax1.set_ylabel(hr[3])
ax2.plot(x, vr[4], label=hr[4], color='green')
ax2.set_ylabel(hr[4])

ax1.legend(loc=2)
ax2.legend(loc=1)

ax1 = fig.add_subplot(2,1,2)
ax1.set_xlabel('Storage (hours)')
ax1.plot(x, vr[2], label=hr[2], color='blue')
ax1.set_ylabel(hr[2])

ax1.legend(loc=2)

plt.tight_layout()
plt.show()
