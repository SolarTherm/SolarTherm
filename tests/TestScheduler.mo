block TestScheduler
	import SolarTherm.Models.Sources.Schedule.Scheduler;
	parameter String file = "resources/tests/daily_schedule.motab";
	SolarTherm.Interfaces.Connectors.WeatherBus wbus;
	SolarTherm.Models.Sources.Date.SimpleDate date;
	Scheduler sch1(
		file=file,
		ndaily=2, // needs to match file (only load first two tables)
		wmap={{1,2,1,1,1,1,1}},
		mmap={1,1,1,1,1,1,1,1,1,1,1,1}
		);
	Scheduler sch2(
		file=file,
		ndaily=4, // needs to match file
		wmap={
			{3,3,3,3,3,3,3},
			{4,4,4,4,4,4,4}
			},
		mmap={1,2,2,2,2,2,2,2,2,2,2,2}
		);
equation
	connect(date.tod, wbus.tod);
	connect(date.dow, wbus.dow);
	connect(date.moy, wbus.moy);
	connect(wbus, sch1.wbus);
	connect(wbus, sch2.wbus);
end TestScheduler;
