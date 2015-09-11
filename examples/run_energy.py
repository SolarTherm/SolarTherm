#! /bin/env python2

def session_run():
	import OMPython
	OMPython = OMPython.OMCSession()

	cmds = [
		'loadModel(Modelica)',
		'loadModel(SolarTherm)',
		'loadFile("EnergySystem.mo")',
		#'setCommandLineOptions("+g=optdaedump")',
		'simulate(EnergySystem, stopTime=31536000, numberOfIntervals=730000)',
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

def manual_run():
	import subprocess as sp

	model = 'EnergySystem'
	sp.call(['omc', '-s', '-q', model+'.mo', 'Modelica', 'SolarTherm'])
	sp.call(['make', '-f', model+'.makefile'])
	sp.call(['./'+model, '-override', 'startTime=0,stopTime=31536000,stepSize=60',
			'-s', 'rungekutta']) # dassl fails
	sp.call(['st_plotmat', model+'_res.mat', 'tnk.E:der(tnk.E)'])

#session_run()
manual_run()
