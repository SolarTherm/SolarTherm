within SolarTherm.Models.Sources.SolarFunctions;
function julianDay
  input Integer year;
  input Integer month;
  input Integer day;
  input Real hour;
  output Real jday;
algorithm
  jday:=div((1461*(year + 4800 + div((month - 14),12))),4) + div((367*(month - 2 - 12*div((month - 14),12))),12) -
    div((3*div((year + 4900 + div((month - 14),12)),100)),4) + day - 32075 - 0.5 + hour/24.0;
end julianDay;
