within SolarTherm.Sources;
package Date
import SI = Modelica.SIunits;

type DayOfWeek = Integer(min=1, max=7, unit="dow");
type MonOfYear = Integer(min=1, max=12, unit="moy");

block SimpleDate "Date and time calculations"
 // Very basic so far.  Don't take actual dates and average out month lengths.
 parameter SI.Time toyoffset(min=0) = 0 "Time from start of year at time=0";
 parameter DayOfWeek dow0 = 1 "Day of the week at time=0";

 constant SI.Time SEC_IN_DAY = 24*3600;
 constant SI.Time SEC_IN_MON = 365*24*3600/12;

 output SI.Time t "Time in year";
 output SI.Time tod;
 output DayOfWeek dow;
 output MonOfYear moy;
equation
 t = time + toyoffset;
 tod = mod(t, SEC_IN_DAY);
 dow = integer(mod(t/SEC_IN_DAY, 7)) + 1;
 moy = integer(mod(t/SEC_IN_MON, 12)) + 1;
end SimpleDate;

end Date;

