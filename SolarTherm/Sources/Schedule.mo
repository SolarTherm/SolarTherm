within SolarTherm.Sources;
package Schedule
import SI = Modelica.SIunits;

partial block DailySched "Daily schedule"
	input Real t "Time in day";
	output Real v "Value at time";
end DailySched;

partial block IntMap "Mapping between two integers"
	input Integer i "Input integer";
	output Integer j "Output integer";
end IntMap;

block DailySchedFile "Loaded from table in file"
	extends DailySched;
	parameter String file "File name";
	parameter String name "Table name";

	Modelica.Blocks.Tables.CombiTable1Ds table(
		verboseRead=false,
		tableOnFile=true,
		fileName=file,
		tableName=name,
		//smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
		smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments
		);
equation
	connect(t, table.u);
	connect(table.y[1], v);
end DailySchedFile;

block WeekMap "Mapping between day of week and daily schedule"
	extends IntMap(i(min=1, max=7));

	parameter Integer map[7];
equation
	j = map[i];
end WeekMap;

block MonthMap "Mapping between month and day of week"
	extends IntMap(i(min=1, max=12));

	parameter Integer map[12];
equation
	j = map[i];
end MonthMap;

block Scheduler "Scheduler"
	parameter String file;
	parameter Integer ndaily "Number of daily schedules in file";

	parameter Integer wmap[:,7] "Week schedules that map to daily schedules";
	parameter Integer mmap[12] "Mapping from month to week schedule";

	parameter Integer nweek = size(wmap, 1);

	DailySchedFile daily[ndaily](
		each file=file,
		name={"daily" + String(i) for i in 1:ndaily}
		);
	WeekMap week[nweek](
		map=wmap
		);
	MonthMap month(
		map=mmap
		);
	input SolarTherm.Interfaces.WeatherBus wbus;
	output Real v "Output value";
equation
	month.i = wbus.moy;
	for i in 1:nweek loop
		week[i].i = wbus.dow;
	end for;
	for i in 1:ndaily loop
		daily[i].t = wbus.tod;
	end for;
	v = daily[week[month.j].j].v;
end Scheduler;

end Schedule;
