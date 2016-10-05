within SolarTherm.Models.Sources.Schedule;
block Scheduler "Scheduler"
 parameter String file;
 parameter Integer ndaily "Number of daily schedules in file";

 parameter Integer wmap[:,7] "Week schedules that map to daily schedules";
 parameter Integer mmap[12] "Mapping from month to week schedule";

 parameter Integer nweek = size(wmap, 1);

 DailySchedFile daily[ndaily](
  each file=file,
  name={"daily" + String(i) for i in 1:ndaily});
 WeekMap week[nweek](
  map=wmap);
 MonthMap month(
  map=mmap);
  input SolarTherm.Interfaces.Connectors.WeatherBus wbus;
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
