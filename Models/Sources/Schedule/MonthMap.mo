within SolarTherm.Models.Sources.Schedule;
block MonthMap "Mapping between month and day of week"
 extends IntMap(i(min=1, max=12));

 parameter Integer map[12];
equation
 j = map[i];
end MonthMap;
