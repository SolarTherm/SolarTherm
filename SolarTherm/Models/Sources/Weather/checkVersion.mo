within SolarTherm.Models.Sources.Weather;
function checkVersion "Check if file is correct version"
 import Modelica.Utilities.Streams;
 import Modelica.Utilities.Strings;
 input String file;
 output Boolean pass;
 // Change these as the format changes
protected
 constant String metal = "#METALABELS,name,lat,lon,elev,tzone,tstart";
 constant String metau = "#METAUNITS,str,deg,deg,m,h,s";
 constant String tablel = "#TABLELABELS,time,ghi,dni,dry,dew,rhum,p,wdir,wspd";
 constant String tableu = "#TABLEUNITS,s,W/m2,W/m2,degC,degC,%,mbar,deg,m/s";
 constant Integer ncol = 9;
 String line;
 Integer nr;
 Integer nc;
 Integer i;
algorithm
 pass := (Streams.readLine(file, 1) == "#1")
   and (Streams.readLine(file, 3) == metal)
   and (Streams.readLine(file, 4) == metau)
   and (Streams.readLine(file, 5) == tablel)
   and (Streams.readLine(file, 6) == tableu);
 if pass then
  // The scan functions assert that Integer is found
  line := Streams.readLine(file, 2);
  i := Strings.find(line, "(");
  (nr, i) := Strings.scanInteger(line, i+1);
  i := Strings.find(line, ",");
  (nc, i) := Strings.scanInteger(line, i+1);
  pass := (nc == ncol);
 end if;
 Streams.close(file);
end checkVersion;
