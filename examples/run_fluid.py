import subprocess as sp

model = 'FluidSystem'
sp.call(['omc', '-s', '-q', '-d=initialization', model+'.mo', 'Modelica', 'SolarTherm'])
sp.call(['make', '-f', model+'.makefile'])
#sp.call(['./'+model, '-override', 'startTime=0,stopTime=31536000,stepSize=60',
#		'-s', 'rungekutta']) # dassl fails
sp.call(['./'+model, '-override', 'startTime=0,stopTime=31536000,stepSize=60',
#sp.call(['./'+model, '-override', 'startTime=0,stopTime=172800,stepSize=60',
#sp.call(['./'+model, '-override', 'startTime=0,stopTime=86400,stepSize=60',
		'-s', 'rungekutta',
		#'-lv', 'LOG_EVENTS'
		])
#sp.call(['st_plotmat', model+'_res.mat', 'rec.T:rec.Q_flow'])
sp.call(['st_plotmat', model+'_res.mat', 'ctnk.medium.T,htnk.medium.T:ctnk.level,htnk.level',
	'rec.R,rec.Q_flow:pmp_rec.m_flow_set',
	'rec.mprop_b.T:wea.wbus.dni', 'pblk.Q_flow,pblk.P_out'])
