#! /bin/env python2

import OMPython
OMPython = OMPython.OMCSession()

cmds = [
	'loadModel(Modelica)',
	'loadModel(SolarTherm.ControlSimple)',
	'simulate(SolarTherm.ControlSimple, stopTime=20)',
	'plot({sol.port1.p, tank.e, gen.p})',
	]

for c in cmds:
	ans = OMPython.execute(c)
	print(ans)
