block TestScheduler
	import SolarTherm.Utilities.Schedule.Scheduler;
	parameter String file = "resources/daily_schedule.motab";
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
end TestScheduler;
