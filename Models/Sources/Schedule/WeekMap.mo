within SolarTherm.Models.Sources.Schedule;
block WeekMap "Mapping between day of week and daily schedule"
 extends IntMap(i(min=1, max=7));

 parameter Integer map[7];
equation
 j = map[i];
end WeekMap;
