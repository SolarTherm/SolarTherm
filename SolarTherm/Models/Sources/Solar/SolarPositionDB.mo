within SolarTherm.Models.Sources.Solar;
block SolarPositionDB "Sun position using Duffie and Beckman"
 extends SolarPosition;
 // Solar Engineering of Thermal Proceesses - Duffie and Beckman
 // http://www.esrl.noaa.gov/gmd/grad/solcalc/solareqns.PDF
 // http://ascend4.org/Calculation_of_sun_position
 // http://www.pveducation.org/pvcdrom/properties-of-sunlight/suns-position
 parameter nSI.Time_hour tzone = 0 "Time zone wrt UTC";
 input SI.Time t "Time relative to start of year";
protected
 constant Real ang_vel(quantity="AngularVelocity", unit="deg/hour") = 360./24
    "Angular velocity of earth";
 constant nSI.Angle_deg axial_tilt = 23.4354 "Axial tilt (ecliptic obliquity)";
 SI.Angle B "Approximate angle of earth in its orbit";
 nSI.Time_hour E "Equation of time";
 SI.Angle dec_r "Solar declination (+ve North of equator)";
 nSI.Time_hour t_solar "Local solar time (solar noon at 12hrs)";
 Real hra_s "Hour angle sign";
 SI.Angle zen_r "Zenith angle";
equation
 // The approximate oribital angle is calculated taking noon UTC as zero
 B = 2*pi*(to_hour(t) - tzone - 12)/(24*365);
 // The equation of time accounts for orbital eccentricity and axial tilt
 E = (1/60)*229.2*(0.000075
  + 0.001868*cos(B) - 0.032077*sin(B)
  - 0.014615*cos(2*B) - 0.04089*sin(2*B));
 // Calculating th declination from approximate orbital angle
 dec_r = 0.006918
  - 0.399912*cos(B) + 0.070257*sin(B)
  - 0.006758*cos(2*B) + 0.000907*sin(2*B)
  - 0.002697*cos(3*B) + 0.00148*sin(3*B);
 dec = to_deg(dec_r);
 // The local solar time is calculated by applying the equation of time
 // correction and correcting for the difference between the location and
 // the time zone meridian
 t_solar = to_hour(t) + lon/ang_vel - tzone + E;
 // The hour angle converts the solar time to an angle and lines up solar
 // noon with zero
 hra = ang_vel*(mod(t_solar, 24) - 12);
 // hra_s gives the sign of hra relative to solar noon for each day
 hra_s = if noEvent(hra >= 0) then 1 else -1;
 // The inbuilt Sign operator/block goes to 0 at 0, which is not what we want
 // where used below
 // Not sure if we hurt the solver by doing this or cause possible numerical
 // trouble...

 // min and max applied to acos arguments because have had numerical
 // problems where the interval [-1, 1] is slightly overshot.
 zen_r = acos(min(max(sin(dec_r)*sin(from_deg(lat))
  + cos(dec_r)*cos(from_deg(lat))*cos(from_deg(hra)),-1),1));
 zen = to_deg(zen_r);
 azi = to_deg(pi + hra_s*acos(min(max((cos(zen_r)*sin(from_deg(lat))
  - sin(dec_r))/(sin(zen_r)*cos(from_deg(lat))),-1),1)));
 // The azimuth becomes very sensitive as zen_r approaches zero
 alt = to_deg(pi/2 - zen_r);
 // To fully calculate the ecliptic longitude from dec_r, also need right
 // ascension (which we can calc from solar time) and then to apply an atan2:
 //ra = ???
 //elo = to_deg(atan2(sin(ra)*cos(from_deg(axial_tilt))
 //			 + tan(dec_r)*sin(from_deg(axial_tilt)), cos(ra)));
 // Using the fact that the ecliptic latitude is zero, we can calculate it
 // for just the range -90 to 90.  This is all that matters anyway for solar
 // efficiency calcs as it should be symmetric in the other quadrants.
 elo = to_deg(asin(min(max(sin(dec_r)/sin(from_deg(axial_tilt)),-1),1)));
end SolarPositionDB;
