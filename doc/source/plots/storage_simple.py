import matplotlib.pyplot as plt

f = open('simple_results.csv')

header = f.readline().strip().split(',')

vals = [[] for i in range(len(header))]
for line in f.readlines():
	l = line.strip().split(',')
	for i in range(len(l)):
		vals[i].append(float(l[i]))

x = vals[1]
fig = plt.figure()
ax1 = fig.add_subplot(2,1,1)
ax2 = ax1.twinx()
ax1.set_xlabel('Storage (hours)')
ax1.plot(x, vals[4], label=header[4], color='blue')
ax1.set_ylabel(header[4])
ax2.plot(x, vals[5], label=header[5], color='green')
ax2.set_ylabel(header[5])

ax1.legend(loc=2)
ax2.legend(loc=1)

ax1 = fig.add_subplot(2,1,2)
ax1.set_xlabel('Storage (hours)')
ax1.plot(x, vals[3], label=header[3], color='blue')
ax1.set_ylabel(header[3])

ax1.legend(loc=2)

plt.show()
