#! /bin/env python2

import OMPython
OMPython = OMPython.OMCSession()

cmds = [
	'setCommandLineOptions("+g=Optimica")',
	'loadFile("TestOptimisation.mo")',
	'simulate(AO, stopTime=1, numberOfIntervals=50)',
	'getErrorString()',
	'plot({x1, x2})',
	]

for c in cmds:
	ans = OMPython.execute(c)
	print(ans)
