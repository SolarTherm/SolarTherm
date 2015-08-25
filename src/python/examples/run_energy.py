#! /bin/env python2

import OMPython
OMPython = OMPython.OMCSession()

cmds = [
	'loadModel(Modelica)',
	'loadModel(SolarTherm)',
	'simulate(SolarTherm.Examples.EnergySystem, stopTime=31536000, numberOfIntervals=730000)',
	#'simulate(SolarTherm.Examples.EnergySystem, stopTime=86400, numberOfIntervals=500)',
	'getErrorString()',
	'plot({wea.wbus.dni})',
	#'plot({tnk.E}, xRange={0.0, 86400})',
	#'plot({tnk.E})',
	#'plot({spl.p_o1.P, tnk.p.P})',
	#'plot({spl.p_o1.P, pmp.p_o.P})',
	#'plot({gen.P_ele})',
	#'plot({spl.frac, pmp.frac})',
	]

for c in cmds:
	ans = OMPython.execute(c)
	print(ans)
