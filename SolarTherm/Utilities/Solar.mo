within SolarTherm.Utilities;
package Solar

import SI = Modelica.SIunits;
import nSI = Modelica.SIunits.Conversions.NonSIunits;
import Modelica.SIunits.Conversions.*;
import Modelica.Math.sin;
import Modelica.Math.cos;
import Modelica.Math.asin;
import Modelica.Math.acos;
import Modelica.Math.tan;
import Modelica.Math.atan;
import Modelica.Math.atan2;
import Modelica.Constants.pi;
import Modelica.Blocks.Math.Sign;

partial block SolarPosition "Sun position"
	output nSI.Angle_deg alt "Altitude";
	output nSI.Angle_deg azi "Azimuth (Clockwise from North=0)";
	parameter nSI.Angle_deg lon "Longitude (+ve East)";
	parameter nSI.Angle_deg lat "Latitude (+ve North)";
equation
end SolarPosition;

block SolarPositionDB "Sun position using Duffie and Beckman"
	extends SolarPosition;
	// Solar Engineering of Thermal Proceesses - Duffie and Beckman
	// http://www.esrl.noaa.gov/gmd/grad/solcalc/solareqns.PDF
	// http://ascend4.org/Calculation_of_sun_position
	// http://www.pveducation.org/pvcdrom/properties-of-sunlight/suns-position
	parameter SI.Time tstart = 0 "Local time difference between time=0 and start of year";
	parameter nSI.Time_hour tzone = 0 "Time zone wrt UTC";
protected
	constant Real ang_vel(quantity="AngularVelocity", unit="rad/hour") = pi/12
		"Angular velocity of earh in orbit";
	SI.Angle B "Approximate angle of earth in its orbit";
	nSI.Time_hour E "Equation of time";
	SI.Angle dec "Solar declination (+ve North)";
	nSI.Time_hour t_solar "Local solar time (solar noon at 12hrs)";
	SI.Angle hra "Hour angle (solar noon at 0)";
	Real hra_s "Hour angle sign";
	SI.Angle zen "Zenith angle";
equation
	// The approximate oribital angle is calculated taking noon UTC as zero
	B = 2*pi*(to_hour(time + tstart) - tzone - 12)/(24*365);
	// The equation of time accounts for orbital eccentricity and axial tilt
	E = (1/60)*229.2*(0.000075
		+ 0.001868*cos(B) - 0.032077*sin(B)
		- 0.014615*cos(2*B) - 0.04089*sin(2*B));
	// Calculating th declination from approximate orbital angle
	dec = 0.006918
		- 0.399912*cos(B) + 0.070257*sin(B)
		- 0.006758*cos(2*B) + 0.000907*sin(2*B)
		- 0.002697*cos(3*B) + 0.00148*sin(3*B);
	// The local solar time is calculated by applying the equation of time
	// correction and correcting for the difference between the location and
	// the time zone meridian
	t_solar = to_hour(time + tstart) + from_deg(lon)/ang_vel - tzone + E;
	// The hour angle converts the solar time to an angle and lines up solar
	// noon with zero
	hra = ang_vel*(t_solar - 12);
	// Note that t_solar and hra are not modulous 1day
	// hra_s gives the sign of hra relative to solar noon for each day
	hra_s = if noEvent(sin(hra) >= 0) then 1 else -1;
	// The inbuilt Sign operator/block goes to 0 at 0, which is not what we want
	// where used below
	// Not sure if we hurt the solver by doing this or cause possible numerical
	// trouble...

	// min and max applied to acos arguments because have had numerical
	// problems where the interval [-1, 1] is slightly overshot.
	zen = acos(min(max(sin(dec)*sin(from_deg(lat))
		+ cos(dec)*cos(from_deg(lat))*cos(hra),-1),1));
	azi = to_deg(pi + hra_s*acos(min(max((cos(zen)*sin(from_deg(lat))
		- sin(dec))/(sin(zen)*cos(from_deg(lat))),-1),1)));
	// The azimuth becomes very sensitive as zen approaches zero
	alt = to_deg(pi/2 - zen);
end SolarPositionDB;

end Solar;
