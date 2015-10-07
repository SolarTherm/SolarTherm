import subprocess as sp

model = 'SimpleSystem'
sp.call(['omc', '-s', '-q', '-d=initialization', model+'.mo', 'Modelica', 'SolarTherm'])
sp.call(['make', '-f', model+'.makefile'])
sp.call(['./'+model, '-override', 'startTime=0,stopTime=31536000,stepSize=60',
#sp.call(['./'+model, '-override', 'startTime=0,stopTime=172800,stepSize=60',
#sp.call(['./'+model, '-override', 'startTime=0,stopTime=86400,stepSize=60',
		'-s', 'rungekutta',
		#'-s', 'dassl',
		#'-lv', 'LOG_EVENTS'
		])
sp.call(['st_plotmat', model+'_res.mat', 'wea.wbus.dni', 'Q_flow_rec,P_blk',
		'con_state,blk_state,sch_state', 'E'])
