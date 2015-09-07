#! /bin/env python2

import OMPython
OMPython = OMPython.OMCSession()

cmds = [
	'loadModel(Modelica)',
	'loadModel(SolarTherm)',
	#'setCommandLineOptions("+g=optdaedump")',
	'simulate(SolarTherm.Examples.EnergySystem, stopTime=31536000, numberOfIntervals=730000)',
	#'simulate(SolarTherm.Examples.EnergySystem, stopTime=86400, numberOfIntervals=500)',
	'getErrorString()',
	#'plot({wea.wbus.dni})',
	#'plot({wea.wbus.ghi})',
	#'plot({tnk.E}, xRange={0.0, 86400})',
	#'plot({tnk.E})',
	#'plot({der(tnk.E)})',
	'plot({tnk.E, der(tnk.E)})',
	#'plot({spl.p_o1.P, tnk.p.P})',
	#'plot({spl.p_o1.P, pmp.p_o.P})',
	#'plot({gen.P_ele})',
	#'plot({spl.frac, pmp.frac})',
	]

for c in cmds:
	ans = OMPython.execute(c)
	print(ans)

# To load the results file:
# from scipy.io import loadmat
# mat = loadmat('SolarTherm.Examples.EnergySystem_res.mat')

# Data is in the matrix under the 'data_2' key.  Can't see sensible names for
# columns, but first at least is time.  Maybe in 'name' key but unicode?

#names = []
#word = ''
#for i in range(len(s)):
#	if s[i] == u'\x00':
#		if word != '':
#			names.append(word)
#		word = ''
#	else:
#		word += s[i]
#if word != '':
#	names.append(word)
