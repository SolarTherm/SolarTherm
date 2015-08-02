within SolarTherm.Utilities;
package Solar

import SI = Modelica.SIunits;
import nSI = Modelica.SIunits.Conversions.NonSIunits;
import Modelica.SIunits.Conversions.*;
import Modelica.Math.sin;
import Modelica.Math.cos;
import Modelica.Math.asin;
import Modelica.Math.acos;
import Modelica.Constants.pi;

partial block SolarPosition "Sun position"
	output SI.Angle alt;
	output SI.Angle azi;
	parameter nSI.Angle_deg lon;
	parameter nSI.Angle_deg lat;
equation
end SolarPosition;

block SolarPositionDB "Sun position using Duffie and Beckman"
	extends SolarPosition;
	// http://ascend4.org/Calculation_of_sun_position
	// http://www.pveducation.org/pvcdrom/properties-of-sunlight/suns-position
	// http://www.esrl.noaa.gov/gmd/grad/solcalc/solareqns.PDF
	parameter SI.Time toy_start = 0 "Time of year for first point";
	parameter SI.Time t_zone = 0 "Time zone wrt GMT";
protected
	constant Real earth_avel(quantity="AngularVelocity", unit="deg/min") = 1/4;
	SI.Angle B "Angle of earth in its orbit";
	nSI.Time_minute E "Equation of time";
	SI.Angle dec "Solar declination";
	nSI.Time_minute tc "Time correction";
	nSI.Angle_deg hra "Hour angle";
equation
	B = 2*pi*to_day(time + toy_start)/365;
	E = 229.2*(0.000075 + 0.001868*cos(B) - 0.032077*sin(B)
		- 0.014615*cos(2*B) - 0.04089*sin(2*B));
	dec = 0.006918 - 0.399912*cos(B) + 0.070257*sin(B)
		- 0.006758*cos(2*B) + 0.000907*sin(2*B)
		- 0.002697*cos(3*B) + 0.00148*sin(3*B);
	tc = lon/earth_avel - to_minute(t_zone) + E;
	hra = 60*earth_avel*(to_hour(time + toy_start) + tc/60 - 12);

	alt = asin(sin(dec)*sin(lat) + cos(dec)*sin(lat)*cos(hra));
	azi = acos((sin(dec)*sin(lat) - cos(dec)*sin(lat)*cos(hra))/cos(alt));
	
end SolarPositionDB;

end Solar;
